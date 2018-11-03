// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'
// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Shader created with Shader Forge v1.30 
// Shader Forge (c) Neat Corporation / Joachim Holmer - http://www.acegikmo.com/shaderforge/
// Note: Manually altering this data may prevent you from opening it in Shader Forge
/*SF_DATA;ver:1.30;sub:START;pass:START;ps:flbk:,iptp:0,cusa:False,bamd:0,lico:1,lgpr:1,limd:1,spmd:1,trmd:0,grmd:0,uamb:True,mssp:True,bkdf:False,hqlp:False,rprd:False,enco:True,rmgx:True,rpth:0,vtps:0,hqsc:True,nrmq:1,nrsp:0,vomd:0,spxs:False,tesm:0,olmd:1,culm:0,bsrc:0,bdst:1,dpts:2,wrdp:True,dith:0,rfrpo:True,rfrpn:Refraction,coma:15,ufog:True,aust:True,igpj:False,qofs:0,qpre:1,rntp:1,fgom:False,fgoc:False,fgod:False,fgor:False,fgmd:0,fgcr:0.5,fgcg:0.5,fgcb:0.5,fgca:1,fgde:0.01,fgrn:0,fgrf:300,stcl:False,stva:128,stmr:255,stmw:255,stcp:6,stps:0,stfa:0,stfz:0,ofsf:0,ofsu:0,f2p0:False,fnsp:False,fnfb:False;n:type:ShaderForge.SFN_Final,id:4013,x:33093,y:32749,varname:node_4013,prsc:2|diff-7120-OUT,normal-5089-RGB;n:type:ShaderForge.SFN_Color,id:1304,x:32465,y:32624,ptovrint:False,ptlb:Color,ptin:_Color,varname:node_1304,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,c1:1,c2:1,c3:1,c4:1;n:type:ShaderForge.SFN_Tex2d,id:2777,x:32425,y:32816,ptovrint:False,ptlb:MainTex,ptin:_MainTex,varname:node_2777,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,ntxv:0,isnm:False;n:type:ShaderForge.SFN_Tex2d,id:5089,x:32592,y:33051,ptovrint:False,ptlb:Bump,ptin:_Bump,varname:node_5089,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,ntxv:3,isnm:True;n:type:ShaderForge.SFN_Multiply,id:7120,x:32740,y:32759,varname:node_7120,prsc:2|A-1304-RGB,B-2777-RGB;proporder:1304-5089-2777;pass:END;sub:END;*/

