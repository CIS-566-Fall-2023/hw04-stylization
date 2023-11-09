using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Rendering.Universal;
using System.Collections;

public class Interactivity_Manager : MonoBehaviour
{
    // public float test_float;
    [SerializeField]
    UniversalRendererData Feature;


    [SerializeField]
    private GameObject DirLight;
    private bool toggle = false;

    [SerializeField]
    ParticleSystem system
    {
        get
        {
            if (_CachedSystem == null)
                _CachedSystem = GetComponent<ParticleSystem>();
            return _CachedSystem;
        }
    }
    private ParticleSystem _CachedSystem;

    //float emissionRate = system.rateOverTime;

    float timeStop;

    // RenderFeature DangoSteam
    // Start is called before the first frame update
    void Start()
    {
        system.Pause(true);
    }

    // Update is called once per frame
    void Update()
    {

        Vector3 mousePos = Input.mousePosition;
        // {
        //     Debug.Log(mousePos.x);
        //     Debug.Log(mousePos.y);
        // }
        
        if (mousePos.x > 400 && mousePos.x < 1500 && mousePos.y > 200 && mousePos.y < 800) {
            if (toggle == false) {
                // DirLight.SetActive(toggle);
                toggle = true;
                Feature.rendererFeatures[2].SetActive(toggle);
                //system.rateOverTime = emissionRate;
                system.Play(true);
            }
            // system.rateOverTime = t * 0 + (1 - t) * emissionRate;
        } else {
            if (toggle == true) {
                // DirLight.SetActive(toggle);
                toggle = false;
                Feature.rendererFeatures[2].SetActive(toggle);
                //system.rateOverTime = 0;
                system.Pause(true);
                timeStop = Time.time;
            }
            float delta = 4;
            float curr = Time.time;
            float t = (curr - timeStop) / delta;

            // system.rateOverTime = t * emissionRate + (1 - t) * 0;
        }

        
    }
    
}
