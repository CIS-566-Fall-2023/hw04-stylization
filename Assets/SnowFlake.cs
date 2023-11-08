using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SnowFlake : MonoBehaviour
{
    public Material[] materials;
    private MeshRenderer meshRenderer;
    int index;

    void Start () {
            meshRenderer = GetComponent<MeshRenderer>();
            materials = GetComponent<Renderer>().materials;
    }

    void Update () {
            if (Input.GetKeyDown(KeyCode.Space)){
                    index = (index + 1) % materials.Length;
                    SwapToNextMaterial(index);
            }
    }

    void SwapToNextMaterial (int index) {
            meshRenderer.material = materials[index % materials.Length];
    }
}
