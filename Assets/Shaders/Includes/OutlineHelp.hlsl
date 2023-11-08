SAMPLER(sampler_point_clamp);

void GetDepth_float(float2 uv, out float Depth)
{
    Depth = SHADERGRAPH_SAMPLE_SCENE_DEPTH(uv);
}


void GetNormal_float(float2 uv, out float3 Normal)
{
    Normal = SAMPLE_TEXTURE2D(_NormalsBuffer, sampler_point_clamp, uv).rgb;
}

static float2 sobelOffsets[9] = {
    float2(-1, 1), float2(0, 1), float2(1, 1),
    float2(-1, 0), float2(0, 0), float2(1, 0),
    float2(-1, -1), float2(0, -1), float2(1, -1)
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

void GetDepthSobel_float(float2 UV, float Thickness, out float Out)
{
    float2 sobel = 0;

    float2 offsetFactor = float2(1.f / _ScreenParams.x, 1.f / _ScreenParams.y) * Thickness;
    
    [unroll] for (int i = 0; i < 9; ++i)
    {
        float depth = SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV + sobelOffsets[i] * offsetFactor);
        sobel += depth * float2(sobelXMatrix[i], sobelYMatrix[i]);
    }

    Out = length(sobel);
}

void GetRobertsCross_float(float2 UV, float Thickness, out float Out)
{
    float2 offsetFactor = float2(1.f / _ScreenParams.x, 1.f / _ScreenParams.y) * Thickness;

    float3 topLeft = SAMPLE_TEXTURE2D(_NormalsBuffer, sampler_point_clamp,
        UV + float2(-offsetFactor.x, offsetFactor.y)).rgb;
    float3 topRight = SAMPLE_TEXTURE2D(_NormalsBuffer, sampler_point_clamp,
        UV + float2(offsetFactor.x, offsetFactor.y)).rgb;
    float3 bottomLeft = SAMPLE_TEXTURE2D(_NormalsBuffer, sampler_point_clamp,
        UV + float2(-offsetFactor.x, -offsetFactor.y)).rgb;
    float3 bottomRight = SAMPLE_TEXTURE2D(_NormalsBuffer, sampler_point_clamp,
        UV + float2(offsetFactor.x, -offsetFactor.y)).rgb;

    float3 cross1 = topLeft - bottomRight;
    float3 cross2 = topRight - bottomLeft;

    Out = sqrt(dot(cross1, cross1) + dot(cross2, cross2));
}