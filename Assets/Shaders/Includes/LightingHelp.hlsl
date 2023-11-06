void WaterWaves_float(float3 WorldPos, float SineTime, out float3 Position) {
    
    Position = WorldPos;
    //Position[1] = SineTime * WorldPos[1] * 0.01 * abs(sin(WorldPos[2]));
    Position[1] = WorldPos[1] * 0.02 * abs(sin(WorldPos[2] * 100000 + SineTime));
    
}

float2 Random2(float2 p)
{
    return frac(sin(float2(dot(p, float2(127.1, 311.7)), dot(p, float2(269.5, 183.3)))) * 43209);

}

float WorleyNoise(float2 uv, float time) {
    
    uv *= 10;
    
    float2 uvInt = floor(uv);
    
    float2 uvFract = frac(uv);
    
    float minDist = 1.0;
    
    for (int y = -1; y <= 1; ++y)
    {
        for (int x = -1; x <= 1; ++x)
        {
            float2 neighbor = float2(float(x), float(y));
            float2 p = Random2(uvInt + neighbor);
            float2 diff = neighbor + p - uvFract;
            float dist = length(diff);
            minDist = min(minDist, dist);

        }

    }
    return minDist;
}

void WaterCaustics_float(float3 WorldUV, float3 CurrColor, float SineTime, out
float3 FinalColor) {
    
    if (WorleyNoise(float2(WorldUV[0], WorldUV[2]), SineTime) < 0.9)
    {
        FinalColor = CurrColor * (2 - WorleyNoise(float2(WorldUV[0], WorldUV[2]), SineTime));
    
    }
    else
    {
        FinalColor = CurrColor;
    }
    
   
    
}

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

void ChooseColor_float(float3 Highlight, float3 Shadow, float3 Midtone, float Diffuse, float2 Thresholds, out float3 OUT)
{
    if (Diffuse < Thresholds.x)
    {
        OUT = Shadow;
    }
    else if (Diffuse < Thresholds.y)
    {
        OUT = Midtone;
    }
    else
    {
        OUT = Highlight;
    }
}
