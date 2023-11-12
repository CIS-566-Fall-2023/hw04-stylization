SAMPLER(sampler_point_clamp);

void GetDepth_float(float2 uv, out float Depth)
{
    Depth = SHADERGRAPH_SAMPLE_SCENE_DEPTH(uv);
}

void GetNormal_float(float2 uv, out float3 Normal)
{
    Normal = SAMPLE_TEXTURE2D(_NormalsBuffer, sampler_point_clamp, uv).rgb;
}

// Rainbow liner
void rainbowColor_float(float3 diffuseColor, float time, out float3 Out)
{
    // Rainbow Palette!
    float3 a = float3(0.5, 0.5, 0.5);
    float3 b = float3(0.5, 0.5, 0.5);
    float3 c = float3(1.0, 1.0, 1.0);
    float3 d = float3(0.0, 0.33, 0.67) + (time * 0.03);

    Out = diffuseColor.rgb + a + b * cos(2 * 3.1415926535897932384626433 * (c + d));
}

// Sobel Helper Functions
// Horizontal kernel
static float xKernel[9] = {
    1, 0, -1,
    2, 0, -2,
    1, 0, -1
};

// Vertical kernel
static float yKernel[9] = {
    1, 2, 1,
    0, 0, 0,
    -1, -2, -1
};

// Noise functions
float rand(float2 xy)
{
    return frac(sin(dot(xy, float2(12.9898 - 0.0, 78.233 + 0.0))) * (43758.5453 + 0.0));
}

float timeRand(float2 xy, float t) {
    float2 seed = float2(
        dot(xy, float2(12.9898, 78.233)), 
        dot(xy, float2(39.3467, 11.1355)) + t);
    return frac(sin(dot(seed, float2(127.1, 311.7))) * 43758.5453);
}

float perlinNoise(float2 uv, float time)
{
    float t = 8.5, p = 0.0;

    for (float i = 0.0; i < 8.0; i++)
    {
        float a = timeRand(float2(floor(t * uv.x) / t, floor(t * uv.y) / t), time);
        float b = timeRand(float2(ceil(t * uv.x) / t, floor(t * uv.y) / t), time);
        float c = timeRand(float2(floor(t * uv.x) / t, ceil(t * uv.y) / t), time);
        float d = timeRand(float2(ceil(t * uv.x) / t, ceil(t * uv.y) / t), time);

        if ((ceil(t * uv.x) / t) == 1.0)
        {
            b = rand(float2(0.0, floor(t * uv.y) / t));
            d = rand(float2(0.0, ceil(t * uv.y) / t));
        }

        float coef1 = frac(t * uv.x);
        float coef2 = frac(t * uv.y);

        float f1 = (1.0 - cos(coef1 * 3.1415927)) * 0.5;
        float f2 = (1.0 - cos(coef2 * 3.1415927)) * 0.5;

        float interp1 = a * (1.0 - f1) + b * f1;
        float interp2 = c * (1.0 - f1) + d * f1;
        float interp3 = interp1 * (1.0 - f2) + interp2 * f2;

        p += interp3 * (1.0 / pow(2.0, (i + 0.6)));
        t *= 2.0;
    }
    return p;
}

void depthSobel_float(float time, float2 UV, float Thickness, float depthThreshold, float depthStrength,
    float Scale, float Intensity, float NoiseIntensity, out float Out) {

    // Perlin noise
    float scale = 3.0;
    float pNoise = perlinNoise(UV * scale, time);
    float2 noiseUV = UV + (pNoise * 2.0 - 1.0) * NoiseIntensity;
    float noiseOffsetThreshold = perlinNoise(noiseUV * 5.0, time) * 0.5 * depthThreshold;
    float strength = Intensity * depthStrength;
    float noiseOffsetStrength = (perlinNoise(noiseUV * Scale + float2(1.0, 1.0), time)  * 2.0 - 1.0) * strength;
    float2 gradient = 0;

    for (int i = 0; i < 9; i++) 
    {
        float multiplier = NoiseIntensity * Thickness;
        float2 pNoise2 = perlinNoise(noiseUV * scale + float2(5.0, 6.0) * i, time) * multiplier;
        float2 sampleUV = noiseUV + float2(xKernel[i], yKernel[i]) * Thickness + pNoise2;
        float depth = SHADERGRAPH_SAMPLE_SCENE_DEPTH(sampleUV);
        gradient += depth * float2(xKernel[i], yKernel[i]);
    }

    float smoothStep = smoothstep(0, depthThreshold + noiseOffsetThreshold, length(gradient));
    smoothStep = pow(smoothStep, 1.5) * (depthStrength + noiseOffsetStrength);
    Out = smoothStep;
}