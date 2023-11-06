using Cyan;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using Unity.VisualScripting;
using UnityEngine;
using UnityEngine.Rendering;
using UnityEngine.Rendering.Universal;

public class InteractivePostMaterial : MonoBehaviour
{
    public Material material;
    float val = 0.0f;

    // Start is called before the first frame update
    void Start()
    {
        material.SetFloat("_Style", 0.0f);
    }

    // Update is called once per frame
    void Update()
    {
        if (Input.GetKeyDown(KeyCode.Space))
        {
            val = 1.0f - val;
            material.SetFloat("_Style", val);
        }
    }
}
