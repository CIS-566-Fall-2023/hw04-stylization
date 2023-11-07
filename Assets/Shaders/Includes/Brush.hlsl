void GetMainLight_float(float3 WorldPos, out float3 Color, out float3 Direction, out float DistanceAtten, out float ShadowAtten)
{
#ifdef SHADERGRAPH_PREVIEW
    Direction = normalize(float3(0.5, 0.5, 0));
    Color = float3(0,1,0);
    DistanceAtten = 1;
    ShadowAtten = 1;
#else
    #if SHADOWS_SCREEN
        float4 clipPos = TransformWorldToHClip(WorldPos);
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

void ToGreyScale_float(float4 mainColor, float4 brushColor, out float texGrey, out float brushGrey) {
    texGrey = (mainColor.x + mainColor.y + mainColor.z) * 0.333;
    // similar to gamma correction, brighten or darken the grayscale value, 
    // depending on whether it's above or below 1, respectively. 
    texGrey = pow(texGrey, 0.3);
    texGrey *= 1 - cos(texGrey * 3.1415926);
    brushGrey = (brushColor.r + brushColor.g + brushColor.b) * 0.333;
}

void BlendGreyScale_float(float texGrey, float brushGrey, out float blend, out float4 col)
{
    blend = texGrey * 0.5 + brushGrey * 0.5;
    col = float4(blend, blend, blend, 1.0);
}

void vert_float(float3 burn, float3 normal_vs, float3 position_ms, float _MaxOutlineZOffset, float _Outline, 
    out float3 modifyPos)
{
    float3 scaledir = normal_vs;
    scaledir += 0.5;
    scaledir.z = 0.01;
    scaledir = normalize(scaledir);

    float4 position_cs = mul(UNITY_MATRIX_MV, position_ms);
    position_cs /= position_cs.w;

    float3 viewDir = normalize(position_cs.xyz);
    float3 offset_pos_cs = position_cs.xyz + viewDir * _MaxOutlineZOffset;

    // cos(FOV/2) = GetViewToHClipMatrix()[1].y
    float linewidth = -position_cs.z / (GetViewToHClipMatrix()[1].y);
    linewidth = sqrt(linewidth);
    position_cs.xy = offset_pos_cs.xy + scaledir.xy * linewidth * burn.x * _Outline;
    position_cs.z = offset_pos_cs.z;
    modifyPos = mul(UNITY_MATRIX_P, position_cs).xyz;
}

void extrude_position_float(float3 offset_pos_cs, float3 scaledir, float _Outline, out float3 position_ms)
{
    position_ms.xy = offset_pos_cs.xy + scaledir.xy * _Outline * 5;
    position_ms.z = offset_pos_cs.z;
    position_ms = TransformViewToWorld(position_ms);
}