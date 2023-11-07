#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Common.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"

TEXTURE2D(_OutlineNoise);
SAMPLER(sampler_OutlineNoise);
float4 _OutlineNoise_ST;

TEXTURE2D(_InteriorNoise);
SAMPLER(sampler_InteriorNoise);


/*
In Unity, the _ST suffix is automatically added to 
texture property names to refer to the scaling and translation 
(tiling and offset) vectors associated with the texture.
*/

TEXTURE2D(_Ramp);
SAMPLER(sampler_Ramp);
float4 _Ramp_ST;

TEXTURE2D(_StrokeTex);
SAMPLER(sampler_StrokeTex);
float4 _StrokeTex_ST;

CBUFFER_START(UnityPerMaterial)
float4 _StrokeColor;
float  _Outline;
float  _OutsideNoiseWidth;
float  _MaxOutlineZOffset;
float  _InteriorNoiseLevel;
float  radius;
float  resolution;
float  hstep;
float  vstep;
CBUFFER_END

struct VIn
{
    float4 position : POSITION;
    float3 normal : NORMAL;
    float2 uv : TEXCOORD0;
};

struct VOut
{
    float3 normal : NORMAL;
    float4 pos    : SV_POSITION;
    float2 uv : TEXCOORD0;
};

VOut Outline_Vert(VIn vin)
{
    float4 burn = _OutlineNoise.SampleLevel(sampler_OutlineNoise, vin.uv, 0) *0.2;
    VOut vout;
    float3 scaledir = mul((float3x3)UNITY_MATRIX_MV, vin.normal);//TransformWorldToViewNormal(vin.normal); 
    scaledir.z = 0.01;
    scaledir = normalize(scaledir);

    // camera space
    float4 position_cs = mul(UNITY_MATRIX_MV, vin.position);
    position_cs /= position_cs.w;
    float3 viewDir = normalize(position_cs.xyz);
    float3 offset_pos_cs = position_cs.xyz + viewDir * _MaxOutlineZOffset;

    // unity_CameraProjection[1].y = fov/2
    float linewidth = -position_cs.z / unity_CameraProjection[1].y;
    linewidth = sqrt(linewidth);
    position_cs.xy = offset_pos_cs.xy + scaledir.xy * linewidth * burn.x * _Outline;
    position_cs.z = offset_pos_cs.z;

    vout.pos = mul(UNITY_MATRIX_P, position_cs);
    return vout;
}

float4 Outlint_Frag(VOut vin) : SV_Target
{
    return  _StrokeColor;
}

struct VIn2
{
    float4 vertex : POSITION;
    float3 normal : NORMAL;
    float2 texcoord : TEXCOORD0;
};

struct VOut2
{
    float4 pos : SV_POSITION;
    float2 uv : TEXCOORD0;
};

VOut2 OutlineTwo_Vert(VIn2 v)
{

    float4 burn = _OutlineNoise.SampleLevel(sampler_OutlineNoise, v.texcoord, 0) * 0.21;
    VOut2 o;
    float3 scaledir = mul((float3x3)UNITY_MATRIX_MV, v.normal);
    scaledir.z = 0.01;
    scaledir = normalize(scaledir);

    float4 position_cs = mul(UNITY_MATRIX_MV, v.vertex);
    position_cs /= position_cs.w;

    float3 viewDir = normalize(position_cs.xyz);
    float3 offset_pos_cs = position_cs.xyz + viewDir * _MaxOutlineZOffset;

    float linewidth = -position_cs.z / unity_CameraProjection[1].y;
    linewidth = sqrt(linewidth);
    position_cs.xy = offset_pos_cs.xy + scaledir.xy * linewidth * burn.y * _Outline * 1.1 * _OutsideNoiseWidth;
    position_cs.z = offset_pos_cs.z;

    o.pos = mul(UNITY_MATRIX_P, position_cs);
    o.uv =  v.texcoord;

    return o;
}

float4 OutlintTwo_Frag(VOut2 i) : SV_Target
{
    // clip random outline here
    float4 c = float4(1,0,0,1);// _StrokeColor;
    float3 burn = _OutlineNoise.Sample(sampler_OutlineNoise, i.uv).rgb;
    if (burn.x > 0.35)
        discard;
    return c;
}


struct a2v
{
    float4 position     : POSITION;
    float3 normal       : NORMAL;
    float4 texcoord     : TEXCOORD0;
    float4 tangent      : TANGENT;
};

struct v2f
{
    float4 pos          : POSITION;
    float2 uv           : TEXCOORD0;
    float3 worldNormal  : TEXCOORD1;
    float3 worldPos     : TEXCOORD2;
    float2 uv2          : TEXCOORD3;
    float4 shadowCoord  : TEXCOORD4;
};

