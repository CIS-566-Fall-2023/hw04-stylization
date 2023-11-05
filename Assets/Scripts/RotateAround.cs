using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class RotateAround : MonoBehaviour
{
    public Transform cameraJig;
    public float rotateSpeed;

    void LateUpdate()
    {
        if(Input.GetKey (KeyCode.Q))
        {
            transform.RotateAround(cameraJig.position, Vector3.up, rotateSpeed * Time.deltaTime);
        }else{
            transform.RotateAround(cameraJig.position, -Vector3.up, rotateSpeed * Time.deltaTime);
        }
    }
}
