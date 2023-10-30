using UnityEngine;

[RequireComponent(typeof(Light))]
public class FlickerLight : MonoBehaviour
{
    public float minIntensity = 0.25f;  // Minimum light intensity
    public float maxIntensity = 1.0f;   // Maximum light intensity
    public float flickerSpeed = 0.5f;   // Speed of flickering effect

    private Light _lightSource;
    private float _randomizer;

    void Start()
    {
        _lightSource = GetComponent<Light>();
        _randomizer = Random.Range(0.0f, 0.99f);  // To make multiple lights flicker differently
    }

    void Update()
    {
        // Create a random flicker effect based on Perlin noise
        float noise = Mathf.PerlinNoise(_randomizer, Time.time * flickerSpeed);
        _lightSource.intensity = Mathf.Lerp(minIntensity, maxIntensity, noise);
    }
}
