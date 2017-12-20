Shader "HairShader"
{
	Properties
	{
		_MainTex("Diffuse (RGB) Alpha (A)", 2D) = "white" {}
	_Color("Main Color", Color) = (0,0,0,1)
		_SpecularTex("Specular (R) Gloss (G) Anisotropic Mask (B)", 2D) = "gray" {}
	_SpecularMultiplierT("Specular Multiplier T", float) = 5.0
		_SpecularMultiplierN("Specular Multiplier N", float) = 10.0
		_SpecularColor("Specular Color", Color) = (0.5,0.5,0.5,1)
		_Cutoff("Alpha Cut-Off Threshold", float) = 0.5
		_GlossInterp("Gloss Interploter", Range(-1,1)) = 0
		_WaveSpeed("Wave Speed", Vector) = (1,1,1,1)
		_WaveSize("Wave Size", float) = 0.1
		_WavePhase("Wave Phase", float) = 0.02
	}

		SubShader
	{
		Tags{ "Queue" = "Geometry" "IgnoreProjector" = "True" "RenderType" = "TransparentCutout" }

		Cull Off
		ZWrite On
		ZTest LEqual

		CGPROGRAM
#pragma surface surf Aniso vertex:vert
#pragma target 3.0

		struct SurfaceOutputAniso
	{
		fixed3 Albedo;
		fixed3 Normal;
		fixed3 Emission;
		half Specular;
		fixed Gloss;
		fixed Alpha;
		fixed AnisoMask;

		half3 tangentV;
	};

	struct Input
	{
		float2 uv_MainTex;
		half3 tangentV;
	};


	float4 _WaveSpeed;
	float _WaveSize;
	float _WavePhase;

	void vert(inout appdata_full v, out Input o)
	{
		UNITY_INITIALIZE_OUTPUT(Input, o);

		float3 waves = _WaveSize * v.tangent.xyz;
		float3 freq = _Time.y * _WaveSpeed.xyz;
		v.vertex.xyz += cos(freq + v.vertex.xyz * _WavePhase) * waves;
		o.tangentV = v.tangent.xyz;
	}


	sampler2D _MainTex, _SpecularTex;
	float _SpecularMultiplierT,_SpecularMultiplierN, _GlossInterp, _Cutoff;
	fixed4 _SpecularColor, _Color;

	void surf(Input IN, inout SurfaceOutputAniso o)
	{
		fixed4 albedo = tex2D(_MainTex, IN.uv_MainTex);
		o.Albedo = lerp(albedo.rgb,albedo.rgb*_Color.rgb,0.5);
		o.Alpha = albedo.a;
		clip(o.Alpha - _Cutoff);
		fixed3 spec = tex2D(_SpecularTex, IN.uv_MainTex).rgb;
		o.Specular = spec.r;
		o.Gloss = spec.g;
		o.AnisoMask = spec.b;
		o.tangentV = IN.tangentV;
	}

	inline fixed4 LightingAniso(SurfaceOutputAniso s, fixed3 lightDir, fixed3 viewDir, fixed atten)
	{
		half3 h = normalize(lightDir + viewDir);
		float NdotL = saturate(dot(s.Normal, lightDir));

		half3 T = normalize(cross(s.Normal, s.tangentV));
		half3 L = normalize(lightDir);
		half3 V = -normalize(viewDir);

		float sq1 = (1.0 - abs(dot(T, L)));
		float sq2 = (1.0 - abs(dot(T, V)));
		float aniso = abs(dot(T,L) * dot(s.Normal,V));
		aniso += sq1 * sq2;
		aniso = pow(aniso, _SpecularMultiplierT);

		float blinn = pow(dot(s.Normal, h), _SpecularMultiplierN) * s.Gloss;

		float spec = saturate(lerp(blinn, aniso, s.AnisoMask + _GlossInterp) * s.Specular) * _SpecularColor;

		fixed4 c;
		c.rgb = spec;
		c.a = s.Alpha;
		return c;
	}
	ENDCG


	}
		FallBack Off
}