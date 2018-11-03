// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

Shader "Consume/LeafAnim" {
	Properties{
		_MainTex("Base (RGB)", 2D) = "white" {}
		_Dist("_Dist", float) = 0.04
		_Speed("_Speed", float) = 0.2
	}

		SubShader{
		Tags{ "IgnoreProjector" = "True" "RenderType" = "Transparent" }
		LOD 350

		CGPROGRAM
#pragma surface surf Lambert vertex:vert  

		sampler2D _MainTex;

	struct Input {
		half2 uv_MainTex;
	};

	fixed _Dist;
	fixed _Speed;

	struct appdata_t {
		float4 vertex : POSITION;
		float2 texcoord : TEXCOORD0;
		float3 normal : NORMAL;
	};

	void vert(inout appdata_t v)
	{
		float4 vertex = mul(v.vertex, unity_ObjectToWorld);
		float a = vertex.x * vertex.z;//沿x和z轴距离作为偏离的一个依据，这样各个地方的叶子偏离的大小就不同，就“摇曳”起来了。
									  //通过偏移顶点让叶子摇动起来
		v.vertex.xyz += float3(1,0,1) * _Dist * sin(_Time.w * (_Speed)+a);//dist是整体偏离放大缩小倍数，用Time.w做循环，sin做距离约束
	}
	void surf(Input IN, inout SurfaceOutput o)
	{
		fixed4 c = tex2D(_MainTex, IN.uv_MainTex);
		o.Albedo = c.rgb;
		o.Alpha = c.a;
	}
	ENDCG
	}

		Fallback "Transparent/VertexLit"
}