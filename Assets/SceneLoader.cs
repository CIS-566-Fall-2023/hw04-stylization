using System;
using System.Collections;
using UnityEngine;
using UnityEngine.SceneManagement;

public class SceneLoader : MonoBehaviour
{
    public static SceneLoader Instance { get; private set; }

    [SerializeField] private Material vignetteMaterial;
    [SerializeField] private AnimationCurve vignetteOpenIntensityCurve;
    [SerializeField] private AnimationCurve vignetteCloseIntensityCurve;
    [SerializeField] private float vignetteAnimationOpenDuration, vignetteAnimationCloseDuration;

    private void Awake()
    {
        if (Instance == null)
        {
            Instance = this;
        }
        else if (Instance != null)
        {
            Destroy(gameObject);
        }
    }

    private void Start()
    {
        // the scene just loaded
        // disable the vignetting
        vignetteMaterial.SetFloat("_Intensity", 4.0f);
        vignetteMaterial.SetColor("_VignetteColor", Color.black);
        vignetteMaterial.SetFloat("_VignetteStrength", 0.72f);

        StartCoroutine(VignetteCoroutine(true));
    }

    public void Restart()
    {
        StartCoroutine(VignetteCoroutine(false, () => SceneManager.LoadScene(0)));
    }

    private IEnumerator VignetteCoroutine(bool open, Action onComplete = null)
    {
        vignetteMaterial.SetFloat("_Intensity", 3.0f);

        float timeSinceStarted = 0.0f;
        float percentComplete = 0.0f;
        float t;
        float duration = open ? vignetteAnimationOpenDuration : vignetteAnimationCloseDuration;
        AnimationCurve curve = open ? vignetteOpenIntensityCurve : vignetteCloseIntensityCurve;

        float startIntensity = vignetteMaterial.GetFloat("_VignetteStrength");
        float endIntensity = open ? 0.0f : 0.72f;

        while (percentComplete <= 1.0f)
        {
            timeSinceStarted += Time.deltaTime;
            percentComplete = timeSinceStarted / duration;
            t = curve.Evaluate(percentComplete);

            vignetteMaterial.SetFloat("_VignetteStrength", Mathf.Lerp(startIntensity, endIntensity, t));

            yield return null;
        }

        vignetteMaterial.SetFloat("_VignetteStrength", endIntensity);

        onComplete?.Invoke();
    }
}
