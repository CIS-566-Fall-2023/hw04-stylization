using Cinemachine;
using System.Collections;
using System.Collections.Generic;
using Unity.VisualScripting;
using UnityEngine;

public class CameraShake : MonoBehaviour
{
    public FloodOcean ocean;
    public CinemachineVirtualCamera virtualCamera;

    private void Start()
    {
        
    }

    void Update()
	{
        virtualCamera.GetCinemachineComponent<CinemachineBasicMultiChannelPerlin>().m_FrequencyGain = Mathf.SmoothStep(0.6f, 1.75f, ocean.level);
        virtualCamera.GetCinemachineComponent<CinemachineBasicMultiChannelPerlin>().m_AmplitudeGain = Mathf.SmoothStep(1.0f, 3.0f, ocean.level);
    }
}
