using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class FloodOcean : MonoBehaviour
{
    public Material ocean;
    private bool isFlooding = false;

    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        if (Input.GetKeyDown(KeyCode.Space))
        {
            index = (index + 1) % materials.Count;
            SwapToNextMaterial(index);
        }
    }
}
