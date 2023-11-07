using System.Collections;
using System.Collections.Generic;
using System.Linq;
using UnityEngine;

public class MatSwap : MonoBehaviour
{
    public Material[] materials;
    private MeshRenderer meshRenderer;
    int index;
    
    // Start is called before the first frame update
    void Start()
    {
        meshRenderer = GetComponent<MeshRenderer>();
    }
    
    // Update is called once per frame
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
        if (materials[index % materials.Length] == null)
        {
            meshRenderer.enabled = false;
        }
        else
        {
            meshRenderer.enabled = true;
        }
    }
}
