using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;
using System;
using System.IO;

[CustomEditor(typeof(BrushTerrain))]
[CanEditMultipleObjects]
public class BrushTerrainEditor : Editor
{
    int Size = 16;
    int sqrtSize=4;
    bool isPaint = false;

    bool mainTex;
    bool secondaryTex;

    int brushSize = 15;
    float brushStronger = 0.5f;

    Texture2D[] blockTex;
    Texture[] brushsTex;

    int selPTex = 0;
    int selFTex = 0;
    int selBrush = 0;

    private Texture2D blendTex;
    private Transform terrain;
    private MeshFilter mf;
    private MeshRenderer mr;
    private bool isLoadBrush = false;
    private bool isLoadBlockTex = false;

    struct Preview
    {
        public int px;
        public int py;
        public int pw;
        public int ph;
        public Color[] pTerrainBay;
        public Preview(int px, int py, int pw, int ph, Color[] pTerrainBay)
        {
            this.px = px;
            this.py = py;
            this.pw = pw;
            this.ph = ph;
            this.pTerrainBay = new Color[pTerrainBay.Length];
            for (int i = 0; i < pTerrainBay.Length; i++)
            {
                this.pTerrainBay[i] = pTerrainBay[i];
            }
        }
    }
    private Preview pre;


    void OnEnable()
    {
       // sqrtSize = (int)Mathf.Sqrt(Size);
        terrain = Selection.activeTransform;
        mf = terrain.GetComponent<MeshFilter>();
        mr = terrain.GetComponent<MeshRenderer>();
    }

    void OnSceneGUI()
    {
        if (isPaint)
        {
            EditTerrain();
        }
    }

    public override void OnInspectorGUI()
    {
        if (Check())
        {

            GUIStyle style = new GUIStyle(GUI.skin.button);

            GUILayout.BeginHorizontal();
            GUILayout.FlexibleSpace();
            isPaint = GUILayout.Toggle(isPaint, EditorGUIUtility.IconContent("EditCollider"), style, GUILayout.Width(30), GUILayout.Height(25));
            GUILayout.Label("Edit Terrain");
            GUILayout.FlexibleSpace();
            GUILayout.EndHorizontal();

            if (!isLoadBlockTex)
            {
                isLoadBlockTex = true;
                LoadBlockMainTex();
            }

            mainTex = EditorGUILayout.BeginToggleGroup("MainTex", !secondaryTex);
            GUILayout.BeginHorizontal();
            GUILayout.FlexibleSpace();
            GUILayout.BeginHorizontal("box", GUILayout.Width(318));
            selPTex = GUILayout.SelectionGrid(selPTex, blockTex, 8, "gridlist", GUILayout.Width(360), GUILayout.Height(70));
            GUILayout.EndHorizontal();
            GUILayout.FlexibleSpace();
            GUILayout.EndHorizontal();
            EditorGUILayout.EndToggleGroup();


            secondaryTex = EditorGUILayout.BeginToggleGroup("SecondaryTex", !mainTex);
            GUILayout.BeginHorizontal();
            GUILayout.FlexibleSpace();
            GUILayout.BeginHorizontal("box", GUILayout.Width(318));
            selFTex = GUILayout.SelectionGrid(selFTex, blockTex, 8, "gridlist", GUILayout.Width(360), GUILayout.Height(70));
            GUILayout.EndHorizontal();
            GUILayout.FlexibleSpace();
            GUILayout.EndHorizontal();
            EditorGUILayout.EndToggleGroup();


            if (!isLoadBrush)
            {
                isLoadBrush = true;
                LoadBrushs();
            }
            GUILayout.Label("Brush");
            GUILayout.BeginHorizontal();
            GUILayout.FlexibleSpace();
            GUILayout.BeginHorizontal("box", GUILayout.Width(318));
            selBrush = GUILayout.SelectionGrid(selBrush, brushsTex, 9, "gridlist", GUILayout.Width(360), GUILayout.Height(70));
            GUILayout.EndHorizontal();
            GUILayout.FlexibleSpace();
            GUILayout.EndHorizontal();




            brushSize = EditorGUILayout.IntSlider("BrushSize", brushSize, 1, 36);
            brushStronger = EditorGUILayout.Slider("BrushStronger", brushStronger, 0, 1);

            GUILayout.BeginHorizontal();
            GUILayout.FlexibleSpace();
            if (GUILayout.Button("Save", "button", GUILayout.Width(360), GUILayout.Height(25)))
            {
                SaveData();
            }
            GUILayout.FlexibleSpace();
            GUILayout.EndHorizontal();



        }

    }


