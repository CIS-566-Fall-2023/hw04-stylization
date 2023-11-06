SAMPLER(sampler_point_clamp);

void GetDepth_float(float2 uv, out float Depth)
{
    Depth = SHADERGRAPH_SAMPLE_SCENE_DEPTH(uv);
}

void GetNormal_float(float2 uv, out float3 Normal)
{
    Normal = SAMPLE_TEXTURE2D(_NormalsBuffer, sampler_point_clamp, uv).rgb;
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

float wobbleEffect(float2 uv, float time, float frequency, float amplitude) {
    float sineValue = sin(time + uv.x * frequency + uv.y * frequency) * amplitude;
    return sineValue;
}

void depthSobel_float(
    float time, float2 UV, float Thickness, float depthThreshold,
    float depthTightening, float depthStrength, out float Out) {

    float2 sobel = 0;

    [unroll] for (int i = 0; i < 9; i++) {
        float depth = SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV + sobelSamplePoints[i] * Thickness + wobbleEffect(UV, time, 25.0, 0.003));
        sobel += depth * float2(sobelXMatrix[i], sobelYMatrix[i]);
    }
    depthThreshold += wobbleEffect(UV, time, 50.0, 0.008);

    float smooth = smoothstep(0, depthThreshold, length(sobel));
    smooth = pow(smooth, depthTightening) * depthStrength;

    float lineVariation = sin(UV.x * 800.0 + time * 3.14) * cos(UV.y * 800.0 + time * 3.14) * 0.2;

    Out = smooth + lineVariation;
}

void GetCrossSampleUVs_float(float4 UV, float2 TexelSize,
    float OffsetMultiplier, out float2 UVOriginal,
    out float2 UVTopRight, out float2 UVBottomLeft,
    out float2 UVTopLeft, out float2 UVBottomRight) {
    UVOriginal = UV;
    UVTopRight = UV.xy + float2(TexelSize.x, TexelSize.y) * OffsetMultiplier;
    UVBottomLeft = UV.xy - float2(TexelSize.x, TexelSize.y) * OffsetMultiplier;
    UVTopLeft = UV.xy + float2(-TexelSize.x * OffsetMultiplier, TexelSize.y * OffsetMultiplier);
    UVBottomRight = UV.xy + float2(TexelSize.x * OffsetMultiplier, -TexelSize.y * OffsetMultiplier);
}
