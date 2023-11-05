SAMPLER(sampler_point_clamp);

void GetDepth_float(float2 uv, out float Depth)
{
    Depth = SHADERGRAPH_SAMPLE_SCENE_DEPTH(uv);
}


void GetNormal_float(float2 uv, out float3 Normal)
{
   // Normal = SAMPLE_TEXTURE2D(_NormalsBuffer, sampler_point_clamp, uv).rgb;
}

void GetCrossSampleUV_float(float4 uv, float2 texelSize, float multiplier, 
                  out float2 UVori, out float2 UVtr, out float2 UVbl,
                  out float2 UVtl, out float2 UVbr)
{
    UVori = uv;
    UVtr = uv.xy + texelSize * multiplier;
    UVbl = uv.xy - texelSize * multiplier;
    UVtl = uv.xy + float2(-texelSize.x, texelSize.y) * multiplier;
    UVbr = uv.xy + float2(texelSize.x, -texelSize.y) * multiplier;
}
