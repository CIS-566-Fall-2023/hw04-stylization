using System;
using System.Collections;
using UnityEngine;
using UnityEngine.SceneManagement;

[RequireComponent(typeof(Rigidbody))]
public class CharacterController : MonoBehaviour
{
    [Header("Outside References")]
    [SerializeField] private Door door;
    private Transform doorTransform;
    private Rigidbody rb;
    [SerializeField] private Camera cam;

    [SerializeField] private Water water;

    [Header("Main Visuals")]
    [SerializeField] private float moveSpeed = 0.005f;
    [SerializeField] private float maxSpeedInitial = 0.05f;
    [SerializeField] private float maxSpeedFinal = 0.015f;
    [SerializeField] private AnimationCurve maxSpeedCurve;
    [SerializeField] private float dist2ToOpenDoor = 5.0f;
    [SerializeField] private float dist2ToChangeWaves = 40f;
    [SerializeField] private float dist2DeactivateDoor = 2.0f;
    [SerializeField] private float dist2ToFullVignette = 2.0f;
    [SerializeField] private float dist2ToFullDistortion = 2.0f;

    [Header("Vignette Curves")]
    [SerializeField] private Material vignetteMaterial;
    [SerializeField] private AnimationCurve vignetteStrengthCurve;
    [SerializeField] private AnimationCurve vignetteAlphaCurve;
    [SerializeField] private Gradient vignetteGradient;
    [SerializeField] private AnimationCurve vignetteIntensityCurve;

    [Header("Portal Visuals")]
    [SerializeField] private MeshRenderer portalRenderer;
    [SerializeField] private AnimationCurve portalDistortionSpeedCurve;
    [SerializeField] private AnimationCurve portalFresnelCurve;
    [SerializeField] private float portalFresnelDuration;

    private float maxSpeed;
    private float maxDist2;

    private float curSpeed;
    private bool hasDoorOpened = false;
    private bool hasChangedWaves = false;
    private bool hasDeactivatedDoor = false;

    [Header("Second Visuals")]
    [SerializeField] private Transform characterFinalLocation;
    [SerializeField] private AnimationCurve characterMovementCurve;
    [SerializeField] private float characterMoveToSecondLocationDuration;
    [SerializeField] private float secondCamFOV;
    [SerializeField] private AnimationCurve camFOVChangeCurve;
    [SerializeField] private float fovChangeDuration;

    public static event Action OnChangeToSecondVisualsStarted;
    public static event Action OnChangeToSecondVisuals;
    private bool hasStartedSecondVisuals;

    public static float TimeSinceLastInput = 0.0f;

    // Start is called before the first frame update
    void Awake()
    {
        rb = GetComponent<Rigidbody>();
        curSpeed = 0.0f;
        maxSpeed = maxSpeedInitial;
        doorTransform = door.transform;
        maxDist2 = Vector3.SqrMagnitude(doorTransform.position - transform.position);
        vignetteMaterial.SetFloat("_VignetteStrength", 0.0f);

        hasStartedSecondVisuals = false;
    }

    private void Move(float distance2)
    {
        float percent = 1.0f - (distance2 / maxDist2);
        float t = maxSpeedCurve.Evaluate(percent);
        maxSpeed = Mathf.Lerp(maxSpeedInitial, maxSpeedFinal, t);

        if (Input.GetKey(KeyCode.W) || Input.GetKey(KeyCode.UpArrow))
        {
            TimeSinceLastInput = 0.0f;
            curSpeed += moveSpeed * Time.deltaTime;
            curSpeed = Mathf.Clamp(curSpeed, 0.0f, maxSpeed);
        }
        else
        {
            curSpeed = 0.0f;
        }

        rb.MovePosition(transform.position + transform.forward * curSpeed);
    }

