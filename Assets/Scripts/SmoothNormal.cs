using System.Collections;
using System.Collections.Generic;
using UnityEngine;
public class SmoothNormal : MonoBehaviour
{
    Mesh MeshNormalAverage(Mesh mesh)
    {
        Dictionary<Vector3, List<int>> map = new Dictionary<Vector3, List<int>>();
        for (int v = 0; v < mesh.vertexCount; ++v)
        {
            if (!map.ContainsKey(mesh.vertices[v]))
            {
                map.Add(mesh.vertices[v], new List<int>());
            }
            map[mesh.vertices[v]].Add(v);
        }
        Vector3[] normals = mesh.normals;
        Vector3 normal;
        foreach (var p in map)
        {
            normal = Vector3.zero;
            foreach (var n in p.Value)
            {
                normal += mesh.normals[n];
            }
            normal /= p.Value.Count;
            foreach (var n in p.Value)
            {
                normals[n] = normal;
            }
        }
        mesh.normals = normals;
        return mesh;
    }

    void Awake()
    {
        if (GetComponent<MeshFilter>())
        {
            Mesh tempMesh = (Mesh)Instantiate(GetComponent<MeshFilter>().sharedMesh);
            tempMesh = MeshNormalAverage(tempMesh);
            gameObject.GetComponent<MeshFilter>().sharedMesh = tempMesh;
        }
    }
}