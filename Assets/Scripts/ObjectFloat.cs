using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ObjectFloat : MonoBehaviour
{
    [SerializeField]
    private FloodOcean ocean;
    [SerializeField]
    private float height;
    private Vector3 initialHeight;
    private float offset = 0;
    // Start is called before the first frame update
    void Start()
    {
        initialHeight = transform.position; 
    }

    // Update is called once per frame
    void Update()
    {
        float waterFloat = 0.045f;
        transform.position = initialHeight + new Vector3(0, ocean.level * (waterFloat + offset), 0);
        offset = Mathf.Cos(Time.fixedTime * 1.25f + initialHeight.z * 1000f) * height;

    }
}
