using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Turntable : MonoBehaviour
{

    public float rotationSpeed = 1.0f;
    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        if (Input.GetKeyDown(KeyCode.UpArrow))
        {
            //rotationSpeed += 1.0f;
            this.transform.Rotate(0, 90.0f, 0);
        }
        else if (Input.GetKeyDown(KeyCode.DownArrow))
        {
            // rotationSpeed -= 1.0f;
            //if (rotationSpeed < 0.0f)   rotationSpeed = 0.0f;
            this.transform.Rotate(0, -90.0f, 0);
        }
        //this.transform.Rotate(0, rotationSpeed * Time.deltaTime, 0);
    }
}
