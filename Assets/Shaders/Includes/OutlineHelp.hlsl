#ifndef OUTLINES
#define OUTLINES
SAMPLER(sampler_point_clamp);

void GetDepth_float(float2 uv, out float Depth)
{
    Depth = SHADERGRAPH_SAMPLE_SCENE_DEPTH(uv);
}


void GetNormal_float(float2 uv, out float3 Normal)
{
    Normal = SAMPLE_TEXTURE2D(_NormalsRT, sampler_point_clamp, uv).rgb;
}


static float horKernel[9] = {
1, 0, -1,
2, 0, -2,
1, 0, -1
};

static float verKernel[9] = {
1, 2, 1,
0, 0, 0,
-1, -2, -1
};

static float2 offsets[9] = {
    float2(-1,1), float2(0,1), float2(1,1),
    float2(-1,0), float2(0,0), float2(1,0),
    float2(-1,-1), float2(0,-1), float2(1,-1)
};

void GetOutline_float(float2 uv, float2 screenResolution, float outlineWidth,  out float outlineMask)
{
    float2 curPx = 0;
    float curPxDepth = 0;
    float3 curPxNor = 0;
    float2 sobel = 0;
    float2 sobelNorX = 0;
    float2 sobelNorY = 0;
    float2 sobelNorZ = 0;

    [unroll] for (int i = 0; i < 9; i++)
    {
        curPx = uv + offsets[i] * 0.001 * outlineWidth;

        GetDepth_float(curPx, curPxDepth);
        GetNormal_float(curPx, curPxNor);

        sobel += curPxDepth * float2(horKernel[i], verKernel[i]);
        sobelNorX += curPxNor.x * float2(horKernel[i], verKernel[i]);
        sobelNorY += curPxNor.y * float2(horKernel[i], verKernel[i]);
        sobelNorZ += curPxNor.z * float2(horKernel[i], verKernel[i]);
    }

    outlineMask = max(length(sobel), max(length(sobelNorX), max(length(sobelNorY), length(sobelNorZ))));
}
#endif