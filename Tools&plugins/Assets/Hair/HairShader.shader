
Shader "Shader Forge/HairShader" {
    Properties {
		_Base("BaseRGB",2D) = "white" {}
		_Bump("_Bump",2D) = "bump" {}
		_ShiftTex("_ShiftTex", 2D) = "white" {}
		_SpecMask("_SpecMask", 2D) = "white" {}
		//_Alpha("_Alpha", 2D) = "white" {}
        _Color ("Color", Color) = (0.5,0.5,0.5,1)
		_PrimaryShift("_PrimaryShift", Float) = 0.5
		_SencondaryShift("_SencondaryShift", Float) = 0.5
        _SpecColor1 ("Spec Color1", Color) = (1,1,1,1)
		_SpecColor2("Spec Color2", Color) = (1,1,1,1)
		_Exponent1("_Exponent1",Range(0, 1)) = 0.5
		_Exponent2("_Exponent2",Range(0, 1)) = 0.5
		_CutOff("Cutoff",Range(0, 1)) = 0.5
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
			uniform sampler2D _Base; uniform float4 _Base_ST;
			uniform sampler2D _Bump; uniform float4 _Bump_ST;
		

            uniform sampler2D _ShiftTex; uniform float4 _ShiftTex_ST;
			uniform sampler2D _SpecMask; uniform float4 _SpecMask_ST;
			//uniform sampler2D _Alpha; uniform float4 _Alpha_ST;
			
            uniform float4 _Color;
            uniform float _PrimaryShift;
			uniform float _SencondaryShift;
			uniform float4 _SpecColor1;
			uniform float4 _SpecColor2;
			float _Exponent1;
			float _Exponent2;
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

            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.uv0 = v.texcoord0;
                o.normalDir = normalize(UnityObjectToWorldNormal(v.normal));
                o.posWorld = mul(unity_ObjectToWorld, v.vertex);
                o.pos = mul(UNITY_MATRIX_MVP, v.vertex );
				o.tangentDir = normalize(mul(unity_ObjectToWorld, float4(v.tangent.xyz, 0.0)).xyz);
				o.bitangentDir = normalize(cross(o.normalDir, o.tangentDir) * v.tangent.w);
                return o;
            }

			float3 ShiftTangent(float3 T,float3 N,float shift)
			{
				return normalize(T + N*shift);
			}

			float StrandSpecular(float3 T, float3 V, float3 L, float exponent)
			{
				float3 H = normalize(L + V);
				float dotTH = dot(T, H);
				float sinTH = sqrt(1 - dotTH*dotTH);
				float dirAtten = smoothstep(-1, 0, dotTH);

				return dirAtten*pow(sinTH, exponent);
			}
			float4 HairLighting(float3 T, float3 N, float3 L, float3 V, float2 uv)
			{
				float shiftTex = tex2D(_ShiftTex, TRANSFORM_TEX(uv, _ShiftTex))-0.5;
				float3 t1 = ShiftTangent(T, N, _PrimaryShift + shiftTex);
				float3 t2 = ShiftTangent(T, N, _SencondaryShift + shiftTex);

				float diffuse = saturate(lerp(0.25, 1.0, dot(N, L)));

				float3 specular = _SpecColor1*StrandSpecular(t1, V, L, exp2(lerp(1, 11, _Exponent1)));
				float specMask = tex2D(_SpecMask, TRANSFORM_TEX(uv, _SpecMask));
				specular+= specMask*_SpecColor2*StrandSpecular(t2, V, L, exp2(lerp(1, 11, _Exponent2)) );

				float4 final;
				float4 base = tex2D(_Base, TRANSFORM_TEX(uv, _Base));
				final.rgb = (diffuse + specular)*base.rgb *_LightColor0.rgb*_Color.rgb+ base.rgb * 0.4;

				final.a = base.a;
				clip(final.a - _CutOff);
				return final;
			}

            float4 frag(VertexOutput i) : COLOR {
				float3x3 tangentTransform = float3x3(i.tangentDir, i.bitangentDir, i.normalDir);
				float4 _Bump_var = tex2D(_Bump, TRANSFORM_TEX(i.uv0, _Bump));
				float3 normalLocal = _Bump_var.rgb;
				float3 normalDirection = normalize(mul(normalLocal, tangentTransform)); 

                float3 lightDirection = normalize(UnityWorldSpaceLightDir(i.posWorld.xyz));
                float3 viewDirection = normalize(_WorldSpaceCameraPos.xyz - i.posWorld.xyz);

				float4 finalRGBA = HairLighting(i.tangentDir, normalDirection, lightDirection, viewDirection,i.uv0);
				//finalRGBA.rgb = normalDirection;
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
			uniform sampler2D _Base; uniform float4 _Base_ST;
		uniform sampler2D _Bump; uniform float4 _Bump_ST;


		uniform sampler2D _ShiftTex; uniform float4 _ShiftTex_ST;
		uniform sampler2D _SpecMask; uniform float4 _SpecMask_ST;
		//uniform sampler2D _Alpha; uniform float4 _Alpha_ST;

		uniform float4 _Color;
		uniform float _PrimaryShift;
		uniform float _SencondaryShift;
		uniform float4 _SpecColor1;
		uniform float4 _SpecColor2;
		float _Exponent1;
		float _Exponent2;
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

		};
		VertexOutput vert(VertexInput v)
		{
			VertexOutput o = (VertexOutput)0;
			o.uv0 = v.texcoord0;
			o.normalDir = normalize(UnityObjectToWorldNormal(v.normal));
			o.posWorld = mul(unity_ObjectToWorld, v.vertex);
			o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
			o.tangentDir = normalize(mul(unity_ObjectToWorld, float4(v.tangent.xyz, 0.0)).xyz);
			o.bitangentDir = normalize(cross(o.normalDir, o.tangentDir) * v.tangent.w);
			return o;
		}

		float3 ShiftTangent(float3 T,float3 N,float shift)
		{
			return normalize(T + N*shift);
		}

		float StrandSpecular(float3 T, float3 V, float3 L, float exponent)
		{
			float3 H = normalize(L + V);
			float dotTH = dot(T, H);
			float sinTH = sqrt(1 - dotTH*dotTH);
			float dirAtten = smoothstep(-1, 0, dotTH);

			return dirAtten*pow(sinTH, exponent);
		}
		float4 HairLighting(float3 T, float3 N, float3 L, float3 V, float2 uv)
		{
			float shiftTex = tex2D(_ShiftTex, TRANSFORM_TEX(uv, _ShiftTex)) - 0.5;
			float3 t1 = ShiftTangent(T, N, _PrimaryShift + shiftTex);
			float3 t2 = ShiftTangent(T, N, _SencondaryShift + shiftTex);

			float diffuse = saturate(lerp(0.25, 1.0, dot(N, L)));
			diffuse *= _Color;

			float3 specular = _SpecColor1*StrandSpecular(t1, V, L, exp2(lerp(1, 11, _Exponent1)));
			float specMask = tex2D(_SpecMask, TRANSFORM_TEX(uv, _SpecMask));
			specular += specMask*_SpecColor2*StrandSpecular(t2, V, L, exp2(lerp(1, 11, _Exponent2)));


			float4 final;
			float4 base = tex2D(_Base, TRANSFORM_TEX(uv, _Base));
			final.rgb = (diffuse + specular)*base.rgb *_LightColor0.rgb + base.rgb * 0.4;

			final.a = base.a;
			return final;
		}

		float4 frag(VertexOutput i) : COLOR{
			float3x3 tangentTransform = float3x3(i.tangentDir, i.bitangentDir, i.normalDir);
			float4 _Bump_var = tex2D(_Bump, TRANSFORM_TEX(i.uv0, _Bump));
			float3 normalLocal = _Bump_var.rgb;
			float3 normalDirection = normalize(mul(normalLocal, tangentTransform));

			float3 lightDirection = normalize(UnityWorldSpaceLightDir(i.posWorld.xyz));
			float3 viewDirection = normalize(_WorldSpaceCameraPos.xyz - i.posWorld.xyz);

			float4 finalRGBA = HairLighting(i.tangentDir, normalDirection, lightDirection, viewDirection,i.uv0);

			return finalRGBA;
		}
			ENDCG
		}
    }
    FallBack "Diffuse"
}
