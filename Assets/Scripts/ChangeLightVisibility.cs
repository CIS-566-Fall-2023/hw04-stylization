using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ChangeLightVisibility : MonoBehaviour
{
    public float[] intensities;
    private Light point;
    int index;

    // Start is called before the first frame update
    void Start()
    {
        point = gameObject.GetComponent<Light>();
    }

    // Update is called once per frame
    void Update()
    {
        if (Input.GetKeyDown(KeyCode.Space))
        {
            index = (index + 1) % intensities.Length;
            SwapToNextMaterial(index);
        }
    }

    void SwapToNextMaterial(int index)
    {
        point.intensity = intensities[index % intensities.Length];

    }
}
