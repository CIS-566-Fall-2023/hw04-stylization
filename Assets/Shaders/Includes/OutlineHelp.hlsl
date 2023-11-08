SAMPLER(sampler_point_clamp);

void GetDepth_float(float2 uv, out float Depth)
{
    Depth = SHADERGRAPH_SAMPLE_SCENE_DEPTH(uv);
}


void GetNormal_float(float2 uv, out float3 Normal)
{
    Normal = SAMPLE_TEXTURE2D(_NormalsBuffer, sampler_point_clamp, uv).rgb;
}

// noise/tool box functions added to animate outlines 
// bias 
float bias(float b, float t) {
    return pow(t, log(b) / log(0.5f));
}

// gain 
float gain(float g, float t) {
    if (t < 0.5f) {
        return bias(1.f - g, 2.f * t) / 2.f;
    }
    else {
        return 1.f - bias(1.f - g, 2.f - 2.f * t) / 2.f;
    }
}


// Based on Ned Makes Games sobel edge detection tutorial 
// The sobel effect runs by sampling texture around a point to see if there are any large changes.
// Each sample is multiplied by a convultion mx weight for the x & y comp separately.
// Each value is then added together and the final sobel value is the length of the resulting float2.
// Higher values = algo detected more of an edge 

// These are the points to sample relative to the starting point 
static float2 sobelSamplePoints[9] = {
    float2(-1, 1), float2(0, 1), float2(1, 1),
    float2(-1, 0), float2(0, 0), float2(1, 0),
    float2(-1, -1), float2(0, -1), float2(1, -1),
}; 

// weights for the x component 
static float sobelXMatrix[9] = {
    1, 0, -1,
    2, 0, -2,
    1, 0, -1
}; 

// weights for the y component 
static float sobelYMatrix[9] = {
    1, 2, 1,
    0, 0, 0,
    -1, -2, -1
}; 

// this func runs the sobel algo over the depth texture 
void DepthSobel_float(
    float2 uv, float Thickness, float depthThreshold,
    float depthTightening, float depthStrength, out float Out) {

    float2 sobel = 0;
    // we can unroll this loop to make it more efficient
    // compiler is also smart enough to remove the i=4 iter, which is always 0 
    [unroll] for (int i = 0; i < 9; i++) {
        float depth = SHADERGRAPH_SAMPLE_SCENE_DEPTH(uv + sobelSamplePoints[i] * Thickness);
        sobel += depth * float2(sobelXMatrix[i], sobelYMatrix[i]);
    }

    float smooth = smoothstep(0, depthThreshold, length(sobel));
    smooth = pow(smooth, depthTightening) * depthStrength;

    Out = smooth;
}; 

// this func runs the sobel algo over the normal texture 
void NormalSobel_float(
    float2 uv, float Thickness, out float Out) {
    
    // run the sobel algo over the rgb channels seperately 
    float2 sobelR = 0;
    float2 sobelG = 0;
    float2 sobelB = 0;

    // unroll loop to make it more efficient 
    float2 sobel = 0;
    [unroll] for (int i = 0; i < 9; i++) {

        // Normal = SAMPLE_TEXTURE2D(_NormalsBuffer, sampler_point_clamp, uv).rgb;
        float3 normalRgb = SAMPLE_TEXTURE2D(_NormalsBuffer, sampler_point_clamp, uv + sobelSamplePoints[i] * Thickness).rgb;
        // create the kernel for the iteration 
        // float depth = SHADERGRAPH_SAMPLE_SCENE_DEPTH(uv + sobelSamplePoints[i] * Thickness);
        float2 kernel = float2(sobelXMatrix[i], sobelYMatrix[i]);
        // accumulate samples for each color
        sobelR += normalRgb.r * kernel;
        sobelG += normalRgb.g * kernel;
        sobelB += normalRgb.b * kernel;
    }
    // get the final sobel value 
    // combien rgb values by taking the one w the largest sobel value 
    Out = max(length(sobelR), max(length(sobelG), length(sobelB))); 
};
