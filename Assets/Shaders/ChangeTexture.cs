using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ChangeTexture : MonoBehaviour {
    // Start is called before the first frame update
    public Texture midToneTexture;
    public Texture shadowToneTexture;
    public MeshRenderer meshRenderer;
    public bool useTexture = true;

    void Start() {
        meshRenderer = GetComponent<MeshRenderer>();
        midToneTexture = meshRenderer.material.GetTexture("_MidTone_Texture");
        shadowToneTexture = meshRenderer.material.GetTexture("_ShadowTone_Texture");
    }

    // Update is called once per frame
    void Update() {
        if (Input.GetKeyDown(KeyCode.T)) {
            if (useTexture) {
                meshRenderer.material.SetTexture("_MidTone_Texture", null);
                meshRenderer.material.SetTexture("_ShadowTone_Texture", null);
            }
            else {
                meshRenderer.material.SetTexture("_MidTone_Texture", midToneTexture);
                meshRenderer.material.SetTexture("_ShadowTone_Texture", shadowToneTexture);
            }
            useTexture = !useTexture;
        }
    }
}
