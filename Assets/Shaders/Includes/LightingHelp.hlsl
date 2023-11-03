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
    float2 Thresholds, float3 RampedDiffuseValues, float MinDiffuse, // 0.3
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
    
    if (Diffuse <= MinDiffuse)
    {
        Color = float3(0, 0, 0);
        Diffuse = 0;
    }
    
#endif
}

void ChooseColor_float(float3 Highlight, float3 Midtone, float3 Shadow, float Diffuse, float2 Thresholds, out float3 OUT)
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

void ComputeSpecularLight_float(float3 WorldPos, float3 WorldNormal, float3 ViewDirection, float3 SpecularColor, float SpecularPower, float SpecularIntensity, float2 Threholds, float3 RampedSpecular, out float3 Color, out float Specular)
{
#ifdef SHADERGRAPH_PREVIEW
    WorldNormal = normalize(float3(0.5, 0.5, 0));
    SpecularPower = 1;
    SpecularIntensity = 1;
    Color = 0;
    Specular = 0;
#else
#if SHADOWS_SCREEN
    float4 clipPos = TransformWorldToClip(WorldPos);
    float4 shadowCoord = ComputeScreenPos(clipPos);
#else
    float4 shadowCoord = TransformWorldToShadowCoord(WorldPos);
#endif

    Light mainLight = GetMainLight(shadowCoord);
    float3 lightColor = mainLight.color * mainLight.distanceAttenuation * mainLight.shadowAttenuation * SpecularColor;
    float tmpSpecular = pow(saturate(dot(WorldNormal, normalize(mainLight.direction + ViewDirection))), SpecularPower) * SpecularIntensity;
    if (tmpSpecular < Threholds.x) {
        Specular = RampedSpecular.x;
    }else if (tmpSpecular < Threholds.y) {
        Specular = RampedSpecular.y;
    }else {
        Specular = RampedSpecular.z;
    }
    Color = Specular * lightColor;

    int pixelLightCount = GetAdditionalLightsCount();
    for (int i = 0; i < pixelLightCount; ++i)
    {
        Light light = GetAdditionalLight(i, WorldPos);
        float4 tmp = unity_LightIndices[i / 4];
        uint light_i = tmp[i % 4];

        half shadowAtten = light.shadowAttenuation * AdditionalLightRealtimeShadow(light_i, WorldPos, light.direction);
        half NdotL = saturate(dot(WorldNormal, light.direction));
        float3 lightColor = light.color.rgb * light.distanceAttenuation * shadowAtten * SpecularColor;
        tmpSpecular = pow(NdotL, SpecularPower) * SpecularIntensity;
        float ramped = 0.0f;
        if (tmpSpecular < Threholds.x) {
            ramped = RampedSpecular.x;
        }
        else if (tmpSpecular < Threholds.y) {
            ramped = RampedSpecular.y;
        }
        else {
            ramped = RampedSpecular.z;
        }
        Color += ramped * lightColor;
        Specular += ramped;
    }
#endif

}