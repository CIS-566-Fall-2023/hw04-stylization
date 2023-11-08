using UnityEngine;

public class SkyboxVisualChanger : MonoBehaviour
{
    [SerializeField] private Material matToChangeTo;

    private void Awake()
    {
        CharacterController.OnChangeToSecondVisuals += ChangeVisuals;
    }

    private void ChangeVisuals()
    {
        RenderSettings.skybox = matToChangeTo;
    }

    private void OnDestroy()
    {
        CharacterController.OnChangeToSecondVisuals -= ChangeVisuals;
    }
}
