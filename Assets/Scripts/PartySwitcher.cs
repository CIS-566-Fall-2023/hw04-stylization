using System.Collections.Generic;
using Unity.Mathematics;
using UnityEngine;
using Color = UnityEngine.Color;

public class PartySwitcher : MonoBehaviour
{
    [SerializeField] private float partySpinSpeed = 60f;
    [SerializeField] private float partyHueShiftSpeed = 0.1f;
    
    private bool _isPartying;
    private readonly List<MaterialData> _materials = new();

    private static readonly int HighlightID = Shader.PropertyToID("_Highlight");
    private static readonly int EdgeGlowID = Shader.PropertyToID("_Edge_Glow");

    struct MaterialData
    {
        public MaterialData(Material material, float edgeGlow, Color color)
        {
            Material = material;
            EdgeGlow = edgeGlow;
            Color = color;
        }

        public Material Material { get; }
        public float EdgeGlow { get; }
        public Color Color { get; }
    }

    private void Awake()
    {
        foreach (var meshRenderer in GetComponentsInChildren<MeshRenderer>())
        {
            var material = meshRenderer.material;
            _materials.Add(
                new MaterialData(material, material.GetFloat(EdgeGlowID), material.GetColor(HighlightID))
            );
        }
    }

    // Update is called once per frame
    private void Update()
    {
        if (_isPartying) UpdateParty();

        if (!Input.GetKeyDown(KeyCode.Space)) return;
        
        _isPartying = !_isPartying;
        if (_isPartying) return;
        
        foreach (var materialData in _materials)
        {
            // reset all values
            materialData.Material.SetColor(HighlightID, materialData.Color);
            materialData.Material.SetFloat(EdgeGlowID, materialData.EdgeGlow);
        }
    }

    private void UpdateParty()
    {
        transform.rotation = Quaternion.AngleAxis(Time.deltaTime * partySpinSpeed, Vector3.up) * transform.rotation;
        
        foreach (var materialData in _materials)
        {
            // party mode!!
            Color.RGBToHSV(materialData.Color, out var h, out var s, out var v);
            h = math.frac(h + Time.time * partyHueShiftSpeed);
            s = 0.8f;
            materialData.Material.SetColor(HighlightID, Color.HSVToRGB(h, s, v));
            materialData.Material.SetFloat(EdgeGlowID, materialData.EdgeGlow);
        }
    }
}