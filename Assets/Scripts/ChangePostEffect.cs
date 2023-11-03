using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Rendering.Universal;

public class ChangePostEffect : MonoBehaviour
{
    public UniversalRendererData data;
    bool activeStatus = true;
    private void Start()
    {
        SwitchPostEffect(true);
    }
    void Update()
    {
        if (Input.GetKeyDown(KeyCode.Space))
        {
            activeStatus = !activeStatus;
            SwitchPostEffect(activeStatus);
        }
    }

    void SwitchPostEffect(bool isActive)
    {
        foreach (ScriptableRendererFeature feature in data.rendererFeatures)
        {
            FullScreenFeature fsFeature = feature as FullScreenFeature;
            if (fsFeature)
            {
                fsFeature.SetActive(isActive);
            }
        }
    }
}
