Shader "Hidden/ObjectOutline"
{
    Properties
    {
        _OutlineWidth("OutlineWidth", Range(0, 10)) = 0.4
        _OutlineColor("Outline Color", Color) = (0, 0, 0, 1)
    }

    SubShader
    {
        HLSLINCLUDE
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"         
            #include "Packages/com.unity.shadergraph/ShaderGraphLibrary/ShaderVariablesFunctions.hlsl"

            CBUFFER_START(UnityPerMaterial)
                float _OutlineWidth;
                float4 _OutlineColor;
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
            Name "OutLine"
            Tags{ "LightMode" = "SRPDefaultUnlit" }
	        Cull front

	        HLSLPROGRAM
	        #pragma vertex vert  
	        #pragma fragment frag

	        Varyings vert(Attributes input) 
            {
                float4 scaledScreenParams = GetScaledScreenParams();
                float scaleX = abs(scaledScreenParams.x / scaledScreenParams.y);

		        Varyings output;
		        VertexPositionInputs vertexInput = GetVertexPositionInputs(input.positionOS.xyz);
                VertexNormalInputs normalInput = GetVertexNormalInputs(input.normalOS);
                float3 normalCS = TransformWorldToHClipDir(normalInput.normalWS);
                float2 extendDis = normalize(normalCS.xy) * _OutlineWidth * 0.01;
                extendDis.x /= scaleX;
                output.positionCS = vertexInput.positionCS;         
                output.positionCS.xy += extendDis * output.positionCS.w ;
		        return output;	            
            }

	        float4 frag(Varyings input) : SV_Target 
            {
                 return float4(_OutlineColor.rgb, 1);
	        }
	        ENDHLSL
         }
    }

    Fallback "Universal Render Pipeline/Lit"
}