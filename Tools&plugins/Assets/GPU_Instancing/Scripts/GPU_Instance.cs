using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GPU_Instance : MonoBehaviour {

    public GameObject prefab;

    public int count=500;
    
	// Use this for initialization
	void Start () {
        MaterialPropertyBlock props = new MaterialPropertyBlock();
        MeshRenderer renderer;

        List<GameObject> objects = new List<GameObject>();

        for (int i = 0; i < count; i++)
        {
            var go = GameObject.Instantiate(prefab,new Vector3(Random.Range(-100.0f,100.0f), Random.Range(-100.0f, 100.0f),0),Quaternion.identity) as GameObject;
            objects.Add(go);
        }



        foreach (GameObject obj in objects)
        {
            float r = Random.Range(0.0f, 1.0f);
            float g = Random.Range(0.0f, 1.0f);
            float b = Random.Range(0.0f, 1.0f);
            props.SetColor("_Color", new Color(r, g, b));

            renderer = obj.GetComponent<MeshRenderer>();
            renderer.SetPropertyBlock(props);
        }
    }
	
	// Update is called once per frame
	void Update () {
		
	}
}