    private void EditTerrain()
    {
        HandleUtility.AddDefaultControl(0);
        if ((Event.current.type == EventType.MouseDrag && Event.current.alt == false && Event.current.control == false && Event.current.shift == false && Event.current.button == 0) || (Event.current.type == EventType.MouseDown && Event.current.shift == false && Event.current.alt == false && Event.current.control == false && Event.current.button == 0))
        {
            UpdatePaint(false);
            pre = new Preview();
        }
        else if (Event.current.type == EventType.MouseMove)
        {
            UpdatePaint(true);
        }

    }



    private void UpdatePaint(bool isPreview)
    {
        float orthographicSize = (brushSize * terrain.localScale.x) * (mf.sharedMesh.bounds.size.x / 200);//笔刷在模型上的正交大小

        int brushSizeInPourcent = (int)Mathf.Round((brushSize * blendTex.width) / 100);//笔刷在模型上的大小

        Ray ray = HandleUtility.GUIPointToWorldRay(Event.current.mousePosition);
        RaycastHit hit;
        if (Physics.Raycast(ray, out hit, Mathf.Infinity, LayerMask.GetMask("Terrain")))
        {
            Handles.color = new Color(1f, 1f, 0f, 1f);
            Handles.DrawWireDisc(hit.point, hit.normal, orthographicSize);
            if (isPreview)
            {
                blendTex.SetPixels(pre.px, pre.py, pre.pw, pre.ph, pre.pTerrainBay, 0);//把绘制后的belnd贴图保存起来
                blendTex.Apply();
            }


            Color targetColor = new Color(selPTex /(float)(Size-1), 0f, 0f, 1f);
           // Color[] blendTexCol = blendTex.GetPixels();

            Vector2 pixelUV = hit.textureCoord;

            //计算笔刷所覆盖的区域
            int PuX = Mathf.FloorToInt(pixelUV.x * blendTex.width);
            int PuY = Mathf.FloorToInt(pixelUV.y * blendTex.height);
            int x = Mathf.Clamp(PuX - brushSizeInPourcent / 2, 0, blendTex.width - 1);
            int y = Mathf.Clamp(PuY - brushSizeInPourcent / 2, 0, blendTex.height - 1);
            int width = Mathf.Clamp((PuX + brushSizeInPourcent / 2), 0, blendTex.width) - x;
            int height = Mathf.Clamp((PuY + brushSizeInPourcent / 2), 0, blendTex.height) - y;

            Color[] terrainBay = blendTex.GetPixels(x, y, width, height, 0);//获取blend贴图被笔刷所覆盖的区域的颜色
            if (isPreview)
            {
                pre = new Preview(x, y, width, height, terrainBay);//保存上次数据
            }
            Texture2D TBrush = brushsTex[selBrush] as Texture2D;//获取笔刷性状贴图
            float[] brushAlpha = new float[brushSizeInPourcent * brushSizeInPourcent];//笔刷透明度

            //根据笔刷贴图计算笔刷的透明度
            for (int i = 0; i < brushSizeInPourcent; i++)
            {
                for (int j = 0; j < brushSizeInPourcent; j++)
                {
                    brushAlpha[j * brushSizeInPourcent + i] = TBrush.GetPixelBilinear(((float)i) / brushSizeInPourcent, ((float)j) / brushSizeInPourcent).a;
                }
            }

            //计算绘制后的颜色
            if (mainTex)
            {
                for (int i = 0; i < height; i++)
                {
                    for (int j = 0; j < width; j++)
                    {
                        int index = (i * width) + j;

                        terrainBay[index].r = targetColor.r;
                    }
                }
            }
            if (secondaryTex)
            {
                for (int i = 0; i < height; i++)
                {
                    for (int j = 0; j < width; j++)
                    {
                        int index = (i * width) + j;
                        float Stronger = brushAlpha[Mathf.Clamp((y + i) - (PuY - brushSizeInPourcent / 2), 0, brushSizeInPourcent - 1) * brushSizeInPourcent + Mathf.Clamp((x + j) - (PuX - brushSizeInPourcent / 2), 0, brushSizeInPourcent - 1)] * brushStronger;

                        targetColor.r = terrainBay[index].r;
                        targetColor.g = selFTex / (float)(Size - 1);
                        targetColor.b = 1;// (terrainBay[index].r == targetColor.g) ? 0 : 1;

                        terrainBay[index] = Color.Lerp(terrainBay[index], targetColor, Stronger);
                        terrainBay[index].g = selFTex / (float)(Size - 1);
                    }
                }
            }
            if (!isPreview)
            {
                Undo.RegisterCompleteObjectUndo(blendTex, "terrainPaint");//保存历史记录以便撤销
            }
            blendTex.SetPixels(x, y, width, height, terrainBay, 0);//把绘制后的belnd贴图保存起来
            blendTex.Apply();

        }
        else
        {
            if (isPreview)
            {
                blendTex.SetPixels(pre.px, pre.py, pre.pw, pre.ph, pre.pTerrainBay, 0);//
                blendTex.Apply();
            }
        }
    }

