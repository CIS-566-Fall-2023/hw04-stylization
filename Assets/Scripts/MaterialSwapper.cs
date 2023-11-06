using System.Diagnostics;
using UnityEngine;

public class MaterialSwapper : MonoBehaviour
{
    public Material[] materials;
    private MeshRenderer meshRenderer;
    private int index;

    void Start()
    {
        meshRenderer = GetComponent<MeshRenderer>();

    }

    void Update()
    {
        if (Input.GetKeyDown(KeyCode.Space))
        {
            index = (index + 1) % materials.Length;
            SwapToNextMaterials(index);
        }
    }

    void SwapToNextMaterials(int index)
    {
        if (materials.Length >= meshRenderer.materials.Length)
        {
            Material[] newMaterials = new Material[meshRenderer.materials.Length];

            for (int i = 0; i < newMaterials.Length; i++)
            {
                newMaterials[i] = materials[index];
            }

            meshRenderer.materials = newMaterials;
        }
    }
}
