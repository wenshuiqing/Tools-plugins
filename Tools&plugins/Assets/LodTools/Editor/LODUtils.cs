using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;
using UnityEditor.SceneManagement;

[InitializeOnLoad]
public class LODUtils
{
    private string terrainName = "TerrainX";
    private string filterName = "walksurface";
    private Vector3 Lod0BoundSize;
    private Vector3 Lod1BoundSize;
    private Vector3 Lod2BoundSize;
    private string chunkName = "";

    private static string delFilterName = "LOD0;LOD1;LOD2;LOD3";
    private static LodNameSettings lds;
    static LODUtils()
    {
        LODUtils LD = new LODUtils();
    }

    private LODUtils()
    {
        lds = AssetDatabase.LoadAssetAtPath<LodNameSettings>("Assets/LodTools/Settings/LodSettings.asset");
        SceneView.onSceneGUIDelegate += OnSceneGUI;
    }

    static GameObject FindOrNewSetParent(Transform tr, string name)
    {
        Transform t = tr.Find(name);

        GameObject obj;
        if (t == null)
        {
            obj = new GameObject(name);
        }
        else
        {
            obj = t.gameObject;
        }
        obj.transform.SetParent(tr);
        return obj;
    }

    private static bool isShowPanel = false;
    [MenuItem("Tools/LOD分块(手动)")]
    static void ChunkHand()
    {
        isShowPanel = !isShowPanel;
    }

    [MenuItem("Tools/LOD分块(自动)")]
    static void Chunk()
    {
        GameObject obj = GameObject.Find(lds.Name);
        Transform trans = obj.transform;
        Transform[] tr = trans.GetComponentsInChildren<Transform>();
        Debug.Log(tr.Length);
        Dictionary<GameObject, Bounds> blists = new Dictionary<GameObject, Bounds>();

        int x = (int)lds.chunkCount.x;
        int z = (int)lds.chunkCount.y;
        float dx = lds.size.x / x;
        float dz = lds.size.z / z;

        Vector3 ori = new Vector3(lds.center.x - lds.size.x / 2 + dx / 2, lds.center.y, lds.center.z - lds.size.z / 2 + dz / 2);
        Vector3 newSize = new Vector3(dx, lds.size.y, dz);



        for (int i = 0; i < x; i++)
        {
            for (int j = 0; j < z; j++)
            {
                Vector3 newCenter = ori + new Vector3(i * dx, 0, j * dz);
                Bounds bound = new Bounds(newCenter, newSize);

                string name = "chunk" + (i * z + j);

                GameObject chunk = FindOrNewSetParent(trans, name);

                FindOrNewSetParent(chunk.transform, "LOD0");
                FindOrNewSetParent(chunk.transform, "LOD1");
                FindOrNewSetParent(chunk.transform, "LOD2");
                FindOrNewSetParent(chunk.transform, "LOD3");

                blists.Add(chunk, bound);
            }
        }

        LOD(blists, tr);


        Delete(trans, delFilterName);
        Debug.Log(tr.Length);


        AssetDatabase.Refresh();
        UnityEditor.SceneManagement.EditorSceneManager.SaveScene(UnityEditor.SceneManagement.EditorSceneManager.GetActiveScene());
    }
    static void LOD(Dictionary<GameObject, Bounds> blists, Transform[] tr)
    {

        foreach (var t in tr)
        {
            if (t.parent != null)
            {
                if (lds.filterName.Contains(t.parent.name))
                {
                    continue;
                }
            }
            Renderer render = t.GetComponent<Renderer>();
            if (render != null)
            {
                foreach (var pair in blists)
                {
                    GameObject chunk = pair.Key;
                    Bounds bound = pair.Value;
                    Transform Lod0 = chunk.transform.Find("LOD0");
                    Transform Lod1 = chunk.transform.Find("LOD1");
                    Transform Lod2 = chunk.transform.Find("LOD2");
                    Transform Lod3 = chunk.transform.Find("LOD3");
                    if (bound.Contains(render.bounds.center))
                    {
                        if ((render.bounds.size.x * render.bounds.size.y * render.bounds.size.z) > (lds.Lod0BoundSize.x * lds.Lod0BoundSize.y * lds.Lod0BoundSize.z))
                        {
                            if (render is SkinnedMeshRenderer)
                                render.transform.parent.SetParent(Lod0);
                            else
                                render.transform.SetParent(Lod0);
                        }
                        else if ((render.bounds.size.x * render.bounds.size.y * render.bounds.size.z) > (lds.Lod1BoundSize.x * lds.Lod1BoundSize.y * lds.Lod1BoundSize.z))
                        {
                            if (render is SkinnedMeshRenderer)
                                render.transform.parent.SetParent(Lod1);
                            else
                                render.transform.SetParent(Lod1);
                        }
                        else if ((render.bounds.size.x * render.bounds.size.y * render.bounds.size.z) > (lds.Lod2BoundSize.x * lds.Lod2BoundSize.y * lds.Lod2BoundSize.z))
                        {
                            if (render is SkinnedMeshRenderer)
                                render.transform.parent.SetParent(Lod2);
                            else
                                render.transform.SetParent(Lod2);
                        }
                        else
                        {
                            if (render is SkinnedMeshRenderer)
                                render.transform.parent.SetParent(Lod3);
                            else
                                render.transform.SetParent(Lod3);
                        }
                    }
                }

            }

        }

    }
    static void Delete(Transform tr, string filterName)
    {
        if (filterName.Contains(tr.name))
        {
            return;
        }
        for (int i = tr.childCount - 1; i >= 0; i--)
        {
            Delete(tr.GetChild(i), filterName);
        }
        Component[] cs = tr.GetComponents<Component>();
        if (tr.childCount == 0 && cs.Length == 1)
        {
            GameObject.DestroyImmediate(tr.gameObject);
        }
    }



