using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class LingYaFX : MonoBehaviour
{

    public Material mat;
    public LayerMask layer = 1 << 8;
    public RenderTexture target;
    void Start()
    {

        target = new RenderTexture(Screen.width, Screen.height, 24, RenderTextureFormat.ARGB32);
        GameObject go = new GameObject("camera");
        go.transform.SetParent(transform);
        go.transform.localPosition = Vector3.zero;
        Camera camera = go.AddComponent<Camera>();
        camera.cullingMask = layer.value;
        camera.clearFlags = CameraClearFlags.SolidColor;
        camera.backgroundColor = new Color(0, 0, 0, 0);
        camera.depth = -99;
        camera.targetTexture = target;

    }

    void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        mat.SetTexture("_Flags", target);
        Graphics.Blit(source, destination, mat);
    }
}
