using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System;

namespace PostFX
{

    [Serializable]
    public class PostEffectBase
    {
        protected Shader shader;
        protected Material material;

        [Tooltip("is Apply")]
        public bool IsApply;

        [HideInInspector]
        public EffectType et;


        public virtual void OnEnable() { }

        public virtual void Update() { }

        protected virtual void CreateMaterial() { }

        protected bool EarlyOutIfNotSupported(RenderTexture source, RenderTexture destination)
        {
            bool Supported = (SystemInfo.supportsImageEffects && material.shader.isSupported);
            if (!Supported)
            {
                Graphics.Blit(source, destination);
                return true;
            }
            return false;
        }
        public virtual void PreProcess(RenderTexture src, RenderTexture dst) { }

        public virtual bool InValidQuality()
        {
#if !RES_EDITOR       
            bool invalidQ = true;
            return invalidQ;
#else
            return false;
#endif
        }

        public virtual void OnDispose()
        {
            if (shader != null)
            {
                shader = null;
            }
            if (material != null)
            {
#if UNITY_EDITOR
                Material.DestroyImmediate(material);

#else
                Material.Destroy(material);
#endif
                // material = null;
            }

        }

        public virtual void ToParam(object[] o)
        {

        }
        public virtual void Refresh()
        {

        }
    }
}