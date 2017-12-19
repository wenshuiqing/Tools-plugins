using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[CreateAssetMenu(menuName = "LODUtils")]
public class LodNameSettings : ScriptableObject {

    public bool showWireCube = true;

    public string Name = "terrain";
    public string filterName = "walksurface";

    [Header("Area")]
    public Vector3 center;
    public Vector3 size;

    [Header("Grid")]
    public Vector2 chunkCount;


    [Header("LOD param")]
    public Vector3 Lod0BoundSize;
    public Vector3 Lod1BoundSize;
    public Vector3 Lod2BoundSize;
   //public Vector3 Lod3BoundSize;
}
