using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SwapMats : MonoBehaviour
{
    // Materials to swap btwn
    public Material mat1;
    public Material mat2;
    bool mat; // curr mat

    // renderers
    private Renderer meshRenderer1;
    private Renderer meshRenderer2;
    private Renderer meshRenderer3;

    // game object
    public GameObject plane1;
    public GameObject plane2;
    public GameObject plane3;

    // Start is called before the first frame update
    void Start()
    {
        // get renderer components
        meshRenderer1 = plane1.GetComponent<Renderer>();
        meshRenderer2 = plane2.GetComponent<Renderer>();
        meshRenderer3 = plane3.GetComponent<Renderer>();
        mat = true;
    }

    // Update is called once per frame
    void Update()
    {
        if (Input.GetKeyDown(KeyCode.Space)) {
            Debug.Log("space key was pressed");
            mat = false;
        } else if (Input.GetKeyUp(KeyCode.Space)) {
            Debug.Log("space key is up");
            mat = true;            
        }
        SetMaterial(mat);
    }
    void SetMaterial(bool mat) {
        if (mat == true) {
            meshRenderer1.material = mat1;
            meshRenderer2.material = mat1;
            meshRenderer3.material = mat1;
        } else {
            meshRenderer1.material = mat2;
            meshRenderer2.material = mat2;
            meshRenderer3.material = mat2;
        }
    }
}
