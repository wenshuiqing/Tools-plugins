
Shader "ZHT/CameraMode"
{	Properties{
		_FLAG("FLAG (RGB)", Int) = 0
}
SubShader
{
	Tags { "RenderType" = "Opaque" }
	Pass
	{
		Name "FORWARD"
		Tags{
		"LightMode" = "ForwardBase"
		}
	CGPROGRAM
	#pragma vertex vert
	#pragma fragment frag
	#define UNITY_PASS_FORWARDBASE
	#include "UnityCG.cginc"
	#include "AutoLight.cginc"
	#pragma multi_compile_fwdbase_fullshadows
	#pragma only_renderers d3d9 d3d11 glcore gles gles3 metal 
	#pragma target 3.0
	struct appdata
	{
		float4 vertex : POSITION;
		float2 texcoord:TEXCOORD;
	};

	struct v2f
	{
		float4 pos : SV_POSITION;
		float2 uv:TEXCOORD0;
	};
	sampler2D _CameraDepthNormalsTexture;
	half4 _CameraDepthNormalsTexture_ST;

	sampler2D _CameraDepthTexture;
	half4 _CameraDepthTexture_ST;

	int _FLAG;
	v2f vert(appdata v)
	{
		v2f o;

		o.pos = UnityObjectToClipPos(v.vertex);
		o.uv = v.texcoord;
		return o;
	}

	fixed4 frag(v2f i) : SV_Target
	{
		half4 sample1 = tex2D(_CameraDepthNormalsTexture, i.uv);

		float d = Linear01Depth(tex2D(_CameraDepthTexture, UNITY_PROJ_COORD(i.pos)));
		if (_FLAG==0)
		{
			return d;
		}
		else if (_FLAG == 1)
		{
			return sample1;
		}
		else
		{
			return d + sample1;
		}
	}
	ENDCG
}
}
}
