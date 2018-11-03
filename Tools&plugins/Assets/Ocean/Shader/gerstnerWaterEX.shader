// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

Shader "ZHT/gerstnerWaterEX" {
	Properties {

		
		_Color ("Main Color", Color) = (1,1,1,1)
		_SpecColor ("Specular Color", Color) = (1.0, 1.0, 1.0, 1.0)
		_ScatterColor ("Scatter Color", Color) = (0.3, 0.7, 0.6, 1.0)
		_ShallowWaterColor("_ShallowWaterColor",Color)=(0.3, 0.7, 0.6, 1.0)
		_DeepWaterColor("_DeepWaterColor",Color)=(0.3, 0.7, 0.6, 1.0)
		_WaterSpecularIntensity ("Water Specular Intensity", Float) = 350
		_WaterSpecularPower ("Water Specular Power", Float) = 1000
		_WaterColorIntensityX ("Water Color Intensity X", Range(0.0,1.0)) = 0.1
		_WaterColorIntensityY ("Water Color Intensity Y", Range(0.0,1.0)) = 0.2
		_Reflectivity("Reflectivity", Range(0, 1)) = 0.6
		_OceanDepth("_OceanDepth",Range(1,1000))=10
		_BumpMap ("Bump Map", 2D) = "bump" {}
		_BumpMap2 ("Bump Map 2", 2D) = "bump" {}
		_ReflMap("Reflection Map", Cube) = "cube" {}
		_ShoreTex ("Shore & Foam texture ", 2D) = "black" {}
		_Foam ("Foam(x:Intensity y:Intensity z:noise ) ", Vector) = (0.1, 0.375, 0.0, 0.0)
		_FrenelFactor( "_FrenelFactor", Range(0,1)) = 0.02037
		_Distortion("_Distortion",Range(0,100))=10
		_NoiseTex ("Noise ", 2D) = "black" {}
		_NumWaves("numWaves",Range(0,32))=4
	}
	
	SubShader {
		Tags { "Queue"="Transparent" "RenderType"="Transparent" }
		LOD 200
		GrabPass
		{
			"_RefractionTex"
		}

		Pass 
		{
		cull off
		blend srcAlpha oneMinusSrcAlpha
		Tags {"LightMode" = "ForwardBase"}
		CGPROGRAM
		#pragma vertex vert
		#pragma fragment frag
		#include "Lighting.cginc"
		const float PI = 3.14159265f;
	
		uniform float4 _Color;
		uniform float4 _ScatterColor;
		float4 _DeepWaterColor;
		float4 _ShallowWaterColor;
		uniform float _WaterSpecularIntensity;
		uniform float _WaterSpecularPower;
		uniform half _WaterColorIntensityX;
		uniform half _WaterColorIntensityY;
		uniform sampler2D _BumpMap;
		uniform float4 _BumpMap_ST;
		uniform sampler2D _BumpMap2;
		uniform float4 _BumpMap2_ST;
		sampler2D _ShoreTex;
		uniform float4 _ShoreTex_ST;
		uniform half _Reflectivity;
		uniform samplerCUBE _ReflMap;
		uniform float _FrenelFactor;
		uniform float4 _Foam;
		uniform sampler2D _CameraDepthTexture;
		uniform sampler2D _NoiseTex;
		uniform float4 _NoiseTex_ST;
		uniform float _NumWaves;
		uniform int _NumCreatedWaves;
		sampler2D _RefractionTex;
		float4 _RefractionTex_TexelSize;
		float _Distortion;
		float _OceanDepth;
		struct Wave {
		  float freq; 
		  float amp;   
		  float phase; 
		  float2 dir;
		};
		struct a2v {
			float4 vertex : POSITION;
			float3 normal : NORMAL;
			float4 tangent : TANGENT;
			float4 texcoord : TEXCOORD0;
		};

	
		struct v2f {
			float4 pos : POSITION;
			float4 uv : TEXCOORD0;
			float4 posWorld : TEXCOORD1;
			float3 normalDir : TEXCOORD2;
			float3 tangentWorld : TEXCOORD3;
			float3 binormalWorld : TEXCOORD4;
			float4 uvFoam:TEXCOORD5;
			float4 scrPos:TEXCOORD6;
		};
		uniform StructuredBuffer<Wave> waveBuffer;


			float3 getGerstnerOffset(float2 x0, Wave w, float time)
			{
				float k = length(w.dir);
				float2 x = (w.dir / k)* w.amp * sin( dot( w.dir, x0) - w.freq * time +w.phase);
				float y = w.amp * cos( dot( w.dir, x0) - w.freq*time + w.phase);
				return float3(x.x, y, x.y);
			}

			float3 computeBinormal(float2 x0, Wave w, float time)
			{
				float3 B = float3(0, 0, 0);
				half k = length(w.dir);
				B.x = w.amp * (pow(w.dir.x, 2) / k) * cos( dot(w.dir, x0) - w.freq * time + w.phase);
				B.y = -w.amp * w.dir.x * sin( dot(w.dir, x0) - w.freq * time + w.phase);
				B.z = w.amp * ((w.dir.y * w.dir.x)/ k) * cos( dot(w.dir, x0) - w.freq * time + w.phase);
				return B;
			}

			float3 computeTangent(float2 x0, Wave w, float time)
			{
				float3 T = float3(0, 0, 0);
				half k = length(w.dir);
				T.x = w.amp * ((w.dir.y * w.dir.x)/ k) * cos( dot(w.dir, x0) - w.freq * time + w.phase);
				T.y = -w.amp * w.dir.x * sin( dot(w.dir, x0) - w.freq * time + w.phase);
				T.z = w.amp * (pow(w.dir.y, 2) / k) * cos( dot(w.dir, x0) - w.freq * time + w.phase);
				return T;		
			}

		
		inline half4 Foam(sampler2D shoreTex, half2 coords) 
		{
			half4 foam = (tex2D(shoreTex, coords.xy) * tex2D(shoreTex,coords.xy)) - 0.125;
			return foam;
		}


		v2f vert(a2v v) 
		{
			v2f o;
			half2 x0 = v.vertex.xz;
			float3 newPos = float3(0.0, 0.0, 0.0);
			float3 tangent = float3(0, 0, 0);
			float3 binormal = float3(0, 0, 0);
			int nw = min(_NumWaves, _NumCreatedWaves);
			for(int i = 0; i < nw; i++)
			{
				Wave w = waveBuffer[i];
				newPos += getGerstnerOffset(x0, w, _Time.y);
				binormal += computeBinormal(x0, w, _Time.y);
				tangent += computeTangent(x0, w, _Time.y);
			}

			binormal.x = 1 - binormal.x;
			binormal.z = 0 - binormal.z;

			tangent.x = 0 - tangent.x;
			tangent.z = 1 - tangent.z;
				
			v.vertex.x -= newPos.x;
			v.vertex.z -= newPos.z;
			v.vertex.y = newPos.y;
			o.pos = UnityObjectToClipPos(v.vertex);
			o.scrPos = ComputeScreenPos(o.pos);	
			o.posWorld.xyz = mul(unity_ObjectToWorld, v.vertex).xyz;
			o.posWorld.w=COMPUTE_DEPTH_01;
			o.tangentWorld = normalize(UnityObjectToWorldDir(tangent));
			o.binormalWorld = normalize(UnityObjectToWorldDir(binormal));
			o.normalDir = normalize( cross(o.tangentWorld,o.binormalWorld) );
			o.uv.xy =TRANSFORM_TEX( v.texcoord,_BumpMap);
			o.uv.zw =TRANSFORM_TEX( v.texcoord,_BumpMap2);
			o.uvFoam.xy = TRANSFORM_TEX(v.texcoord,_ShoreTex);
			o.uvFoam.zw = TRANSFORM_TEX(v.texcoord,_NoiseTex);
			return o;

		}
		float4 frag(v2f i):COLOR
		{	

				float3 lightDir = normalize(UnityWorldSpaceLightDir(float4(i.posWorld.xyz,1)));
				float3 viewDir = normalize(UnityWorldSpaceViewDir(float4(i.posWorld.xyz,1)));
				float3 reflectDir;
				float fresnelFactor;
				float diffuseFactor;
				float specularFactor;
				float scatterFactor;
				float shadowFactor = 0.01;
				float4 refractionColor;
				float4 reflectionColor;


				float3 localCoords =  UnpackNormal(tex2D(_BumpMap,i.uv.xy));
				float3 localCoords2 =  UnpackNormal(tex2D(_BumpMap,i.uv.zw));

				localCoords = (localCoords+localCoords2)/2;

				float3x3 local2WorldTranspose = float3x3(i.tangentWorld.x, i.binormalWorld.x, i.normalDir.x,
														i.tangentWorld.y, i.binormalWorld.y, i.normalDir.y,
														i.tangentWorld.z, i.binormalWorld.z, i.normalDir.z);
				float3 nDir = normalize( mul(local2WorldTranspose,localCoords) );

				float L = length(_WorldSpaceCameraPos.xyz - i.posWorld.xyz);


				//factor
				scatterFactor =  2.5 *max(0, i.posWorld.y * 0.25 + 0.25);
				scatterFactor *= shadowFactor*pow(saturate( dot(normalize(float3(lightDir.x, 0.0, lightDir.z)),-viewDir )),2);
				scatterFactor *= pow( max(0.0, 1.0 - dot( lightDir, nDir)), 8.0);
				scatterFactor += shadowFactor *1.5 * _WaterColorIntensityY* max( 0, i.posWorld.y + 1) * max(0, dot( viewDir, nDir)) * max(0, 1 -viewDir.y) * (300.0/L);
				scatterFactor = clamp(scatterFactor, 0, 0.5);


				//fresnelFactor = max(0.0, min(1.0, _FrenelFactor.x+_FrenelFactor.y*pow(1.0-dot( nDir, viewDir), _FrenelFactor.z)));
				fresnelFactor =pow(1-dot(nDir, viewDir),2);
				reflectDir = reflect(-lightDir, nDir);
				specularFactor = pow(saturate(dot(viewDir, reflectDir)), _WaterSpecularPower);
				

				diffuseFactor = _WaterColorIntensityX + _WaterColorIntensityY * saturate( dot(lightDir, nDir)) * _LightColor0.xyz;

				float2 scrpos = i.scrPos.xy/i.scrPos.w;
				scrpos.y=1-scrpos.y;
				float sceneDepth =SAMPLE_DEPTH_TEXTURE(_CameraDepthTexture,scrpos); 
				float lineDepth = Linear01Depth(sceneDepth);
				float depth = i.posWorld.w;
				float f = saturate(lineDepth-depth);
				//f = smoothstep(0.3,0.8,f);
				//rgb

	
				half facing = saturate(dot(viewDir,float3(0,1,0)));
				float3 waterColor = lerp(_DeepWaterColor,_ShallowWaterColor,facing)*_Color;
				waterColor = lerp(_DeepWaterColor,_ShallowWaterColor,f)*_Color;
	
				reflectionColor.rgb = texCUBE(_ReflMap, reflectDir).rgb*_Reflectivity;

				float offset = nDir.xy*_RefractionTex_TexelSize.xy*_Distortion;
				i.scrPos.xy += offset;
				refractionColor.rgb = tex2D(_RefractionTex,i.scrPos.xy/i.pos.w).xyz;
	
				half4 foam = Foam(_ShoreTex, i.uvFoam.xy+half2(_Time.x, _Time.x/2));
				foam.rgb=foam.rgb * _Foam.x * saturate( _Foam.y);

				half4 foam1 = Foam(_ShoreTex, i.uvFoam.xy+half2(-_Time.x*2, _Time.x));
				foam1.rgb=foam1.rgb * _Foam.x * saturate( _Foam.y);

				float noise =smoothstep(0.8,1,1-saturate(tex2D(_NoiseTex,i.uvFoam.zw+half2(_Time.x, _Time.x/2)).r-_Foam.z));
				float noise2 = smoothstep(0.8,1,1-saturate(tex2D(_NoiseTex,i.uvFoam.zw+half2(-_Time.x*4, _Time.x)).r-_Foam.z));
				noise = (noise + noise2)/2;




				float4 color;

				float t = clamp(L*fresnelFactor/25, 0, 0.5);
				t = smoothstep(0.3,0.8,t);
				//float s = fresnelFactor* (1-facing) + 0.5;
				color.rgb = lerp(refractionColor.rgb*waterColor, waterColor + reflectionColor,t);
				color.rgb += _WaterSpecularIntensity*specularFactor*_SpecColor* _LightColor0.xyz;
				color.rgb += _ScatterColor * scatterFactor;
				//color.rgb += foam.rgb*noise;
				color.a =1.0;

				//color.rgb = float3(depth,depth,depth);
				//color.rgb = color.a;
				return color;
		}


		ENDCG
		}
		
	} 
	FallBack "Diffuse"
}
