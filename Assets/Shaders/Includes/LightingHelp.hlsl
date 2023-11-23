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

void ChooseColor3Tone_float(float3 Highlight, float3 Shadow, float3 MidTone, float Diffuse, float Threshold, float Threshold2, out float3 OUT, out float3 SHADOW_HATCH_MASK, out float3 MIDTONE_HATCH_MASK)
{
    SHADOW_HATCH_MASK = float3(0.0f, 0.0f, 0.0f);
    MIDTONE_HATCH_MASK = float3(0.0f, 0.0f, 0.0f);
    if (Diffuse < Threshold && Diffuse < Threshold2)
    {
        OUT = Shadow;
        SHADOW_HATCH_MASK = float3(1.0f, 1.0f, 1.0f);
    }
    else if (Diffuse < Threshold2)
    {
        OUT = MidTone;
        MIDTONE_HATCH_MASK = float3(1.0f, 1.0f, 1.0f);
    }
    else
    {
        OUT = Highlight;
    }
}

void ChooseThreeToneSimple_float(float3 Highlight, float3 Midtone, float3 Shadow, float Diffuse, float Threshold1, float Threshold2, out
float3 OUT)
{
    if (Diffuse < Threshold1)
    {
        OUT = Shadow;
    }
    else if (Diffuse < Threshold2)
    {
        OUT = Midtone;
    }
    else
    {
        OUT = Highlight;
    }
}

void MapCircle_float(float3 innerColor, float3 outerColor, float3 backgroundColor, float colorOffset, float xOffset, float yOffset, float radius, float falloff, float falloffLimit, float xValue, float yValue, out float3 OUT)
{
    float circleValue = pow((xValue - xOffset), 2) + pow((yValue - yOffset), 2);
    //float3 realOuterColor = lerp(outerColor, backgroundColor, 0.5);
    if (circleValue <= pow(radius, 2))
    {
        float circleP = sqrt(circleValue) / radius;
        OUT = lerp(innerColor, outerColor, circleP * colorOffset);

    }
    else
    {
        // Not a circle
        float outerP = (sqrt(circleValue) - radius) / (falloffLimit - radius);
        OUT = lerp(outerColor, backgroundColor, outerP * falloff);
        //OUT = float3(defaultC, defaultC, defaultC);
    }
}


float GetBias(float time, float bias)
{
    return (time / ((((1.0 / bias) - 2.0) * (1.0 - time)) + 1.0));
}

float GetGain(float time, float gain)
{
  if(time < 0.5)
    return GetBias(time * 2.0,gain)/2.0;
  else
    return GetBias(time * 2.0 - 1.0,1.0 - gain)/2.0 + 0.5;
}

void ComputeCloudColor_float(float3 leftRightColor, float3 DColor1, float3 DColor2, float3 DColor3, float3 DColor4, 
float3 sunColor, float3 normal, float threshold, float Dthreshold1, float Dthreshold2, float Dthreshold3, float yPosition, float zPosition, float bias, out float3 OUT)
{
    float biasedY = GetGain(yPosition, bias);
    float3 backFrontColor;
    if (zPosition <= Dthreshold1)
    {
        backFrontColor = DColor1;
    }
    else if (zPosition <= Dthreshold2)
    {
        backFrontColor = DColor2;
    }
    else if (zPosition <= Dthreshold3)
    {
        backFrontColor = DColor3;
    }
    else
    {
        backFrontColor = DColor4;
    }
    float3 gradientColor = lerp(leftRightColor, backFrontColor, biasedY);;
    if (dot(normal, float3(1, 0, 0)) <= threshold) 
    {
        OUT = sunColor;
    }
    else
    {
        OUT = gradientColor;
    }
    
}

void computeFoamColor_float(float dotProd, float foamThreshold, float zDistance, float foamBias, out float OUT)
{
    if (dotProd < foamThreshold)
    {
        OUT = 1.f * GetBias((1 - zDistance), foamBias);
    }
    else
    {
        OUT = 0.0;
    }
}

void computePalmColor_float(float3 treeColor, float3 highlightColor, float3 shadowColor, float xDistance, float yDistance, float threshold, float threshold2, out float3 OUT)
{
    if ((1 - xDistance) < threshold2)
    {
        OUT = highlightColor;
    }
    else if (yDistance * threshold < xDistance)
    {
        OUT = treeColor;
    }
    else
    {
        OUT = shadowColor;
    }
}