    // [MenuItem("GameObject/MoveTo", priority = 0)]
    [MenuItem("GameObject/MoveTo/LOD0", priority = 0)]
    static void MoveLOD0()
    {
        GameObject[] gts = Selection.gameObjects;
        foreach (var gt in gts)
        {
            gt.transform.SetParent(gt.transform.parent.parent.Find("LOD0"));
        }

    }
    [MenuItem("GameObject/MoveTo/LOD1", priority = 0)]
    static void MoveLOD1()
    {
        GameObject[] gts = Selection.gameObjects;
        foreach (var gt in gts)
        {
            gt.transform.SetParent(gt.transform.parent.parent.Find("LOD1"));
        }
    }
    [MenuItem("GameObject/MoveTo/LOD2", priority = 0)]
    static void MoveLOD2()
    {
        GameObject[] gts = Selection.gameObjects;
        foreach (var gt in gts)
        {
            gt.transform.SetParent(gt.transform.parent.parent.Find("LOD2"));
        }
    }
    [MenuItem("GameObject/MoveTo/LOD3", priority = 0)]
    static void MoveLOD3()
    {
        GameObject[] gts = Selection.gameObjects;
        foreach (var gt in gts)
        {
            gt.transform.SetParent(gt.transform.parent.parent.Find("LOD3"));
        }
    }



    void OnSceneGUI(SceneView sceneView)
    {
        if (lds.showWireCube)
        {
            DrawArea();
        }

        if (isShowPanel)
        {
            int width = 200;
            int height = 225;
            GUI.Window(0, new Rect(Screen.width - width * 1.2f, Screen.height - height * 1.2f, width, height), UiLayout, "LOD分割工具");
        }

    }



