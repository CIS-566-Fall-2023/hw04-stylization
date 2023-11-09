using System.Collections;
using UnityEngine;

[RequireComponent(typeof(MeshRenderer))]
public class Water : MonoBehaviour
{
    [System.Serializable]
    struct WaveProps
    {
        public float steepness;
        public float speed;
        public float angle;
    }

    [System.Serializable]
    struct WaterProps
    {
        [SerializeField] private WaveProps[] waves;
        public WaveProps[] Waves => waves;
    }

    private MeshRenderer meshRenderer;
    private Material waterMaterial;
    [SerializeField] private WaterProps normalWaterProps;
    [SerializeField] private WaterProps fastWaterProps;
    [SerializeField] private float rotateTime = 2.0f;
    [SerializeField] private float delayBeforeChange = 1.0f;
    [SerializeField] private AnimationCurve waveChangeCurve;
    private WaterProps currWaterProps;

    private Coroutine waveChangeCoroutine = null;

    private void Awake()
    {
        meshRenderer = GetComponent<MeshRenderer>();
        waterMaterial = meshRenderer.sharedMaterial;
        currWaterProps = normalWaterProps;
        NormalWave();
    }

    [ContextMenu("ChangeWaveNormal")]
    public void NormalWave()
    {
        currWaterProps = normalWaterProps;
        ChangeWave();
    }

    [ContextMenu("ChangeWaveFast")]
    public void FastWave()
    {
        currWaterProps = fastWaterProps;
        ChangeWave();
    }

    private void ChangeWave()
    {
        if (waveChangeCoroutine != null)
        {
            StopCoroutine(waveChangeCoroutine);
        }

        waveChangeCoroutine = StartCoroutine(DoorRotateCoroutine());
    }

    private IEnumerator DoorRotateCoroutine()
    {
        yield return new WaitForSeconds(delayBeforeChange);

        float timeSinceStarted = 0.0f;
        float percentComplete = 0.0f;

        float currSpeed1 = waterMaterial.GetFloat("_Speed_1");
        float currSteepness1 = waterMaterial.GetFloat("_Steepness_1");
        float currAngle1 = waterMaterial.GetFloat("_DirectionAngle_1");
        float currSpeed2 = waterMaterial.GetFloat("_Speed_2");
        float currSteepness2 = waterMaterial.GetFloat("_Steepness_2");
        float currAngle2 = waterMaterial.GetFloat("_DirectionAngle_2");
        float currSpeed3 = waterMaterial.GetFloat("_Speed_3");
        float currSteepness3 = waterMaterial.GetFloat("_Steepness_3");
        float currAngle3 = waterMaterial.GetFloat("_DirectionAngle_3");
        float t = 0.0f;

        while (percentComplete <= 1.0f)
        {
            timeSinceStarted += Time.deltaTime;
            percentComplete = timeSinceStarted / rotateTime;
            t = waveChangeCurve.Evaluate(percentComplete);

            waterMaterial.SetFloat("_Speed_1", Mathf.Lerp(currSpeed1, currWaterProps.Waves[0].speed, t));
            waterMaterial.SetFloat("_Steepness_1", Mathf.Lerp(currSteepness1, currWaterProps.Waves[0].steepness, t));
            waterMaterial.SetFloat("_DirectionAngle_1", Mathf.Lerp(currAngle1, currWaterProps.Waves[0].angle, t));
            waterMaterial.SetFloat("_Speed_2", Mathf.Lerp(currSpeed2, currWaterProps.Waves[1].speed, t));
            waterMaterial.SetFloat("_Steepness_2", Mathf.Lerp(currSteepness2, currWaterProps.Waves[1].steepness, t));
            waterMaterial.SetFloat("_DirectionAngle_2", Mathf.Lerp(currAngle2, currWaterProps.Waves[1].angle, t));
            waterMaterial.SetFloat("_Speed_3", Mathf.Lerp(currSpeed3, currWaterProps.Waves[2].speed, t));
            waterMaterial.SetFloat("_Steepness_3", Mathf.Lerp(currSteepness3, currWaterProps.Waves[2].steepness, t));
            waterMaterial.SetFloat("_DirectionAngle_3", Mathf.Lerp(currAngle3, currWaterProps.Waves[2].angle, t));

            yield return null;
        }
    }
}
