using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;


namespace PostFX
{
    [Serializable]
    public class SpiritPressure : PostEffectBase
    {


        public LayerMask layer = 1 << 8;
        public Texture lineTex1;
        public Texture lineTex2;
        public Vector4 shakeFactor = new Vector4(0.01f, 20, 0.0125f, 20);
        public Vector2 lineFactor = new Vector2(10, 20);

        private RenderTexture target;



        public override void Enable()
        {
            et = EffectType.SpiritPressure;
            CreateMaterial();
           // CameraSettings();
        }


        protected override void CreateMaterial()
        {
            if (base.material == null)
            {
                base.shader = Shader.Find("Hidden/SpiritPressure");
                if (base.shader != null)
                {
                    base.material = new Material(base.shader);
                }
            }
        }

        private GameObject FindOrNewSetParent(Transform tr, string name, out bool isExsit)
        {
            Transform t = tr.Find(name);

            GameObject obj;
            if (t == null)
            {
                obj = new GameObject(name);
                isExsit = false;
            }
            else
            {
                obj = t.gameObject;
                isExsit = true;
            }
            obj.transform.SetParent(tr);
            return obj;
        }

       /* private void CameraSettings()
        {
            bool isExsit;
            GameObject go = FindOrNewSetParent(PostEffectBase.camera.transform, "camera", out isExsit);
            target = new RenderTexture(Screen.width, Screen.height, 24, RenderTextureFormat.ARGB32);
            go.transform.localPosition = Vector3.zero;

            Camera cam = go.AddComponent<Camera>();

            cam.cullingMask = layer.value;
            cam.clearFlags = CameraClearFlags.SolidColor;
            cam.depth = -99;
            cam.targetTexture = target;
            cam.backgroundColor = new Color(0, 0, 0, 0);

        }*/


        public override void PreProcess(RenderTexture source, RenderTexture destination)
        {
            if (material == null)
            {
                CreateMaterial();
            }
            if (material != null)// && mGlowEnable)
            {
                material.SetTexture("_Flags", target);
                material.SetTexture("_LineTex1", lineTex1);
                material.SetTexture("_LineTex2", lineTex2);
                material.SetVector("_ShakeFactor", shakeFactor);
                material.SetVector("_LineFactor", new Vector4(lineFactor.x, lineFactor.y, 0, 0));
                Graphics.Blit(source, destination, material);
            }
        }
        public override void ToParam(object[] o)
        {
            if (o[0] != null)
            {
                layer = (LayerMask)(o[0]);
            }
            if (o[1] != null)
            {
                lineTex1 = (Texture)(o[1]);
            }
            if (o[2] != null)
            {
                lineTex2 = (Texture)(o[2]);
            }
            if (o[3] != null)
            {
                shakeFactor = (Vector4)o[3];
            }
            if (o[4] != null)
            {
                lineFactor = (Vector4)o[4];
            }
        }

        public override void Dispose()
        {
            
            target.Release();
            target = null;
        }
    }
}