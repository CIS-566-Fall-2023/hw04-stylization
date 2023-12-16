using UnityEngine;

public class SwapMat : MonoBehaviour
{
    public Material[] materials;
    private MeshRenderer meshRenderer;
    int index;

    void Start () {
        meshRenderer = GetComponent<MeshRenderer>();
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


