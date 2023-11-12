using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Turntable : MonoBehaviour
{

    public float rotationSpeed = 1.0f;
    public float translationSpeed = 1.0f;
    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        this.transform.Rotate(0, Mathf.Sin(rotationSpeed * Time.deltaTime), 0);
        this.transform.Translate(Mathf.Sin(translationSpeed * Time.deltaTime), 0, 0);
    }
}
