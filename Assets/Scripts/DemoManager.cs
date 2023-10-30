using System.Collections;
using System.Collections.Generic;
using Unity.VisualScripting;
using UnityEngine;
using UnityEngine.SceneManagement;

public class DemoManager : MonoBehaviour
{
    [SerializeField]
    Material[] _stylizedMaterials;

    class Info
    {
        public int matIdx = 0;
        public (Material, Material) mats;
    }

    Dictionary<Renderer, List<Info>> _dict = new Dictionary<Renderer, List<Info>> ();
    int _curIdx = 0;

    void SwapMaterial()
    {
        if(_dict.Count == 0)
        {
            var scene = SceneManager.GetActiveScene();
            foreach (var obj in scene.GetRootGameObjects())
            {
                var renderer = obj.GetComponentsInChildren<MeshRenderer>();
                foreach (var rend in renderer)
                {
                    for (int j = 0; j < rend.materials.Length; ++j)
                    {
                        for (int i = 0; i < _stylizedMaterials.Length; ++i)
                        {
                            if (rend.materials[j].name.StartsWith(_stylizedMaterials[i].name))
                            {
                                if (!_dict.ContainsKey(rend))
                                {
                                    _dict.Add(rend, new List<Info> { new Info
                                    {
                                        matIdx = j,
                                        mats = ( rend.materials[j], _stylizedMaterials[i] )
                                    } });
                                }
                                else
                                {
                                    _dict[rend].Add(new Info
                                    {
                                        matIdx = j,
                                        mats = (rend.materials[j], _stylizedMaterials[i])
                                    });
                                }
                            }
                        }
                    }
                }
            }
        }

        ++_curIdx;
        foreach(var kvp in _dict)
        {
            var rend = kvp.Key;
            var mats = rend.materials;
            foreach(var info in kvp.Value)
            {
                mats[info.matIdx] = _curIdx % 2 == 0 ? info.mats.Item1 : info.mats.Item2;
            }
            rend.materials = mats;
        }
    }

    // Start is called before the first frame update
    void Start()
    {
/*        foreach(var mat in _stylizedMaterials)
        {
            Debug.Log(mat.name);
        }*/
    }

    // Update is called once per frame
    void Update()
    {
        if(Input.GetKeyDown(KeyCode.X))
        {
            SwapMaterial();
        }
    }
}
