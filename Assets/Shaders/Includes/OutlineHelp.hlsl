SAMPLER(sampler_point_clamp);

void GetDepth_float(float2 uv, out float Depth)
{
    Depth = SHADERGRAPH_SAMPLE_SCENE_DEPTH(uv);

    // Lower bound: 0.0195
    // Upper bound: 0.04675
}


void GetNormal_float(float2 uv, out float3 Normal)
{
    Normal = SAMPLE_TEXTURE2D(_NormalsBuffer, sampler_point_clamp, uv).rgb;
}

static float2 sobelSamplePoints[9] = {
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

float ReadDepth(float2 UV, float Thickness, int i, float2 ScreenRatios) {
    float depth = SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV + sobelSamplePoints[i] * Thickness);
    if (depth >= 0.0195 && depth <= 0.04675) {
        // Remap depth.
        float numerator = depth - 0.0195;
        float denominator = 0.04675 - 0.0195;
        depth = numerator / denominator;
    }
    else {
        depth = 0.0;
    }
    return depth;
}

void DepthSobel_float(float2 UV, float Thickness, float2 ScreenRatios, out float OUT) {
    float2 sobel = 0;
    //float depth = SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV);
    [unroll] for (int i = 0; i < 9; i++) {
        float depth = ReadDepth(UV, Thickness, i, ScreenRatios);
        if (depth > 0.0) {
            sobel += depth * float2(sobelXMatrix[i], sobelYMatrix[i]);
        }
    }
    OUT = length(sobel);
}


void ColourSobel_float(float2 UV, float Thickness, out float OUT) {
    float2 sobelR = 0;
    float2 sobelG = 0;
    float2 sobelB = 0;

    [unroll] for (int i = 0; i < 9; i++) {
        float3 rgb = SHADERGRAPH_SAMPLE_SCENE_COLOR(UV + sobelSamplePoints[i] * Thickness);
        float2 kernel = float2(sobelXMatrix[i], sobelYMatrix[i]);

        sobelR += rgb.r * kernel;
        sobelG += rgb.g * kernel;
        sobelB += rgb.b * kernel;
    }

    OUT = max(length(sobelR), max(length(sobelG), length(sobelB)));
}

void NormalSobel_float(float2 UV, float Thickness, out float OUT) {
    float redSobel = 0;
    float greenSobel = 0;
    float blueSobel = 0;

    [unroll] for (int i = 0; i < 9; i++) {
        float2 currPixel = UV + sobelSamplePoints[i] * Thickness;

        float3 Normal;
        GetNormal_float(currPixel, Normal);

        redSobel += Normal.r * float2(sobelXMatrix[i], sobelYMatrix[i]);
        greenSobel += Normal.g * float2(sobelXMatrix[i], sobelYMatrix[i]);
        blueSobel += Normal.b * float2(sobelXMatrix[i], sobelYMatrix[i]);
    }

    OUT = max(length(redSobel), max(length(greenSobel), length(blueSobel)));
}