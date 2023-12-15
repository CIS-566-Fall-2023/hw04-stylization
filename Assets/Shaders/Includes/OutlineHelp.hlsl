SAMPLER(sampler_point_clamp);

void GetDepth_float(float2 uv, out float Depth)
{
    Depth = SHADERGRAPH_SAMPLE_SCENE_DEPTH(uv);
}


void GetNormal_float(float2 uv, out float3 Normal)
{
    Normal = SAMPLE_TEXTURE2D(_NormalsBuffer, sampler_point_clamp, uv).rgb;
}

//Sobel Functions
static float2 sobelSamplePoints[9] =
{
    float2(-1, 1), float2(0, 1), float2(1, 1),
    float2(-1, 0), float2(0, 0), float2(1, 1),
    float2(-1, -1), float2(0, -1), float2(1, -1)
};

static float sobelXMatrix[9] =
{
    1, 0, -1,
    2, 0, -2,
    1, 0, -1
};

static float sobelYMatrix[9] =
{
    1, 2, 1,
    0, 0, 0,
    -1, -2, -1
};

float DepthSobel_float_helper(float2 UV, float Thickness, int i, float2 ScreenRatios) {
    float depth = SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV + sobelSamplePoints[i] * Thickness);
    if (depth >= 0.02 && depth <= 0.045) 
    {
        float numerator = depth - 0.02;
        float denominator = 0.045 - 0.02;
        depth = numerator / denominator;
    }
    else 
    {
        depth = 0.0;
    }
    return depth;
}

void DepthSobel_float(float2 UV, float Thickness, float2 ScreenRatios, out float OUT) {
    float2 sobel = 0;
    [unroll] 
    for (int i = 0; i < 9; i++) 
    {
        float depth;
        GetDepth_float(UV + sobelSamplePoints[i] * Thickness, depth);
        if (depth > 0.0) {
            sobel += depth * float2(sobelXMatrix[i], sobelYMatrix[i]);
        }
    }
    OUT = length(sobel);
}

void NoiseSobel_float(float2 UV, float Thickness, float noise, float noiseStrength, out float OUT)
{
    float2 sobel = 0;
    [unroll]
    for (int i = 0; i < 9; i++)
    {
        float depth;
        GetDepth_float(UV + sobelSamplePoints[i] * Thickness + noise * noiseStrength, depth);
        sobel += depth * float2(sobelXMatrix[i], sobelYMatrix[i]);
    }

    OUT = length(sobel);

}