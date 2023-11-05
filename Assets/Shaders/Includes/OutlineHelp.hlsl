SAMPLER(sampler_point_clamp);

void GetDepth_float(float2 uv, out float Depth)
{
    Depth = SHADERGRAPH_SAMPLE_SCENE_DEPTH(uv);
}

void GetNormal_float(float2 uv, out float3 Normal)
{
    //Normal = SAMPLE_TEXTURE2D(_NormalsBuffer, sampler_point_clamp, uv).rgb;
}

void GrayScale_float(float3 rgb, float2 uv, out float3 OUT)
{
    float gray = dot(rgb, float3(0.21, 0.72, 0.07));
    float vig = smoothstep(0.7f, 0.45f, length(uv - 0.5f));
    gray *= vig;
    OUT = float3(gray, gray, gray);
}

void GaussianBlur_float(UnityTexture2D Texture, float2 UV, float Blur, UnitySamplerState Sampler, out float3 Out_RGB, out float Out_Alpha)
{
    float4 col = float4(0.0, 0.0, 0.0, 0.0);
    float kernelSum = 0.0;

    int upper = ((Blur - 1) / 2);
    int lower = -upper;

    for (int x = lower; x <= upper; ++x)
    {
        for (int y = lower; y <= upper; ++y)
        {
            kernelSum++;

            float2 offset = float2(_MainTex_TexelSize.x * x, _MainTex_TexelSize.y * y);
            col += float4(Texture.Sample(Sampler, UV + offset).rgb, 1.0);
        }
    }

    col /= kernelSum;
    Out_RGB = float3(col.r, col.g, col.b);
    Out_Alpha = col.a;
}

float3 GetMixColor_float(UnityTexture2D Texture, float3 MixColor, float2 Pos, UnitySamplerState Sampler)
{
    float3 rgb = Texture.Sample(Sampler, Pos * _MainTex_TexelSize.xy).rgb;
    float d = clamp(dot(rgb, float3(-0.5, 1.0, -0.5)), 0.0, 1.0);
    return lerp(rgb, MixColor, 1.8 * d);
}

float3 GetBWDist_float(UnityTexture2D Texture, UnityTexture2D NoiseTexture, float2 NoiseTexelSize, float2 Pos, UnitySamplerState Sampler) {
    float val = length(GetMixColor_float(Texture, float3(0.4, 0.4, 0.4), Pos, Sampler)) +
        0.0001 * length(Pos);
    val *= 0.9f;
    val += clamp(pow(NoiseTexture.Sample(Sampler, Pos * NoiseTexelSize * 0.4f).x + 0.3f, 2.0f) + 0.1f, 0.0f, 1.0f);

    float d = smoothstep(0.9, 1.1, val);
    return float3(d, d, d);
}

void GetGradientValue_float(UnityTexture2D Texture, float3 MixColor, float2 Pos, float Delta, UnitySamplerState Sampler, out float2 Out_Gradient) {
    float2 d = float2(Delta, 0.0);
    Out_Gradient = float2(
        dot(GetMixColor_float(Texture, MixColor, Pos + d.xy, Sampler) - GetMixColor_float(Texture, MixColor, Pos - d.xy, Sampler), float3(1.0 / 3.0, 1.0 / 3.0, 1.0 / 3.0)),
        dot(GetMixColor_float(Texture, MixColor, Pos + d.yx, Sampler) - GetMixColor_float(Texture, MixColor, Pos - d.yx, Sampler), float3(1.0 / 3.0, 1.0 / 3.0, 1.0 / 3.0))) / Delta ;
}

