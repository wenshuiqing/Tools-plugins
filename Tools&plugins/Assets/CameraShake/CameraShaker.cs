using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CameraShaker : MonoBehaviour
{
    public float duration;
    public float RotationAngle;
    public float Force;

    private Vector3 m_initialPosition;
    private Quaternion m_initialRotation;
    private float m_oldRotationOffset;
    private Vector3 m_oldOffset;
    private float timer;


    void OnEnable()
    {
        m_initialPosition = Camera.main.transform.position;
        m_initialRotation = Camera.main.transform.localRotation;

        timer = duration;
    }

    void Update()
    {
        if (timer > 0)
        {
            Transform objectToMove = Camera.main.transform;
            Vector3 newOffset = new Vector3(UnityEngine.Random.Range(-Force, Force), UnityEngine.Random.Range(-Force, Force), 0);
            float newRotationOffset = UnityEngine.Random.Range(-RotationAngle, RotationAngle);
            objectToMove.position = objectToMove.position - m_oldOffset + newOffset;
            objectToMove.Rotate(0, 0, -m_oldRotationOffset);
            objectToMove.Rotate(0, 0, newRotationOffset);
            m_oldOffset = newOffset;
            m_oldRotationOffset = newRotationOffset;
            timer -= Time.deltaTime;
        }
        else
        {
            timer = 0;
            enabled = false;
        }
    }

    private void OnDisable()
    {
        Camera.main.transform.position = m_initialPosition;
        Camera.main.transform.localRotation = m_initialRotation;
    }

}
