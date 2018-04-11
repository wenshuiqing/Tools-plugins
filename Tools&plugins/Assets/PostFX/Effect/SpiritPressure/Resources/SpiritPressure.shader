Shader "Hidden/SpiritPressure"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_LineTex1("_LineTex1", 2D) = "white" {}
		_LineTex2("_LineTex2", 2D) = "white" {}
		_Flags("_Flags", 2D) = "white" {}
		_ShakeFactor("xy(实体的振幅和频率),zw(虚影的振幅和频率)",Vector)=(0.01,20,0.0125,20)

		_LineFactor("xy(振幅和频率)",Vector)= (10,20,0,0)
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
			sampler2D _MainTex;
		float4 _MainTex_TexelSize;
			sampler2D _LineTex1;
			float4 _LineTex1_ST;
			sampler2D _LineTex2;
			float4 _LineTex2_ST;
			sampler2D _Flags;
			float4 _ShakeFactor;
			float4 _LineFactor;
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

			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = mul(UNITY_MATRIX_MVP, v.vertex);
				o.uv.xy = v.uv;

#if UNITY_UV_STARTS_AT_TOP
				if (_MainTex_TexelSize.y < 0)
				{
					o.uv.y = 1 - o.uv.y;
				}
#endif
				return o;
			}
			

			fixed4 frag (v2f i) : SV_Target
			{
				float x1 = _ShakeFactor.x*sin(_Time.y * _ShakeFactor.y);
				float x2 = _ShakeFactor.z*sin(_Time.y * _ShakeFactor.w);

				float3 mainRGB = tex2D(_MainTex, i.uv + float2(x1, 0)).rgb;
				float3 shadowRGB = tex2D(_MainTex, i.uv + float2(x2, 0)).rgb;


				float y = _LineFactor.x*sin(_Time.y * _LineFactor.y);
				float2 lineUV1 = TRANSFORM_TEX(i.uv, _LineTex1);
				float2 lineUV2 = TRANSFORM_TEX(i.uv, _LineTex2);
				float3 lineRGB1 = tex2D(_LineTex1, lineUV1+float2(0, y)).rgb;
				float3 lineRGB2 = tex2D(_LineTex2, lineUV2+ float2(0, -y)).rgb;

				float3 average = (lineRGB1 + lineRGB2) / 2;

				float2 uv = i.uv;
				
				float flag = tex2D(_Flags, uv).a;


				float3 emissive = (mainRGB*0.7 + shadowRGB*0.3)* average*flag+ (mainRGB*0.7 + shadowRGB*0.3)*(1-flag);
				float3 finalColor = emissive;
				return fixed4(finalColor,1);
			}
			ENDCG
		}
	}
}
