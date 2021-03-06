﻿// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Hidden/FrameFadeout"
{
	Properties
	{
		_MainTex("Texture", 2D) = "white" {}
		_FadeoutTexture("Fade Texture",2D) = "white"{}
		_FadeoutFactor("Fade Factor",Range(0,1)) = 1
	}
		SubShader
		{
			// No culling or depth
			Cull Off ZWrite Off ZTest Always

			Pass
			{
				CGPROGRAM
				#pragma vertex vert
				#pragma fragment frag

				#include "UnityCG.cginc"

				struct appdata
				{
					float4 vertex : POSITION;
					float2 uv : TEXCOORD0;
				};

				struct v2f
				{
					float2 uv : TEXCOORD0;
					float4 vertex : SV_POSITION;
				};

				v2f vert(appdata v)
				{
					v2f o;
					o.vertex = UnityObjectToClipPos(v.vertex);
					o.uv = v.uv;
					return o;
				}

				sampler2D _MainTex;
				sampler2D _FadeoutTexture;
				float _FadeoutFactor;

				float4 frag(v2f i) : SV_Target
				{
					float4 col = tex2D(_MainTex, i.uv);
					float4 fadeCol = tex2D(_FadeoutTexture, i.uv);


					return lerp(col,fadeCol, _FadeoutFactor);
			}
			ENDCG
		}
		}
}
