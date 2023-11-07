using UnityEngine;

[RequireComponent(typeof(Terrain))]
public class TerrainVisualChanger : MonoBehaviour
{
    private Terrain terrain;
    [SerializeField] private Material matToChangeTo;

    private void Awake()
    {
        terrain = GetComponent<Terrain>();
        CharacterController.OnChangeToSecondVisuals += ChangeVisuals;
    }

    private void ChangeVisuals()
    {
        terrain.materialTemplate = matToChangeTo;
    }

    private void OnDestroy()
    {
        CharacterController.OnChangeToSecondVisuals -= ChangeVisuals;
    }
}
