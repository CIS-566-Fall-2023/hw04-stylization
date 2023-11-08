using System.Collections;
using System.Collections.Generic;
using System.Runtime.CompilerServices;
using UnityEngine;

[RequireComponent(typeof(CanvasGroup))]
public class UIHintDisplay : MonoBehaviour
{
    private CanvasGroup canvasGroup;
    [SerializeField] private float timeToDisplayHint = 2.0f;
    [SerializeField] private bool isAfterVisualChange = false;
    [SerializeField] private float firstHintDisplayTime = 5.0f;
    [SerializeField] private float fadeDuration = 0.3f;

    private bool shouldDisplay = false;
    private float displayHintTimer;

    private bool isOn = false;
    private Coroutine fadeCoroutine;

    private void Awake()
    {
        canvasGroup = GetComponent<CanvasGroup>();
        CharacterController.OnChangeToSecondVisualsStarted += OnVisualsChangeStarted;
        shouldDisplay = !isAfterVisualChange;

        displayHintTimer = firstHintDisplayTime;
    }

    private void OnVisualsChangeStarted()
    {
        shouldDisplay = isAfterVisualChange;

        if (!shouldDisplay && isOn)
        {
            isOn = false;
            Fade(false);
        }
    }

    // Update is called once per frame
    void Update()
    {
        if (!shouldDisplay)
        {
            return;
        }

        if (CharacterController.TimeSinceLastInput > displayHintTimer && !isOn)
        {
            displayHintTimer = timeToDisplayHint;
            isOn = true;
            Fade(true);
        }
        else if (CharacterController.TimeSinceLastInput <= 0.1f && isOn)
        {
            isOn = false;
            Fade(false);
        }
    }

    private void Fade(bool fadeIn)
    {
        if (fadeCoroutine != null)
        {
            StopCoroutine(fadeCoroutine);
        }

        fadeCoroutine = StartCoroutine(FadeCanvasGroupCoroutine(fadeIn));
    }

    private IEnumerator FadeCanvasGroupCoroutine(bool fadeIn)
    {
        float timeSinceStarted = 0.0f;
        float percentageComplete = 0.0f;

        float startAlpha = canvasGroup.alpha;
        float endAlpha = fadeIn ? 1.0f : 0.0f;

        while (percentageComplete <= 1.0f)
        {
            timeSinceStarted += Time.deltaTime;
            percentageComplete = timeSinceStarted / fadeDuration;

            canvasGroup.alpha = Mathf.Lerp(startAlpha, endAlpha, percentageComplete);

            yield return null;
        }

        fadeCoroutine = null;
    }


    private void OnDestroy()
    {
        CharacterController.OnChangeToSecondVisualsStarted -= OnVisualsChangeStarted;
    }
}
