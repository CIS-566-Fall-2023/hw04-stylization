SAMPLER(sampler_point_clamp);

void GetDepth_float(float2 uv, out float Depth)
{
    Depth = SHADERGRAPH_SAMPLE_SCENE_DEPTH(uv);
}


void GetNormal_float(float2 uv, out float3 Normal)
{
    Normal = SAMPLE_TEXTURE2D(_NormalsBuffer, sampler_point_clamp, uv).rgb;
}
float rnd(float2 xy)
{
    return frac(sin(dot(xy, float2(12.9898 - 0.0, 78.233 + 0.0))) * (43758.5453 + 0.0));
}

float rndTime(float2 xy, float t) {
    float2 seed = float2(dot(xy, float2(12.9898, 78.233)), dot(xy, float2(39.3467, 11.1355)) + t);
    return frac(sin(dot(seed, float2(127.1, 311.7))) * 43758.5453);
}
float inter(float a, float b, float x)
{
    //return a*(1.0-x) + b*x; // Linear interpolation

    float f = (1.0 - cos(x * 3.1415927)) * 0.5; // Cosine interpolation
    return a * (1.0 - f) + b * f;
}
float perlinTime(float2 uv, float time)
{
    float a, b, c, d, coef1, coef2, t, p;

    t = 8.0;					// Precision
    p = 0.0;								// Final heightmap value

    for (float i = 0.0; i < 8.0; i++)
    {
        a = rndTime(float2(floor(t * uv.x) / t, floor(t * uv.y) / t), time);	    //	a----b
        b = rndTime(float2(ceil(t * uv.x) / t, floor(t * uv.y) / t), time);		//	|    |
        c = rndTime(float2(floor(t * uv.x) / t, ceil(t * uv.y) / t), time);		//	c----d
        d = rndTime(float2(ceil(t * uv.x) / t, ceil(t * uv.y) / t), time);

        if ((ceil(t * uv.x) / t) == 1.0)
        {
            b = rnd(float2(0.0, floor(t * uv.y) / t));
            d = rnd(float2(0.0, ceil(t * uv.y) / t));
        }

        coef1 = frac(t * uv.x);
        coef2 = frac(t * uv.y);
        p += inter(inter(a, b, coef1), inter(c, d, coef1), coef2) * (1.0 / pow(2.0, (i + 0.6)));
        t *= 2.0;
    }
    return p;
}

static float2 sobelSamplePoints[9] = {
    float2(-1, 1), float2(0, 1), float2(1, 1),
    float2(-1, 0), float2(0, 0), float2(1, 0),
    float2(-1, -1), float2(0, -1), float2(1, -1),
};

// Weights for the x component
static float sobelXMatrix[9] = {
    1, 0, -1,
    2, 0, -2,
    1, 0, -1
};

// Weights for the y component
static float sobelYMatrix[9] = {
    1, 2, 1,
    0, 0, 0,
    -1, -2, -1
};

void depthSobel_float(
    float time, float2 UV, float Thickness, float depthThreshold,
    float depthTightening, float depthStrength,
    float thresholdNScale, float thresholdNIntensity,
    float strengthNScale, float strengthNIntensity,
    float lineNoiseScale, float lineNoiseIntensity,
    out float Out) {

    float2 noiseUV = UV + (perlinTime(UV * lineNoiseScale, time) * 2.0 - 1.0) * lineNoiseIntensity;

    // Calculate noise offsets for the threshold and strength
    float noiseOffsetThreshold = perlinTime(noiseUV * thresholdNScale, time) * thresholdNIntensity * depthThreshold;
    float noiseOffsetStrength = (perlinTime(noiseUV * strengthNScale + float2(1.0, 1.0), time)*2.-1.) * strengthNIntensity * depthStrength;
    
    float2 sobel = 0;

    [unroll] for (int i = 0; i < 9; i++) {
        float2 additionalNoise = perlinTime(noiseUV * lineNoiseScale + float2(5.0, 6.0) * i, time) * lineNoiseIntensity * Thickness;
        float2 sampleUV = noiseUV + sobelSamplePoints[i] * Thickness + additionalNoise;
        float depth = SHADERGRAPH_SAMPLE_SCENE_DEPTH(sampleUV);
        sobel += depth * float2(sobelXMatrix[i], sobelYMatrix[i]);
    }

    // Get the final sobel value
    float smooth = smoothstep(0, depthThreshold + noiseOffsetThreshold, length(sobel));
    smooth = pow(smooth, depthTightening) * (depthStrength + noiseOffsetStrength);

    Out = smooth;
}