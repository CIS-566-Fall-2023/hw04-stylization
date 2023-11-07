using System.Collections;
using System.Collections.Generic;
using System.Drawing;
using UnityEngine;
using Color = UnityEngine.Color;

public class EditFullScreen : MonoBehaviour
{
    public Material material;
    public float[] thicknesses = { 0.0005f, 0.0005f, 0.005f };
    public Color[] colors = { new Color(0.5764706f, 0.1372549f, 0.1215686f, 1.0f),
                              new Color(0.5764706f, 0.1372549f, 0.1215686f, 1.0f),
                              new Color(0.5764706f, 0.1372549f, 0.1215686f, 1.0f) };
    public float[] normalThresholds = { 0.013f, 1.0f, 0.01f };
    public float[] lightningOpacities = { 1f, 0.5f, 0f };
    public Color[] lightningInnerColors = { Color.black, new Color(0.7232704f, 0.8365187f, 1f, 1.0f), Color.black };
    public Color[] lightningOuterColors = { new Color(0.5764706f, 0.1372549f, 0.1215686f, 1.0f),
                                            Color.white,
                                            new Color(0.5764706f, 0.1372549f, 0.1215686f, 1.0f) };
    int index;

    // Start is called before the first frame update
    void Start()
    {
    }

    // Update is called once per frame
    void Update()
    {
        if (Input.GetKeyDown(KeyCode.Space))
        {
            index = (index + 1) % lightningOpacities.Length;
            SwapToNextMaterial(index);
        }
    }

    void SwapToNextMaterial(int index)
    {
        material.SetFloat("_Thickness", thicknesses[index]);
        material.SetColor("_Color", colors[index]);
        material.SetFloat("_Normal_Threshold", normalThresholds[index]);
        material.SetFloat("_Lightning_Opacity", lightningOpacities[index]);
        material.SetColor("_Lightning_Inner_Color", lightningInnerColors[index]);
        material.SetColor("_Lightning_Outer_Color", lightningOuterColors[index]);
    }
}
