// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "ZHT/ShadowGS"
{
	Properties
	{
		_ShadowColor("Color", Color) = (0.5,0.5,0.5,1)
		_PlanarHeight("Ground Height",float) = 0
		_AnimMap("AnimMap", 2D) = "white" {}
	_AnimLen("Anim Length", Float) = 0
	}
		SubShader
	{
		Tags{ "RenderType" = "Transparent"
		"Queue" = "Transparent" }
		Pass
	{
		Name "FORWARD"
		Tags{ "LightMode" = "ForwardBase" }
		Stencil
	{
		Ref 0
		Comp Equal
		Pass IncrWrap
		ZFail Keep
	}

		zwrite on
		cull front
		blend srcalpha oneminussrcalpha

		CGPROGRAM
#pragma vertex vert
#pragma fragment frag
#include "UnityCG.cginc"
#include "AutoLight.cginc"
#include "Lighting.cginc"
#pragma only_renderers  d3d11 glcore gles3 metal 
#pragma target 3.0
		uniform sampler2D _AnimMap;
	uniform float4 _AnimMap_TexelSize;//x == 1/width
	uniform float _AnimLen;
		uniform float4 _ShadowColor;
		float _PlanarHeight;
		struct VertexInput
	{
		float4 vertex : POSITION;
	};
	struct VertexOutput
	{
		float4 pos : SV_POSITION;
	};

	VertexOutput vert(VertexInput v, uint vid : SV_VertexID)
	{
		VertexOutput o = (VertexOutput)0;

		float3 lightColor = _LightColor0.rgb;
		float f = _Time.y / _AnimLen;
		fmod(f, 1.0);
		float animMap_x = (vid + 0.5) * _AnimMap_TexelSize.x;
		float animMap_y = f;
		float4 pos = tex2Dlod(_AnimMap, float4(animMap_x, animMap_y, 0, 0));

		float4 worldPos = mul(unity_ObjectToWorld, pos);

		float3 worldLightDir = normalize(UnityWorldSpaceLightDir(worldPos));
		float k = (_PlanarHeight - worldPos.y) / worldLightDir.y;
		float4 vt = worldPos;
		vt.xz = vt.xz + worldLightDir.xz * k;
		vt.y = _PlanarHeight;
		vt = mul(unity_WorldToObject, vt);

		o.pos = UnityObjectToClipPos(vt);
		return o;
	}

	float4 frag(VertexOutput i) : COLOR
	{
		return _ShadowColor;
	}
		ENDCG
	}
	}
		FallBack "Custom/SimpleShadow"
}