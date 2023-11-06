#define DEG2RAD 0.0174533

// modified version of catlike coding tutorial on Gerstner waves: https://catlikecoding.com/unity/tutorials/flow/waves/ 
void GetGerstnerWave_float(float3 position, float wavelength, float steepness, 
								float waveSpeed, float pi, float time, float angle, float3 tangent, float3 bitangent,
								out float3 updatedPosition, out float3 updatedTangent, out float3 updatedBitangent)
{
	float modifiedWavelength = 2 * pi / wavelength;
	float c = sqrt(9.8 / modifiedWavelength);

	float angleRad = DEG2RAD * angle;
	float3 dir = normalize(float3(cos(angleRad), 0, -sin(angleRad)));	// we're rotating (1,0,0) by angle in the XZ plane

	float f = modifiedWavelength * (dot(dir.xz, position.xz) - waveSpeed * c * time);
	float amplitude = steepness / modifiedWavelength;

	// Gerstner
	updatedPosition = position;
	updatedPosition.x += dir.x * amplitude * cos(f);
	updatedPosition.y += amplitude * sin(f);
	updatedPosition.z += dir.y * amplitude * cos(f);

	// Normals
	// Use derivative of xyz pos values
	updatedTangent = 0;
	updatedBitangent = 0;

	updatedTangent = tangent + float3(-dir.x * dir.x * steepness * sin(f),
					 dir.x * steepness * cos(f),
					 -dir.x * dir.y * steepness * sin(f));

	updatedBitangent = bitangent + float3(updatedTangent.z, dir.y * steepness * cos(f), -dir.y * dir.y * steepness * sin(f));
}