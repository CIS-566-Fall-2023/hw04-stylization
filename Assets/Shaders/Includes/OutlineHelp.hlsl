SAMPLER(sampler_point_clamp);

static const float kx[9] = {
    1, 0, -1,
    2, 0, -2,
    1, 0, -1
};
static const float ky[9] = {
    1, 2, 1,
    0, 0, 0,
    -1, -2, -1
};

void GetDepth_float(float2 uv, out float Depth)
{
    Depth = SHADERGRAPH_SAMPLE_SCENE_DEPTH(uv);
}


void GetNormal_float(float2 uv, out float3 Normal)
{
    Normal = SAMPLE_TEXTURE2D(_NormalsBuffer, sampler_point_clamp, uv).rgb;
}

float3 hash33(float3 p3)
{
    float3 p = frac(p3 * float3(0.1031, 0.11369, 0.13787));
    p += dot(p, p.yxz + 19.19);
    return (frac(float3((p.x + p.y) * p.z, (p.x + p.z) * p.y, (p.y + p.z) * p.x)) - 0.5) * 2.0;
}

float quinticsmooth(float t)
{
    return t * t * t * (t * (t * 6.0 - 15.0) + 10.0);
}

float surflet(float3 p, float3 gridP)
{
    float3 gradient = 2.0 * hash33(gridP) - 1.0;
    float3 diff = p - gridP;
    float h = dot(diff, gradient);
    for (int i = 0; i < 3; i++)
    {
        h *= 1.0 - quinticsmooth(abs(p[i] - gridP[i]));
    }
    return h;
}

float perlin(float3 p)
{
    float res = 0.0;
    float3 cell = floor(p);
    for (int x = 0; x <= 1; x++)
    {
        for (int y = 0; y <= 1; y++)
        {
            for (int z = 0; z <= 1; z++)
            {
                res += surflet(p, cell + float3(float(x), float(y), float(z)));
            }
        }
    }
    return res;
}

void DistortUv_float(float2 uv, float time, out float2 NewUv)
{
    uv.x += perlin(float3(uv.x, uv.y, time) * 10) / 300;
    uv.y += perlin(float3(uv.x, time, uv.y) * 10) / 300;
    NewUv = uv;
}

void GetOutline_float(float2 uv, out float Edge)
{
    float2 delta = float2(1.0, 1.0) / _ScreenDims;
    float2 sum = 0;
    
    for (int i = 0; i < 3; i++)
    {
        for (int j = 0; j < 3; j++)
        {
            float depth = SHADERGRAPH_SAMPLE_SCENE_DEPTH(uv + float2(i - 1, j - 1) * delta * _Thickness);
            sum += depth * float2(kx[i * 3 + j], ky[i * 3 + j]);
        }
    }
    Edge = step(0.05, length(sum));
}