    private void SaveData()
    {

        var path = AssetDatabase.GetAssetPath(blendTex);
        var bytes = blendTex.EncodeToPNG();
        File.WriteAllBytes(path, bytes);
        AssetDatabase.ImportAsset(path, ImportAssetOptions.ForceUpdate);
    }

    private void LoadBlockMainTex()
    {
        blockTex = new Texture2D[Size];
        Texture2D ap = mr.sharedMaterial.GetTexture("_BlockMainTex") as Texture2D;
        for (int i = 0; i < blockTex.Length / sqrtSize; i++)
        {
            for (int j = 0; j < blockTex.Length / sqrtSize; j++)
            {
                Color[] col = ap.GetPixels((ap.width/sqrtSize) * i, (ap.height / sqrtSize) * j, ap.width / sqrtSize, ap.height / sqrtSize);
                blockTex[sqrtSize * i + j] = new Texture2D(ap.width / sqrtSize, ap.height / sqrtSize, TextureFormat.RGB24, false);
                blockTex[sqrtSize * i + j].SetPixels(col);
            }
        }
    }

    private void LoadBrushs()
    {
        string path = "Assets/BrushTerrain/Editor/Brushes/Brush";
        int num = 0;
        Texture2D texture;
        List<Texture2D> ts = new List<Texture2D>();
        do
        {
            texture = AssetDatabase.LoadAssetAtPath<Texture2D>(path + num + ".png");
            if (texture)
            {
                ts.Add(texture);
            }
            num++;

        } while (texture);
        brushsTex = ts.ToArray();
    }

    private bool Check()
    {

        Mesh mesh = mf.sharedMesh;

        if (mesh == null)
        {
            EditorGUILayout.HelpBox("Mesh is null!", MessageType.Error);
            return false;
        }

        Material mt = mr.sharedMaterial;

        if (mt == null)
        {
            EditorGUILayout.HelpBox("Material is null!", MessageType.Error);
            return false;
        }
        if (mt.shader != Shader.Find("Terrain/TerrainShader"))
        {
            EditorGUILayout.HelpBox("Shader is error!", MessageType.Error);
            return false;
        }
        blendTex = mt.GetTexture("_BlendTex") as Texture2D;
        if (blendTex == null)
        {
            EditorGUILayout.HelpBox("_BlendTex is null!", MessageType.Error);

            if (GUILayout.Button("Create _BlendTex"))
            {
                CreatAndSetBlendTex(mt);

            }
            return false;
        }
        else
        {
            mt.SetFloat("_Size", Size-1);
            mt.SetFloat("_SqrtSize", sqrtSize);
        }

        return true;
    }

    private void CreatAndSetBlendTex(Material mt)
    {
        string blendTexFolder = "Assets/BrushTerrain/BlendTex/";
        Texture2D blendTexAs = new Texture2D(256, 256, TextureFormat.ARGB32, true);

        Color[] col = new Color[256 * 256];
        for (int i = 0; i < col.Length; i++)
        {
            col[i] = new Color(0, 0, 0, 0);
        }

        blendTexAs.SetPixels(col);

        string path = blendTexFolder + blendTexAs.GetHashCode() + ".png";

        byte[] bytes = blendTexAs.EncodeToPNG();

        File.WriteAllBytes(path, bytes);

        AssetDatabase.ImportAsset(path, ImportAssetOptions.ForceUpdate);//==AssetDatabase.Refresh();
                                                                        //AssetDatabase.Refresh();

        TextureImporter imt = TextureImporter.GetAtPath(path) as TextureImporter;
        imt.isReadable = true;
#if UNITY_5_5_OR_NEWER

        TextureImporterPlatformSettings tips = imt.GetDefaultPlatformTextureSettings();
        tips.textureCompression = TextureImporterCompression.Uncompressed;
        tips.format = TextureImporterFormat.RGBA32;
        tips.overridden = true;
        imt.SetPlatformTextureSettings(tips);
#else
        imt.textureFormat = TextureImporterFormat.RGBA32;
#endif
        imt.wrapMode = TextureWrapMode.Clamp;
        imt.anisoLevel = 9;
        imt.mipmapEnabled = false;
        AssetDatabase.ImportAsset(path, ImportAssetOptions.ForceUpdate);

        Texture2D blendTex = AssetDatabase.LoadAssetAtPath<Texture2D>(path);
        mt.SetTexture("_BlendTex", blendTex);
    }
}
