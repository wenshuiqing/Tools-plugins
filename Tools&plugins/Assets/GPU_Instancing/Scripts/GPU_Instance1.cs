using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GPU_Instance1 : MonoBehaviour
{
    public GameObject prefab;
    public int count;

    private Mesh mesh;
    private Material mat;
    private Matrix4x4[] matrices;
   // private MaterialPropertyBlock[] props;
    // Use this for initialization
    void Start()
    {
        MeshFilter meshFilter = prefab.GetComponent<MeshFilter>();
        mesh = meshFilter.sharedMesh;
        MeshRenderer meshRenderer = prefab.GetComponent<MeshRenderer>();
        mat = meshRenderer.sharedMaterial;
        matrices = new Matrix4x4[count];
        for (int i = 0; i < count; i++)
        {
            //矩阵
            var position = Random.insideUnitSphere * 100;
            var rotation = Quaternion.LookRotation(Random.insideUnitSphere);
            var scale = Vector3.one;
            var matrix = Matrix4x4.TRS(position, rotation, scale);
            matrices[i] = matrix;

        }
    }

    // Update is called once per frame
    void Update()
    {

        Graphics.DrawMeshInstanced(mesh, 0, mat, matrices, count);//需要每帧调用
    }
}
