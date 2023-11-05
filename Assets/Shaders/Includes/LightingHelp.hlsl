void GetMainLight_float(float3 WorldPos, out float3 Color, out float3 Direction, out float DistanceAtten, out float ShadowAtten)
{
#ifdef SHADERGRAPH_PREVIEW
    Direction = normalize(float3(0.5, 0.5, 0));
    Color = 1;
    DistanceAtten = 1;
    ShadowAtten = 1;
#else
#if SHADOWS_SCREEN
        float4 clipPos = TransformWorldToClip(WorldPos);
        float4 shadowCoord = ComputeScreenPos(clipPos);
#else
    float4 shadowCoord = TransformWorldToShadowCoord(WorldPos);
#endif

    Light mainLight = GetMainLight(shadowCoord);
    Direction = mainLight.direction;
    Color = mainLight.color;
    DistanceAtten = mainLight.distanceAttenuation;
    ShadowAtten = mainLight.shadowAttenuation;
#endif
}

void ComputeAdditionalLighting_float(float3 WorldPosition, float3 WorldNormal,
    float2 Thresholds, float3 RampedDiffuseValues,
    out float3 Color, out float Diffuse, out float shadowAttenCalc)
{
    Color = float3(0, 0, 0);
    Diffuse = 0;
    shadowAttenCalc = 1.0;

#ifndef SHADERGRAPH_PREVIEW

    int pixelLightCount = GetAdditionalLightsCount();
    
    for (int i = 0; i < pixelLightCount; ++i)
    {
        Light light = GetAdditionalLight(i, WorldPosition);
        float4 tmp = unity_LightIndices[i / 4];
        uint light_i = tmp[i % 4];

        half shadowAtten = light.shadowAttenuation * AdditionalLightRealtimeShadow(light_i, WorldPosition, light.direction);
        
        half NdotL = saturate(dot(WorldNormal, light.direction));
        half distanceAtten = light.distanceAttenuation;

        half thisDiffuse = distanceAtten * shadowAtten * NdotL;
        
        half rampedDiffuse = 0;
        
        if (thisDiffuse < Thresholds.x)
        {
            rampedDiffuse = RampedDiffuseValues.x;
        }
        else if (thisDiffuse < Thresholds.y)
        {
            rampedDiffuse = RampedDiffuseValues.y;
        }
        else
        {
            rampedDiffuse = RampedDiffuseValues.z;
        }

        if (shadowAtten * NdotL <= 0) {
            rampedDiffuse = 0.0;
            shadowAttenCalc = 0.0; 
        }
        
        if (light.distanceAttenuation <= 0)
        {
            rampedDiffuse = 0.0;
        }

        Color += max(rampedDiffuse, 0) * light.color.rgb;
        Diffuse += rampedDiffuse;
       
    }
    
    //if (Diffuse <= 0.3)
    //{
    //    Color = float3(0, 0, 0);
    //    Diffuse = 0;
    //}
    
#endif
}

void ChooseColor_float(float3 Highlight, float3 Midtone, float3 Shadow, float Diffuse, float2 Thresholds, out float3 OUT)
{
    if (Diffuse < Thresholds.x)
    {
        OUT = Shadow;
    }
    else if (Diffuse < Thresholds.y)
    {
        OUT = Midtone;
    }
    else
    {
        OUT = Highlight;
    }
}

void ChooseColorSpecial_float(float3 edgeSoftness, float3 Highlight, float3 Midtone, float3 Shadow, float Diffuse, float2 Thresholds, out float3 OUT)
{
    // Start blending from Shadow to Midtone below the lower threshold
    float lowerBlendStart = Thresholds.x - edgeSoftness;
    float lowerBlendEnd = Thresholds.x + edgeSoftness;

    // Start blending from Midtone to Highlight above the upper threshold
    float upperBlendStart = Thresholds.y - edgeSoftness;
    float upperBlendEnd = Thresholds.y + edgeSoftness;

    // Determine blend amounts using smoothstep, which will give us a value between 0 and 1
    float lowerBlend = smoothstep(lowerBlendStart, lowerBlendEnd, Diffuse);
    float upperBlend = smoothstep(upperBlendStart, upperBlendEnd, Diffuse);

    // Linearly interpolate between colors using the blend factors
    float3 blendedColor = lerp(Shadow, Midtone, lowerBlend);
    blendedColor = lerp(blendedColor, Highlight, upperBlend);

    OUT = blendedColor;

}

