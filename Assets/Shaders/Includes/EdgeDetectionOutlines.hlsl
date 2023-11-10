#ifndef SOBELOUTLINES_INCLUDED
#define SOBELOUTLINES_INCLUDED
SAMPLER(sampler_point_clamp);

static float2 pts[9] = {
    float2(-1,1), float2(0,1), float2(1,1),
    float2(-1,0), float2(0,0), float2(1,0),
    float2(-1,-1), float2(0,-1), float2(1,-1)
};

static float sobelXMat[9] = {
    1, 0, -1,
    2, 0, -2,
    1, 0, -1
};

static float sobelYMat[9] = {
    1, 2, 1,
    0, 0, 0,
    -1, -2, -1
};

void DepthSobel_float(float2 uv, float Thickness, float Noise, out float OUT) {
    float2 sobel = 0;
    float2 normX = 0;
    float2 normY = 0;
    float2 normZ = 0;
    [unroll] for(int i =0; i < 9; i++) {
        float d = 0.0;//SHADERGRAPH_SAMPLE_SCENE_DEPTH(uv + pts[i] * Thickness * Noise);
        sobel += d * float2(sobelXMat[i], sobelYMat[i]);
        float3 n = SAMPLE_TEXTURE2D(_NormalsBuffer, sampler_point_clamp, uv + pts[i] * Thickness * Noise).rgb;
        normX += n.x * float2(sobelXMat[i], sobelYMat[i]);
        normY += n.y * float2(sobelXMat[i], sobelYMat[i]);
        normZ += n.z * float2(sobelXMat[i], sobelYMat[i]);
    }
    OUT = max(length(sobel), max(length(normX),max(length(normY),length(normZ))));
}

#endif