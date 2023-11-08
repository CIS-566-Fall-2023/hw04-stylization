using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Sun : MonoBehaviour
{
    [SerializeField] private Vector3 finalScale;
    [SerializeField] private AnimationCurve scaleCurve;
    [SerializeField] private float scaleDuration = 0.7f;
    [SerializeField] private float delayBeforeScale = 3.0f;

    private void Awake()
    {
        CharacterController.OnChangeToSecondVisuals += Scale;
    }

    private void Scale()
    {
        StartCoroutine(ScaleCoroutine());
    }

    private IEnumerator ScaleCoroutine()
    {
        float percentageComplete = 0.0f;
        float timeSinceStarted = 0.0f;
        float t;

        Vector3 startPos = transform.localScale;

        yield return new WaitForSeconds(delayBeforeScale);

        while (percentageComplete <= 1.0f)
        {
            timeSinceStarted += Time.deltaTime;
            percentageComplete = timeSinceStarted / scaleDuration;
            t = scaleCurve.Evaluate(percentageComplete);

            transform.localScale = Vector3.Lerp(startPos, finalScale, t);

            yield return null;
        }

        transform.localScale = finalScale;
    }

    private void OnDestroy()
    {
        CharacterController.OnChangeToSecondVisuals -= Scale;
    }
}
