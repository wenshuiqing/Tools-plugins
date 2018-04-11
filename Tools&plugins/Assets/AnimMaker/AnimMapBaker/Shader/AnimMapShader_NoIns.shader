
Shader "chenjd/AnimMapShader_NoIns"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_AnimMap ("AnimMap", 2D) ="white" {}
		_AnimLen("Anim Length", Float) = 0
	}
		SubShader
		{
			Tags { "RenderType" = "Opaque" }
			LOD 100
			Cull off

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma only_renderers d3d9 d3d11 glcore gles gles3 metal 
			#pragma target 3.0
			#include "UnityCG.cginc"

			struct appdata
			{
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;

			sampler2D _AnimMap;
			float4 _AnimMap_TexelSize;//x == 1/width

			float _AnimLen;

			
			v2f vert (appdata v, uint vid : SV_VertexID)
			{
				float f = _Time.y / _AnimLen;

				fmod(f, 1.0);

				float animMap_x = (vid + 0.5) * _AnimMap_TexelSize.x;
				float animMap_y = f;

				float4 pos = tex2Dlod(_AnimMap, float4(animMap_x, animMap_y, 0, 0));

				v2f o;
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				o.vertex = UnityObjectToClipPos(pos);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				fixed4 col = tex2D(_MainTex, i.uv);
				return col;
			}
			ENDCG
		}
	}
}
