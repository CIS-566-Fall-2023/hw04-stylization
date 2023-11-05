Shader "Hidden/Highlight"
{
    Properties
    {
        [Toggle]_SPEC("Turn on Specular?", float) = 1
        _SpecColor("SpecColor", Color) = (0, 0, 0, 1)
        _SpecSize("SpecSize", Range(0, 1)) = 0.4  
        _Color("Color", Color) = (0, 0, 0, 1)
        _Tex ("Tex", 2D) = "white" {}
        _EdgeThre("EdgeThre", Range(-3, 3)) = 0.4
        _EdgeHelper("EdgeHelper", Range(0, 1)) = 0.4    

        _TillSize ("TillSize", Range(0, 10)) = 10
        _Mult("Mult", Range(0, 0.1)) = 0.4
        _MidOffset("MidOffset", Range(-1, 1)) = 0.4
        _Mult1("Mult1", Range(-5, 0)) = 0.4
        _Mult2("Mult2", Range(-1, 2)) = 0.4
    }

    SubShader
    {
        HLSLINCLUDE
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"         
            #include "Packages/com.unity.shadergraph/ShaderGraphLibrary/ShaderVariablesFunctions.hlsl"

            #pragma shader_feature _SPEC_ON

            CBUFFER_START(UnityPerMaterial)
                float4 _SpecColor;
                float _SpecSize;
                float4 _Color;
                float _EdgeThre;
                float _EdgeHelper;
                int _TillSize;
                float _Mult;
                float _MidOffset;
                float _Mult1;
                float _Mult2;
            CBUFFER_END

            TEXTURE2D(_Tex);                 
            SAMPLER(sampler_Tex);

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
            Tags{
              "RenderPipeline"="UniversalRenderPipeline"
              "RenderType"="Transparent"
              "IgnoreProjector"="True"
              "Queue"="Transparent"
            }
            Blend SrcAlpha OneMinusSrcAlpha
            ZWrite Off

            HLSLPROGRAM
	        #pragma target 3.0
            #pragma vertex Vertex
            #pragma fragment Frag

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

                #if _SPEC_ON
                // Specular
                float3 worldHalfDir = normalize(lightDir + input.viewDirWS);
                float spec = dot(normalize(input.normalWS), worldHalfDir);
                if(spec > _SpecSize) 
                {
                    return _SpecColor;
                }
                #endif

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
                halfValue =  1 - edgeTerm + _EdgeThre;
                
                float halfTerm = remap(halfValue, 1, _Mult1, _Mult2, 2);
                halfTerm = pow(length, halfTerm);
                halfTerm = round(halfTerm);
                halfTerm = saturate(halfTerm);   
                float4 col =  halfTerm * _Color;
                col.a = halfTerm;
                return col;
            }

            ENDHLSL
        }

        Pass 
        {
            Tags{
              "RenderPipeline"="UniversalRenderPipeline"
              "RenderType"="Transparent"
              "IgnoreProjector"="True"
              "Queue"="Transparent"
            }
            Blend SrcAlpha OneMinusSrcAlpha
            ZWrite Off

            HLSLPROGRAM
	        #pragma target 3.0
            #pragma vertex Vertex
            #pragma fragment Frag

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
                halfValue =  1 - edgeTerm + _EdgeThre;
                
                float halfTerm = remap(halfValue, 1, _Mult1, _Mult2, 2);
                halfTerm = pow(length, halfTerm);
                halfTerm = round(halfTerm);
                halfTerm = saturate(halfTerm);   
                float4 col =  halfTerm * _Color;
                col.a = halfTerm;
                return col;
            }

            ENDHLSL
        }
   
    }

    Fallback "Universal Render Pipeline/Lit"
}