void GetGradient_float(UnityTexture2D Texture, UnityTexture2D NoiseTexture, float2 NoiseTexelSize, float2 UV, float SampleNum, UnitySamplerState Sampler, out float3 Col) {
    float3 Col1 = float3(0.0, 0.0, 0.0);
    float3 Col2 = float3(0.0, 0.0, 0.0);
    float2 Pos = UV / _MainTex_TexelSize.xy;
    float2 Pos1 = Pos, Pos2 = Pos, Pos3 = Pos, Pos4 = Pos;
    float cnt = 0.0, cnt2 = 0.0;

    float delta = 2.0f;

    for (int i = 0; i < SampleNum; ++i) {
        // get gradients

        float2 gr1 = float2(0.0, 0.0), gr2 = float2(0.0, 0.0), gr3 = float2(0.0, 0.0), gr4 = float2(0.0, 0.0);

        // gradient for outlines
        GetGradientValue_float(Texture, float3(0.4, 0.4, 0.4), Pos1, delta, Sampler, gr1);
        gr1 += 0.0001 * (NoiseTexture.Sample(Sampler, Pos1 * NoiseTexelSize).rg - 0.5f);
        GetGradientValue_float(Texture, float3(0.4, 0.4, 0.4), Pos2, delta, Sampler, gr2);
        gr2 += 0.0001 * (NoiseTexture.Sample(Sampler, Pos2 * NoiseTexelSize).rg - 0.5f);

        // gradient for wash effect
        GetGradientValue_float(Texture, float3(1.5, 1.5, 1.5), Pos3, delta, Sampler, gr3);
        gr3 += 0.0001 * (NoiseTexture.Sample(Sampler, Pos3 * NoiseTexelSize).rg - 0.5f);
        GetGradientValue_float(Texture, float3(1.5, 1.5, 1.5), Pos4, delta, Sampler, gr4);
        gr4 += 0.0001 * (NoiseTexture.Sample(Sampler, Pos4 * NoiseTexelSize).rg - 0.5f);

        float d1 = clamp(10. * length(gr1), 0., 1.);
        float d2 = clamp(10. * length(gr2), 0., 1.);

        Pos1 += 0.8 * normalize(gr1.yx * float2(1.0f, -1.0f));
        Pos2 -= 0.8 * normalize(gr2.yx * float2(1.0f, -1.0f));

        float fact = 1.0f - float(i) / SampleNum;
        Col1 += fact * lerp(float3(1.2f, 1.2f, 1.2f), 2.0f * GetBWDist_float(Texture, NoiseTexture, NoiseTexelSize, Pos1, Sampler), d1);
        Col1 += fact * lerp(float3(1.2f, 1.2f, 1.2f), 2.0f * GetBWDist_float(Texture, NoiseTexture, NoiseTexelSize, Pos2, Sampler), d2);

        Pos3 += 0.25f * normalize(gr3);// +0.5 * (NoiseTexture.Sample(Sampler, NoiseTexelSize * Pos * 0.07).rg - 0.5f);
        Pos4 -= 0.5f * normalize(gr4);// +0.5 * (NoiseTexture.Sample(Sampler, NoiseTexelSize * Pos * 0.07).rg - 0.5f);

        float f1 = 3.0f * fact;
        float f2 = 4.0f * (0.7f - fact);
        Col2 += f1 * (GetMixColor_float(Texture, float3(1.5, 1.5, 1.5), Pos3, Sampler) + 0.25f + 0.4 * NoiseTexture.Sample(Sampler, NoiseTexelSize * Pos3).rgb);
        Col2 += f2 * (GetMixColor_float(Texture, float3(1.5, 1.5, 1.5), Pos4, Sampler) + 0.25f + 0.4 * NoiseTexture.Sample(Sampler, NoiseTexelSize * Pos4).rgb);

        cnt2 += f1 + f2;
        cnt += fact;
    }

    Col1 /= cnt * 2.5f;
    Col2 /= cnt2 * 1.65f;

    Col = clamp(clamp(Col1 * .9 + .1, 0., 1.) * Col2, 0., 1.);
}

void calcRegion(UnityTexture2D Texture, UnitySamplerState Sampler, int2 lower, int2 upper, int samples, float2 uv, out float3 mean, out float variance)
{
    float3 sum = 0.0;
    float3 squareSum = 0.0;

    for (int x = lower.x; x <= upper.x; ++x)
    {
        for (int y = lower.y; y <= upper.y; ++y)
        {
            float2 offset = float2(_MainTex_TexelSize.x * x, _MainTex_TexelSize.y * y);
            float3 tex = Texture.Sample(Sampler, uv + offset).rgb;

            sum += tex;
            squareSum += tex * tex;
        }
    }

    mean = sum / samples;
    variance = length(abs((squareSum / samples) - (mean * mean)));
}

void kuwahara_float(UnityTexture2D Texture, UnitySamplerState Sampler, float2 UV, int Radius, out float4 out_Col)
{
    int upper = (Radius - 1) / 2;
    int lower = -upper;

    int samples = (upper + 1) * (upper + 1);

    float3 meanA, meanB, meanC, meanD;
    float varianceA, varianceB, varianceC, varianceD;
    calcRegion(Texture, Sampler, int2(lower, lower), int2(0, 0), samples, UV, meanA, varianceA);
    calcRegion(Texture, Sampler, int2(0, lower), int2(upper, 0), samples, UV, meanB, varianceB);
    calcRegion(Texture, Sampler, int2(lower, 0), int2(0, upper), samples, UV, meanC, varianceC);
    calcRegion(Texture, Sampler, int2(0, 0), int2(upper, upper), samples, UV, meanD, varianceD);

    float3 col = meanA;
    float minVar = varianceA;
    float testVal;

    // Test region B.
    testVal = step(varianceB, minVar);
    col = lerp(col, meanB, testVal);
    minVar = lerp(minVar, varianceB, testVal);

    // Test region C.
    testVal = step(varianceC, minVar);
    col = lerp(col, meanC, testVal);
    minVar = lerp(minVar, varianceC, testVal);

    // Text region D.
    testVal = step(varianceD, minVar);
    col = lerp(col, meanD, testVal);

    out_Col = float4(col, 1.0);
}