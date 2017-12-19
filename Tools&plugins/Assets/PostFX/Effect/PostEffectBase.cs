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
        protected bool mIsApply;

        [HideInInspector]
        public EffectType et;


        public virtual void Enable() { }

        public virtual void Update(){}

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

        public virtual void Dispose()
        {
            shader = null;
            material = null;
        }

        public virtual void ToParam(object[] o)
        {

        }
        public virtual void Refresh()
        {

        }
    }
}