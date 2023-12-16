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

// These are points to sample relative to the starting point
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

void DepthSobel_float(float2 UV, float Thickness, out float Out)
{
    float2 sobel = 0;


    [unroll] for (int i = 0; i < 9; ++i)
    {
        float depth = SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV + sobelOffsets[i] * Thickness);
        sobel += depth * float2(sobelXMatrix[i], sobelYMatrix[i]);
    }

    Out = length(sobel);
}

inline float DecodeFloatRG(float2 enc) {
    float2 kDecodeDot = float2(1.0, 1 / 255.0);
    return dot(enc, kDecodeDot);
}

inline float3 DecodeViewNormalStereo(float4 enc4) {
    float kScale = 1.7777;
    float3 nn = enc4.xyz * float3(2 * kScale, 2 * kScale, 0) + float3(-kScale, -kScale, 1);
    float g = 2.0 / dot(nn.xyz, nn.xyz);
    float3 n;
    n.xy = g * nn.xy;
    n.z = g - 1;
    return n;
}

// This function runs the sobel algorithm over the normal texture
void NormalsSobel_float(float2 UV, float Thickness, out float Out) {
    float2 sobelDepth = 0;
    float2 sobelX = 0;
    float2 sobelY = 0;
    float2 sobelZ = 0;
    // We can unroll this loop to make it more efficient
    // The compiler is also smart enough to remove the i=4 iteration, which is always zero
    [unroll] for (int i = 0; i < 9; i++) {
        float depth;
        float3 normal;
        // Get depth and normal for each sample point
        GetDepth_float(UV + sobelSamplePoints[i] * Thickness, depth);
        GetNormal_float(UV + sobelSamplePoints[i] * Thickness, normal);

        // Create the kernel for this iteration
        float2 kernel = float2(sobelXMatrix[i], sobelYMatrix[i]);

        // Accumulate samples for depth and each coordinate
        sobelDepth += depth * kernel;
        sobelX += normal.x * kernel;
        sobelY += normal.y * kernel;
        sobelZ += normal.z * kernel;
    }
    // Combine the XYZ values by taking the one with the largest sobel value
    float maxNormalSobel = max(length(sobelX), max(length(sobelY), length(sobelZ)));

    // Combine depth and normal sobel values for final output
    Out = max(sobelDepth, maxNormalSobel);
}
