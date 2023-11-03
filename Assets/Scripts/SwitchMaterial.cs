using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SwitchMaterial : MonoBehaviour
{
    MeshRenderer rend;

    public List<Material> materials;

    int matIdx = 0;

    private void Start()
    {
        rend = GetComponent<MeshRenderer>();
    }

    void Update()
    {
        if (Input.GetKeyDown(KeyCode.Space))
        {
            SwitchToNextMaterial();
        }
    }

    void SwitchToNextMaterial()
    {
        matIdx = (matIdx + 1) % materials.Count;
        rend.material = materials[matIdx];
    }
}
