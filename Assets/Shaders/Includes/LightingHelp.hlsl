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

void ChooseColor2_float(float3 Highlight, float3 Midtone, float3 Shadow, float Diffuse, float Threshold1, float Threshold2, out float3 OUT)
{
    if (Diffuse < Threshold1)
    {
        OUT = Shadow;
    }
    else if (Diffuse >= Threshold1 && Diffuse <= Threshold2) {
        OUT = Midtone;
    }
    else
    {
        OUT = Highlight;
    }
}

void ChooseColor3_float(float3 Highlight, float3 Midtone, float3 Shadow, float DiffuseHS, float DiffuseM, float Threshold1, float Threshold2, out float3 OUT)
{
    if (DiffuseM >= Threshold1 && DiffuseM <= Threshold2) {
        OUT = Midtone;
    }
    else if (DiffuseHS < Threshold1)
    {
        OUT = Shadow;
    }
    else if (DiffuseHS > Threshold2)
    {
        OUT = Highlight;
    }
    else {
        OUT = Midtone;
    }
}

// Toolbox helper function
float bias_float(float b, float t) {
    return pow(t, log(b) / log(0.5f));
}

void StylisedBoundsHelper_float(float Diffuse, float Threshold1, float Threshold2, float TransitionBorder, out float DIFFUSE) {
    if (abs(Threshold1 - Diffuse) < abs(Threshold1 - TransitionBorder)) {
        if (Diffuse < Threshold1) {
            float denominator = TransitionBorder;
            float numerator = Diffuse - (Threshold1 - TransitionBorder);
            DIFFUSE = lerp(0, 1, numerator / denominator);
        }
        else {
            float denominator = TransitionBorder;
            float numerator = (Threshold1 + TransitionBorder) - Diffuse;
            DIFFUSE = lerp(0, 1, numerator / denominator);
        }
    }
    else if (abs(Threshold2 - Diffuse) < abs(Threshold2 - TransitionBorder)) {
        if (Diffuse < Threshold2) {
            float denominator = TransitionBorder;
            float numerator = Diffuse - (Threshold2 - TransitionBorder);
            DIFFUSE = lerp(0, 1, numerator / denominator);
        }
        else {
            float denominator = TransitionBorder;
            float numerator = (Threshold2 + TransitionBorder) - Diffuse;
            DIFFUSE = lerp(0, 1, numerator / denominator);
        }
    }
    else {
        DIFFUSE = 0.0;
    }
}

void StylisedBounds_float(float Camel, float Diffuse, float2 ObjectUVs, out float FINAL_DIFFUSE) {
    float noise = 0.1 * sin((ObjectUVs.x + ObjectUVs.y) * 100.0);
    FINAL_DIFFUSE = Diffuse + Camel * noise;
}