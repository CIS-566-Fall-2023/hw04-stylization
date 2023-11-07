// This file is actually help for everything that's post-process

SAMPLER(sampler_point_clamp);

TEXTURE2D(_CameraColorTexture);
SAMPLER(sampler_CameraColorTexture);

void GetDepth_float(float2 uv, out float Depth)
{
    Depth = SHADERGRAPH_SAMPLE_SCENE_DEPTH(uv);
}

void GetNormal_float(float2 uv, out float3 Normal)
{
    Normal = SAMPLE_TEXTURE2D(_NormalsBuffer, sampler_point_clamp, uv).rgb;
}

void GetCameraColor_float(float2 uv, out float4 CameraColor)
{
    CameraColor = SAMPLE_TEXTURE2D(_CameraColorTexture, sampler_CameraColorTexture, uv);	
}

float2 n22 (float2 p)
{
    float3 a = frac(p.xyx * float3(123.34, 234.34, 345.65));
    a += dot(a, a + 34.45);
    return frac(float2(a.x * a.y, a.y * a.z));
}

float2 get_gradient(float2 pos)
{
    float twoPi = 6.283185;
    float angle = n22(pos).x * twoPi;
    return float2(cos(angle), sin(angle));
}

float perlin_noise(float2 uv)
{
    float2 pos_in_grid = uv;
    float2 cell_pos_in_grid =  floor(pos_in_grid);
    float2 local_pos_in_cell = (pos_in_grid - cell_pos_in_grid);
    float2 blend = local_pos_in_cell * local_pos_in_cell * (3.0f - 2.0f * local_pos_in_cell);
    
    float2 left_top = cell_pos_in_grid + float2(0, 1);
    float2 right_top = cell_pos_in_grid + float2(1, 1);
    float2 left_bottom = cell_pos_in_grid + float2(0, 0);
    float2 right_bottom = cell_pos_in_grid + float2(1, 0);
    
    float left_top_dot = dot(pos_in_grid - left_top, get_gradient(left_top));
    float right_top_dot = dot(pos_in_grid - right_top,  get_gradient(right_top));
    float left_bottom_dot = dot(pos_in_grid - left_bottom, get_gradient(left_bottom));
    float right_bottom_dot = dot(pos_in_grid - right_bottom, get_gradient(right_bottom));
    
    float noise_value = lerp(
                            lerp(left_bottom_dot, right_bottom_dot, blend.x), 
                            lerp(left_top_dot, right_top_dot, blend.x), 
                            blend.y);
   
    
    return (0.5 + 0.5 * (noise_value / 0.7));
}

// https://ameye.dev/notes/edge-detection-outlines/
void Outlines_float(float2 uv, float OutlineThickness, float DepthSensitivity, float NormalsSensitivity, float ColorSensitivity, out float4 Out) {

    // Add noise to UVs

    float freq = 25.;
    float amplitude = 0.002;
    float noise = perlin_noise(uv * freq) * amplitude - amplitude * 0.2;

    uv += float2(noise, 2 * noise);
    uv = saturate(uv);

    float2 texelSize = 1.0 / float2(3840, 2160);
    texelSize /= 1;

    // Add noise to outline thickness

    freq = 25.;
    amplitude = 3;
    noise = perlin_noise(uv * freq) * amplitude;

    OutlineThickness += noise;


    float halfScaleFloor = floor(OutlineThickness * 0.5);
    float halfScaleCeil = ceil(OutlineThickness * 0.5);
    
    float2 uvSamples[4];
    float depthSamples[4];
    float3 normalSamples[4];
    float colorSamples[4];

    uvSamples[0] = uv - float2(texelSize.x, texelSize.y) * halfScaleFloor;
    uvSamples[1] = uv + float2(texelSize.x, texelSize.y) * halfScaleCeil;
    uvSamples[2] = uv + float2(texelSize.x * halfScaleCeil, -texelSize.y * halfScaleFloor);
    uvSamples[3] = uv + float2(-texelSize.x * halfScaleFloor, texelSize.y * halfScaleCeil);

    for (int i = 0; i < 4; i++) {
        depthSamples[i] = SHADERGRAPH_SAMPLE_SCENE_DEPTH(uvSamples[i]);
        normalSamples[i] = SAMPLE_TEXTURE2D(_NormalsBuffer, sampler_point_clamp, uvSamples[i]).rgb;
                colorSamples[i] = SAMPLE_TEXTURE2D(_CameraColorTexture, sampler_CameraColorTexture, uvSamples[i]);

    }

    // Depth
    float depthFiniteDifference0 = depthSamples[1] - depthSamples[0];
    float depthFiniteDifference1 = depthSamples[3] - depthSamples[2];
    float edgeDepth = sqrt(pow(depthFiniteDifference0, 2) + pow(depthFiniteDifference1, 2)) * 100;
    float depthThreshold = (1/DepthSensitivity) * depthSamples[0];
    edgeDepth = edgeDepth > depthThreshold ? 1 : 0;

    // Normals
    float3 normalFiniteDifference0 = normalSamples[1] - normalSamples[0];
    float3 normalFiniteDifference1 = normalSamples[3] - normalSamples[2];
    float edgeNormal = sqrt(dot(normalFiniteDifference0, normalFiniteDifference0) + dot(normalFiniteDifference1, normalFiniteDifference1));
    edgeNormal = edgeNormal > (1/NormalsSensitivity) ? 1 : 0;


    // Color
    float3 colorFiniteDifference0 = colorSamples[1] - colorSamples[0];
    float3 colorFiniteDifference1 = colorSamples[3] - colorSamples[2];
    float edgeColor = sqrt(dot(colorFiniteDifference0, colorFiniteDifference0) + dot(colorFiniteDifference1, colorFiniteDifference1));
	edgeColor = edgeColor > (1/ColorSensitivity) ? 1 : 0;

    float edge = max(edgeDepth, max(edgeNormal, edgeColor));

    // float edge = (edgeDepth + 1) * (2 * edgeNormal + 1) * (edgeColor + 1) - 3;

    // float edge = edgeDepth + edgeNormal + edgeColor;
    edge = saturate(edge);

    
    
    edge = 1 - edge;

    


    // Gaps in the noise

    float speckle = 0;
    freq = 1.;
    amplitude = 5; // lower for darker noise
    noise = perlin_noise(uv * freq) * amplitude;

    if (noise < 0.5) {
        // edge = 1;
    }

    Out = edge;    

}


