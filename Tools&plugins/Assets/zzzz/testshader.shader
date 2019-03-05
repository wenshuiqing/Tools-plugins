// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "ApcShader/XRayEffect"
{
	Properties
	{
		_MainTex("Base 2D", 2D) = "white"{}
	}

		SubShader
	{
		Tags{ "Queue" = "Geometry" "RenderType" = "Opaque" }

		//渲染X光效果的Pass
		Pass
		{
			Blend SrcAlpha One
			ZWrite Off
			ZTest Greater

			CGPROGRAM
			#include "Lighting.cginc"
			struct v2f
			{
				float4 pos : SV_POSITION;
			};

			v2f vert(appdata_base v)
			{
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);
				return o;
			}

			fixed4 frag(v2f i) : SV_Target
			{
				return fixed4(1,1,1,0.5);
			}
			#pragma vertex vert
			#pragma fragment frag
			ENDCG
		}

		//正常渲染的Pass
		Pass
		{
			ZWrite On
			CGPROGRAM
			#include "Lighting.cginc"
			sampler2D _MainTex;
			float4 _MainTex_ST;

			struct v2f
			{
				float4 pos : SV_POSITION;
				float2 uv : TEXCOORD1;
			};

			v2f vert(appdata_base v)
			{
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.texcoord, _MainTex);
				return o;
			}

			fixed4 frag(v2f i) : SV_Target
			{
				return tex2D(_MainTex, i.uv);
			}

			#pragma vertex vert
			#pragma fragment frag	
			ENDCG
		}
	}

		FallBack "Diffuse"
}