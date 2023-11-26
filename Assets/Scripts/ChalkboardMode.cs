using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ChalkboardMode : MonoBehaviour
{
    public Material outlines;
    private bool chalk;
    private float colorThickness;
    private float wiggle;
    private float thickness;
    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        outlines.SetFloat("_ColorThickness", colorThickness);
        outlines.SetFloat("_WiggleStrength", wiggle);
        outlines.SetFloat("_Thickness", thickness);

        if (Input.GetKeyDown(KeyCode.C))
        {
            chalk = !chalk;
        }

        wiggle = chalk ? 0.01f : 0.0f;
        colorThickness = chalk ? -0.7f : 1.0f;
        thickness = chalk ? 2.0f : 1.0f;
    }
}
