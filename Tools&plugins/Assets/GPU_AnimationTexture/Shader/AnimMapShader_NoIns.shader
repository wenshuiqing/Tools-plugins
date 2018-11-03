
Shader "ZHT/AnimMapShader_NoIns"
{
	Properties
	{
		_Color("Color", Color) = (0.5,0.5,0.5,1)
		_SkinChangeColor("SkinChangeColor", Color) = (0.5,0.5,0.5,1)
		_MainTex("MainTex", 2D) = "gray" {}
		_ShadowTex("ShadowTex", 2D) = "white" {}
		_RampTex("RampTex", 2D) = "white" {}
		_SkinShadowColor("SkinShadowColor", Color) = (0.5,0.5,0.5,1)
		_ShadowColor("ClothShadowColor", Color) = (0.5,0.5,0.5,1)
		_RimColor("RimColor", Color) = (0.5,0.5,0.5,1)
		_RimWidth("RimStrenth", Range(0, 2)) = 0.99
		_SpcStrenth("SpcStrenth", Range(0, 10)) = 0
		_InnerGlowRange("InnerGlowRange", Range(0, 2)) = 0
		_InnerGlowColor("InnerGlowColor", Color) = (0,0,0,1)
		_Fade("Fade", Float) = 0
		_selfluminous("self-luminous", Color) = (0,0,0,1)

		_AnimMap("AnimMap", 2D) = "white" {}
		_AnimLen("Anim Length", Float) = 0

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
#pragma multi_compile Quality_High_ON Quality_High_OFF
			#pragma multi_compile_fwdbase_fullshadows
#pragma only_renderers  d3d11 glcore gles3 metal 
#pragma target 3.0
			struct appdata
			{
				float4 vertex : POSITION;
				float3 normal : NORMAL;
				float2 texcoord0 : TEXCOORD0;
			};

			struct v2f
			{
				float4 pos : SV_POSITION;
				float2 uv0 : TEXCOORD0;
				float4 posWorld : TEXCOORD1;
				float3 normalDir : TEXCOORD2;
			};
			uniform sampler2D _AnimMap;
			uniform float4 _AnimMap_TexelSize;//x == 1/width
			uniform float _AnimLen;

			uniform float4 _LightColor0;
			uniform sampler2D _MainTex; uniform float4 _MainTex_ST;
			uniform sampler2D _RampTex; uniform float4 _RampTex_ST;
			uniform fixed4 _RimColor;
			uniform float4 _ShadowColor;
			uniform float4 _SkinShadowColor;
			uniform float4 _Color;
			uniform fixed _RimWidth;
			uniform sampler2D _ShadowTex; uniform float4 _ShadowTex_ST;
			uniform float4 _SkinChangeColor;
			uniform float _SpcStrenth;
			uniform float4 _InnerGlowColor;
			uniform float _InnerGlowRange;
			uniform float _Fade;
			uniform float4 _selfluminous;

			v2f vert(appdata v, uint vid : SV_VertexID)
			{
				v2f o;
				o.uv0 = v.texcoord0;
				o.normalDir = UnityObjectToWorldNormal(v.normal);
				o.posWorld = mul(unity_ObjectToWorld, v.vertex);
				float3 lightColor = _LightColor0.rgb;
				float f = _Time.y / _AnimLen;
				fmod(f, 1.0);
				float animMap_x = (vid + 0.5) * _AnimMap_TexelSize.x;
				float animMap_y = f;
				float4 pos = tex2Dlod(_AnimMap, float4(animMap_x, animMap_y, 0, 0));
				o.pos = UnityObjectToClipPos(pos);
				return o;
			}

			fixed4 frag(v2f i) : SV_Target
			{
				i.normalDir = normalize(i.normalDir);
			float3 viewDirection = normalize(_WorldSpaceCameraPos.xyz - i.posWorld.xyz);
			float3 normalDirection = i.normalDir;

			////// Lighting:
			////// Emissive:
			float3 brightConvertParam = float3(0.299,0.587,0.114);
			float fadeFactor = step(0.5,_Fade);
			float4 _MainTex_var = tex2D(_MainTex,TRANSFORM_TEX(i.uv0, _MainTex));


			float4 _MaskTex = tex2D(_ShadowTex,TRANSFORM_TEX(i.uv0, _ShadowTex));
			float3 skinChangeColor = (_SkinChangeColor.rgb*((_MainTex_var.rgb*_MaskTex.b)*2.0));
			float3 skinShadowColor = (_SkinShadowColor.rgb*skinChangeColor);
			float3 shadow_t = (_MainTex_var.rgb*(1.0 - _MaskTex.b));

			float3 lightDirection = normalize(_WorldSpaceLightPos0.xyz);
			half2 wrap_uv = float2(0.5*dot(lightDirection, normalDirection) + 0.5,0.5);
			float4 _RampR = tex2D(_RampTex,TRANSFORM_TEX(wrap_uv, _RampTex));
#ifdef Quality_High_ON

			float3 innerGlowCol0 = (_InnerGlowColor.rgb*(pow(1.0 - max(0,dot(normalDirection, viewDirection)),(2.0 - _InnerGlowRange))*step(0.01,_InnerGlowRange)));
			float2 viewNormal = (mul(UNITY_MATRIX_V, float4(normalDirection,0)).xy*0.5 + 0.5);
			float4 _RimTex = tex2D(_RampTex,TRANSFORM_TEX(viewNormal, _RampTex));
#endif

			float3 shadowColor = lerp((skinShadowColor * 2 + (_ShadowColor.rgb*shadow_t)),(skinChangeColor + shadow_t),(_MaskTex.g*_RampR.r*(normalDirection.g*0.25 + 0.75)));


			float3 node_64 = _LightColor0.rgb*((_Color.rgb*shadowColor)
#ifdef Quality_High_ON
				+ (_RimTex.g*_RimWidth*_RimColor.rgb) + (_MaskTex.r*_RimTex.b*_SpcStrenth) + (_MaskTex.a*_selfluminous.rgb)
#endif
				);

			float3 tempColor = node_64
#ifdef Quality_High_ON				
				+ innerGlowCol0
#endif
				;
			float brightNess = dot(tempColor, brightConvertParam);
			float3 finalColor = lerp(tempColor, float3(brightNess, brightNess, brightNess), fadeFactor);
			return fixed4(finalColor,1);
			}
			ENDCG
		}
		}
			FallBack "Shader Forge/sf-roleNew3"
}
