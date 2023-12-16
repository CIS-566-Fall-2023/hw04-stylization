using System.Collections;
using System.Collections.Generic;
using UnityEngine;
public class RotateScript : MonoBehaviour
{
    public float rotationSpeed = 45f; 
    public KeyCode rotationKey = KeyCode.Space;
    private bool isRotating = false;

    // Update is called once per frame
    void Update()
    {
        if (Input.GetKeyDown(KeyCode.Space))
        {
            isRotating = !isRotating;
        }

        if (isRotating)
        {
            RotateObject();
        }
    }

    void RotateObject()
    {
        // Calculate rotation amount
        float rotationStep = rotationSpeed * Time.deltaTime;

        // Apply rotation around the Y axis (up vector)
        transform.Rotate(Vector3.up, rotationStep);
    }
}
