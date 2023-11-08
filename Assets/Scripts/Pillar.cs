using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Pillar : MonoBehaviour
{
    [SerializeField] private Transform finalPos;
    [SerializeField] private AnimationCurve moveCurve;
    [SerializeField] private float moveDuration = 0.7f;
    [SerializeField] private float delayBeforeMove = 3.0f;

    private void Awake()
    {
        CharacterController.OnChangeToSecondVisuals += Move;
    }

    private void Move()
    {
        StartCoroutine(MoveCoroutine());
    }

    private IEnumerator MoveCoroutine()
    {
        float percentageComplete = 0.0f;
        float timeSinceStarted = 0.0f;
        float t;

        Vector3 startPos = transform.position;

        yield return new WaitForSeconds(delayBeforeMove);

        while (percentageComplete <= 1.0f)
        {
            timeSinceStarted += Time.deltaTime;
            percentageComplete = timeSinceStarted / moveDuration;
            t = moveCurve.Evaluate(percentageComplete);

            transform.position = Vector3.Lerp(startPos, finalPos.position, t);

            yield return null;
        }

        transform.position = finalPos.position;
    }

    private void OnDestroy()
    {
        CharacterController.OnChangeToSecondVisuals -= Move;
    }
}
