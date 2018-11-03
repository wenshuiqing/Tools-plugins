Shader "ZHT/FogTest"
{
	Properties
	{
		_Color("Color",Color)=(1,1,1,1)
		_MainTex ("Texture", 2D) = "white" {}
		_NearDis("NearDis",Float)=10
		_FarDis("FarDis",Float)=100
		_Hstart("Start",Float)=0
		_Hend("End",Float)=100
	}
	SubShader
	{
		Tags { "RenderType"="Opaque" }
		LOD 100

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 texcoord : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float3 vPos:TEXCOORD1;
				float3 wPos:TEXCOORD2;
				float4 pos : SV_POSITION;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			float4 _Color;
			float _NearDis;
			float _FarDis;
			float _Hstart;
			float _Hend;
			v2f vert (appdata v)
			{
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.texcoord, _MainTex);
				o.vPos = UnityObjectToViewPos(v.vertex);
				o.wPos = mul(unity_ObjectToWorld,v.vertex);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				float t = 1-(_FarDis-abs(i.vPos.z))/(_FarDis-_NearDis);
				float s = (_Hend-i.wPos.y)/(_Hend-_Hstart);

				fixed4 col = tex2D(_MainTex, i.uv);

				fixed4 fincol = (lerp(col,_Color,s*t));
				return fincol;
			}
			ENDCG
		}
	}
}
