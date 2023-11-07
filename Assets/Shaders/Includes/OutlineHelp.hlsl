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

float2 random(float2 r) {
    return float2(sin(float2(dot(r, float2(127.1, 311.7)), dot(r, float2(269.5, 183.3)))) * 43758.5453);
}

float surflet(float2 P, float2 gridPoint) {
    // Compute falloff function by converting linear distance to a polynomial
    float distX = abs(P.x - gridPoint.x);
    float distY = abs(P.y - gridPoint.y);
    float tX = 1.0 - 6.0 * pow(distX, 5.f) + 15.0 * pow(distX, 4.f) - 10.0 * pow(distX, 3.f);
    float tY = 1.0 - 6.0 * pow(distY, 5.f) + 15.0 * pow(distY, 4.f) - 10.0 * pow(distY, 3.f);
    // Get the random vector for the grid point
    float2 gradient = 2.f * random(gridPoint) - float2(1.f, 0.f);
    // Get the vector from the grid point to P
    float2 diff = P - gridPoint;
    // Get the value of our height field by dotting grid->P with our gradient
    float height = dot(diff, gradient);
    // Scale our height field (i.e. reduce it) by our polynomial falloff function
    return height * tX * tY;
}


float perlinNoise(float2 uv) {
    float surfletSum = 0.f;
    // Iterate over the four integer corners surrounding uv
    for (int dx = 0; dx <= 1; ++dx) {
        for (int dy = 0; dy <= 1; ++dy) {
            surfletSum += surflet(uv, floor(uv) + float2(dx, dy));
        }
    }
    return surfletSum;
}


void NormalSobel_float(float2 UV, float Thickness, float NoiseScale, float NoiseIntensity, out float OUT) {
    float redSobel = 0;
    float greenSobel = 0;
    float blueSobel = 0;

    // Noise on lines.
    float2 noisePixelOffset = perlinNoise(UV * NoiseScale) * NoiseIntensity;
    float2 UVAccum = 0.0000001 * noisePixelOffset + UV;

    [unroll] for (int i = 0; i < 9; i++) {
        float2 currPixel = UVAccum + sobelSamplePoints[i] * Thickness;

        float3 Normal;
        GetNormal_float(currPixel, Normal);

        redSobel += Normal.r * float2(sobelXMatrix[i], sobelYMatrix[i]);
        greenSobel += Normal.g * float2(sobelXMatrix[i], sobelYMatrix[i]);
        blueSobel += Normal.b * float2(sobelXMatrix[i], sobelYMatrix[i]);
    }

    OUT = max(length(redSobel), max(length(greenSobel), length(blueSobel)));
}