using System;
using System.Collections;
using System.Collections.Generic;
using System.Numerics;
using Unity.Mathematics;
using Unity.VisualScripting;
using UnityEngine;

public class FloodOcean : MonoBehaviour
{
    public Material ocean;
    public float level = 0.0f;
    public float speed = 0.0005f;
    private bool isFlooded = false;

    // Start is called before the first frame update
    void Start()
    {
        ocean.SetFloat("_WaveHeight", Mathf.SmoothStep(0.02f, 1.3f, level));
    }

    // Update is called once per frame
    void Update()
    {
        level = isFlooded ? math.min(level + speed, 1.0f) : math.max(level - speed, 0.00f);

        ocean.SetFloat ("_WaveHeight", Mathf.SmoothStep(0.02f, 1.1f, level));

        if (Input.GetKeyDown(KeyCode.Space))
        {
            isFlooded = !isFlooded;
        }
    }
}
