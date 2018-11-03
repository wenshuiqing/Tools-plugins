// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

Shader "ZHT/SnowTest2"
{
	Properties
	{
		_Color("Color",Color) = (1,1,1,1)
		_MainTex ("Texture", 2D) = "white" {}
		_BumpMap("NormalMap",2D) = "bump"{}
		_Specular("Specular",Color)=(1,1,1,1)
		_Gloss("Gloss",Range(8,256))=20

		_SnowTex("SnowTex",2D)="white"{}
		_SnowColor("SnowColor",Color) = (1,1,1,1)
		_Param("Param",Range(0,1))=0.5
		_NoiseTex("NoiseTex",2D)="white"{}
		
	}
	SubShader
	{
		Tags { "RenderType"="Opaque" }
		LOD 100

		Pass
		{
			Tags{"LightMode"="ForwardBase"}
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
	
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			struct appdata
			{
				float4 vertex : POSITION;
				float4 tangent:TANGENT;
				float3 normal:NORMAL;
				float2 texcoord : TEXCOORD0;
			};

			struct v2f
			{
				float4 pos : SV_POSITION;
				float4 uv : TEXCOORD0;
				float4 worldPos :TEXCOORD1;
				float3 worldNormal:TEXCOORD2;
				float3 worldTangent :TEXCOORD3;
				float3 bTangent :TEXCOORD4;
				float2 uv1 : TEXCOORD5;
			};

			float4 _Color;
			sampler2D _MainTex;
			float4 _MainTex_ST;
			sampler2D _BumpMap;
			float4 _BumpMap_ST;
			float4 _Specular;
			float _Gloss;
			float _Param;
			sampler2D _SnowTex;
			float4 _SnowColor;
			sampler2D _NoiseTex;
			float4 _NoiseTex_ST;

			v2f vert (appdata v)
			{
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);
				o.uv.xy = TRANSFORM_TEX(v.texcoord, _MainTex);
				o.uv.zw = TRANSFORM_TEX(v.texcoord, _BumpMap);
				o.uv1 = TRANSFORM_TEX(v.texcoord, _NoiseTex);
				o.worldPos = mul(unity_ObjectToWorld,v.vertex);
				o.worldNormal =normalize(UnityObjectToWorldNormal(v.normal));
				o.worldTangent = normalize(UnityObjectToWorldDir(v.tangent).xyz);
				o.bTangent = normalize(cross(o.worldNormal,o.worldTangent)*v.tangent.w);

				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{								
				float3x3 tTow = float3x3(i.worldTangent.x,i.bTangent.x,i.worldNormal.x,
										i.worldTangent.y,i.bTangent.y,i.worldNormal.y,
										i.worldTangent.z,i.bTangent.z,i.worldNormal.z);
			
				float3 tNormal = UnpackNormal(tex2D(_BumpMap,i.uv.zw));
				float3 bump =normalize(mul(tTow,tNormal));
				float3 lightDir = normalize(UnityWorldSpaceLightDir(i.worldPos));
				float3 viewDir = normalize(UnityWorldSpaceViewDir(i.worldPos));

				fixed4 texCol = tex2D(_MainTex, i.uv.xy);

				fixed3 albedo = texCol.rgb*_Color.rgb;

				fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.rgb*albedo;

				fixed3 diffuse = _LightColor0.rgb*albedo*max(0,dot(bump,lightDir));

				fixed3 halfDir = normalize(viewDir+lightDir);
				fixed3 specular = _LightColor0.rgb*_Specular.rgb*pow(max(0,dot(bump,halfDir)),_Gloss);


				float noise = tex2D(_NoiseTex,i.uv1).r;


				noise += texCol.a;//高度和噪声的叠加
				noise /= 2;
				float s =1-saturate(noise-_Param);//高度和噪声共同影响的结果
				float t = 1-smoothstep(0.8,1,s);//平滑雪的边缘


				fixed3 scol =(ambient+diffuse+specular);
				fixed3 snowCol = tex2D(_SnowTex,i.uv.xy).rgb*_SnowColor.rgb;



				fixed4 finCol =fixed4(lerp(snowCol,scol,t),1);
				return finCol;
			}
			ENDCG
		}
	}
}
