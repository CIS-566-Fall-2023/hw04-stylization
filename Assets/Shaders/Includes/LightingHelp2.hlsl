void GetMainLight_float(float3 WorldPos, out float3 Color, out float3 Direction, out float DistanceAtten, out float ShadowAtten) {
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

void ChooseColor_float(float3 Highlight, float3 Shadow, float3 EdgeTex,
                       float Diffuse, float EdgeTerm, 
                       float Threshold, float Threshold2, float EdgeThreshold, float EdgeThreshold2, 
                       float RimMult,
                       out float3 OUT)
{
    if (EdgeTerm < EdgeThreshold)
    {
       if(Diffuse < Threshold)
       {
          if (EdgeTerm < EdgeThreshold2) OUT = float3(0, 0, 0);
          else OUT = EdgeTex;
       }
       else if(Diffuse < Threshold2)
       {
          float3 temp = 0.5 * Shadow +  0.5 * Highlight;
          EdgeTerm += RimMult;
          OUT = float3(1, 1, 1) * (1 - EdgeTerm) + temp * EdgeTerm;
       }
       else
       {
          EdgeTerm += RimMult;
          OUT = float3(1, 1, 1) * (1 - EdgeTerm) + Highlight * EdgeTerm;
       }
    }
    else if (Diffuse < Threshold)
    {
        OUT = Shadow;
    }
    else if(Diffuse < Threshold2)
    {
        OUT = 0.5 * Shadow +  0.5 * Highlight;
    }
    else
    {
        OUT = Highlight;
    }
}