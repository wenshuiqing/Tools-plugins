using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CameraShake : MonoBehaviour {
    private Vector3 shakePos = Vector3.zero;

    /// <summary>
    /// 相机震动方向
    /// </summary>
    public Vector3 shakeDir = Vector3.one;
    /// <summary>
    /// 相机震动时间
    /// </summary>
    public float shakeTime = 1.0f;

    private float currentTime = 0.0f;
    private float totalTime = 0.0f;

    public void Trigger()
    {
        totalTime = shakeTime;
        currentTime = shakeTime;
    }

    public void Stop()
    {
        currentTime = 0.0f;
        totalTime = 0.0f;
    }

    public void UpdateShake()
    {
        if (currentTime > 0.0f && totalTime > 0.0f)
        {
            float percent = currentTime / totalTime;

            Vector3 shakePos = Vector3.zero;
            shakePos.x = UnityEngine.Random.Range(-Mathf.Abs(shakeDir.x) * percent, Mathf.Abs(shakeDir.x) * percent);
            shakePos.y = UnityEngine.Random.Range(-Mathf.Abs(shakeDir.y) * percent, Mathf.Abs(shakeDir.y) * percent);
            shakePos.z = UnityEngine.Random.Range(-Mathf.Abs(shakeDir.z) * percent, Mathf.Abs(shakeDir.z) * percent);

            Camera.main.transform.position += shakePos;

            currentTime -= Time.deltaTime;
        }
        else
        {
            currentTime = 0.0f;
            totalTime = 0.0f;
        }
    }

    void LateUpdate()
    {
        UpdateShake();
    }

    void OnEnable()
    {
        Trigger();
    }


    private void Shake1()
    {
        if (Input.GetKey(KeyCode.Space))
        {
            transform.localPosition -= shakePos;
            shakePos = Random.insideUnitSphere / 5.0f;
            transform.localPosition += shakePos;
        }
    }
}