float rnd(float2 xy)
{
    return frac(sin(dot(xy, float2(12.9898 - 0.0, 78.233 + 0.0))) * (43758.5453 + 0.0));
}

float rndTime(float2 xy, float t) {
    float2 seed = float2(dot(xy, float2(12.9898, 78.233)), dot(xy, float2(39.3467, 11.1355)) + t);
    return frac(sin(dot(seed, float2(127.1, 311.7))) * 43758.5453);
}
float inter(float a, float b, float x)
{
    //return a*(1.0-x) + b*x; // Linear interpolation

    float f = (1.0 - cos(x * 3.1415927)) * 0.5; // Cosine interpolation
    return a * (1.0 - f) + b * f;
}
float perlinTime(float2 uv, float time)
{
    float a, b, c, d, coef1, coef2, t, p;

    t = 8.0;					// Precision
    p = 0.0;								// Final heightmap value

    for (float i = 0.0; i < 8.0; i++)
    {
        a = rndTime(float2(floor(t * uv.x) / t, floor(t * uv.y) / t), time);	    //	a----b
        b = rndTime(float2(ceil(t * uv.x) / t, floor(t * uv.y) / t), time);		//	|    |
        c = rndTime(float2(floor(t * uv.x) / t, ceil(t * uv.y) / t), time);		//	c----d
        d = rndTime(float2(ceil(t * uv.x) / t, ceil(t * uv.y) / t), time);

        if ((ceil(t * uv.x) / t) == 1.0)
        {
            b = rnd(float2(0.0, floor(t * uv.y) / t));
            d = rnd(float2(0.0, ceil(t * uv.y) / t));
        }

        coef1 = frac(t * uv.x);
        coef2 = frac(t * uv.y);
        p += inter(inter(a, b, coef1), inter(c, d, coef1), coef2) * (1.0 / pow(2.0, (i + 0.6)));
        t *= 2.0;
    }
    return p;
}

float perlin(float2 uv)
{
    float a, b, c, d, coef1, coef2, t, p;

    t = 8.0;					// Precision
    p = 0.0;								// Final heightmap value

    for (float i = 0.0; i < 8.0; i++)
    {
        a = rnd(float2(floor(t * uv.x) / t, floor(t * uv.y) / t));	    //	a----b
        b = rnd(float2(ceil(t * uv.x) / t, floor(t * uv.y) / t));		//	|    |
        c = rnd(float2(floor(t * uv.x) / t, ceil(t * uv.y) / t));		//	c----d
        d = rnd(float2(ceil(t * uv.x) / t, ceil(t * uv.y) / t));

        if ((ceil(t * uv.x) / t) == 1.0)
        {
            b = rnd(float2(0.0, floor(t * uv.y) / t));
            d = rnd(float2(0.0, ceil(t * uv.y) / t));
        }

        coef1 = frac(t * uv.x);
        coef2 = frac(t * uv.y);
        p += inter(inter(a, b, coef1), inter(c, d, coef1), coef2) * (1.0 / pow(2.0, (i + 0.6)));
        t *= 2.0;
    }
    return p;
}

void ChooseColorSpecial2_float(float perlinScale, float2 uv, float3 edgeSoftness,
    float3 Highlight, float3 Midtone, float3 Shadow, float Diffuse, float2 Thresholds, out float3 OUT)
{
    // Calculate the edge noise
    // float noiseValue = _NoiseTex.Sample(_NoiseTexSampler, uv.xy).r;
    float noiseValue = perlin(uv * perlinScale);
    // Modulate the thresholds with noise
    float modulatedThresholdX = Thresholds.x + (noiseValue * edgeSoftness * 2.0 - edgeSoftness);
    float modulatedThresholdY = Thresholds.y + (noiseValue * edgeSoftness * 2.0 - edgeSoftness);

    // Soft blending influenced by noise
    float lowerBlendStart = modulatedThresholdX - edgeSoftness;
    float lowerBlendEnd = modulatedThresholdX + edgeSoftness;
    float upperBlendStart = modulatedThresholdY - edgeSoftness;
    float upperBlendEnd = modulatedThresholdY + edgeSoftness;

    // Calculate the blend factors using the noise-modulated thresholds
    float lowerBlend = smoothstep(lowerBlendStart, lowerBlendEnd, Diffuse);
    float upperBlend = smoothstep(upperBlendStart, upperBlendEnd, Diffuse);

    // Blend the colors together
    float3 blendedColor = lerp(Shadow, Midtone, lowerBlend);
    blendedColor = lerp(blendedColor, Highlight, upperBlend);

    // Apply watercolor blend effect here
    // This could be a function that applies a more complex blending based on the
    // paper texture, color bleeding, and other artistic effects.

    OUT = blendedColor;
}

