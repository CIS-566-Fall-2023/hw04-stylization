void GetMainLight_float(float3 WorldPos, out float3 Color, out float3 Direction, out float DistanceAtten, out float ShadowAtten)
{
#ifdef SHADERGRAPH_PREVIEW
    Direction = normalize(float3(0.5, 0.5, 0));
    Color = 1;
    DistanceAtten = 1;
    ShadowAtten = 1;
#else
#if SHADOWS_SCREEN
        float4 clipPos = TransformWorldToClip(WorldPos);
        float4 shadowCoord = ComputeScreenPos(clipPos);
#else
    float4 shadowCoord = TransformWorldToShadowCoord(WorldPos);
#endif

    Light mainLight = GetMainLight(shadowCoord);
    Direction = mainLight.direction;
    Color = mainLight.color;
    DistanceAtten = mainLight.distanceAttenuation;
    ShadowAtten = mainLight.shadowAttenuation;
#endif
}

void ComputeAdditionalLighting_float(float3 WorldPosition, float3 WorldNormal,
    float2 Thresholds, float3 RampedDiffuseValues,
    out float3 Color, out float Diffuse)
{
    Color = float3(0, 0, 0);
    Diffuse = 0;

#ifndef SHADERGRAPH_PREVIEW

    int pixelLightCount = GetAdditionalLightsCount();
    
    for (int i = 0; i < pixelLightCount; ++i)
    {
        Light light = GetAdditionalLight(i, WorldPosition);
        float4 tmp = unity_LightIndices[i / 4];
        uint light_i = tmp[i % 4];

        half shadowAtten = light.shadowAttenuation * AdditionalLightRealtimeShadow(light_i, WorldPosition, light.direction);
        
        half NdotL = saturate(dot(WorldNormal, light.direction));
        half distanceAtten = light.distanceAttenuation;

        half thisDiffuse = distanceAtten * shadowAtten * NdotL;
        
        half rampedDiffuse = 0;
        
        if (thisDiffuse < Thresholds.x)
        {
            rampedDiffuse = RampedDiffuseValues.x;
        }
        else if (thisDiffuse < Thresholds.y)
        {
            rampedDiffuse = RampedDiffuseValues.y;
        }
        else
        {
            rampedDiffuse = RampedDiffuseValues.z;
        }

        
        if (light.distanceAttenuation <= 0)
        {
            rampedDiffuse = 0.0;
        }

        Color += max(rampedDiffuse, 0) * light.color.rgb;
        Diffuse += rampedDiffuse;
    }
    
    if (Diffuse <= 0.3)
    {
        Color = float3(0, 0, 0);
        Diffuse = 0;
    }
    
#endif
}

void ChooseColor_float(float3 ExtraHighlight, float3 Highlight, float3 Midtone, float3 Shadow, float Diffuse, float3 Thresholds, out float3 OUT)
{
    if (Diffuse < Thresholds.x)
    {
        OUT = Shadow;
    }
    else if (Diffuse < Thresholds.y)
    {
        OUT = Midtone;
    }
    else if (Diffuse < Thresholds.z) 
    {
        OUT = Highlight;
    }
    else 
    {
        OUT = ExtraHighlight;
    }
}


void RimHighlight_float(float3 WorldPosition, float3 Normal, float RimPower, out float3 OUT)
{
    float3 viewDir = normalize(_WorldSpaceCameraPos - WorldPosition);
    float rim = 1.0 - saturate(dot(Normal, viewDir));
    rim = pow(rim, RimPower);
    OUT = float3(rim, rim, rim);
}

float3 HSVtoRGB(float hue, float saturation, float value)
{
    float c = saturation * value;
    float x = c * (1 - abs(fmod(hue * 6, 2) - 1));
    float m = value - c;

    if (hue < 1.0 / 6) return float3(c, x, 0) + m;
    if (hue < 2.0 / 6) return float3(x, c, 0) + m;
    if (hue < 3.0 / 6) return float3(0, c, x) + m;
    if (hue < 4.0 / 6) return float3(0, x, c) + m;
    if (hue < 5.0 / 6) return float3(x, 0, c) + m;
    return float3(c, 0, x) + m;
}