v2f Interior_Vert(a2v v) {
    v2f o;
    o.pos = TransformObjectToHClip(v.position);
    o.worldNormal = TransformObjectToWorldNormal(v.normal);
    o.worldPos = mul(unity_ObjectToWorld, v.position).xyz;
    o.uv = TRANSFORM_TEX(v.texcoord, _Ramp);
    o.uv2 = TRANSFORM_TEX(v.texcoord, _StrokeTex);
    
    VertexPositionInputs vertexInput = GetVertexPositionInputs(v.position.xyz);
    o.shadowCoord = GetShadowCoord(vertexInput);

    return o;
}

float4 GetColorFromUV(float u) {
    float4 color1 = float4(63 / 255.0, 155 / 255.0, 209 / 255.0, 1.0);
    float4 color2 = float4(132 / 255.0, 176 / 255.0, 125 / 255.0, 1.0);
    float4 color3 = float4(161 / 255.0, 141 / 255.0, 72 / 255.0, 1.0);
    float4 color4 = float4(173 / 255.0, 145 / 255.0, 80 / 255.0, 1.0);

    if (u > 0.9) return color3;
    else if (u > 0.7) return color2;
    else if (u > 0.4) return color1;
    else return color4;
}

float4 ApplyGaussianBlur(float2 tc, float blur, float hstep) {
    float4 sum = float4(0, 0, 0, 0);

    sum += GetColorFromUV(tc.x - 4.0 * blur * hstep) * 0.0162162162;
    sum += GetColorFromUV(tc.x - 3.0 * blur * hstep) * 0.0540540541;
    sum += GetColorFromUV(tc.x - 2.0 * blur * hstep) * 0.1216216216;
    sum += GetColorFromUV(tc.x - 1.0 * blur * hstep) * 0.1945945946;
    sum += GetColorFromUV(tc.x) * 0.2270270270;
    sum += GetColorFromUV(tc.x + 1.0 * blur * hstep) * 0.1945945946;
    sum += GetColorFromUV(tc.x + 2.0 * blur * hstep) * 0.1216216216;
    sum += GetColorFromUV(tc.x + 3.0 * blur * hstep) * 0.0540540541;
    sum += GetColorFromUV(tc.x + 4.0 * blur * hstep) * 0.0162162162;

    return sum;
}


float4 Interior_Frag(v2f i) : SV_Target
{
    float3 worldNormal = normalize(i.worldNormal);

    // GetMainLight defined in Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl
    Light mainLight = GetMainLight();
    float3 direction = mainLight.direction;
    //direction = float3(1, 0, 0);
    float3 worldLightDir = normalize(direction);

    // Perlin Noise
    // For the bias of the coordiante
    float4 burn = _InteriorNoise.Sample(sampler_InteriorNoise, i.uv);
    // a little bit disturbance on normal vector
    float diff = dot(worldNormal, worldLightDir);
    diff = (diff * 0.5 + 0.5);
    float2 k = _StrokeTex.Sample(sampler_StrokeTex, i.uv).xy;
    float2 cuv = float2(diff, diff) + k * burn.xy * _InteriorNoiseLevel;

    // This iniminate the bias of the uv movement?
    if (cuv.x > 0.95)
    {
        cuv.x = 0.95;
        cuv.y = 1;
    }
    if (cuv.y > 0.95)
    {
        cuv.x = 0.95;
        cuv.y = 1;
    }
    cuv = clamp(cuv, 0, 1);

    //Guassian Blur
    float4 sum = float4(0.0, 0.0, 0.0, 0.0);
    float2 tc = cuv;
    //blur radius in pixels
    float blur = radius / resolution / 4;

    //sum = ApplyGaussianBlur(tc, blur, hstep);
    sum += _Ramp.Sample(sampler_Ramp, float2(tc.x - 4.0 * blur * hstep, 0.5)) * 0.0162162162;
    sum += _Ramp.Sample(sampler_Ramp, float2(tc.x - 3.0 * blur * hstep, 0.5)) * 0.0540540541;
    sum += _Ramp.Sample(sampler_Ramp, float2(tc.x - 2.0 * blur * hstep, 0.5)) * 0.1216216216;
    sum += _Ramp.Sample(sampler_Ramp, float2(tc.x - 1.0 * blur * hstep, 0.5)) * 0.1945945946;
    sum += _Ramp.Sample(sampler_Ramp, float2(tc.x, tc.y)) * 0.2270270270;
    sum += _Ramp.Sample(sampler_Ramp, float2(tc.x + 1.0 * blur * hstep, 0.5)) * 0.1945945946;
    sum += _Ramp.Sample(sampler_Ramp, float2(tc.x + 2.0 * blur * hstep, 0.5)) * 0.1216216216;
    sum += _Ramp.Sample(sampler_Ramp, float2(tc.x + 3.0 * blur * hstep, 0.5)) * 0.0540540541;
    sum += _Ramp.Sample(sampler_Ramp, float2(tc.x + 4.0 * blur * hstep, 0.5)) * 0.0162162162;

    return float4(sum.rgb, 1.0);
}

