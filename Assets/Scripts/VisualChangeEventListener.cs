using System.Linq;
using UnityEngine;

public class VisualChangeEventListener : MonoBehaviour
{
    [System.Serializable]
    private struct VisualsData
    {
        [SerializeField] private MeshRenderer meshRenderer;
        public MeshRenderer MeshRenderer => meshRenderer;
        [SerializeField] private Material matToChangeTo;
        public Material MatToChangeTo => matToChangeTo;
    }

    [SerializeField] private VisualsData[] visualsToChange;

    private void Awake()
    {
        CharacterController.OnChangeToSecondVisuals += ChangeVisuals;
    }

    private void ChangeVisuals()
    {
        foreach (VisualsData visual in visualsToChange)
        {
            Material[] mats = visual.MeshRenderer.sharedMaterials;
            for (int i = 0; i < mats.Length; i++)
            {
                mats[i] = visual.MatToChangeTo;
            }
            visual.MeshRenderer.sharedMaterials = mats;

            //for (int i = 0; i < visual.MeshRenderer.materials.Length; i++)
            //{
            //    visual.MeshRenderer.materials[i] = visual.MatToChangeTo;
            //}
        }
    }

    private void OnDestroy()
    {
        CharacterController.OnChangeToSecondVisuals -= ChangeVisuals;
    }
}
