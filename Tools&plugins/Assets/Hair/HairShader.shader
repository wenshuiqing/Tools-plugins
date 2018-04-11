// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'


Shader "ShaderMe/HairShader" {
    Properties {
		_CutOff("Cutoff",Range(0, 1)) = 0.5
        _Color ("Color", Color) = (0.5,0.5,0.5,1)
		_MainTex("BaseRGB",2D) = "white" {}
		_Bump("Bump",2D) = "bump" {}


		_Tangent("Tangent", 2D) = "white" {}
		//_SpecMask("_SpecMask", 2D) = "white" {}
		//_AO("AO", 2D) = "white" {}
        _Specular ("SpecColor", Color) = (1,1,1,1)
		_SubColor("SubColor", Color) = (1,1,1,1)
		_Gloss("Gloss",Range(0, 1)) = 0.5
		_ScatterFactor("_ScatterFactor",Range(0, 1)) = 0.5
		_TangentParam("Tangent",Vector) = (1,0,0,1)
		_BlenfTangent("BlenfTangent",Range(0, 1)) = 0.5
    }
    SubShader {
		Tags{ "Queue" = "Transparent" "RenderType" = "TransparentCutout" }
        Pass {
            Name "FORWARD"
            Tags {
                "LightMode"="ForwardBase"
            }
			Cull Off
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #define UNITY_PASS_FORWARDBASE
            #include "UnityCG.cginc"
            #include "AutoLight.cginc"
            #include "Lighting.cginc"
            #pragma multi_compile_fwdbase_fullshadows
            #pragma multi_compile_fog
            #pragma exclude_renderers gles3 metal d3d11_9x xbox360 xboxone ps3 ps4 psp2 
            #pragma target 3.0
			uniform sampler2D _MainTex; uniform float4 _MainTex_ST;
			uniform sampler2D _Bump; uniform float4 _Bump_ST;
			uniform sampler2D _Tangent; uniform float4 _Tangent_ST;
			//uniform sampler2D _SpecMask; uniform float4 _SpecMask_ST;
			//uniform sampler2D _AO; uniform float4 _AO_ST;
			
            uniform float4 _Color;
			uniform float4 _Specular;
			uniform float4 _SubColor;
			float _Gloss;
			float _ScatterFactor;
			float4 _TangentParam;
			float _BlenfTangent;
			float _CutOff;
            struct VertexInput {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float2 texcoord0 : TEXCOORD0;
				float4 tangent:TANGENT;
            };
            struct VertexOutput {
                float4 pos : SV_POSITION;
                float2 uv0 : TEXCOORD0;
                float4 posWorld : TEXCOORD1;
                float3 normalDir : TEXCOORD2;
				float3 tangentDir :TEXCOORD3;
				float3 bitangentDir : TEXCOORD4;
				LIGHTING_COORDS(5, 6)
				UNITY_FOG_COORDS(7)
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.uv0 = v.texcoord0;
                o.normalDir = normalize(UnityObjectToWorldNormal(v.normal));
                o.posWorld = mul(unity_ObjectToWorld, v.vertex);
                o.pos = UnityObjectToClipPos(v.vertex );
				o.tangentDir = normalize(mul(unity_ObjectToWorld, float4(v.tangent.xyz, 0.0)).xyz);
				o.bitangentDir = normalize(cross(o.normalDir, o.tangentDir) * v.tangent.w);
				UNITY_TRANSFER_FOG(o, o.pos);
				TRANSFER_VERTEX_TO_FRAGMENT(o)
                return o;
            }


			float StrandSpecular(float3 T, float3 V, float3 L, float exponent)
			{
				float3 H = normalize(L + V);
				float dotTH = dot(T, H);
				float sinTH = sqrt(1 - dotTH*dotTH);
				float dirAtten = smoothstep(-1, 0, dotTH);

				return dirAtten*pow(sinTH, exponent);
			}
			float4 HairLighting(float3 T, float3 N, float3 L, float3 V, float2 uv, float3 lightColor)
			{

				float diffuse = saturate(lerp(0.25, 1.0, dot(N, L)))*lightColor;
				float3 indirectDiffuse = float3(0, 0, 0);
				indirectDiffuse += UNITY_LIGHTMODEL_AMBIENT.rgb; // Ambient Light

				float3 H = normalize(L + V);
				float LdotH = saturate(dot(L, H));
				float3 specular = _Specular*StrandSpecular(T, V, L, exp2(lerp(1, 11, _Gloss)));
				//float specMask = tex2D(_SpecMask, TRANSFORM_TEX(uv, _SpecMask));
				specular += /*specMask*/_SubColor*StrandSpecular(T, V, L, exp2(lerp(1, 11, _ScatterFactor)));


				float4 final;
				float4 base = tex2D(_MainTex, TRANSFORM_TEX(uv, _MainTex));
				float3 diffuseColor = (_Color.rgb*base.rgb);
				//float ao = tex2D(_AO, TRANSFORM_TEX(uv, _AO)).g;
				final.rgb = (diffuse + indirectDiffuse)*diffuseColor + specular*lightColor* FresnelTerm(_Specular, LdotH);
				//final.rgb *= ao;
				final.a = base.a;
				clip(final.a - _CutOff);
				return final;
			}

            float4 frag(VertexOutput i) : COLOR {
				float3x3 tangentTransform = float3x3(i.tangentDir, i.bitangentDir, i.normalDir);
				float3 _Bump_var = UnpackNormal(tex2D(_Bump, TRANSFORM_TEX(i.uv0, _Bump)));
				float3 _T_var = UnpackNormal(tex2D(_Tangent, TRANSFORM_TEX(i.uv0, _Tangent)));
				float3 temp = lerp(_TangentParam.xyz, _T_var, _BlenfTangent);
				float3 T = normalize(mul(float3(temp.xy,0), tangentTransform));
				float3 normalLocal = _Bump_var.rgb;
				float3 normalDirection = normalize(mul(normalLocal, tangentTransform));

				float3 lightDirection = normalize(UnityWorldSpaceLightDir(i.posWorld.xyz));
				float3 viewDirection = normalize(_WorldSpaceCameraPos.xyz - i.posWorld.xyz);
				float attenuation = LIGHT_ATTENUATION(i);
				float3 lightColor = attenuation * _LightColor0.xyz;

				float4 finalRGBA = HairLighting(T, normalDirection, lightDirection, viewDirection,i.uv0, lightColor);
				return finalRGBA;
            }
            ENDCG
        }
		Pass{
			Name "FORWARD"
			Tags{
			"LightMode" = "ForwardBase"
		}
			Blend SrcAlpha OneMinusSrcAlpha
			ZWrite Off

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#define UNITY_PASS_FORWARDBASE
			#include "UnityCG.cginc"
			#include "AutoLight.cginc"
			#include "Lighting.cginc"
			#pragma multi_compile_fwdbase_fullshadows
			#pragma multi_compile_fog
			#pragma exclude_renderers gles3 metal d3d11_9x xbox360 xboxone ps3 ps4 psp2 
			#pragma target 3.0
			uniform sampler2D _MainTex; uniform float4 _MainTex_ST;
		uniform sampler2D _Bump; uniform float4 _Bump_ST;

		uniform sampler2D _Tangent; uniform float4 _Tangent_ST;
		uniform sampler2D _ShiftTex; uniform float4 _ShiftTex_ST;
		//uniform sampler2D _SpecMask; uniform float4 _SpecMask_ST;
		//uniform sampler2D _AO; uniform float4 _AO_ST;

		uniform float4 _Color;
		uniform float4 _Specular;
		uniform float4 _SubColor;
		float _Gloss;
		float _ScatterFactor;
		float4 _TangentParam;
		float _BlenfTangent;
		struct VertexInput
		{
			float4 vertex : POSITION;
			float3 normal : NORMAL;
			float2 texcoord0 : TEXCOORD0;
			float4 tangent:TANGENT;
		};
		struct VertexOutput
		{
			float4 pos : SV_POSITION;
			float2 uv0 : TEXCOORD0;
			float4 posWorld : TEXCOORD1;
			float3 normalDir : TEXCOORD2;
			float3 tangentDir :TEXCOORD3;
			float3 bitangentDir : TEXCOORD4;
			LIGHTING_COORDS(5, 6)
			UNITY_FOG_COORDS(7)

		};
		VertexOutput vert(VertexInput v)
		{
			VertexOutput o = (VertexOutput)0;
			o.uv0 = v.texcoord0;
			o.normalDir = normalize(UnityObjectToWorldNormal(v.normal));
			o.posWorld = mul(unity_ObjectToWorld, v.vertex);
			o.pos = UnityObjectToClipPos(v.vertex);
			o.tangentDir = normalize(mul(unity_ObjectToWorld, float4(v.tangent.xyz, 0.0)).xyz);
			o.bitangentDir = normalize(cross(o.normalDir, o.tangentDir) * v.tangent.w);
			UNITY_TRANSFER_FOG(o, o.pos);
			TRANSFER_VERTEX_TO_FRAGMENT(o)
			return o;
		}

		float StrandSpecular(float3 T, float3 V, float3 L, float exponent)
		{
			float3 H = normalize(L + V);
			float dotTH = dot(T, H);
			float sinTH = sqrt(1 - dotTH*dotTH);
			float dirAtten = smoothstep(-1, 0, dotTH);

			return dirAtten*pow(sinTH, exponent);
		}
		float4 HairLighting(float3 T, float3 N, float3 L, float3 V, float2 uv, float3 lightColor)
		{
		
			float diffuse = saturate(lerp(0.25, 1.0, dot(N, L)))*lightColor;
			float3 indirectDiffuse = float3(0, 0, 0);
			indirectDiffuse += UNITY_LIGHTMODEL_AMBIENT.rgb; // Ambient Light

			float3 H = normalize(L + V);
			float LdotH = saturate(dot(L, H));
			float3 specular = _Specular*StrandSpecular(T, V, L, exp2(lerp(1, 11, _Gloss)));
			//float specMask = tex2D(_SpecMask, TRANSFORM_TEX(uv, _SpecMask));
			specular += /*specMask*/_SubColor*StrandSpecular(T, V, L, exp2(lerp(1, 11, _ScatterFactor)));


			float4 final;
			float4 base = tex2D(_MainTex, TRANSFORM_TEX(uv, _MainTex));
			float3 diffuseColor = (_Color.rgb*base.rgb);
			//float ao = tex2D(_AO, TRANSFORM_TEX(uv, _AO)).g;
			final.rgb = (diffuse + indirectDiffuse)*diffuseColor + specular*lightColor* FresnelTerm(_Specular, LdotH);
			//final.rgb *= ao;
			final.a = base.a;
			return final;
		}

		float4 frag(VertexOutput i) : COLOR{
			float3x3 tangentTransform = float3x3(i.tangentDir, i.bitangentDir, i.normalDir);
			float3 _Bump_var = UnpackNormal(tex2D(_Bump, TRANSFORM_TEX(i.uv0, _Bump)));
			float3 _T_var = UnpackNormal(tex2D(_Tangent, TRANSFORM_TEX(i.uv0, _Tangent)));
			float3 temp = lerp(_TangentParam.xyz, _T_var, _BlenfTangent);
			float3 T = normalize(mul(float3(temp.xy,0), tangentTransform));
			float3 normalLocal = _Bump_var.rgb;
			float3 normalDirection = normalize(mul(normalLocal, tangentTransform));

			float3 lightDirection = normalize(UnityWorldSpaceLightDir(i.posWorld.xyz));
			float3 viewDirection = normalize(_WorldSpaceCameraPos.xyz - i.posWorld.xyz);
			float attenuation = LIGHT_ATTENUATION(i);
			float3 lightColor = attenuation * _LightColor0.xyz;

			float4 finalRGBA = HairLighting(T, normalDirection, lightDirection, viewDirection,i.uv0, lightColor);
			return finalRGBA;
		}
			ENDCG
		}
    }
    FallBack "Diffuse"
}
