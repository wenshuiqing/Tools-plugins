using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System;
using System.Runtime.InteropServices;

[RequireComponent(typeof(SkinnedMeshRenderer))]
public class Test : MonoBehaviour
{
    public List<GameObject> objs = new List<GameObject>();
    public Material mat;

    private List<SkinnedMeshRenderer> srms = new List<SkinnedMeshRenderer>();
    private MyCombineSkinMgr skinMgr;


    private SkinnedMeshRenderer smr;

    // Use this for initialization
    void Start()
    {

        smr = GetComponent<SkinnedMeshRenderer>();
        if (skinMgr == null)
        {
            skinMgr = new MyCombineSkinMgr();
        }

        for (int i = 0; i < objs.Count; i++)
        {
            SkinnedMeshRenderer srm = objs[i].GetComponentInChildren<SkinnedMeshRenderer>();

            srms.Add(srm);
        }
    }

    private void Update()
    {
        if (Input.GetButtonDown("Fire1"))
        {
            skinMgr.CombineObject(smr, srms.ToArray(), mat);
        }
    }

}
