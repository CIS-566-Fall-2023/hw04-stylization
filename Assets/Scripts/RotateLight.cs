using UnityEngine;

public class RotateLight : MonoBehaviour
{
    public Transform character;
    public float rotationSpeed = 1.0f;
    public float rotationAmplitude = 45.0f;

    private float angle;

    void Update()
    {
        angle = Mathf.Sin(Time.time * rotationSpeed) * rotationAmplitude;

        transform.RotateAround(character.position, Vector3.up, angle * Time.deltaTime);
    }
}