    void UiLayout(int id)
    {
        GUILayout.BeginHorizontal();
        GUILayout.Label("TerrainName:");
        terrainName = GUILayout.TextField(terrainName, 25);
        GUILayout.EndHorizontal();

        GUILayout.BeginHorizontal();
        GUILayout.Label("FilterName:");
        filterName = GUILayout.TextField(filterName, 30);
        GUILayout.EndHorizontal();

        Lod0BoundSize = EditorGUILayout.Vector3Field("LOD0", Lod0BoundSize);

        Lod1BoundSize = EditorGUILayout.Vector3Field("LOD1", Lod1BoundSize);

        Lod2BoundSize = EditorGUILayout.Vector3Field("LOD2", Lod2BoundSize);

        GUILayout.BeginHorizontal();
        GUILayout.Label("ChunkName:");
        chunkName = GUILayout.TextField(chunkName, 7);
        GUILayout.EndHorizontal();



        GUILayout.BeginHorizontal();
        GUILayout.FlexibleSpace();
        if (GUILayout.Button("Create", "button", GUILayout.Width(180), GUILayout.Height(20)))
        {
            LODPart();
        }
        GUILayout.FlexibleSpace();
        GUILayout.EndHorizontal();
    }



    void LODPart()
    {
        GameObject obj = GameObject.Find(terrainName);
        Transform trans = obj.transform;
        GameObject[] gts = Selection.gameObjects;
        GameObject chunk = FindOrNewSetParent(trans, chunkName);
        Transform Lod0 = FindOrNewSetParent(chunk.transform, "LOD0").transform;
        Transform Lod1 = FindOrNewSetParent(chunk.transform, "LOD1").transform;
        Transform Lod2 = FindOrNewSetParent(chunk.transform, "LOD2").transform;
        Transform Lod3 = FindOrNewSetParent(chunk.transform, "LOD3").transform;

        foreach (var gt in gts)
        {
            Transform[] tr = gt.GetComponentsInChildren<Transform>();

            foreach (var t in tr)
            {
                if (t.parent != null)
                {
                    if (lds.filterName.Contains(t.parent.name))
                    {
                        continue;
                    }
                }

                Renderer render = t.GetComponent<Renderer>();
                if (render != null)
                {
                    if ((render.bounds.size.x * render.bounds.size.y * render.bounds.size.z) > (lds.Lod0BoundSize.x * lds.Lod0BoundSize.y * lds.Lod0BoundSize.z))
                    {
                        if (render is SkinnedMeshRenderer)
                            render.transform.parent.SetParent(Lod0);
                        else
                            render.transform.SetParent(Lod0);
                    }
                    else if ((render.bounds.size.x * render.bounds.size.y * render.bounds.size.z) > (lds.Lod1BoundSize.x * lds.Lod1BoundSize.y * lds.Lod1BoundSize.z))
                    {
                        if (render is SkinnedMeshRenderer)
                            render.transform.parent.SetParent(Lod1);
                        else
                            render.transform.SetParent(Lod1);
                    }
                    else if ((render.bounds.size.x * render.bounds.size.y * render.bounds.size.z) > (lds.Lod2BoundSize.x * lds.Lod2BoundSize.y * lds.Lod2BoundSize.z))
                    {
                        if (render is SkinnedMeshRenderer)
                            render.transform.parent.SetParent(Lod2);
                        else
                            render.transform.SetParent(Lod2);
                    }
                    else
                    {
                        if (render is SkinnedMeshRenderer)
                            render.transform.parent.SetParent(Lod3);
                        else
                            render.transform.SetParent(Lod3);
                    }
                }
            }
        }
        Selection.activeGameObject = chunk;
        Delete(trans, delFilterName);
        AssetDatabase.Refresh();
        UnityEditor.SceneManagement.EditorSceneManager.SaveScene(UnityEditor.SceneManagement.EditorSceneManager.GetActiveScene());
    }

    void DrawArea()
    {
        Handles.color = Color.blue;
        int x = (int)lds.chunkCount.x;
        int z = (int)lds.chunkCount.y;
        float dx = lds.size.x / x;

        float dz = lds.size.z / z;

        Vector3 ori = new Vector3(lds.center.x - lds.size.x / 2 + dx / 2, lds.center.y, lds.center.z - lds.size.z / 2 + dz / 2);
        for (int i = 0; i < x; i++)
        {
            for (int j = 0; j < z; j++)
            {
                Vector3 newCenter = ori + new Vector3(i * dx, 0, j * dz);
                Handles.DrawWireCube(newCenter, new Vector3(dx, lds.size.y, dz));

            }
        }
    }
}
