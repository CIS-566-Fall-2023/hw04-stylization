SAMPLER(sampler_point_clamp); //"necessary function, clamps to (0,1)

void GetDepth_float(float2 uv, out float Depth) //Access the depth textures
{
    Depth = SHADERGRAPH_SAMPLE_SCENE_DEPTH(uv);
}


void GetNormal_float(float2 uv, out float4 Normal) //Access the normals textures
{
    Normal = SAMPLE_TEXTURE2D(_Normals_Buffer, sampler_point_clamp, uv);
}

void GetScene_float(float2 uv, out float4 Scene) //Access the normals textures
{
    //Scene = SAMPLE_TEXTURE2D(_SceneBuffer, sampler_point_clamp, uv);
}


void GetCrossSampleUVs_float(float4 UV, float2 TexelSize, float OffsetMultiplier, 
    out float2 UVOriginal, 
    out float2 UVTopRight, out float2 UVBottomLeft, 
    out float2 UVTopLeft, out float2 UVBottomRight) {

    UVOriginal = UV; 
    UVTopRight = UV.xy + float2(TexelSize.x, TexelSize.y) * OffsetMultiplier;
    UVBottomLeft = UV.xy - float2(TexelSize.x, TexelSize.y) * OffsetMultiplier;
    
    UVTopLeft = UV.xy + float2(-TexelSize.x * OffsetMultiplier, TexelSize.y * OffsetMultiplier);
    UVBottomRight = UV.xy + float2(TexelSize.x * OffsetMultiplier, -TexelSize.y * OffsetMultiplier);
}

void IfAnyNonZeroReturnOneElseZero_float(float A, float B,
    float C, float D, out float final)
{

    if (A + B + C + D == 0)
    {
        final = 0; 
    }
    else
    {
        final = 1; 
    }
    
}