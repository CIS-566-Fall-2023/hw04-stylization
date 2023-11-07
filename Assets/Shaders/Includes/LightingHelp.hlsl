// This file is actually help for everything that's preprocess

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
    float2 Thresholds, float3 RampedDiffuseValues, float Smoothness,
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
        
        float smoothstepFactor; 

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

void ChooseColor_float(float3 Highlight, float3 Midtone, float3 Shadow, float Diffuse, float2 Thresholds, float Smoothness, out float3 OUT)
{
    float smoothstepFactor; 

    if (Diffuse < Thresholds.x)
    {
        OUT = Shadow;
    }
    else if (Diffuse < Thresholds.x + Smoothness)
    {
        smoothstepFactor = smoothstep(Thresholds.x, Thresholds.x + Smoothness, Diffuse);
        OUT = lerp(Shadow, Midtone, smoothstepFactor);
    }
    else if (Diffuse < Thresholds.y - Smoothness)
    {
        OUT = Midtone;
    }
    else if (Diffuse < Thresholds.y + Smoothness)
    {
        smoothstepFactor = smoothstep(Thresholds.y - Smoothness, Thresholds.y + Smoothness, Diffuse);
        OUT = lerp(Midtone, Highlight, smoothstepFactor);
    }
    else
    {
        OUT = Highlight;
    }
}

void ChooseShadow_float(float Diffuse, float2 Thresholds, float Smoothness, out float3 SHADOW, out float3 NOTSHADOW) 
{

    if (Diffuse < Thresholds.x)
    {
        SHADOW = float3(0, 0, 0);
    }
    else if (Diffuse < Thresholds.x + Smoothness)
    {
        float smoothstepFactor = smoothstep(Thresholds.x, Thresholds.x + Smoothness, Diffuse);
        SHADOW = lerp(float3(0, 0, 0), float3(1, 1, 1), smoothstepFactor);
    }
    else
    {
        SHADOW = float3(1, 1, 1);
    }
    NOTSHADOW = float3(1, 1, 1) - SHADOW;

}

float2 n22 (float2 p)
{
    float3 a = frac(p.xyx * float3(123.34, 234.34, 345.65));
    a += dot(a, a + 34.45);
    return frac(float2(a.x * a.y, a.y * a.z));
}

float2 get_gradient(float2 pos)
{
    float twoPi = 6.283185;
    float angle = n22(pos).x * twoPi;
    return float2(cos(angle), sin(angle));
}

float perlin_noise(float2 uv)
{
    float2 pos_in_grid = uv;
    float2 cell_pos_in_grid =  floor(pos_in_grid);
    float2 local_pos_in_cell = (pos_in_grid - cell_pos_in_grid);
    float2 blend = local_pos_in_cell * local_pos_in_cell * (3.0f - 2.0f * local_pos_in_cell);
    
    float2 left_top = cell_pos_in_grid + float2(0, 1);
    float2 right_top = cell_pos_in_grid + float2(1, 1);
    float2 left_bottom = cell_pos_in_grid + float2(0, 0);
    float2 right_bottom = cell_pos_in_grid + float2(1, 0);
    
    float left_top_dot = dot(pos_in_grid - left_top, get_gradient(left_top));
    float right_top_dot = dot(pos_in_grid - right_top,  get_gradient(right_top));
    float left_bottom_dot = dot(pos_in_grid - left_bottom, get_gradient(left_bottom));
    float right_bottom_dot = dot(pos_in_grid - right_bottom, get_gradient(right_bottom));
    
    float noise_value = lerp(
                            lerp(left_bottom_dot, right_bottom_dot, blend.x), 
                            lerp(left_top_dot, right_top_dot, blend.x), 
                            blend.y);
   
    
    return (0.5 + 0.5 * (noise_value / 0.7));
}

void GetSpecks_float(float2 uv, float3 OutlineColor, out float3 OUT) {

    // add noise to UVs

    float freq = 150.;
    float amplitude = 0.001;
    float noise = perlin_noise(uv * freq) * amplitude;

    uv += float2(noise, noise);
    uv = saturate(uv);

    // get specks

    
     freq = 120;
     amplitude = 1;
     noise = perlin_noise(uv * freq) * amplitude;

    if (noise > 0.88 && noise < 0.94) {
        OUT = OutlineColor;
    } else {
        OUT = 1;
    }
}

void LeavesDisplacement_float(float2 uv, float3 pos, float time, out float3 OUT) {

    // Static high-freq leaves displacement

    float freq = 40.;
    float amplitude = 0.006;
    float noise = perlin_noise(uv * freq) * amplitude - amplitude * 0.1;

    pos.y += noise;

    // Static low-freq leaves displacement

    freq = 2.;
    amplitude = 0.001;
    noise = perlin_noise(uv * freq) * amplitude - amplitude * 0.1;

    pos.y += noise;

    // Blowing animation

    float2 uvTime = float2(sin(uv.y * 10), time);
    freq = 0.5;
    amplitude = 0.002;
    noise = perlin_noise(uvTime * freq) * amplitude - amplitude * 0.1;

    pos.z += noise;
    pos.x += noise;

    OUT = pos;
}

void Displacement_float(float2 uv, float3 pos, out float3 OUT) {

    // Static high-freq displacement

    float freq = 40.;
    float amplitude = 0.006;
    float noise = perlin_noise(uv * freq) * amplitude - amplitude * 0.1;

    pos.y += noise;

    // Static low-freq displacement

    freq = 2.;
    amplitude = 0.001;
    noise = perlin_noise(uv * freq) * amplitude - amplitude * 0.1;

    pos.y += noise;

    OUT = pos;
}