Shader "Shader Forge/Skin" {
    Properties {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("MainTex", 2D) = "white" {}
		_BumpMap("Bump", 2D) = "bump" {}
		_Translucency("Translucency (G) AO (A)", 2D) = "gray" {}
		_LookUp("Curvature",2D) = "white" {}
		[Header(Diffuse Bump Settings)]
		[Space(4)]
		_BumpBias("Diffuse Normal Map Blur Bias", Float) = 3.0
		_BlurStrength("Blur Strength", Range(0,1)) = 1.0

		[Header(Preintegrated Skin Lighting)]
		[Space(4)]
		_CurvatureInfluence("Curvature Influence", Range(0,1)) = 0.5
		_CurvatureScale("Curvature Scale", Float) = 0.02
		_Bias("Bias", Range(0,1)) = 0.0
		_Lux_Skin_DeepSubsurface("R(power),G(distort),B(scale)",Vector) = (0,0,0,0)
		_Smoothness("_Smoothness", Range(0,1)) = 0.5
		_SubColor("_SubColor",Color) = (1,1,1,1)
    }
    SubShader {
        Tags {
            "RenderType"="Opaque"
        }
        LOD 200
        Pass {
            Name "FORWARD"
            Tags {
                "LightMode"="ForwardBase"
            }
            
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #define UNITY_PASS_FORWARDBASE
            #include "UnityCG.cginc"
            #include "AutoLight.cginc"
            #pragma multi_compile_fwdbase_fullshadows
            #pragma multi_compile_fog
            #pragma exclude_renderers xbox360 xboxone ps3 ps4 psp2 
            #pragma target 3.0
            uniform float4 _LightColor0;
            uniform float4 _Color;
            uniform sampler2D _MainTex; uniform float4 _MainTex_ST;
            uniform sampler2D _BumpMap; uniform float4 _BumpMap_ST;
			uniform sampler2D _LookUp; uniform float4 _LookUp_ST;
			uniform sampler2D _Translucency; uniform float4 _Translucency_ST;
			
			float _BumpBias;
			float _BlurStrength;
			float _CurvatureScale;
			float _CurvatureInfluence;
			float _Bias;
			float _Smoothness;
			float4 _Lux_Skin_DeepSubsurface;
			float4 _SubColor;
            struct VertexInput {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float4 tangent : TANGENT;
                float2 texcoord0 : TEXCOORD0;
            };
            struct VertexOutput {
                float4 pos : SV_POSITION;
                float2 uv0 : TEXCOORD0;
                float4 posWorld : TEXCOORD1;
                float3 normalDir : TEXCOORD2;
                float3 tangentDir : TEXCOORD3;
                float3 bitangentDir : TEXCOORD4;
                LIGHTING_COORDS(5,6)
                UNITY_FOG_COORDS(7)
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.uv0 = v.texcoord0;
                o.normalDir = UnityObjectToWorldNormal(v.normal);
                o.tangentDir = normalize( mul( unity_ObjectToWorld, float4( v.tangent.xyz, 0.0 ) ).xyz );
                o.bitangentDir = normalize(cross(o.normalDir, o.tangentDir) * v.tangent.w);
                o.posWorld = mul(unity_ObjectToWorld, v.vertex);
                float3 lightColor = _LightColor0.rgb;
                o.pos = UnityObjectToClipPos(v.vertex );
                UNITY_TRANSFER_FOG(o,o.pos);
                TRANSFER_VERTEX_TO_FRAGMENT(o)
                return o;
            }
			half4 Pow5(half4 x)
			{
				return x*x * x*x * x;
			}
			half3 FresnelTerm(half3 F0, half cosA)
			{
				half t = Pow5(1 - cosA);   // ala Schlick interpoliation
				return F0 + (1 - F0) * t;
			}

			half3 BentNormalsDiffuseLighting(float3 normal, float3 L, float Curvature, float nl)
			{
				float NdotLBlurredUnclamped = dot(normal, L);
				half3 diffuseLookUp = tex2Dlod(_LookUp, float4((NdotLBlurredUnclamped * 0.5 + 0.5), Curvature, 0, 0));

				return diffuseLookUp;
			}

            float4 frag(VertexOutput i) : COLOR {
                i.normalDir = normalize(i.normalDir);
                float3x3 tangentTransform = float3x3( i.tangentDir, i.bitangentDir, i.normalDir);
                float3 viewDirection = normalize(_WorldSpaceCameraPos.xyz - i.posWorld.xyz);
                float3 _Bump_var = UnpackNormal(tex2D(_BumpMap,TRANSFORM_TEX(i.uv0, _BumpMap)));
				float3 blurredWorldNormal = UnpackNormal(tex2Dbias(_BumpMap, float4(i.uv0, 0, _BumpBias)));
				float3 normalLocal = normalize(lerp(_Bump_var, blurredWorldNormal, _BlurStrength));

                float3 normalDirection = normalize(mul( normalLocal, tangentTransform )); // Perturbed normals
#ifndef USING_DIRECTIONAL_LIGHT
				float3 lightDirection = normalize(UnityWorldSpaceLightDir(i.posWorld));
#else
				float3 lightDirection = _WorldSpaceLightPos0.xyz;
#endif
                float3 lightColor = _LightColor0.rgb;

				
				float4 _Translucency_var = tex2D(_Translucency, TRANSFORM_TEX(i.uv0, _Translucency));
				fixed Curvature = 0;
				//	Calculate the curvature of the model dynamically
				if (_CurvatureInfluence > 0)
				{
					//	Get the scale of the derivatives of the blurred world normal and the world position.
#if (SHADER_TARGET > 40) //SHADER_API_D3D11
					// In DX11, ddx_fine should give nicer results.
					float deltaWorldNormal = length(abs(ddx_fine(normalDirection)) + abs(ddy_fine(normalDirection)));
					float deltaWorldPosition = length(abs(ddx_fine(i.posWorld)) + abs(ddy_fine(i.posWorld)));
#else
					float deltaWorldNormal = length(fwidth(normalDirection));
					float deltaWorldPosition = length(max(1e-5f, fwidth(i.posWorld)));
					deltaWorldPosition = (deltaWorldPosition == 0.0) ? 1e-5f : deltaWorldPosition;
#endif		
					Curvature = (deltaWorldNormal / deltaWorldPosition) * _CurvatureScale;
					Curvature = lerp(_Translucency_var.b, Curvature, _CurvatureInfluence);
				}
				else
				{
					Curvature = _Translucency_var.b;
				}
				Curvature = saturate(Curvature + _Bias);
////// Lighting:
                float attenuation = LIGHT_ATTENUATION(i);
                float3 attenColor = attenuation * _LightColor0.xyz;


/////// Diffuse:
                float4 _MainTex_var = tex2D(_MainTex,TRANSFORM_TEX(i.uv0, _MainTex));
                float NdotL = max(0.0,dot( normalDirection, lightDirection ));
                float3 directDiffuse = BentNormalsDiffuseLighting(normalDirection, lightDirection, Curvature, NdotL) ;
                float3 indirectDiffuse = float3(0,0,0);
                indirectDiffuse += UNITY_LIGHTMODEL_AMBIENT.rgb; // Ambient Light
                float3 diffuseColor = (_Color.rgb*_MainTex_var.rgb);
                float3 diffuse = (directDiffuse* attenColor + indirectDiffuse) * diffuseColor;

///////Specular
				float3 H = normalize(lightDirection + viewDirection);
				float LdotH = saturate(dot(lightDirection, H));
				float NdotH = saturate(dot(normalDirection, H));
				float specularTerm = pow(NdotH, exp2(lerp(1, 11, _Smoothness)));

				float specCol = unity_ColorSpaceDielectricSpec.rgb * 0.7;


////////scatter
				half3 transLightDir = lightDirection + normalDirection * _Lux_Skin_DeepSubsurface.y;
				half transDot = dot(-transLightDir, viewDirection);
				transDot = exp2((saturate(transDot)-1) * _Lux_Skin_DeepSubsurface.x) * _Translucency_var.g * _Lux_Skin_DeepSubsurface.z;
				half3 lightScattering = transDot * _SubColor * attenColor;

/// Final Color:
                float3 finalColor = diffuse+ specularTerm*attenColor* FresnelTerm(specCol, LdotH) + lightScattering;
				finalColor *= _Translucency_var.a;
                fixed4 finalRGBA = fixed4(finalColor,1);
                UNITY_APPLY_FOG(i.fogCoord, finalRGBA);
                return finalRGBA;
            }
            ENDCG
        }
    }
    FallBack "Diffuse"
}
