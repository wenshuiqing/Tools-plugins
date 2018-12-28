// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

Shader "ZHT/Electricity"
{
	Properties
	{
		_MotionRateGlobal("_MotionRateGlobal",Range(0,5)) = 0.4
		_NoiseMotionRate("_NoiseMotionRate",Range(0,5)) = 0.4
		_NoiseFrequency("_NoiseFrequency",Range(0,5)) = 0.4
		_NoiseScale("_NoiseScale",Range(0,1)) = 0.4
		_Color("Color",Color) = (1,1,1,1)
		_MainTex("MainTex",2D) = "white"{}
	}
	SubShader
	{
		Tags{ "Queue" = "Transparent" "RenderType" = "Opaque" }
		LOD 100
		Pass
	{
		Cull off
		ZTest Always
		Blend srcAlpha OneMinusSrcAlpha
		Tags{ "LightMode" = "ForwardBase" }
		CGPROGRAM
		#pragma vertex vert
		#pragma fragment frag

		#include "UnityCG.cginc"
		struct appdata
		{
			float4 vertex : POSITION;
			float2 texcoord : TEXCOORD0;
			float4 color :COLOR;
		};

		struct v2f
		{
			float4 pos : SV_POSITION;
			float2 meshUV : TEXCOORD0;
			float4 color : TEXCOORD1;
		};
		float _MotionRateGlobal;
		float _NoiseMotionRate;
		float _NoiseFrequency;
		float _NoiseScale;
		float4 _Color;
		sampler2D _MainTex;
		float4 _MainTex_ST;
		v2f vert(appdata v)
		{
			v2f o;
			UNITY_INITIALIZE_OUTPUT(v2f, o);
			float4 m_time = frac((_Time.xyzw + v.color.r + v.color.g + v.color.b)* (0.05));
			float4 m_time_global = m_time * (25.0) * (_MotionRateGlobal);
			float4 floor0 = floor(m_time_global * (1.123));
			float4 floor1 = floor(m_time_global * (3.0));
			//Z轴的初始偏移量
			float4 zoffset = m_time_global + (floor0 + floor1)* (8.93);
			float4 zRates = float4(3, 0.15, 0.15, -0.1051);
			float4 zFrequencys = float4(193.1759, 8.567, 93.15, 25.31);
			float4 zScales = float4(0.25, 5, 0.5, 1.5);
			float4 zSum = float4(0.0, 0.0, 0.0, 0.0);
			for (int i = 0; i<4; i++)
			{
				float4 offset = zoffset * _NoiseMotionRate * zRates[i];
				offset = float4(0.0, v.texcoord.y, 0.0, 0.0) + offset;
				offset = offset * zFrequencys[i] * _NoiseFrequency;
				float4 SinOffset = sin(offset);
				float4 sum = SinOffset * zScales[i] * _NoiseScale;
				zSum += sum;
			}
			//y轴的初始偏移量
			float4 yoffset = zoffset + float4(2.0, 2.0, 2.0, 2.0);
			float4 yRates = float4(0.256, 0.190731, 2.705931, -0.107335);
			float4 yFrequencys = float4(7.071, 79.533, 179.5317, 23.0917);
			float4 yScales = float4(5.0, 0.5, 0.25, 1.5);
			float4 ySum = float4(0.0, 0.0, 0.0, 0.0);
			for (int i = 0; i<4; i++)
			{
				float4 offset = yoffset * _NoiseMotionRate.xxxx * yRates[i];
				offset = float4(0.0, v.texcoord.y, 0.0, 0.0) + offset;
				offset = offset * yFrequencys[i] * _NoiseFrequency;
				float4 SinOffset = sin(offset);
				float4 sum = SinOffset * yScales[i] * _NoiseScale;
				ySum += sum;
			}

			float4 Mask1 = float4(0.0, ySum.y, zSum.y, 0.0);

			float4 Add13 = float4(-1.0, -1.0, -1.0, -1.0) + v.texcoord.y * float4(2.0, 2.0, 2.0, 2.0);
			float4 Abs0 = abs(Add13);
			float4 Lerp1 = lerp(Mask1, float4(0.0, 0.0, 0.0, 0.0), Abs0);
			float4 Add0 = Lerp1 + v.vertex;
			float4 NewVertex = Add0;
			o.color = v.color;
			o.pos = UnityObjectToClipPos(NewVertex);
			o.meshUV.xy = v.texcoord.xy;
			return o;
		}

		fixed4 frag(v2f i) : SV_Target
		{
			
			float4 col = tex2D(_MainTex,TRANSFORM_TEX(i.meshUV.yx, _MainTex))*_Color;
			return col;
		}
		ENDCG
	}
	}
}
