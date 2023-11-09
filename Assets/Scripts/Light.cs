using UnityEngine;

public class Light : MonoBehaviour
{
    [SerializeField] private Transform finalTransform;

    private void Awake()
    {
        CharacterController.OnChangeToSecondVisuals += Scale;
    }

    private void Scale()
    {
        transform.rotation = finalTransform.rotation;
    }
    private void OnDestroy()
    {
        CharacterController.OnChangeToSecondVisuals -= Scale;
    }
}
