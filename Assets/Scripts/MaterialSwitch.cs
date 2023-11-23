using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MaterialSwitch : MonoBehaviour
{
    public Material[] mats;
    private int index;
    private MeshRenderer meshRenderer;
    private void Start()
    {
        meshRenderer = GetComponent<MeshRenderer>();
    }

    void Update()
    {
        if (Input.GetKeyDown(KeyCode.Space))
        {
            index = (index + 1) % mats.Length;
            SwapToNextMaterial(index);
        }
    }

    public void SwapToNextMaterial(int index)
    {
        meshRenderer.material = mats[index % mats.Length];
    }
}
