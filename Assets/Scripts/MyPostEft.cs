using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
[RequireComponent(typeof(Camera))]
public class MyPostEft : MonoBehaviour
{
    public Material postProcessingMaterial;

    private void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        if (postProcessingMaterial != null)
        {
            Graphics.Blit(source, destination, postProcessingMaterial);
        }
        else
        {
            Graphics.Blit(source, destination);
        }
    }

    public void ChangeMaterial(Material newMaterial)
    {
        postProcessingMaterial = newMaterial;
    }
}
