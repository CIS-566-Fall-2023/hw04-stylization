void GetEdgeArea_float(float3 Normal, float3 ViewDirection, float Disturb, float DisturbBar, float DisturbScale, out float EdgeRatio)
{
#ifdef SHADERGRAPH_PREVIEW
    Normal = normalize(float3(0.5, 0.5, 0));
    ViewDirection = normalize(float3(0.5, 0.5, 0));
#endif

    EdgeRatio = saturate(1.0f - abs(dot(Normal, ViewDirection)) + (Disturb - DisturbBar) * DisturbScale);
}

inline float Lumi(float3 col)
{
    return(0.299f * col.x + 0.587f * col.y + 0.114f * col.z);
}


void InterpolateShadow_float(float ShadowValue, float ShadowThreshold, float3 ShadowTextureColor, float3 ShadowColor, float3 DiffuseColor, out float3 Color)
{
#ifdef SHADERGRAPH_PREVIEW
    Color = 0;
#else
    float3 targetShadowColor = Lumi(ShadowTextureColor) < Lumi(DiffuseColor) ? ShadowColor : DiffuseColor;
    Color = ShadowValue < ShadowThreshold ? targetShadowColor : DiffuseColor;

#endif
}

void GerstnerWave_float(float2 waveDir, float2 waveParam, float speed, float3 pos, out float3 out_pos, out float3 tangent, out float3 bitangent)
{
    float k = 2 * PI / max(0.00001, waveParam.x);
    float amplitude = exp(k * waveParam.y) / k;

    waveDir = normalize(waveDir);
    float f = k * (dot(pos.xz, waveDir) - speed);
    pos.y = amplitude * (sin(f));
    pos.x += amplitude * cos(f) * waveDir.x;
    pos.z += amplitude * cos(f) * waveDir.y;

    float cf = amplitude * k * cos(f);
    float sf = amplitude * k * sin(f);
    // part-differential for pos.x
    tangent = normalize(float3(1 - sf * waveDir.x * waveDir.x, cf * waveDir.x, -sf * waveDir.y * waveDir.x));
    // part-differential for pox.z
    bitangent = normalize(float3(-sf * waveDir.x * waveDir.x, cf * waveDir.y, 1 - sf * waveDir.y * waveDir.y));
    
    out_pos = pos;
}

void CalculateAlphaWater_float(float4 ShallowColor, float4 DeepColor,
    float ColorDepth, float AlphaDepth, float DepthDiff,
    out float3 Color, out float Alpha)
{
    Color = lerp(ShallowColor.rgb, DeepColor.rgb, smoothstep(0, ColorDepth, DepthDiff));
    Alpha = lerp(ShallowColor.a, DeepColor.a, smoothstep(0, AlphaDepth, DepthDiff));
}

void CalculateFoam_float(float3 WaterColor, float WaterAlpha, float3 FoamColor, float DepthDiff, float FoamLimit, out float3 FinalColor, out float FinalAlpha)
{
    float hasFoam = step(DepthDiff, FoamLimit);
    FinalColor = WaterColor + FoamColor * hasFoam;
    FinalAlpha = saturate(WaterAlpha + hasFoam);
}

const static float2 sobelSamplePoints[9] = {
    float2(-1, 1), float2(0, 1), float2(1, 1),
    float2(-1, 0), float2(0, 0), float2(1, 0),
    float2(-1, -1), float2(0, -1), float2(1, -1),
};

const static float sobelXMatrix[9] = {
    1, 0, -1,
    2, 0, -2,
    1, 0, -1
};

const static float sobelYMatrix[9] = {
    1, 2, 1,
    0, 0, 0,
    -1, -2, -1
};

void DepthSobel_float(float2 UV, float Shift, out float edge) {
    float2 sobel = 0;
    [unroll] for (int i = 0; i < 9; i++) {
        float depth = SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV + sobelSamplePoints[i] * Shift);
        sobel += depth * float2(sobelXMatrix[i], sobelYMatrix[i]);
    }
    edge = length(sobel);
}

void ColorSobel_float(UnityTexture2D MainTex, UnitySamplerState ss, float2 UV, float Shift, out float edge) {
    float2 sobelR = 0;
    float2 sobelG = 0;
    float2 sobelB = 0;
    [unroll] for (int i = 0; i < 9; i++) {
        float3 rgb = SAMPLE_TEXTURE2D(MainTex, ss, UV + sobelSamplePoints[i] * Shift);
        float2 kernel = float2(sobelXMatrix[i], sobelYMatrix[i]);
        sobelR += rgb.r * kernel;
        sobelG += rgb.g * kernel;
        sobelB += rgb.b * kernel;
    }
    edge = max(max(length(sobelR), length(sobelR)), length(sobelB));    
}

void NormalRobert_float(UnityTexture2D NormalTex, UnitySamplerState ss, float2 UV, float Shift, out float edge) {
    // since we just using the diff between normals, we don't need to unpack it
    float3 nor_ur = SAMPLE_TEXTURE2D(NormalTex, ss, UV + float2(1, 1) * Shift);
    float3 nor_dl = SAMPLE_TEXTURE2D(NormalTex, ss, UV + float2(-1, -1) * Shift);
    float3 nor_ul = SAMPLE_TEXTURE2D(NormalTex, ss, UV + float2(1, -1) * Shift);
    float3 nor_dr = SAMPLE_TEXTURE2D(NormalTex, ss, UV + float2(-1, 1) * Shift);
    float3 diff1 = nor_ur - nor_dl;
    float3 diff2 = nor_ul - nor_dr;
    edge = sqrt(dot(diff1, diff1) + dot(diff2, diff2));
}