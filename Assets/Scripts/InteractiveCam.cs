using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class InteractiveCam : MonoBehaviour
{
    private Color originalColor = new Color(231f / 255f, 221f / 255f, 210f / 255f);
    private Color blackColor = Color.black; // Shorthand for new Color(0, 0, 0)
    private bool isOriginalColor = true;

    void Update()
    {
        if (Input.GetKeyDown(KeyCode.Space))
        {
            if (isOriginalColor)
            {
                GetComponent<Camera>().backgroundColor = blackColor;
            }
            else
            {
                GetComponent<Camera>().backgroundColor = originalColor;
            }
            isOriginalColor = !isOriginalColor;
        }
    }
}
