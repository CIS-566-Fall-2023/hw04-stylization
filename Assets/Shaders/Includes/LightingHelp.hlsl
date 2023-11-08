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


        if (shadowAtten * NdotL == 0)
        {
            rampedDiffuse = 0;

        }

        if (light.distanceAttenuation <= 0)
        {
            rampedDiffuse = 0.0;
        }

        Color += max(rampedDiffuse, 0) * light.color.rgb;
        Diffuse += rampedDiffuse;
    }
#endif
}

float Random(float2 uv)
{
    return frac(sin(dot(uv, float2(12.9898, 78.233))) * 43758.5453);
}

void ChooseColor_float(float3 Highlight, float3 Shadow, float Diffuse, float Threshold, out float3 OUT)
{
    if (Diffuse < Threshold)
    {
        OUT = Shadow;
    }
    else
    {
        OUT = Highlight;
    }
}

void ChooseColor2_float(float3 WorldNormal, float3 WorldPosition, float3 CameraPosition, float3 BaseColor, float OutLineScale, out float3 OUT)
{
    float outline = dot(normalize(CameraPosition - WorldPosition), normalize(WorldNormal));
    //if (outline < 0.45 && Random(Thresholds) < 0.8)
    if (outline < OutLineScale)
    {
        //OUT = float3(0, 0, 0);
        OUT = lerp(BaseColor, float3(0, 0, 0), 1 + OutLineScale - outline);
    }
    else
    {
        OUT = BaseColor;
    }
}

float Gaussian(float x, float mu, float sigma)
{
    float a = (x - mu) / sigma;
    return exp(-0.5 * a * a);
}

void NoiseColor_float(float3 EdgeColor, float3 CenterColor, float3 WorldNormal, float3 WorldPosition, float3 CameraPosition, float mu, float sigma, float NoiseScale, float NoiseIntensity, float3 NoiseTexture, out float3 OUT)
{
    float distanceFromCenter = dot(normalize(CameraPosition - WorldPosition), normalize(WorldNormal));

    float noiseValue = (NoiseTexture.r + NoiseTexture.g + NoiseTexture.b) / 3.0;

    float gaussianValue = Gaussian(distanceFromCenter, mu, sigma);

    gaussianValue = saturate(gaussianValue * (1.0 + NoiseIntensity * (noiseValue - 0.5)));

    float3 color = lerp(CenterColor, EdgeColor, gaussianValue);

    OUT = lerp(color, float3(0, 0, 0), gaussianValue + NoiseScale);
}



