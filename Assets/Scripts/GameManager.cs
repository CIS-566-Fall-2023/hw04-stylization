using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SocialPlatforms;

public class GameManager : MonoBehaviour
{
    private static GameManager _instance;
    public static GameManager instance
    {
        get
        {
            if (_instance == null)
            {
                _instance = FindObjectOfType(typeof(GameManager)) as GameManager;
                if (_instance == null)
                {
                    GameObject go = new GameObject("GameManager");
                    go.tag = "GameController";
                    _instance = go.AddComponent<GameManager>();
                    DontDestroyOnLoad(go);
                }
            }
            return _instance;
        }
    }


    [SerializeField]
    float maxWindForce = 0.02f;
    //[SerializeField]
    //float windFieldScale = 1f;
    [SerializeField]
    float timeScale = 1f;

    Vector3 windForce = Vector3.zero;

    public Vector3 WindForce
    {
        get { return windForce; }
    }

    [SerializeField]
    float enforceWind = 10f;
    float windMultiplier = 1f;
    [SerializeField]
    float enforceDecay = 10f;

    private void Update()
    {
        if (windMultiplier > 1f)
        {
            windMultiplier = Mathf.Max(1f, windMultiplier - enforceDecay * Time.deltaTime);
        }
        if (Input.GetMouseButtonDown(0))
        {
            windMultiplier = enforceWind;
        }
    }

    void FixedUpdate()
    {
        windForce = ComputeWindForce() * windMultiplier;
    }
    Vector3 ComputeWindForce()
    {
        Vector3 direction = new Vector3(
            Mathf.PerlinNoise(Time.time * timeScale, 0.0f) * 2.0f - 1.0f,
            Mathf.PerlinNoise(0.0f, Time.time * timeScale) * 2.0f - 1.0f,
            Mathf.PerlinNoise(Time.time * timeScale, Time.time * timeScale) * 2.0f - 1.0f
        ).normalized;
        float magnitude = Mathf.PerlinNoise(Time.time * timeScale, Time.time * timeScale) * maxWindForce;
        return direction * magnitude;
    }
}
