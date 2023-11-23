using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Turntable : MonoBehaviour
{

    public float rotationSpeed = 1.0f;
    public float ratationMaxDegree = 60.0f;

    private float rotateCount;
    // Start is called before the first frame update
    void Start()
    {
        rotateCount = 0;
    }

    // Update is called once per frame
    void Update()
    {
        if (rotateCount < ratationMaxDegree)
        {
            this.transform.Rotate(0, rotationSpeed * Time.deltaTime, 0);
            rotateCount += rotationSpeed * Time.deltaTime;
        }
        else if (rotateCount < ratationMaxDegree * 3)
        {
            this.transform.Rotate(0, -rotationSpeed * Time.deltaTime, 0);
            rotateCount += rotationSpeed * Time.deltaTime;
        }
        else if (rotateCount < ratationMaxDegree * 4)
        {
            this.transform.Rotate(0, rotationSpeed * Time.deltaTime, 0);
            rotateCount += rotationSpeed * Time.deltaTime;
        }
        else
        {
            rotateCount = 0;
        }
    }
}
