Shader "Hidden/MangaPoint"
{
    Properties
    {
        _EdgeThre("EdgeThre", Range(-3, 3)) = 0.4
        _EdgeHelper("EdgeHelper", Range(-3, 3)) = 0.4

        _TillSize ("TillSize", Range(0, 10)) = 10
        _Mult("Mult", Range(0, 0.1)) = 0.4
        _MidOffset("MidOffset", Range(-1, 1)) = 0.4
        _Mult1("Mult1", Range(-5, 0)) = 0.4
        _Mult2("Mult2", Range(-1, 2)) = 0.4
    }

    SubShader
    {
        Tags
        {
            "RenderType" = "Opaque"
            "RenderPipeline" = "UniversalPipeline"
            "UniversalMaterialType" = "SimpleLit"
            "IgnoreProjector" = "True"
        }
        HLSLINCLUDE
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"         
            #include "Packages/com.unity.shadergraph/ShaderGraphLibrary/ShaderVariablesFunctions.hlsl"

            CBUFFER_START(UnityPerMaterial)
                float _EdgeThre;
                float _EdgeHelper;
                int _TillSize;
                float _Mult;
                float _MidOffset;
                float _Mult1;
                float _Mult2;
            CBUFFER_END

            struct Attributes{
                float4 positionOS : POSITION;
                float4 normalOS : NORMAL;
                float4 texcoord : TEXCOORD0;
            };

            struct Varyings{
                float4 positionCS : SV_POSITION;
                float3 positionWS : TEXCOORD1;
                float2 uv : TEXCOORD0;
                float3 normalWS : TEXCOORD2;
                float3 viewDirWS : TEXCOORD3;
            };
        ENDHLSL

        Pass 
        {
            Tags{"LightMode" = "UniversalForward"} 
            Cull off

            HLSLPROGRAM
	        #pragma target 2.0
            #pragma vertex Vertex
            #pragma fragment Frag

            #pragma multi_compile _ _MAIN_LIGHT_SHADOWS _MAIN_LIGHT_SHADOWS_CASCADE _MAIN_LIGHT_SHADOWS_SCREEN

            float remap(float target, float oldMin, float oldMax, float newMin, float newMax)
            {
                return(target - oldMin) / (oldMax - oldMin) * (newMax - newMin) + newMin;
            }

            float2 remap(float2 target, float oldMin, float oldMax, float newMin, float newMax)
            {
                 target.x = remap(target.x, oldMin, oldMax, newMin, newMax);
                 target.y = remap(target.y, oldMin, oldMax, newMin, newMax);
                 return target;
            }

            Varyings Vertex(Attributes input)
            {
                Varyings output;
                VertexPositionInputs positionInputs = GetVertexPositionInputs(input.positionOS.xyz);
                VertexNormalInputs normalInputs = GetVertexNormalInputs(input.normalOS.xyz);
                output.positionWS = positionInputs.positionWS;
                output.positionCS = positionInputs.positionCS;
                output.normalWS = normalInputs.normalWS;
                output.uv = input.texcoord.xy;
                output.viewDirWS = GetCameraPositionWS() - positionInputs.positionWS;
                return output;
            }

            float4 Frag(Varyings input) : SV_Target
            {           
                Light light = GetMainLight();                
                float3 lightDir = normalize(light.direction);
                float diffuse = saturate(dot(lightDir, input.normalWS));
                diffuse *= light.distanceAttenuation * light.shadowAttenuation;

                // Multiple lightings
                uint pixelLightCount = GetAdditionalLightsCount();
                for (uint lightIndex = 0; lightIndex < pixelLightCount; ++lightIndex)
                {
                    Light l = GetAdditionalLight(lightIndex, input.positionWS);
                    diffuse += saturate(dot(l.direction, input.normalWS)) * l.distanceAttenuation * l.shadowAttenuation;
                }

                float edgeTerm = abs(dot(input.viewDirWS, input.normalWS));

                float2 screenUV = input.positionCS.xy / _ScreenParams.xy;
                float2 tileSum = _ScreenParams.xy / _TillSize;
                screenUV = frac(screenUV * tileSum);
                screenUV = remap(screenUV, 0, 1.0, -0.5, 0.5);
                float length = (screenUV.x * screenUV.x + screenUV.y * screenUV.y);

                float halfValue = diffuse;
                
                edgeTerm = pow(edgeTerm, _EdgeHelper);
                halfValue = max(diffuse, 1 - edgeTerm + _EdgeThre);
                
                float halfTerm = remap(halfValue, 1, _Mult1, _Mult2, 2);
                halfTerm = pow(length, halfTerm);
                halfTerm = round(halfTerm);
                halfTerm = saturate(halfTerm);   
                
                return halfTerm;
            }

            ENDHLSL
        }

        Pass
        {
            Name "ShadowCaster"
            Tags
            {
                "LightMode" = "ShadowCaster"
            }

            // -------------------------------------
            // Render State Commands
            ZWrite On
            ZTest LEqual
            ColorMask 0
            Cull[_Cull]

            HLSLPROGRAM
            #pragma target 2.0

            // -------------------------------------
            // Shader Stages
            #pragma vertex ShadowPassVertex
            #pragma fragment ShadowPassFragment

            // -------------------------------------
            // Material Keywords
            #pragma shader_feature_local_fragment _ALPHATEST_ON
            #pragma shader_feature_local_fragment _GLOSSINESS_FROM_BASE_ALPHA

            // -------------------------------------
            // Unity defined keywords
            #pragma multi_compile_fragment _ LOD_FADE_CROSSFADE

            //--------------------------------------
            // GPU Instancing
            #pragma multi_compile_instancing
            #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DOTS.hlsl"

            // This is used during shadow map generation to differentiate between directional and punctual light shadows, as they use different formulas to apply Normal Bias
            #pragma multi_compile_vertex _ _CASTING_PUNCTUAL_LIGHT_SHADOW

            // -------------------------------------
            // Includes
            #include "Packages/com.unity.render-pipelines.universal/Shaders/SimpleLitInput.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/Shaders/ShadowCasterPass.hlsl"
            ENDHLSL
        }
   
    }

    Fallback "Universal Render Pipeline/Lit"
}