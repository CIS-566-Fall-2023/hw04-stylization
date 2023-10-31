SAMPLER(sampler_point_clamp);

void GetDepth_float(float2 uv, out float Depth)
{
    Depth = SHADERGRAPH_SAMPLE_SCENE_DEPTH(uv);
}


void GetNormal_float(float2 uv, out float3 Normal)
{
    Normal = SAMPLE_TEXTURE2D(_NormalTexture, sampler_point_clamp, uv).rgb;
}

static float2 sobelSamples[9] = {
    float2(-1,1),float2(0,1),float2(1,1),
    float2(-1,0),float2(0,0),float2(1,0),
    float2(-1,-1),float2(0,-1),float2(1,-1)
};

static float sobelX[9] = {
    1,0,-1,
    2,0,-2,
    1,0,-1
};

static float sobelY[9] = {
    1,2,1,
    0,0,0,
    -1,-2,-1
};

void DepthSobel_float(float2 uv, float2 texelSize, out float Out){
    float2 sobel = 0;
    [unroll] for (int i = 0;i<9;++i){
        float depth = SHADERGRAPH_SAMPLE_SCENE_DEPTH(uv + sobelSamples[i] * texelSize);
        sobel += depth * float2(sobelX[i],sobelY[i]);
    }
    Out = length(sobel);
}

void SampleCrossUVs_float(float2 uv, float2 texelSize, 
out float2 center, out float2 UR, out float2 LL, out float2 UL, out float2 LR){
    center = uv;
    UR = uv + float2(texelSize.x, texelSize.y);
    LL = uv + float2(texelSize.x, texelSize.y);
    UL = uv + float2(-texelSize.x, texelSize.y);
    LR = uv + float2(texelSize.x,-texelSize.y);
}