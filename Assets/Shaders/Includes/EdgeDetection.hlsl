SAMPLER(sampler_point_clamp);

void sobelEdgeCheck(float2 pos, float dx, float dy, out float3 val)
{
    float2 uv = (pos.xy + float2(dx, dy));
    val.xyz = SAMPLE_TEXTURE2D(_CameraNormalsTexture, sampler_point_clamp, uv).xyz;
}

void normalEdge_float(float2 uv, float2 texelSize, out float edge)
{
    float3 horizontal = 0, vertical = 0, value = 0;
    sobelEdgeCheck(uv, -1.0 * texelSize.x, -1.0 * texelSize.y, value);
    horizontal += -1.0 * value;
    sobelEdgeCheck(uv, -1.0 * texelSize.x,  0.0 * texelSize.y, value);
    horizontal += -2.0 * value;
    sobelEdgeCheck(uv, -1.0 * texelSize.x,  1.0 * texelSize.y, value);
    horizontal += -1.0 * value;
    sobelEdgeCheck(uv,  1.0 * texelSize.x, -1.0 * texelSize.y, value);
    horizontal +=  1.0 * value;
    sobelEdgeCheck(uv,  1.0 * texelSize.x,  0.0 * texelSize.y, value);
    horizontal +=  2.0 * value;
    sobelEdgeCheck(uv,  1.0 * texelSize.x,  1.0 * texelSize.y, value);
    horizontal +=  1.0 * value;
    sobelEdgeCheck(uv, -1.0 * texelSize.x, -1.0 * texelSize.y, value);
    vertical += -1.0 * value;
    sobelEdgeCheck(uv,  0.0 * texelSize.x, -1.0 * texelSize.y, value);
    vertical += -2.0 * value;
    sobelEdgeCheck(uv,  1.0 * texelSize.x, -1.0 * texelSize.y, value);
    vertical += -1.0 * value;
    sobelEdgeCheck(uv, -1.0 * texelSize.x,  1.0 * texelSize.y, value);
    vertical +=  1.0 * value;
    sobelEdgeCheck(uv,  0.0 * texelSize.x,  1.0 * texelSize.y, value);
    vertical +=  2.0 * value;
    sobelEdgeCheck(uv,  1.0 * texelSize.x,  1.0 * texelSize.y, value);
    vertical +=  1.0 * value;

    edge = sqrt(dot(horizontal.xyz, horizontal.xyz) + dot(vertical.xyz, vertical.xyz));
}

void isInInterval(float a, float b, float x, out float val) {
    val = step(a, x) * (1.0 - step(b, x));
}

void depthEdgeCheck(in float2 uv, in float weight, in float base, inout float n) {
    // float depth = SHADERGRAPH_SAMPLE_SCENE_DEPTH(uv);
    float depth = SAMPLE_TEXTURE2D(_CameraDepthTexture, sampler_point_clamp, uv).x;
    float val = 0;
    isInInterval(base-0.004, base+0.004, depth, val);
    n += weight * (1.0 - val);
}

void depthEdge_float(in float2 uv, in float2 uvPixel, out float n) {
    // float base = SHADERGRAPH_SAMPLE_SCENE_DEPTH(uv);
    float depth = SAMPLE_TEXTURE2D(_CameraDepthTexture, sampler_point_clamp, uv).x;
    n = 0.0;
    depthEdgeCheck(uv + float2( 1.0, 0.0)*uvPixel, 0.125, depth, n);
    depthEdgeCheck(uv + float2( 0.0, 1.0)*uvPixel, 0.125, depth, n);
    depthEdgeCheck(uv + float2( 0.0,-1.0)*uvPixel, 0.125, depth, n);
    depthEdgeCheck(uv + float2(-1.0, 0.0)*uvPixel, 0.125, depth, n);

    depthEdgeCheck(uv + float2( 1.0, 1.0)*uvPixel, 0.125, depth, n);
    depthEdgeCheck(uv + float2( 1.0,-1.0)*uvPixel, 0.125, depth, n);
    depthEdgeCheck(uv + float2(-1.0, 1.0)*uvPixel, 0.125, depth, n);
    depthEdgeCheck(uv + float2(-1.0,-1.0)*uvPixel, 0.125, depth, n);
}