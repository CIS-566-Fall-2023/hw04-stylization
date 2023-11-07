Shader "MyShader/MasterUnlit_Ver3"
{
    Properties
    {
        [Header(OutLine)]
        // Stroke Color
        _StrokeColor("Stroke Color", Color) = (0,0,0,1)
        // Noise Map
        _OutlineNoise("Outline Noise Map", 2D) = "white" {}
        // First Outline Width
        _Outline("Outline Width", Range(0, 1)) = 0.1
        // Second Outline Width
        _OutsideNoiseWidth("Outside Noise Width", Range(1, 2)) = 1.3
        _MaxOutlineZOffset("Max Outline Z Offset", Range(0,1)) = 0.5

        [Header(Interior)]
        _Ramp("Ramp Texture", 2D) = "white" {}
        // Stroke Map
        _StrokeTex("Stroke Noise Tex", 2D) = "white" {}
        _InteriorNoise("Interior Noise Map", 2D) = "white" {}
        // Interior Noise Level
        _InteriorNoiseLevel("Interior Noise Level", Range(0, 1)) = 0.15
        // Guassian Blur
        radius("Guassian Blur Radius", Range(0,60)) = 30
        resolution("Resolution", float) = 800
        hstep("HorizontalStep", Range(0,1)) = 0.5
        vstep("VerticalStep", Range(0,1)) = 0.5

    }
    SubShader
    {
        Tags{ "RenderType" = "Opaque" "RenderPipeline" = "UniversalPipeline"}
        Pass
        {
            Tags { "LightMode" = "_Outline" }
            Name "Outline"
            Cull Front

            HLSLPROGRAM

            #pragma vertex Outline_Vert;
            #pragma fragment Outlint_Frag;

            #include "Assets/Shaders/Includes/Unlit.hlsl"
            ENDHLSL
        }

        Pass
        {
            Tags { "LightMode" = "_Outline_Two" }
            Name "_Outline_Two"
            Cull Front

            HLSLPROGRAM

            #pragma vertex OutlineTwo_Vert;
            #pragma fragment OutlintTwo_Frag;

            #include "Assets/Shaders/Includes/Unlit.hlsl"
            ENDHLSL
        }

            Pass
        {
            Tags {"LightMode" = "_Interior3"}
            Name "_Interior3"

            Cull Back

            HLSLPROGRAM
            #pragma vertex Interior_Vert3
            #pragma fragment Interior_Frag3

            #include "Assets/Shaders/Includes/Unlit.hlsl"
            ENDHLSL
        }
    }
}
