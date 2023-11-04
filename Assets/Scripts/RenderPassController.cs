using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using UnityEngine;
using UnityEngine.Rendering.Universal;

public class RenderPassController : MonoBehaviour
{
    public Material postProcessMat;
    private MeshRenderer meshRenderer;
    Boolean isActive = false;

    void Start()
    {
        meshRenderer = GetComponent<MeshRenderer>();
    }

    void Update()
    {
        if (Input.GetKeyDown(KeyCode.Space))
        {
            isActive = !isActive;
            if (isActive)
            {
                postProcessMat.SetFloat("_IsActive", 1);
            }
            else {
                postProcessMat.SetFloat("_IsActive", -1);
            }


        }
    }


}
