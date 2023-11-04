using System.Collections;
using System.Collections.Generic;
using System.Linq;
using Unity.Mathematics;
using UnityEngine;

public class MaterialSwap : MonoBehaviour
{
    public FullScreenFeature fullScreenFeature;
    public Material[] materials;
    public Material bodyMat;
    public Material skybox;
    public float rotationSpeed;
    public Light directionalLight;
    public Light pointLight;
    int index;
    private float rotationAngle;
    private float exposure;
    void Start()
    {
        transform.rotation = directionalLight.transform.rotation;
        rotationAngle = 132f;
        exposure = 2f;
    }

    void Update()
    {
        if (Input.GetKeyDown(KeyCode.Q))
        {
            int currentAnimateValue = bodyMat.GetInt("_Animate");
            bodyMat.SetInt("_Animate", 1 - currentAnimateValue);
        }
        if (Input.GetKey(KeyCode.A))
        {
            if (directionalLight != null)
            {
                directionalLight.transform.Rotate(Vector3.up, -rotationSpeed, Space.World);
            }
            rotationAngle = (rotationAngle - rotationSpeed) % 360f;
            skybox.SetFloat("_Rotation", rotationAngle);
        }
        if (Input.GetKey(KeyCode.D))
        {
            if (directionalLight != null)
            {
                directionalLight.transform.Rotate(Vector3.up, rotationSpeed, Space.World);
            }
            rotationAngle = (rotationAngle + rotationSpeed) % 360;
            skybox.SetFloat("_Rotation", rotationAngle);
        }
        if (Input.GetKey(KeyCode.R))
        {
            if (directionalLight != null)
            {
                directionalLight.transform.rotation = transform.rotation;
                skybox.SetFloat("_Rotation", 132f);
            }
        }
        float angle = directionalLight.transform.rotation.eulerAngles.y;
        float skyBoxIntensity = math.sin(math.radians(angle * 0.5f)) * 1.8f + 0.2f;
        float directionalLightIntensity = math.sin(math.radians(angle * 0.5f));
        float pointLightIntensity = math.sin(math.radians(angle * 0.5f)) * 0.5f;
        skybox.SetFloat("_Exposure", skyBoxIntensity);
        directionalLight.intensity = directionalLightIntensity;
        pointLight.intensity = pointLightIntensity;
        for (int i = 0; i < materials.Length; i++)
        {
            float outlineStrength = math.sin(math.radians(angle * 0.5f)) * 6f;
            materials[i].SetFloat("_DepthStrength", outlineStrength);
        }
        if (Input.GetKeyDown(KeyCode.Space))
        {
            index = (index + 1) % materials.Length;
            fullScreenFeature.SetMaterial(materials[index]);
        }
    }

}
