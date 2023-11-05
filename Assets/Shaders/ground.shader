Shader "Unlit/ground"
{
    Properties
    {
        _ShadowColor ("ShadowColor", Color) = (.0, .0, .0, .5)
    }
    SubShader
    {
        Tags { 
            "Queue" = "Transparent"
            "RenderType" = "Transparent"
        }
        LOD 100
        Blend SrcAlpha OneMinusSrcAlpha

        Pass
        {
            HLSLPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma multi_compile _MAIN_LIGHT_SHADOWS
            #pragma multi_compile _MAIN_LIGHT_SHADOWS_CASCADE
            
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            float4 _ShadowColor;

            struct v2f
            {
                float4 vertex : SV_POSITION;
                float4 shadowCoord : TEXCOORD0;
            };

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = TransformObjectToHClip(v.vertex);
                #if SHADOWS_SCREEN
                    float4 clipPos = TransformWorldToClip(i.worldPos);
                    o.shadowCoord = ComputeScreenPos(clipPos);
                #else
                    float3 worldPos = GetVertexPositionInputs(v.vertex.xyz).positionWS;
                    o.shadowCoord = TransformWorldToShadowCoord(worldPos);
                #endif
                return o;
            }

            float4 frag (v2f i) : SV_Target
            {
                if (MainLightRealtimeShadow(i.shadowCoord) < 0.99)
                {
                    return _ShadowColor;
                }
                else return (.0, .0, .0, .0);
            }
            ENDHLSL
        }
    }
}
