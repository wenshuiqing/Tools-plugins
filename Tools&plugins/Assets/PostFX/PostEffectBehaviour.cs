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
        public static Camera newCamera;

        void Start()
        {
            newCamera = GetComponent<Camera>();
            peblist = postEffect.Initialization();
            // postEffect = new PostEffectSettings();    
            for (int i = 0; i < peblist.Count; i++)
            {
                peblist[i].OnEnable();
            }

        }

        void Update()
        {
            for (int i = 0; i < peblist.Count; i++)
            {
                if (!peblist[i].IsApply) continue;

                if (peblist[i].InValidQuality()) continue;

                peblist[i].Update();
            }
        }

        void OnRenderImage(RenderTexture source, RenderTexture destination)
        {
            RenderTexture buffer0 = RenderTexturePool.Get(Screen.width, Screen.height);
            Graphics.Blit(source, buffer0);

            for (int i = 0; i < peblist.Count; i++)
            {
                if (!peblist[i].IsApply) continue;
                //if (peblist[i].InValidQuality()) continue;

                RenderTexture buffer1 = RenderTexturePool.Get(Screen.width, Screen.height);
                peblist[i].PreProcess(buffer0, buffer1);
                RenderTexturePool.Release(buffer0);
                buffer0 = buffer1;
            }
            Graphics.Blit(buffer0, destination);
            RenderTexturePool.Release(buffer0);
        }


        void OnDestroy()
        {
            if (peblist != null)
            {
                for (int i = 0; i < peblist.Count; i++)
                {
                    peblist[i].OnDispose();
                }
                peblist.Clear();
                RenderTexturePool.ReleaseAll();
            }

            postEffect = null;
        }


        public List<PostEffectBase> GetPostEffectsList()
        {
            return peblist;
        }

    }

}