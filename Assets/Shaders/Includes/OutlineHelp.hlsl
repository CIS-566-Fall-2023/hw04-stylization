SAMPLER(sampler_point_clamp);

void GetDepth_float(float2 uv, out float Depth)
{
    Depth = SHADERGRAPH_SAMPLE_SCENE_DEPTH(uv);
}


float3 GetNormal(float2 uv)
{
    return SAMPLE_TEXTURE2D(_NormalsBuffer, sampler_point_clamp, uv).rgb;
}


static float2 sobelSamplePoints[9] = {
    float2(-1, 1), float2(0, 1), float2(1, 1),
    float2(-1, 0), float2(0, 0), float2(1, 0),
    float2(-1, -1), float2(0, -1), float2(1, -1),
};

static float sobelXMatrix[9] = {
    1, 0, -1,
    2, 0, -2,
    1, 0, -1
};

static float sobelYMatrix[9] = {
    1, 2, 1,
    0, 0, 0,
    -1, -2, -1
};

void DepthSobel_float(float2 uv, float thickness, out float Out) {
    float2 sobel = 0;
    [unroll] for (int i = 0; i < 9; i++) {
        float depth = SHADERGRAPH_SAMPLE_SCENE_DEPTH(uv + sobelSamplePoints[i] * thickness);
        sobel += depth * float2(sobelXMatrix[i], sobelYMatrix[i]);
    }
    //[unroll] for (int i = 0; i < 9; i++)
    //{
    //    float normal = GetNormal(uv + sobelSamplePoints[i] * thickness);
    //    sobel += normal * float2(sobelXMatrix[i], sobelYMatrix[i]);
    //}

    Out = length(sobel);
}