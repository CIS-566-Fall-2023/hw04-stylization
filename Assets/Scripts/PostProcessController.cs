using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PostProcessController : MonoBehaviour
{
    // Start is called before the first frame update
    public Material matStatic;
    public Material matBW;
    private MeshRenderer meshRenderer;
    Boolean isStaticActive = false;
    Boolean isBWActive = false;
    void Start()
    {
        meshRenderer = GetComponent<MeshRenderer>();
    }

    void Update()
    {
        if (Input.GetKeyDown(KeyCode.S))
        {
            isStaticActive = !isStaticActive;
            int val = isStaticActive ? 1 : 0;
            matStatic.SetFloat("_IsStaticActive", val);
            /*if (isActive)
            {
                mat.SetFloat("_IsStaticActive", 1);
            }
            else
            {
                mat.SetFloat("_IsStaticActive", 0);
            }*/


        } else if (Input.GetKeyDown(KeyCode.B))
        {
            isBWActive = !isBWActive;
            int val = isBWActive ? 1 : 0;
            matBW.SetFloat("_IsBWActive", val);
        }
    }
}
