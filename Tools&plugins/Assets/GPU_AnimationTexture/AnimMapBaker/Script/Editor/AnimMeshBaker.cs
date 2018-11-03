using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;
using System.IO;
using System;

public class AnimMeshBaker : EditorWindow
{

    [MenuItem("Window/AnimMapBakerTest")]
    public static void ShowWindow()
    {
        EditorWindow.GetWindow(typeof(AnimMeshBaker));
    }

    public static GameObject targetGo;

    public static string path;
    void OnGUI()
    {
        targetGo = (GameObject)EditorGUILayout.ObjectField(targetGo, typeof(GameObject), true);

        if (GUILayout.Button("Bake"))
        {
            if (targetGo == null)
            {
                EditorUtility.DisplayDialog("err", "targetGo is null！", "OK");
                return;
            }
            
            BakeAnimToMesh();
        }
    }

    static void BakeAnimToMesh()
    {
        Animation anim = targetGo.GetComponent<Animation>();
        SkinnedMeshRenderer smr = targetGo.GetComponentInChildren<SkinnedMeshRenderer>();


        foreach (AnimationState state in anim)
        {
            path = "Assets/ZZZTest/" + state.clip.name;
            if (!Directory.Exists(path))
            {
                Directory.CreateDirectory(path);
                AssetDatabase.Refresh();
            }
            PerBake(anim, smr, state);
        }
    }



    static void PerBake(Animation anim, SkinnedMeshRenderer smr, AnimationState curAnim)
    {
        int curClipFrame = 0;
        float sampleTime = 0;
        float perFrameTime = 0;
        curClipFrame = Mathf.ClosestPowerOfTwo((int)(curAnim.clip.frameRate * curAnim.length));//这个片段有多少帧
        perFrameTime = curAnim.length / curClipFrame;//计算每帧所需要的时间

        Mesh mesh = smr.sharedMesh;
        anim.Play(curAnim.name);
        for (int i = 0; i < curClipFrame; i++)
        {
            curAnim.time = sampleTime;

            // curAnim.clip.SampleAnimation(anim.gameObject, curAnim.time);
            anim.Sample();
            Mesh m = new Mesh();
            smr.BakeMesh(m);



            AssetDatabase.CreateAsset(m, path +"/"+ curAnim.name + i + ".asset");

            sampleTime += perFrameTime;
        }

        AssetDatabase.Refresh();


    }

}
