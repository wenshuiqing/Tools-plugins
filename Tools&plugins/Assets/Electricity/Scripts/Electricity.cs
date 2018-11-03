using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
public class Electricity : MonoBehaviour
{
    public Transform start;
    public Transform end;
    // Use this for initialization
    void Start()
    {

    }

    // Update is called once per frame
    void Update()
    {
        Vector3 dir = end.position - start.position;

        Vector3 mid = (end.position + start.position) / 2.0f;

        transform.position = mid;

        Quaternion qua = Quaternion.LookRotation(dir, Vector3.up);
        transform.rotation = qua;

        transform.localScale = new Vector3(transform.localScale.x, transform.localScale.y, dir.magnitude / 10.0f);

    }
}
