using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[RequireComponent(typeof(DynamicBone))]
public class DynamicBoneWindField : MonoBehaviour
{
    [SerializeField]
    DynamicBone DBone;
    [SerializeField]
    Vector3 WindForceMask = Vector3.one;

    private void Reset()
    {
        DBone = GetComponent<DynamicBone>();
    }

    private void FixedUpdate()
    {
        DBone.m_Force = Vector3.Scale(WindForceMask, GameManager.instance.WindForce);
    }
}