float3 ApplyNoiseToColor(float3 color, float2 uv, float noiseScale, float noiseIntensity, float time) {
    // Create a fractal noise pattern for granulation.
    float granulationNoise = perlinTime(uv * noiseScale, time) * noiseIntensity;

    // For flow noise, you can use a directional noise pattern, or warp the UVs
    float2 flowUV = uv + ((perlin(uv * noiseScale * 0.5) * 2.0 - 1.0) * 0.5);
    float flowNoise = perlin(flowUV * noiseScale) * noiseIntensity;

    // Combine the granulation and flow noises with the base color
    float3 noisyColor = color + color * granulationNoise + color * flowNoise;

    return noisyColor;
}

// Function to calculate the edge darkening effect
float EdgeDarkeningFactor(float diffuseValue, float threshold, float edgeRange, float noiseScale, float noiseIntensity, float2 uv) {
    float edgeCenter = smoothstep(threshold - edgeRange, threshold, diffuseValue);
    float edgeTransition = smoothstep(threshold, threshold + edgeRange, diffuseValue);
    float edgeFactor = edgeCenter * (1.0 - edgeTransition); // This creates a sharp edge window around the threshold

    // Add noise to the edge factor to simulate watercolor irregularities
    float noise = perlin(uv * noiseScale) * noiseIntensity;
    edgeFactor *= noise;

    return edgeFactor;
}

void ChooseColorSpecial3_float(
    float time,
    float perlinScale, float perlinStrength,
    float edgeIntensity, float edgeRange,
    float edgeNoiseScale, float edgeNoiseIntensity,
    float hueVarIntensity,
    float colorNoiseScale, float colorNoiseIntensity, 
    float2 uv, float3 edgeSoftness, float3 Highlight, float3 Midtone, float3 Shadow,
    float Diffuse, float2 Thresholds, out float3 OUT)
{
    // Calculate the noise based on the UV coordinates
    float noise = perlinTime(uv * perlinScale, time) * perlinStrength;

    // Warp the Diffuse value by the noise
    Diffuse += noise;

    float3 noisyShadow = ApplyNoiseToColor(Shadow, uv, colorNoiseScale, colorNoiseIntensity, time);
    float3 noisyMidtone = ApplyNoiseToColor(Midtone, uv, colorNoiseScale, colorNoiseIntensity, time);
    float3 noisyHighlight = ApplyNoiseToColor(Highlight, uv, colorNoiseScale, colorNoiseIntensity, time);

    // Calculate the edge darkening factors for each threshold
    float edgeFactorLower = EdgeDarkeningFactor(Diffuse, Thresholds.x, edgeRange, edgeNoiseScale, edgeNoiseIntensity, uv);
    float edgeFactorUpper = EdgeDarkeningFactor(Diffuse, Thresholds.y, edgeRange, edgeNoiseScale, edgeNoiseIntensity, uv);

    // Apply the edge darkening factors selectively
    noisyShadow *= (1.0 - edgeFactorLower);
    noisyMidtone *= (1.0 - edgeFactorUpper);
    //noisyHighlight *= (1.0 - edgeFactorUpper);

    float lowerBlendStart = Thresholds.x - edgeSoftness;
    float lowerBlendEnd = Thresholds.x + edgeSoftness;

    float upperBlendStart = Thresholds.y - edgeSoftness;
    float upperBlendEnd = Thresholds.y + edgeSoftness;

    float lowerBlend = smoothstep(lowerBlendStart, lowerBlendEnd, Diffuse);
    float upperBlend = smoothstep(upperBlendStart, upperBlendEnd, Diffuse);

    float3 blendedColor = lerp(noisyShadow, noisyMidtone, lowerBlend);
    blendedColor = lerp(blendedColor, noisyHighlight, upperBlend);

    OUT = blendedColor;
}



void ChooseColor2_float(float3 Highlight, float3 Midtone, float3 Shadow, float Diffuse, float Threshold, float Threshold2, out float3 OUT)
{
    if (Diffuse < Threshold)
    {
        OUT = Shadow;
    }
    else if (Diffuse < Threshold2) {
        OUT = Midtone;
    }
    else
    {
        OUT = Highlight;
    }
}