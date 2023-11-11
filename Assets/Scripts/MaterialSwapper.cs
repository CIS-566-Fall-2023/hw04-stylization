using System.Collections;
using System.Collections.Generic;
using System.Linq;
using UnityEngine;

public class MaterialSwapper : MonoBehaviour
{
    public Material[] materials;
    private SkinnedMeshRenderer meshRenderer;
    int index;

    void Start()
    {
        meshRenderer = GetComponent<SkinnedMeshRenderer>();
    }

    void Update()
    {
        if (Input.GetKeyDown(KeyCode.Space))
        {
            index = (index + 1) % materials.Length;
            SwapToNextMaterial(index);
        }
    }

    void SwapToNextMaterial(int index)
    {
        meshRenderer.material = materials[index % materials.Length];
    }
}
