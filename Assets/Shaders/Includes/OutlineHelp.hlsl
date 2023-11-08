SAMPLER(sampler_point_clamp);

// Given functions for depth and normal buffers: 

void GetDepth_float(float2 uv, out float Depth)
{
    Depth = SHADERGRAPH_SAMPLE_SCENE_DEPTH(uv);
}


void GetNormal_float(float2 uv, out float3 Normal)
{
    Normal = SAMPLE_TEXTURE2D(_NormalsBuffer, sampler_point_clamp, uv).rgb;
}

// Perlin noise for outline animation

float2 random2(float2 p2)
{
    return frac(sin(dot(p2, float2(11.092, 81.299))) * 412128.2434);
}


float surflet2D(float2 p, float2 gridPoint)
{

    float t2x = abs(p.x - gridPoint.x);
    float t2y = abs(p.y - gridPoint.y);

    float tx = 1 - 6 * pow(t2x, 5) + 15 * pow(t2x, 4) - 10 * pow(t2x, 3);
    float ty = 1 - 6 * pow(t2y, 5) + 15 * pow(t2y, 4) - 10 * pow(t2y, 3);

    float2 gradient = random2(gridPoint) * 2 - float2(1,1);

    float2 diff = p - gridPoint;

    float height = dot(diff, gradient);

    return height * tx * ty;
}

float perlinNoise2D(float2 p)
{
    float surfletSum = 0;

    for (int dx = 0; dx <= 1; ++dx)
    {
        for (int dy = 0; dy <= 1; ++dy)
        {
         
            surfletSum += surflet2D(p, floor(p) + float2(dx, dy));
            
        }
    }
    return surfletSum;
}

// Sobel Outline from tutorial 

// offsets for each cell in matrix relative to central pixel
static float2 sobelSamplePoints[9] =
{
    float2(-1, 1), float2(0, 1), float2(1, 1),
    float2(-1, 0), float2(0, 0), float2(1, 1),
    float2(-1, -1), float2(0, -1), float2(1, -1),
};

// weights for horizontal
static float sobelXMatrix[9] =
{
    1, 0, -1,
    2, 0, -2,
    1, 0, -1
};

// weights for vertical 
static float sobelYMatrix[9] =
{
    1, 2, 1,
    0, 0, 0,
    -1, -2, -1
};

// run sobel algorithm over depth texture
void DepthSobel_float(float2 UV, float Thickness, float t, out float OUT)
{
    float2 sobel = 0;
    
    // compute each cell in convolution matrix
    for (int i = 0; i < 9; i++)
    {
        float noise = 0.001 * sin(t);
        float depth = SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV + sobelSamplePoints[i] * Thickness + noise);
        sobel += depth * float2(sobelXMatrix[i], sobelYMatrix[i]);
    }

    OUT = length(sobel);
}

void ReturnMainTex_float(float2 UV, out float3 OUT)
{
    OUT = SAMPLE_TEXTURE2D(_MainTex, sampler_point_clamp, UV).rgb;
}

// outline color differences as well 
void ColorSobel_float(float2 UV, float Thickness, out float OUT)
{
 
    float2 sobelR = 0;
    float2 sobelG = 0;
    float2 sobelB = 0;

    for (int i = 0; i < 9; i++)
    {
        float noise = perlinNoise2D(UV);
        float3 rgb = SAMPLE_TEXTURE2D(_MainTex, sampler_point_clamp, UV + sobelSamplePoints[i] * Thickness + noise).rgb;
        float2 kernel = float2(sobelXMatrix[i], sobelYMatrix[i]);
        
        sobelR += rgb.r * kernel;
        sobelG += rgb.g * kernel;
        sobelB += rgb.b * kernel;
    }
    
    OUT = max(length(sobelR), max(length(sobelG), length(sobelB)));
}
