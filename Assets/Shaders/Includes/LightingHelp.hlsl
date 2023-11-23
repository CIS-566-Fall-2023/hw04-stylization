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
            float factor=(Thresholds.x-thisDiffuse)/(Thresholds.x);
            rampedDiffuse = (1-factor)*RampedDiffuseValues.x;
        }
        else if (thisDiffuse < Thresholds.y)
        {
            float factor=(Thresholds.y-thisDiffuse)/(Thresholds.y-Thresholds.x);
            rampedDiffuse = (1-factor)*RampedDiffuseValues.y+factor*RampedDiffuseValues.x;
        }
        else
        {
            float factor=(1.0-thisDiffuse)/(1-Thresholds.y);
            rampedDiffuse = (1-factor)*RampedDiffuseValues.z+factor*RampedDiffuseValues.y;
        }

        
        if (light.distanceAttenuation <= 0)
        {
            rampedDiffuse = 0.0;
        }

        Color += max(rampedDiffuse, 0) * light.color.rgb;
        Diffuse += rampedDiffuse;
    }
    
    /*if (Diffuse <= 0.3)
    {
        Color = float3(0, 0, 0);
        Diffuse = 0;
    }*/
    
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

void ChooseColorText_float(float3 Highlight, float3 Midtone, float3 Shadow, float3 text_color, float Diffuse, float2 Thresholds, out float3 OUT)
{
    float color_strength=1-length(text_color);
    if (Diffuse < Thresholds.x)
    {
        OUT = Shadow*color_strength;
    }
    else if (Diffuse < Thresholds.y)
    {
        OUT = Midtone*color_strength;
    }
    else
    {
        OUT = Highlight*color_strength;
    }
    //OUT=Highlight*color_strength+(1.0f-color_strength)*Shadow;
}

void blackline_float(float linethreshold, float input_dot, float3 color, out float3 OUT)
{
    if (input_dot > linethreshold)
    {
        OUT = color;
    }
    else
    {
        OUT = float3(0, 0, 0);
    }
}

void texture_color_float(float3 text_color, float3 original, out float3 OUT)
{
    float color_strength=1.0f-length(text_color);
    OUT=original*color_strength+(1.0f-color_strength)*float3(1,1,1);
}

void ChooseColor3_float(float3 Highlight, float3 Midtone,float3 Shadow, float3 Transparency,float Diffuse, float Threshold1, float Threshold2,float Attenuation, out float3 OUT)
{
        if(Diffuse < Threshold1){
            OUT = Shadow;
        }
        else if (Diffuse < Threshold2)
        {
            float Alpha=length(Transparency);
            OUT = (1.0f-Alpha)*Shadow+Alpha*Midtone;
        }
        else
        {
            OUT = Highlight;
        }
    
}