float CubicPulse(float center, float width, float x)
{
    x = abs(x - center);
    if (x > width) return 0.0;
    x /= width;
    return 1.0 - x * x * (3.0 - 2.0 * x);
}

float Sawtooth_wave(float x, float freq, float amp)
{
    return amp * (x * freq - floor(x * freq));
}

float3 RandomColor(float3 Color, float Seed)
{
    float hue = CubicPulse(0, 1, Sawtooth_wave(Seed, 0.2, 1.0));
    float maxSaturation = 1;
    float minSaturation = 0.97;
    float saturation = (sin(Seed * 2) + 1.0) * 0.5 * (maxSaturation - minSaturation) + minSaturation;
    float value = 1.0;
    float3 randomColor = HSVtoRGB(hue, saturation, value);
    return pow(randomColor, 1/2.2);
}

float3 Tint(float3 Highlight, float3 Shadow, float3 Color)
{
    float lerpValue = (Color.r + Color.g + Color.b) / 3.0;
    return lerp(Shadow, Highlight, lerpValue);
}

float3 blendOverwrite(float3 Base, float3 Blend, float3 Mask)
{
    return lerp(Base, Blend, Mask);
}


void BlendLight_float(const float3 Color, const float3 Shadow, const float3 Midtone, const float3 Highlight, const float3 ExtraHighlight,
    const float2 Weight, const float2 uv, Texture2D _HairMask, Texture2D _SkinMask, Texture2D _ShadowTexture,
    SamplerState sampler_BodyMask, 
    const float Seed, bool Animated, const float4 ShadowTextureScale,
    out float3 MidtoneColor, out float3 HighlightColor, out float3 ExtraHighlightColor, out float3 ShadowColor)
{
    float3 hairMask = SAMPLE_TEXTURE2D(_HairMask, sampler_BodyMask, uv).rgb;
    float3 skinMask = SAMPLE_TEXTURE2D(_SkinMask, sampler_BodyMask, uv).rgb;
    float3 randColor = RandomColor(Color, Seed);
    float3 FaceColor = Color;
    MidtoneColor = blendOverwrite(Color * Midtone, Color, hairMask);
    MidtoneColor = blendOverwrite(MidtoneColor, FaceColor, skinMask);
    float offset = (sin(Seed * 0.01) + 1.0) * 0.5;
    float3 ShadowTextureColor = SAMPLE_TEXTURE2D(_ShadowTexture, sampler_BodyMask, float2(uv.x + offset, uv.y + offset* 20.f) * ShadowTextureScale).rgb;
    ShadowColor = Color * Shadow * Tint(Color, Shadow, ShadowTextureColor);
    ExtraHighlightColor = lerp(Color, ExtraHighlight, Weight.x);
    HighlightColor = lerp(Color, Highlight, Weight.y);
    if (Animated){
        ShadowColor = blendOverwrite(randColor, ShadowColor, hairMask);
        MidtoneColor = blendOverwrite(randColor, MidtoneColor, hairMask);
        float3 randHighlightColor = lerp(randColor, HighlightColor, 0.5);
        float3 randExtraHighlightColor = lerp(randColor, ExtraHighlightColor, 0.5);
        HighlightColor = blendOverwrite(randHighlightColor,  MidtoneColor, hairMask);
        ExtraHighlightColor = blendOverwrite(randExtraHighlightColor,  MidtoneColor, hairMask);
    }else{
        HighlightColor = blendOverwrite(HighlightColor, MidtoneColor, hairMask);
        ExtraHighlightColor = blendOverwrite(ExtraHighlightColor, MidtoneColor, hairMask);
    }
}