using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System;

namespace PostFX
{
    [Serializable]
    public class ScreenFlip : PostEffectBase
    {
        // Use this for initialization
        public override void OnEnable()
        {
            et = EffectType.ScreenFlip;
            CreateMaterial();
        }

        public override void PreProcess(RenderTexture source, RenderTexture destination)
        {
            if (material == null)
            {
                CreateMaterial();
            }
            if (material != null)
            {
                if (EarlyOutIfNotSupported(source, destination))
                {
                    return;
                }
                Graphics.Blit(source, destination, material);
            }
        }

        public override bool InValidQuality()
        {
            return false;
        }

        protected override void CreateMaterial()
        {
            if (material == null)
            {
                shader = Shader.Find("PostEffect/ScreenFlip");
                if (shader != null)
                {
                    material = new Material(shader);
                }
            }
        }
    }
}