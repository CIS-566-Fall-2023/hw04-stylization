SAMPLER(sampler_point_clamp);

void GetDepth_float(float2 uv, out float Depth)
{
    Depth = SHADERGRAPH_SAMPLE_SCENE_DEPTH(uv);
}

void GetNormal_float(float2 uv, out float3 Normal)
{
    Normal = SHADERGRAPH_SAMPLE_SCENE_NORMAL(uv);
}

void Wobble_float(float2 uv, float noise, float range, float period, Texture2D mainTexture, SamplerState samp, out float3 color, out float alpha) {
    const int n = 3; // number of contour lines
    float2 uvs[n];
    for (int i = 0; i < n; i++) {
        uvs[i] = uv + float2(range * sin(period * uv.y + 1.047 * i) + noise, range * sin(period * uv.x + 1.571 * (n-i)) + noise);
    }
    float edge = 0.0f;
    for (int i = 0; i < n; i++) {
        edge += mainTexture.Sample(samp, uvs[i]).a;
    }
    // edge detection results are stored in the alpha channel
    // float3 diffuse = mainTexture.Sample(samp, uv).rgb;
    color = lerp(float3(1,1,1), float3(0,0,0), edge);
    alpha = edge;
}