    // Update is called once per frame
    void FixedUpdate()
    {
        TimeSinceLastInput += Time.deltaTime;

        if (hasStartedSecondVisuals)
        {
            if (Input.GetKey(KeyCode.Space))
            {
                // very bad code but its fast and will work.
                TimeSinceLastInput = 0.0f;
                SceneLoader.Instance.Restart();
            }

            return;     // no more user control, the aliens have taken over, sorry :(
        }

        float distance2 = Vector3.SqrMagnitude(doorTransform.position - transform.position);
        Move(distance2);

        if (distance2 < dist2ToOpenDoor)
        {
            if (!hasDoorOpened)
            {
                hasDoorOpened = true;
                door.OpenDoor();
            }

            float distorPercent = 1.0f - (distance2 - dist2ToFullDistortion) / (dist2ToOpenDoor - dist2ToFullDistortion);
            float t = portalDistortionSpeedCurve.Evaluate(distorPercent);
            portalRenderer.material.SetFloat("_DistortionIntensity", t);
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

        if (distance2 < dist2ToFullVignette)
        {
            float t = vignetteStrengthCurve.Evaluate(distance2);
            vignetteMaterial.SetFloat("_VignetteStrength", t);

            vignetteMaterial.SetFloat("_Intensity", vignetteIntensityCurve.Evaluate(distance2));

            float colorT = vignetteAlphaCurve.Evaluate(distance2);
            vignetteMaterial.SetColor("_VignetteColor", vignetteGradient.Evaluate(colorT));
        }

        if (distance2 <= 1.0f)
        {
            SwitchVisuals();
        }
    }

    private void SwitchVisuals()
    {
        hasStartedSecondVisuals = true;
        rb.isKinematic = true;      // disable any non-programmatic movement including external forces like gravity
        OnChangeToSecondVisualsStarted?.Invoke();

        StartCoroutine(SwitchVisualsCoroutine());
    }

    private IEnumerator SwitchVisualsCoroutine()
    {
        yield return StartCoroutine(PortalCoroutine());

        OnChangeToSecondVisuals?.Invoke();
        StartCoroutine(MoveCharacterCoroutine());
        StartCoroutine(LerpFOV());
    }

    private IEnumerator PortalCoroutine()
    {
        float timeSinceStarted = 0.0f;
        float percentageComplete = 0.0f;

        float t;

        while (percentageComplete <= 1.0f)
        {
            timeSinceStarted += Time.deltaTime;
            percentageComplete = timeSinceStarted / portalFresnelDuration;

            t = portalFresnelCurve.Evaluate(percentageComplete);
            portalRenderer.material.SetFloat("_FresnelPower", t);

            yield return null;
        }

        rb.MovePosition(characterFinalLocation.position);
    }

    private IEnumerator MoveCharacterCoroutine()
    {
        float timeSinceStarted = 0.0f;
        float percentageComplete = 0.0f;

        Vector3 startPos = rb.position;
        float t;

        while (percentageComplete <= 1.0f)
        {
            timeSinceStarted += Time.deltaTime;
            percentageComplete = timeSinceStarted / characterMoveToSecondLocationDuration;

            t = characterMovementCurve.Evaluate(percentageComplete);
            rb.MovePosition(Vector3.LerpUnclamped(startPos, characterFinalLocation.position, t));

            yield return null;
        }

        rb.MovePosition(characterFinalLocation.position);
    }

    private IEnumerator LerpFOV()
    {
        float timeSinceStarted = 0.0f;
        float percentageComplete = 0.0f;

        float startFOV = cam.fieldOfView;
        float t;

        while (percentageComplete <= 1.0f)
        {
            timeSinceStarted += Time.deltaTime;
            percentageComplete = timeSinceStarted / characterMoveToSecondLocationDuration;

            t = camFOVChangeCurve.Evaluate(percentageComplete);
            cam.fieldOfView = Mathf.LerpUnclamped(startFOV, secondCamFOV, t);

            yield return null;
        }

        cam.fieldOfView = secondCamFOV;
    }

    private void OnDestroy()
    {
        vignetteMaterial.SetFloat("_VignetteStrength", 0.0f);
    }
}