float4 Interior_Frag2(v2f i) : SV_Target
{
    float3 worldNormal = normalize(i.worldNormal);

    // GetMainLight defined in Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl
    Light mainLight = GetMainLight();
    float3 direction = mainLight.direction;
    //direction = float3(1, 0, 0);
    float3 worldLightDir = normalize(direction);

    // Perlin Noise
    // For the bias of the coordiante
    float4 burn = _InteriorNoise.Sample(sampler_InteriorNoise, i.uv);
    // a little bit disturbance on normal vector
    float diff = dot(worldNormal, worldLightDir);
    diff = (diff * 0.5 + 0.5);
    float2 k = _StrokeTex.Sample(sampler_StrokeTex, i.uv).xy;
    float2 cuv = float2(diff, diff) + k * burn.xy * _InteriorNoiseLevel;

    // This iniminate the bias of the uv movement?
    if (cuv.x > 0.95)
    {
        cuv.x = 0.95;
        cuv.y = 1;
    }
    if (cuv.y > 0.95)
    {
        cuv.x = 0.95;
        cuv.y = 1;
    }
    cuv = clamp(cuv, 0, 1);

    //Guassian Blur
    float4 sum = float4(0.0, 0.0, 0.0, 0.0);
    float2 tc = cuv;
    //blur radius in pixels
    float blur = radius / resolution / 4;

    sum = ApplyGaussianBlur(tc, blur, hstep);
    return float4(sum.rgb, 1.0);
}

v2f Interior_Vert3(a2v v) {
    v2f o;
    o.pos = TransformObjectToHClip(v.position);
    o.worldNormal = TransformObjectToWorldNormal(v.normal);
    o.worldPos = mul(unity_ObjectToWorld, v.position).xyz;
    
    o.uv = TRANSFORM_TEX(v.texcoord, _Ramp);
    o.uv.x += 0.1 * _Time.x;
    o.uv.y += 0.1 * sin(_Time.x);
    if (o.uv.x > 1)
        o.uv.x -= 1;
    o.uv2 = TRANSFORM_TEX(v.texcoord, _StrokeTex);
    o.uv2.x += 0.1 * _Time.x;
    if (o.uv2.x > 1)
        o.uv2.x -= 1;

    VertexPositionInputs vertexInput = GetVertexPositionInputs(v.position.xyz);
    o.shadowCoord = GetShadowCoord(vertexInput);

    return o;
}


float4 Interior_Frag3(v2f i) : SV_Target
{
    float3 worldNormal = normalize(i.worldNormal);

    // GetMainLight defined in Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl
    Light mainLight = GetMainLight();
    float3 direction = mainLight.direction;
    //direction = float3(1, 0, 0);
    float3 worldLightDir = normalize(direction);

    // Perlin Noise
    // For the bias of the coordiante
    float4 burn = _InteriorNoise.Sample(sampler_InteriorNoise, i.uv);
    // a little bit disturbance on normal vector
    float diff = dot(worldNormal, worldLightDir);
    diff = (diff * 0.5 + 0.5);
    float2 k = _StrokeTex.Sample(sampler_StrokeTex, i.uv).xy;
    float2 cuv = float2(diff, diff) + k * burn.xy * _InteriorNoiseLevel;

    if (cuv.x > 0.95)
    {
        cuv.x = 0.95;
        cuv.y = 1;
    }
    if (cuv.y > 0.95)
    {
        cuv.x = 0.95;
        cuv.y = 1;
    }
    cuv = clamp(cuv, 0, 1);

    //Guassian Blur
    float4 sum = float4(0.0, 0.0, 0.0, 0.0);
    float2 tc = cuv;
    //blur radius in pixels
    float blur = radius / resolution / 4;

    //sum = ApplyGaussianBlur(tc, blur, hstep);
    sum += _Ramp.Sample(sampler_Ramp, float2(tc.x - 4.0 * blur * hstep, 0.5)) * 0.0162162162;
    sum += _Ramp.Sample(sampler_Ramp, float2(tc.x - 3.0 * blur * hstep, 0.5)) * 0.0540540541;
    sum += _Ramp.Sample(sampler_Ramp, float2(tc.x - 2.0 * blur * hstep, 0.5)) * 0.1216216216;
    sum += _Ramp.Sample(sampler_Ramp, float2(tc.x - 1.0 * blur * hstep, 0.5)) * 0.1945945946;
    sum += _Ramp.Sample(sampler_Ramp, float2(tc.x, tc.y)) * 0.2270270270;
    sum += _Ramp.Sample(sampler_Ramp, float2(tc.x + 1.0 * blur * hstep, 0.5)) * 0.1945945946;
    sum += _Ramp.Sample(sampler_Ramp, float2(tc.x + 2.0 * blur * hstep, 0.5)) * 0.1216216216;
    sum += _Ramp.Sample(sampler_Ramp, float2(tc.x + 3.0 * blur * hstep, 0.5)) * 0.0540540541;
    sum += _Ramp.Sample(sampler_Ramp, float2(tc.x + 4.0 * blur * hstep, 0.5)) * 0.0162162162;

    return float4(sum.rgb, 1.0);
}