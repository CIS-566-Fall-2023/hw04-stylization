using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[RequireComponent(typeof(Rigidbody))]
public class CharacterControllerDumb : MonoBehaviour
{
    [SerializeField] private Door door;
    private Transform doorTransform;
    private Rigidbody rb;

    [SerializeField] private Water water;

    [SerializeField] private float moveSpeed = 0.005f;
    [SerializeField] private float maxSpeedInitial = 0.05f;
    [SerializeField] private float maxSpeedFinal = 0.015f;
    [SerializeField] private AnimationCurve maxSpeedCurve;
    [SerializeField] private float dist2ToOpenDoor = 5.0f;
    [SerializeField] private float dist2ToChangeWaves = 40f;
    [SerializeField] private float dist2DeactivateDoor = 2.0f;

    private float maxSpeed;
    private float maxDist2;

    private float curSpeed;
    private bool hasDoorOpened = false;
    private bool hasChangedWaves = false;
    private bool hasDeactivatedDoor = false;

    // Start is called before the first frame update
    void Awake()
    {
        rb = GetComponent<Rigidbody>();
        curSpeed = 0.0f;
        maxSpeed = maxSpeedInitial;
        doorTransform = door.transform;
        maxDist2 = Vector3.SqrMagnitude(doorTransform.position - transform.position);
    }

    // Update is called once per frame
    void FixedUpdate()
    {
        float distance2 = Vector3.SqrMagnitude(doorTransform.position - transform.position);
        float percent = 1.0f - (distance2 / maxDist2);
        float t = maxSpeedCurve.Evaluate(percent);
        maxSpeed = Mathf.Lerp(maxSpeedInitial, maxSpeedFinal, t);

        if (Input.GetKey(KeyCode.W) || Input.GetKey(KeyCode.UpArrow))
        {
            curSpeed += moveSpeed * Time.deltaTime;
            curSpeed = Mathf.Clamp(curSpeed, 0.0f, maxSpeed);
        }
        else
        {
            curSpeed = 0.0f;
        }

        rb.MovePosition(transform.position + transform.forward * curSpeed);

        if (distance2 < dist2ToOpenDoor && !hasDoorOpened)
        {
            hasDoorOpened = true;
            door.OpenDoor();
        }

        //if (distance2 < dist2ToChangeWaves && !hasChangedWaves)
        //{
        //    hasChangedWaves = true;
        //    water.FastWave();
        //}

        if (distance2 < dist2DeactivateDoor && !hasDeactivatedDoor)
        {
            hasDeactivatedDoor = true;
            door.DeactivateEverythingExceptFrame();
        }
    }
}
