using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MaterialSwap : MonoBehaviour
{
    private MeshRenderer meshRenderer;
    public Material[] materials;
    int index;
    public float rotation;
    public Light light;

    void Start()
    {
        meshRenderer = GetComponent<MeshRenderer>();
        rotation = 5f;
    }

    void Update()
    {
        if (Input.GetKeyDown(KeyCode.Space))
        {
            index = (index + 1) % materials.Length;
            SwapToNextMaterial(index);
        }

        if (Input.GetKey(KeyCode.Q))
        {
            if (light != null)
            {
                light.transform.Rotate(Vector3.up, -rotation, Space.World);
            }
        }

        if (Input.GetKey(KeyCode.E))
        {
            if (light != null)
            {
                light.transform.Rotate(Vector3.up, rotation, Space.World);
            }
        }
    }

    void SwapToNextMaterial(int index)
    {
        meshRenderer.material = materials[index % materials.Length];
    }
}