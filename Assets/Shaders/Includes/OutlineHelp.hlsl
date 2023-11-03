SAMPLER(sampler_point_clamp);

void GetDepth(float2 uv, out float Depth)
{
    Depth = SHADERGRAPH_SAMPLE_SCENE_DEPTH(uv);
}


float3 GetNormal(float2 uv)
{
    return SAMPLE_TEXTURE2D(_NormalsBuffer, sampler_point_clamp, uv).rgb;
}

static const float2 sobelSamplePoints[9] = {
    float2(-1,1), float2(0,1), float2(1,1),
    float2(-1,0), float2(0,0), float2(1,1),
    float2(-1,-1), float2(0,-1), float2(1,-1)
};

static const float sobelXMatrix[9] = { 1, 0, -1,
                          2, 0, -2,
                          1, 0, -1 };

static const float sobelYMatrix[9] = { 1,  2,  1,
                          0,  0,  0,
                         -1,  -2,  -1 };

float noise(float2 coord)
{
    return frac(sin(dot(coord, float2(12.9898, 78.233))) * 43758.5453);
}
float triangle_wave(float x, float freq, float amp) {
  return abs(fmod(x * freq, amp) - 0.5 * amp);
}
float2 warpUV(float2 UV, float Seed, float Intensity, float Thickness, float Offset)
{
    float amp = triangle_wave(UV + Seed * 0.01, 10, 1.0);
    float2 warpedUV = UV + amp * Intensity + Offset;
    return warpedUV;
}

float DepthSobel(float2 UV, float Thickness, float Threshold, float Strength, float Seed)
{
    float2 sobel = 0;
    [unroll] for (int i = 0; i < 9; i++)
    {
        float depth = SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV + sobelSamplePoints[i] * Thickness);
        sobel += depth * float2(sobelXMatrix[i], sobelYMatrix[i]);
    }
    [unroll] for (int i = 0; i < 9; i++)
    {
        float normal = GetNormal(UV + sobelSamplePoints[i] * Thickness);
        sobel += normal * float2(sobelXMatrix[i], sobelYMatrix[i]);
    }
    if (length(sobel) < Threshold)
        sobel = 0;
    return Strength * pow(smoothstep(0, Threshold, length(sobel)), Thickness);
}

float3 blendOverwrite(float3 Base, float3 Blend, float3 Mask)
{
    return lerp(Base, Blend, Mask);
}

float3 PaperEffect(float3 Color, float3 PaperColor)
{
    float3 dodgedCol = Color / (1 - PaperColor);
    float3 combinedCol = lerp(Color, dodgedCol, (PaperColor.r + PaperColor.g + PaperColor.b) * 0.3333);
    combinedCol *= PaperColor;
    return combinedCol;
}

void Postprocess_float(Texture2D MainTex, float2 UV, float2 UVScale,
    float Thickness, float Threshold, float Strength, float Seed, 
    float3 OutlineColor, Texture2D PaperTex, float3 ModulateColor, float Power, bool Paper,
    out float3 OUT)
{
    const float3 screenColor = SAMPLE_TEXTURE2D(MainTex, sampler_point_clamp, UV).rgb;
    // https://www.youtube.com/watch?v=a4mV7sCewM0
    float outlineMask = DepthSobel(UV, Thickness, Threshold, Strength, Seed);
    outlineMask += DepthSobel(warpUV(UV, Seed, 0.001, Thickness, 0.00035), Thickness, Threshold, Strength, Seed);
    outlineMask += DepthSobel(warpUV(UV, Seed, 0.001, Thickness, 0.0004), Thickness, Threshold, Strength, Seed);
    outlineMask += DepthSobel(warpUV(UV, Seed, 0.001, Thickness, 0.00045), Thickness, Threshold, Strength, Seed);
    OUT = blendOverwrite(screenColor, OutlineColor, outlineMask);
    if (!Paper)
        return;
    const float3 paperColor = SAMPLE_TEXTURE2D(PaperTex, sampler_point_clamp, UV * UVScale).rgb;
    OUT = pow(PaperEffect(OUT, paperColor) * ModulateColor, Power);
}