Shader "Hidden/CompoundRendererFeature/StylizedDetail"
{
    HLSLINCLUDE
    #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
    #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Common.hlsl"
    #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DeclareDepthTexture.hlsl"
    #include "../../ShaderLibrary/Core.hlsl"

    TEXTURE2D_X(_MainTex);
    float4 _MainTex_TexelSize;
    SAMPLER(sampler_MainTex);

    TEXTURE2D_X(_BlurTex1);
    TEXTURE2D_X(_BlurTex2);

    float _Intensity;
    float _BlurStrength;

    float4 _SourceSize;
    float4 _DownSampleScaleFactor;

    float3 _CoCParams;

    #define FarStart        _CoCParams.x
    #define FarEnd          _CoCParams.y

#define BLUR_KERNEL 1
#if BLUR_KERNEL == 0
    // Offsets & coeffs for optimized separable bilinear 3-tap gaussian (5-tap equivalent)
    const static int kTapCount = 3;
    const static float kOffsets[] = {
        -1.33333333,
         0.00000000,
         1.33333333
    };
    const static half kCoeffs[] = {
         0.35294118,
         0.29411765,
         0.35294118
    };
#elif BLUR_KERNEL == 1
    // Offsets & coeffs for optimized separable bilinear 5-tap gaussian (9-tap equivalent)
    const static int kTapCount = 5;
    const static float kOffsets[] = {
        -3.23076923,
        -1.38461538,
        0.00000000,
        1.38461538,
        3.23076923
    };
    const static half kCoeffs[] = {
        0.07027027,
        0.31621622,
        0.22702703,
        0.31621622,
        0.07027027
    };
#endif

    float4 Blend_LinearLight(float4 Base, float4 Blend, float Opacity) {
        const float4 Out = Blend < 0.5 ? max(Base + (2 * Blend) - 1, 0) : min(Base + 2 * (Blend - 0.5), 1);
        return lerp(Base, Out, Opacity);
    }

    inline float3 Contrast(float3 In, float Contrast) {
        const float midGray = 0.5;  // Alternative: ACEScc_MIDGRAY
        return (In - midGray) * Contrast + midGray;
    }

    float4 CompositeFragmentProgram(PostProcessVaryings input) : SV_Target {
        UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(input);
        const float2 uv = UnityStereoTransformScreenSpaceTex(input.texcoord) * _SourceSize.xy;

        const float4 color = LOAD_TEXTURE2D_X(_MainTex, uv);
        const float4 blur1 = LOAD_TEXTURE2D_X(_BlurTex1, uv);
        const float4 invert1 = 1.0 - blur1;
        const float4 blend1 = lerp(color, invert1, 0.5);
        const float4 blur2 = LOAD_TEXTURE2D_X(_BlurTex2, uv);
        const float4 blend2 = Blend_LinearLight(blur2, blend1, 1.0);
        const float4 invert2 = 1.0 - blend2;
        const float4 blend3 = lerp(invert2, color, 0.5);
        const float4 contrast = float4(Contrast(blend3.rgb, _Intensity), 1.0);
        const float4 blend4 = Blend_LinearLight(color, contrast, 1.0);

        float depth = SampleSceneDepth(input.texcoord);
        depth = LinearEyeDepth(depth, _ZBufferParams);
        half coc = (depth - FarStart) / (FarEnd - FarStart);
        coc = saturate(coc);
        coc = 1.0 - coc;

        float3 dstColor = 0.0;
        half dstAlpha = 1.0;

        UNITY_BRANCH
        if (coc > 0.0) {
            // Non-linear blend "CryEngine 3 Graphics Gems" [Sousa13]
            const half blend = sqrt(coc * TWO_PI);
            dstColor = blend4.rgb * saturate(blend);
            dstAlpha = saturate(1.0 - blend);
        }

        dstColor = color.rgb * dstAlpha + dstColor;
        return float4(dstColor.rgb, color.a);
    }

    half4 Blur(PostProcessVaryings input, float2 dir, float premultiply) {
        UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(input);
        const float2 uv = UnityStereoTransformScreenSpaceTex(input.texcoord);

        const float2 offset = _SourceSize.zw * _DownSampleScaleFactor.zw * dir * _BlurStrength;
        half4 acc = 0.0;

        UNITY_UNROLL
        for (int i = 0; i < kTapCount; i++)
        {
            const float2 sampCoord = uv + kOffsets[i] * offset;
            half3 sampColor = SAMPLE_TEXTURE2D_X(_MainTex, sampler_MainTex, sampCoord).xyz;

            // Weight & pre-multiply to limit bleeding on the focused area
            acc += half4(sampColor, 1.0) * kCoeffs[i];
        }

        acc.xyz /= acc.w + 1e-4; // Zero-div guard
        return half4(acc.xyz, 1.0);
    }

    half4 FragBlurH(PostProcessVaryings input) : SV_Target {
        return Blur(input, float2(1.0, 0.0), 1.0);
    }

    half4 FragBlurV(PostProcessVaryings input) : SV_Target {
        return Blur(input, float2(0.0, 1.0), 0.0);
    }
    ENDHLSL

    SubShader
    {
        Cull Off ZWrite Off ZTest Always

        Pass
        {
            Name "Stylized Details"

            HLSLPROGRAM
            #pragma vertex FullScreenTrianglePostProcessVertexProgram
            #pragma fragment CompositeFragmentProgram
            ENDHLSL
        }

        Pass
        {
            Name "Gaussian Blur Horizontal"

            HLSLPROGRAM
            #pragma vertex FullScreenTrianglePostProcessVertexProgram
            #pragma fragment FragBlurH
            ENDHLSL
        }

        Pass
        {
            Name "Gaussian Blur Vertical"

            HLSLPROGRAM
            #pragma vertex FullScreenTrianglePostProcessVertexProgram
            #pragma fragment FragBlurV
            ENDHLSL
        }

    }

    Fallback Off
}