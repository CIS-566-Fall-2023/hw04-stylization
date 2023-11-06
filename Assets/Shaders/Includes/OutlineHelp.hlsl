SAMPLER(sampler_point_clamp);

void GetDepth_float(float2 uv, out float Depth)
{
    Depth = SHADERGRAPH_SAMPLE_SCENE_DEPTH(uv); // accessing node from shader graph
}

void GetNormal_float(float2 uv, out float3 Normal)
{
    Normal = SAMPLE_TEXTURE2D(_NormalsBuffer, sampler_point_clamp, uv).rgb;
}

// SOBEL
static float2 sobelSamplePoints[9] =
{
    float2(-1, 1), float2(0, 1), float2(1, 1),
    float2(-1, 0), float2(0, 0), float2(1, 1),
    float2(-1, -1), float2(0, -1), float2(1, -1),
};

// Weights for the x component
static float sobelXMatrix[9] =
{
    1, 0, -1,
    2, 0, -2,
    1, 0, -1
};

// Weights for the y component
static float sobelYMatrix[9] =
{
    1, 2, 1,
    0, 0, 0,
    -1, -2, -1
};

void DepthSobel_float(float2 UV, float Thickness, float2 screenRatio, out

float OUT)
{
    float2 sobel = 0;
    
    //[unroll]
    for (int i = 0; i < 9; i++)
    {
        float depth = SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV + sobelSamplePoints[i] * Thickness * screenRatio);
        sobel += depth * float2(sobelXMatrix[i], sobelYMatrix[i]);
    }

    OUT = length(sobel);
}

void ReturnMainTex_float(float2 UV, out float3 OUT)
{
    OUT = SAMPLE_TEXTURE2D(_MainTex, sampler_point_clamp, UV).rgb; 
}

void ColorSobel_float(float2 UV, float Thickness, float2 screenRatio, out float OUT)
{
    // have to run sobel over RGB separately
    float2 sobelR = 0;
    float2 sobelG = 0;
    float2 sobelB = 0;
    
    //[unroll]
    for (int i = 0; i < 9; i++)
    {
        //float3 rgb = SHADERGRAPH_SAMPLE_SCENE_COLOR(UV + sobelSamplePoints[i] * Thickness * screenRatio);
        float3 rgb = SAMPLE_TEXTURE2D(_MainTex, sampler_point_clamp, UV + sobelSamplePoints[i] * Thickness * screenRatio).rgb;
        float2 kernel = float2(sobelXMatrix[i], sobelYMatrix[i]);
        
        sobelR += rgb.r * kernel;
        sobelG += rgb.g * kernel;
        sobelB += rgb.b * kernel;
    }
    
    OUT = max(length(sobelR), max(length(sobelG), length(sobelB)));
}

// Saturation
void ColorSaturation_float(float2 UV, float2 screenRatio, out float4 OUT)
{
    float3 rgb = SAMPLE_TEXTURE2D(_MainTex, sampler_point_clamp, UV + screenRatio).rgb;
    float3 gray = dot(rgb, float3(0.299, 0.587, 0.114));
    
    float4 shade = float4(gray.x, gray.y, gray.z, 0);
    
   // float4 gray = dot(Color, float4(0.299, 0.587, 0.114, 0));
    
   // float4 shade = float4(gray.x, gray.y, gray.z, Color.w);
    
    OUT = shade;
}

void ColorBucket_float(float2 UV, float pixelAmt, out float2 OUT)
{
    float pixelateAmt = 1 - pixelAmt;
    
    float2 newUV = floor(UV * pixelateAmt) / pixelateAmt;
    
    OUT = newUV;
}

void ColorConvertToBlackAndWhite_float(float4 rgb, float threshold, out float4 OUT)
{
    float4 newColor = float4(0, 0, 0, 0);
    
    if (rgb[0] + rgb[1] + rgb[2] + rgb[3] > threshold)
    {
        newColor = float4(1, 1, 1, 0);
    }
    
    OUT = newColor;
}