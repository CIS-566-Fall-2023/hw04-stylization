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

float BlinnPhongOneLight(float3 normal, float3 viewDir, float3 worldPos, float3 lightColor, float3 lightDir, float lightDistanceAtten, float lightShadowAtten, float specWeight, float shiness, float rimWeight)
{
    float3 reflectDir = reflect(-lightDir, normal);
    // Compute the specular reflection using the Blinn-Phong model
    float3 halfVec = normalize(lightDir + viewDir);
    float specular = pow(max(dot(halfVec, normal), 0.0), shiness);
    float rim = max(0, abs(dot(normal, viewDir)));
    
    float lightDotNormal = saturate(dot(normal, lightDir));
    float shaded = lightDotNormal * lightColor * lightDistanceAtten * lightShadowAtten + 
        specWeight * specular + rim * rimWeight;
    return shaded;
}


void BlinnPhong_float(
    float3 ambientColor,
    float ambientWeight,
    float3 normal,
    float3 viewDir,
    float3 worldPos,
    float specWeight,
    float shiness,
    float rimWeight,
    out float shaded
) {
    float3 mainLightColor;
    float3 mainLightDir;
    float mainLightDistanceAtten;
    float mainLightShadowAtten;

    GetMainLight_float(worldPos, mainLightColor, mainLightDir, mainLightDistanceAtten, mainLightShadowAtten);
    shaded = BlinnPhongOneLight(normal, viewDir, worldPos, mainLightColor, mainLightDir, mainLightDistanceAtten, mainLightShadowAtten, specWeight, shiness, rimWeight);
    
#ifndef SHADERGRAPH_PREVIEW
    int pixelLightCount = GetAdditionalLightsCount();
    for (int i = 0; i < pixelLightCount; ++i) {
        Light light = GetAdditionalLight(i, worldPos);
        float4 tmp = unity_LightIndices[i / 4];
        uint light_i = tmp[i % 4];
        float3 lightColor = light.color.rgb;
        float3 lightDir = light.direction;
        float lightDistanceAtten = light.distanceAttenuation;
        float lightShadowAtten = light.shadowAttenuation * AdditionalLightRealtimeShadow(light_i, worldPos, lightDir);
        shaded += BlinnPhongOneLight(normal, viewDir, worldPos, lightColor, lightDir, lightDistanceAtten, lightShadowAtten, specWeight, shiness, rimWeight);
    }
#endif
    shaded += ambientColor * ambientWeight;
}

void BlendSamples_float(
    Texture2DArray texs,
    SamplerState samp,
    float2 uv,
    float intensity,
    float uv_scale,
    float specFactor,
    out float3 sampled_color
) {
    // intensity = clamp(intensity, 0, 1);
    
    int w,h,n;
    texs.GetDimensions(w, h, n);
    float val = intensity * n;
    int tex1 = floor(val);
    int tex2 = ceil(val);
    float fr = frac(val);
    float2 uv2 = uv * uv_scale;
    float3 color1 = texs.SampleLevel(samp, float3(uv2, tex1), 0);
    float3 color2 = tex2 == n ? float3(1, 1, 1) : texs.SampleLevel(samp, float3(uv2, tex2), 0);
    sampled_color = lerp(color1, color2, fr);
}

void Stepify_float(float val, float min_val, float max_val, float step, out float out_val) {
    float range = max_val - min_val;
    float num_steps = range / step;
    float step_size = range / num_steps;
    float step_val = floor((val - min_val) / step_size);
    out_val = min_val + step_val * step_size;
}