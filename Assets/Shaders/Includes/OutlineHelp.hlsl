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
void DepthSobel_float(float2 UV, float Thickness, out float OUT)
{
    float2 sobel = 0;
    
    // compute each cell in convolution matrix
    for (int i = 0; i < 9; i++)
    {
        float depth = SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV + sobelSamplePoints[i] * Thickness);
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
     
        float3 rgb = SAMPLE_TEXTURE2D(_MainTex, sampler_point_clamp, UV + sobelSamplePoints[i] * Thickness).rgb;
        float2 kernel = float2(sobelXMatrix[i], sobelYMatrix[i]);
        
        sobelR += rgb.r * kernel;
        sobelG += rgb.g * kernel;
        sobelB += rgb.b * kernel;
    }
    
    OUT = max(length(sobelR), max(length(sobelG), length(sobelB)));
}

// Kuwahara filter function
float4 KuwaharaFilter(float2 uv, int radius)
{
    // Fixed sizes for arrays
    const int sectors = 4;
    
    // Mean colors for each sector
    float4 means[sectors] = { float4(0, 0, 0, 0), float4(0, 0, 0, 0), float4(0, 0, 0, 0), float4(0, 0, 0, 0) };
    
    // Variances for each sector
    float variances[sectors] = { 0, 0, 0, 0 };

    // The number of samples taken in each sector is a square of the radius
    int samplesPerSector = radius * radius;
    
    // Calculate means
    for (int i = -radius; i <= radius; ++i)
    {
        for (int j = -radius; j <= radius; ++j)
        {
            float2 sampleUV = uv + float2(i, j) * _ScreenParams.xy;
            float4 sampleColor = SAMPLE_TEXTURE2D(_MainTex, sampler_point_clamp, sampleUV);
            
            // Determine the sector for the current sample
            int sector = (i < 0) ? ((j < 0) ? 0 : 1) : ((j < 0) ? 2 : 3);
            means[sector] += sampleColor;
        }
    }
    
    // Finalize means calculation
    for (int i = 0; i < sectors; ++i)
    {
        means[i] /= samplesPerSector;
    }
    
    // Calculate variances
    for (int i = -radius; i <= radius; ++i)
    {
        for (int j = -radius; j <= radius; ++j)
        {
            float2 sampleUV = uv + float2(i, j) * _ScreenParams.xy;
            float4 sampleColor = SAMPLE_TEXTURE2D(_MainTex, sampler_point_clamp, sampleUV);
            
            // Determine the sector for the current sample
            int sector = (i < 0) ? ((j < 0) ? 0 : 1) : ((j < 0) ? 2 : 3);
            float4 diff = sampleColor - means[sector];
            variances[sector] += dot(diff, diff);
        }
    }
    
    // Normalize variances
    for (int i = 0; i < sectors; ++i)
    {
        variances[i] /= samplesPerSector;
    }
    
    // Find the sector with the minimum variance
    int minVarianceSector = 0;
    float minVariance = variances[0];
    for (int i = 1; i < sectors; ++i)
    {
        if (variances[i] < minVariance)
        {
            minVariance = variances[i];
            minVarianceSector = i;
        }
    }
    
    // Return the color of the sector with the minimum variance
    return means[minVarianceSector];
}

// Main image function
void kuwahara_float(float2 uv, out float4 color)
{
    // Radius of the Kuwahara filter
    const int radius = 2;
    
    // Apply the Kuwahara filter
    color = KuwaharaFilter(uv, radius);
}