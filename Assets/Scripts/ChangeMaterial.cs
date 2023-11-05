using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using UnityEngine;

public class ChangeMaterial : MonoBehaviour
{
    public Material[] materials;
    private MeshRenderer meshRenderer;
    private Renderer renderer;
    private Material[] renderer_materials;

    public int MeshRendererIdx;
    int index;

    void Start()
    {
        meshRenderer = GetComponent<MeshRenderer>();
        renderer = meshRenderer.GetComponent<Renderer>();
        renderer_materials = renderer.materials;
    }

    void Update()
    {
        if (Input.GetKeyDown(KeyCode.Space))
        {
            index = (index + 1) % materials.Length;
            SwapToNextMaterial(index);
            renderer.materials = renderer_materials;
        }
    }

    void SwapToNextMaterial(int index)
    {
        renderer_materials[MeshRendererIdx] = materials[index % materials.Length];
    }
}
