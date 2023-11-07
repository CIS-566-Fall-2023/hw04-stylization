SAMPLER(sampler_point_clamp);

static float2 SamplePoints[] = {
    float2(-1, 1), float2(0, 1), float2(1, 1),
    float2(-1, 0), float2(0, 0), float2(1, 1),
    float2(-1, -1), float2(0, -1), float2(1, -1),
};

static float2 Kernel[9] = {
    float2(1, 1), float2(0, 2), float2(-1, 1),
    float2(2, 0), float2(0, 0), float2(-2, 0),
    float2(1, -1), float2(0, -2), float2(-1, -1),
};

float SampleDepth(float2 uv) {
    return SHADERGRAPH_SAMPLE_SCENE_DEPTH(uv);
}

float SampleNormal(float2 uv) {
    return SAMPLE_TEXTURE2D(_NormalsBuffer, sampler_point_clamp, uv).rgb;
}

void GetDepth_float(float2 uv, out float Depth) {
    Depth = SampleDepth(uv);
}

void GetNormal_float(float2 uv, out float3 Normal) {
    Normal = SampleNormal(uv);
}

void EdgeDetection_float(float2 uv, float range, out float Out) {
    float2 conv = 0;

    [unroll]
    for (uint i = 0; i < 9; i++) {
        float depth = SampleDepth(uv + SamplePoints[i] * range);
        conv += depth * Kernel[i];
    }
    Out = length(conv);
}