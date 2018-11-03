// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

Shader "GOE/WaterEX"
{
	Properties
	{
		[Header(LightingSettings)]
		_LightColor("LightColor",Color) = (1,1,1,1)
		_LightDirection("LightDirection",Vector) = (1,1,1,1)
		_Frenel("_Frenel",Range(0,1)) = 0.4

		[Header(WaterSettings)]
		_Color("Color",Color) = (1,1,1,1)
		_ShallowColor("_ShallowColor",Color) = (1,1,1,1)
		_DeepColor("_DeepColor",Color) = (1,1,1,1)
		_DepthTex("_DepthTex", 2D) = "white" {}
		_BumpMap("NormalMap",2D) = "bump"{}
		_Specular("Specular",Color) = (1,1,1,1)
		_Gloss("Gloss",Range(8,2024)) = 20
		_Distortion("Distortion",Range(0,100)) = 10
		_WaterSpeedDir("_WaterSpeedDir",Vector)= (0,0,0,0)
	}
		SubShader
	{
		Tags{ "Queue" = "Geometry" "RenderType" = "Opaque" }
		LOD 100
		Pass
	{
		Tags{ "LightMode" = "ForwardBase" }
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
	};
	float4 _LightColor;
	float4 _LightDirection;
	float4 _Color;
	float4 _ShallowColor;
	float4 _DeepColor;
	sampler2D _DepthTex;
	float4 _DepthTex_ST;
	float4 _DepthTex_TexelSize;
	sampler2D _BumpMap;
	float4 _BumpMap_ST;
	float4 _Specular;
	float _Distortion;
	float4 _WaterSpeedDir;
	float _Gloss;
	float _Frenel;
	v2f vert(appdata v)
	{
		v2f o;
		o.pos = UnityObjectToClipPos(v.vertex);
		o.uv.xy = v.texcoord;
		o.uv.zw = v.texcoord;

		o.worldPos = mul(unity_ObjectToWorld,v.vertex);
		o.worldNormal = normalize(UnityObjectToWorldNormal(v.normal));
		o.worldTangent = normalize(UnityObjectToWorldDir(v.tangent).xyz);
		o.bTangent = normalize(cross(o.worldNormal,o.worldTangent)*v.tangent.w);

		return o;
	}

	fixed4 frag(v2f i) : SV_Target
	{
		float3x3 tTow = float3x3(i.worldTangent.x,i.bTangent.x,i.worldNormal.x,
		i.worldTangent.y,i.bTangent.y,i.worldNormal.y,
		i.worldTangent.z,i.bTangent.z,i.worldNormal.z);

		float2 speed1 = _Time.y*float2(_WaterSpeedDir.x, _WaterSpeedDir.y);
		float2 speed2 = _Time.y*float2(_WaterSpeedDir.z, _WaterSpeedDir.w);

		float3 tNormal1 = UnpackNormal(tex2D(_BumpMap, TRANSFORM_TEX(i.uv.zw, _BumpMap) + speed1));
		float3 tNormal2 = UnpackNormal(tex2D(_BumpMap, TRANSFORM_TEX(i.uv.zw, _BumpMap) - speed2));
		float3 tNormal = normalize(tNormal1 + tNormal2);

		float2 offset = tNormal.xy*_Distortion*_DepthTex_TexelSize.xy;
		float2 refuv = offset * 1 + i.uv.xy;

		float3 bump = normalize(mul(tTow, tNormal));
		float3 lightDir = normalize(_LightDirection.xyz);
		float3 viewDir = normalize(UnityWorldSpaceViewDir(i.worldPos));


		float depth = tex2D(_DepthTex, TRANSFORM_TEX(refuv, _DepthTex)).r;

		float3 waterColor = lerp(_ShallowColor.rgb, _DeepColor.rgb,1 - depth);


		fixed3 halfDir = normalize(viewDir + lightDir);
		fixed3 specular = _LightColor.rgb*_Specular.rgb*pow(max(0,dot(bump,halfDir)),_Gloss);
		fixed3 refCol = waterColor+specular;
		fixed fresnel = pow(1 - max(0,dot(viewDir,bump)),4);



		fixed4 col = fixed4(lerp(waterColor, refCol, _Frenel),1.0);
		col.rgb *= _Color.rgb;

	return col;
	}
		ENDCG
	}
	}
}
