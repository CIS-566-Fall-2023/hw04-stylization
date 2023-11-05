#define TAU 6.28318530718

const float3 CloudColor = float3(0.8, 0.8, 0.87);


float Func(float pX)
{
	return 0.6 * (0.5 * sin(0.1 * pX) + 0.5 * sin(0.553 * pX) + 0.7 * sin(1.2 * pX));
}


float FuncR(float pX)
{
	return 0.5 + 0.25 * (1.0 + sin(fmod(40.0 * pX, TAU)));
}


float Layer(float2 pQ, float pT)
{
	float2 Qt = 3.5 * pQ;
	pT *= 0.5;
	Qt.x += pT;

	float Xi = floor(Qt.x);
	float Xf = Qt.x - Xi - 0.5;

	float2 C;
	float Yi;
	float D = 1.0 - step(Qt.y, Func(Qt.x));

	// Disk:
	Yi = Func(Xi + 0.5);
	C = float2(Xf, Qt.y - Yi);
	D = min(D, length(C) - FuncR(Xi + pT / 80.0));

	// Previous disk:
	Yi = Func(Xi + 1.0 + 0.5);
	C = float2(Xf - 1.0, Qt.y - Yi);
	D = min(D, length(C) - FuncR(Xi + 1.0 + pT / 80.0));

	// Next Disk:
	Yi = Func(Xi - 1.0 + 0.5);
	C = float2(Xf + 1.0, Qt.y - Yi);
	D = min(D, length(C) - FuncR(Xi - 1.0 + pT / 80.0));

	return min(1.0, D);
}



void Cloud_float(in float3 BackColor, in float2 UV, in float time, out float3 Color)
{

	//float2 UV = 2.0 * (pixelCoord.xy - resolution.xy / 2.0) / min(resolution.x, resolution.y);

	Color = BackColor;
	for (float J = 0.0; J <= 1.0; J += 0.5)
	{
		// Cloud Layer: 
		float Lt = time * (0.5 + 2.0 * J) * (1.0 + 0.1 * sin(226.0 * J)) + 17.0 * J;
		float2 Lp = float2(0.0, 0.3 + 1.5 * (J - 0.5));
		float L = Layer(UV + Lp, Lt);

		// Blur and color:
		float Blur = 4.0 * (0.5 * abs(2.0 - 5.0 * J)) / (11.0 - 5.0 * J);

		float V = lerp(0.0, 1.0, 1.0 - smoothstep(0.0, 0.01 + 0.2 * Blur, L));
		float3 Lc = lerp(BackColor, float3(1.0, 1.0, 1.0), J);

		Color = lerp(Color, Lc, V);
	}
}


