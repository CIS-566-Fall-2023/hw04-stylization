void MakeVignette_float(float2 UV, float radius, out float OUT)
{
    // caluclate distance from UV origin
    float2 d = float2(UV.x - 0.5, UV.y - 0.5);
    float dist = sqrt(d.x * d.x + d.y * d.y);
    // normalize
    dist = dist / sqrt(0.5);

    OUT = 1.0 - (dist * radius);
}
