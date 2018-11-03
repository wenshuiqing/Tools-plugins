using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class NewBehaviourScript : MonoBehaviour {

	// Use this for initialization
	void Start () {
		
	}
	
	// Update is called once per frame
	void Update () {
        Shader.SetGlobalVector("_Centre",new Vector4( transform.position.x, transform.position.y, transform.position.z, 1));
        
	}
}
