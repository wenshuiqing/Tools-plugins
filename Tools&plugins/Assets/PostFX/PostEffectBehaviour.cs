using System.Collections;
using System.Collections.Generic;
using UnityEngine;


namespace PostFX
{
    [RequireComponent(typeof(Camera))]
    [ExecuteInEditMode]
    public class PostEffectBehaviour : MonoBehaviour
    {

        public PostEffectSettings postEffect = new PostEffectSettings();

        private List<PostEffectBase> peblist = null;
        // Use this for initialization
        private  Camera newcamera;
        void Awake()
        {
            newcamera = GetComponent<Camera>();
            peblist = postEffect.Initialization();
        }

        void OnEnable()
        {
            PostEffectBase.camera = newcamera;
            foreach (var p in peblist)
            {
                p.Enable();
            }
        }

        void Update()
        {
            foreach (var p in peblist)
            {
                p.Update();
            }
        }

        void OnRenderImage(RenderTexture source, RenderTexture destination)
        {
            var src = source;
            var dst = destination;

            RenderTexture buffer0 = RenderTexture.GetTemporary(Screen.width, Screen.height);
            Graphics.Blit(src, buffer0);
            foreach (var p in peblist)
            {
                if (!p.IsApply) continue;
                RenderTexture buffer1 = RenderTexture.GetTemporary(Screen.width, Screen.height);
                p.PreProcess(buffer0, buffer1);
                RenderTexture.ReleaseTemporary(buffer0);
                buffer0 = buffer1;
            }
            Graphics.Blit(buffer0, dst);
            RenderTexture.ReleaseTemporary(buffer0);
        }
        void OnDisable()
        {
            foreach (var p in peblist)
            {
                p.Dispose();
            }
            RenderTexturePool.ReleaseAll();
        }

        void OnDestroy()
        {
            peblist.Clear();
            peblist = null;
        }


        public List<PostEffectBase> GetPostEffectsList()
        {
            return peblist;
        }
    }
}