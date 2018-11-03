using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;

namespace PostFX
{
    [CustomEditor(typeof(PostEffectBehaviour))]
    public class PostEffectBehaviourInspector : Editor
    {
        #region Fields

        private PostEffectBehaviour _behaviour;
        private bool _refreshFlag = false;

        #endregion

        #region Editor Methods

        private void OnEnable()
        {
            _behaviour = target as PostEffectBehaviour;

            _refreshFlag = false;
        }

        public override void OnInspectorGUI()
        {
            base.OnInspectorGUI();

            bool tempRefresh = EditorGUILayout.Toggle("Refresh",_refreshFlag);
            if (tempRefresh != _refreshFlag)
            {
                _refreshFlag = tempRefresh;
                if (_refreshFlag)
                {
                    List<PostEffectBase> effectList = _behaviour.GetPostEffectsList();
                    foreach (var effect in effectList)
                    {
                        if (!effect.IsApply) continue;
                        if (effect.InValidQuality()) continue;

                        effect.Refresh();
                    }
                }
            }
        }

        #endregion

    }
}

