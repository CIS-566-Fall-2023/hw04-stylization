using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class FullScreenPostProcessSwitch : MonoBehaviour
{
    public Material OutlineMat;
    public Material OldMovieMat;

    // Update is called once per frame
    void Update()
    {
        if (Input.GetKeyDown(KeyCode.A))
        {
            if (OutlineMat.GetFloat("_On") == 1)
            {
                OutlineMat.SetFloat("_On", 0);
            }
            else
            {
                OutlineMat.SetFloat("_On", 1);
            }
        }
        if (Input.GetKeyDown(KeyCode.S))
        {
            if (OldMovieMat.GetFloat("_On") == 1)
            {
                OldMovieMat.SetFloat("_On", 0);
            }
            else
            {
                OldMovieMat.SetFloat("_On", 1);
            }
        }
    }
}
