using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Door : MonoBehaviour
{
    public enum DoorState
    {
        Open,
        Closed
    }

    [SerializeField] private Transform hinge;
    [SerializeField] private float openRotation;
    [SerializeField] private float rotateTime = 1.5f;
    private const float closeRotation = 0f;
    private float maxRotation;
    [SerializeField] private AnimationCurve openCurve;
    [SerializeField] private GameObject mainParent;

    private Coroutine doorRotateCoroutine = null;

    public DoorState State { get; private set; }

    private void Awake()
    {
        maxRotation = closeRotation - openRotation;
        State = DoorState.Closed;
    }

    [ContextMenu("Open")]
    public void OpenDoor()
    {
        State = DoorState.Open;
        RotateDoor(openRotation);
    }

    [ContextMenu("Close")]
    public void CloseDoor()
    {
        State = DoorState.Closed;
        RotateDoor(closeRotation);
    }

    private void RotateDoor(float finalAngle)
    {
        float angleDiff = finalAngle - hinge.rotation.y;

        if (doorRotateCoroutine != null)
        {
            StopCoroutine(doorRotateCoroutine);
        }

        doorRotateCoroutine = StartCoroutine(DoorRotateCoroutine(angleDiff));
    }

    private IEnumerator DoorRotateCoroutine(float angleToRotateBy)
    {
        float timeSinceStarted = 0.0f;
        float percentComplete = 0.0f;

        Quaternion startRot = hinge.rotation;
        Quaternion finalRot = Quaternion.AngleAxis(angleToRotateBy, hinge.up);

        while (percentComplete <= 1.0f)
        {
            timeSinceStarted += Time.deltaTime;
            percentComplete = timeSinceStarted / rotateTime;

            hinge.rotation = Quaternion.Slerp(startRot, finalRot, openCurve.Evaluate(percentComplete));

            yield return null;
        }

        hinge.rotation = finalRot;
    }

    public void DeactivateEverythingExceptFrame()
    {
        mainParent.SetActive(false);
    }
}
