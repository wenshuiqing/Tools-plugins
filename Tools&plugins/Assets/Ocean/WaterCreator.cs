using UnityEngine;
using System.Collections;

struct Wave
{
	public float freq;
	// 2*PI / wavelength
	public float amp;
	// amplitude
	public float phase;
	// speed * 2*PI / wavelength
	public Vector2 dir;

	public Wave (float f, float a, float p, Vector2 d)
	{
		this.freq = f;
		this.amp = a;
		this.phase = p;
		this.dir = d;
	}
};


public class WaterCreator : MonoBehaviour
{
	/*public int m_width;
	public int m_height;
	public int m_resolutionX;
	public int m_resolutionY;*/
	[Range (1, 32)]
	public float Amplitude = 16;
	[Range (8, 32)]
	public float SteepnessUp = 8;
	[Range (1, 16)]
	public float SteepnessDown = 2;

	public Material oceanMat;
	public float m_repeatTime;
	public int m_numWaves;
	public float m_gravity = 9.81f;
	public Vector2 m_windDirection;
	public float m_windDeviation;
	private ComputeBuffer m_waveBuffer;
	private float w0;

	void Start ()
	{
		w0 = 2 * Mathf.PI / m_repeatTime;
		int WaveSize = sizeof(float) * 5;
		Wave[] waves = new Wave[m_numWaves];
		m_waveBuffer = new ComputeBuffer (32, WaveSize);

		for (int i = 0; i < m_numWaves; i++) {
			float medianAmplitude = Random.Range (0.15f, 1.5f);
			waves [i] = CreateWave (medianAmplitude);
			//Debug.Log (waves [i].amp + "  " + waves [i].freq + " " + waves [i].dir + " " + waves [i].phase);
		}
		m_waveBuffer.SetData (waves);
		oceanMat.SetBuffer ("waveBuffer", m_waveBuffer);
		oceanMat.SetInt ("_NumCreatedWaves", m_numWaves);

	}

	Wave CreateWave (float mAmp)
	{
		float dA = mAmp / Amplitude;
		float amp = Random.Range (mAmp - dA, mAmp + dA);
		float kA = Random.Range (1.0f / SteepnessUp, 1.0f / SteepnessDown);
		//float waveLength = (2 * Mathf.PI ) / (amp * 32);	// wavelength
		float waveLength = (2 * Mathf.PI * amp) / (kA);
		float k = 2 * Mathf.PI / waveLength;
		float w2;
		if (waveLength < 0.01)
			w2 = m_gravity * k * (1 + (k * k) * (waveLength * waveLength));
		else
			w2 = m_gravity * k;
		float w = Mathf.Sqrt (w2);
		int f = (int)(w / w0);
		w = f * w0;

		Vector2 dir = GetRandomDirection ();
		dir *= k;
		float phase = 0.1f;
		return new Wave (w, amp, phase, dir);


	}


	Vector2 GetRandomDirection ()
	{ 
		float theta = Vector2.Angle (m_windDirection, Vector2.right);
		float minTheta = Mathf.Deg2Rad * (theta - m_windDeviation);
		float maxTheta = Mathf.Deg2Rad * (theta + m_windDeviation);
		theta = Random.Range (minTheta, maxTheta);
		//theta = Random.Range(0, 359);
		return new Vector2 (Mathf.Cos (theta), Mathf.Sin (theta));

	}

	/*Mesh CreateUniformGrid ()
	{
		int segmentsX = m_resolutionX + 1;
		int segmentsY = m_resolutionY + 1;
		float dx = m_width / m_resolutionX;
		float dy = m_height / m_resolutionY;
		float du = 1.0f / m_resolutionX;
		float dv = 1.0f / m_resolutionY;
		Vector3[] vertices = new Vector3[segmentsX * segmentsY];
		Vector3[] normals = new Vector3[segmentsX * segmentsY];
		Vector4[] tangents = new Vector4[segmentsX * segmentsY];
		Vector2[] texcoords = new Vector2[segmentsX * segmentsY]; //not used atm

		for (int x = 0; x < segmentsX; x++) {
			float px = x * dx;
			for (int y = 0; y < segmentsY; y++) {
				normals [x + y * segmentsX] = new Vector3 (0, 1, 0);
				tangents [x + y * segmentsX] = new Vector4 (0.0f, 0.0f, 1.0f, 1.0f);
				Vector3 vertexPos = new Vector3 (px, 0.0f, y * dy);
				vertices [x + y * segmentsX] = vertexPos;
				texcoords [x + y * segmentsX] = new Vector2 (x * du, y * dv);
			}
		}

		int[] indices = new int[segmentsX * segmentsY * 6];

		int num = 0;
		for (int x = 0; x < segmentsX - 1; x++) {
			for (int y = 0; y < segmentsY - 1; y++) {
				indices [num++] = x + y * segmentsX;
				indices [num++] = x + (y + 1) * segmentsX;
				indices [num++] = (x + 1) + y * segmentsX;

				indices [num++] = x + (y + 1) * segmentsX;
				indices [num++] = (x + 1) + (y + 1) * segmentsX;
				indices [num++] = (x + 1) + y * segmentsX;

			}
		}

		Mesh mesh = new Mesh ();

		mesh.vertices = vertices;
		mesh.uv = texcoords;
		mesh.normals = normals;
		mesh.triangles = indices;
		mesh.tangents = tangents;

		return mesh;

	}*/

	void OnDestroy ()
	{
		m_waveBuffer.Release ();
	}
}
