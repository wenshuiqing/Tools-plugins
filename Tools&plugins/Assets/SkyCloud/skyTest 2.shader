// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'
Shader "Shader Forge/skyTest2" {
    Properties {
        _HorizonSharpness ("Horizon Sharpness", Float ) = 16
        _StarPosition ("StarPosition", Float ) = 5
        _StarsTexture ("StarsTexture", 2D) = "white" {}
        _Night ("Night", Color) = (0.128,0.052,0.292,1)
        _Dusk ("Dusk", Color) = (0.8014706,0.530385,0.1237565,1)
        _DayTop ("DayTop", Color) = (0.223,0.572,0.823,1)
        _StarIntensity ("StarIntensity", Float ) = 100
        _GroundSharpness ("GroundSharpness", Float ) = 0.005
        _LightEccentricity ("LightEccentricity", Float ) = 20
        _SunSize ("SunSize", Float ) = 3
        _SunSharpness ("SunSharpness", Float ) = 2
        _nHorizonRelation ("nHorizonRelation", Float ) = 2
        _Ground ("Ground", Color) = (0.5,0.5,0.5,1)
        _DitheringIntensity ("DitheringIntensity", Range(0, 10)) = 4
        _Dithering ("Dithering", Range(0, 1)) = 1
        [MaterialToggle] _ScreenSpaceNoise ("ScreenSpaceNoise", Float ) = 0
        _MoonSize ("MoonSize", Float ) = 6.5
        _MoonSharpness ("MoonSharpness", Float ) = 2
        _MoonColor ("MoonColor", Color) = (0.8447232,0.8858788,0.9264706,1)
		
		_SampleCount0("Sample Count (min)", Float) = 30
		_SampleCount1("Sample Count (max)", Float) = 90
		_SampleCountL("Sample Count (light)", Int) = 16

		[Space]
		_NoiseTex1("Noise Volume", 3D) = ""{}
		_NoiseTex2("Noise Volume", 3D) = ""{}
		_NoiseFreq1("Frequency 1", Float) = 3.1
		_NoiseFreq2("Frequency 2", Float) = 35.1
		_NoiseAmp1("Amplitude 1", Float) = 5
		_NoiseAmp2("Amplitude 2", Float) = 1
		_NoiseBias("Bias", Float) = -0.2

		[Space]
		_Scroll1("Scroll Speed 1", Vector) = (0.01, 0.08, 0.06, 0)
		_Scroll2("Scroll Speed 2", Vector) = (0.01, 0.05, 0.03, 0)

		[Space]
		_Altitude0("Altitude (bottom)", Float) = 1500
		_Altitude1("Altitude (top)", Float) = 3500
		_FarDist("Far Distance", Float) = 30000

		[Space]
		_Scatter("Scattering Coeff", Float) = 0.008
		_HGCoeff("Henyey-Greenstein", Range(0,1)) = 0.5
		_Extinct("Extinction Coeff", Float) = 0.01
		_CloudColor("CloudColor",Color)=(1,1,1,1)


    }
    SubShader {
        Tags {
            "RenderType"="Opaque"
            "PreviewType"="Skybox"
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
            #pragma exclude_renderers gles3 metal d3d11_9x xbox360 xboxone ps3 ps4 psp2 
            #pragma target 3.0
            uniform float4 _LightColor0;
            uniform float4 _TimeEditor;
            uniform float _HorizonSharpness;
            uniform float _StarPosition;
            uniform sampler2D _StarsTexture; uniform float4 _StarsTexture_ST;
            uniform float4 _Night;
            uniform float4 _DayTop;
            uniform float _StarIntensity;
            uniform float _GroundSharpness;
            uniform float _LightEccentricity;
            uniform float _SunSize;
            uniform float _SunSharpness;
            uniform float _nHorizonRelation;
            uniform float4 _Ground;
            uniform float _DitheringIntensity;
            uniform float _Dithering;
            uniform fixed _ScreenSpaceNoise;
            uniform float _CloudPosition;
            uniform float4 _Dusk;
            uniform float _MoonSize;
            uniform float _MoonSharpness;
            uniform float4 _MoonColor;

			float _SampleCount0;
			float _SampleCount1;
			int _SampleCountL;

			sampler3D _NoiseTex1;
			sampler3D _NoiseTex2;
			float _NoiseFreq1;
			float _NoiseFreq2;
			float _NoiseAmp1;
			float _NoiseAmp2;
			float _NoiseBias;

			float3 _Scroll1;
			float3 _Scroll2;

			float _Altitude0;
			float _Altitude1;
			float _FarDist;

			float _Scatter;
			float _HGCoeff;
			float _Extinct;
			float4 _CloudColor;

            struct VertexInput {
                float4 vertex : POSITION;
                float2 texcoord0 : TEXCOORD0;
            };
            struct VertexOutput {
                float4 pos : SV_POSITION;
                float2 uv0 : TEXCOORD0;
                float4 posWorld : TEXCOORD1;
                float4 screenPos : TEXCOORD2;
                LIGHTING_COORDS(3,4)
                UNITY_FOG_COORDS(5)
            };

			float UVRandom(float2 uv)
			{
				float f = dot(float2(12.9898, 78.233), uv);
				return frac(43758.5453 * sin(f));
			}

			float SampleNoise(float3 uvw)
			{
				const float baseFreq = 1e-5;

				float4 uvw1 = float4(uvw * _NoiseFreq1 * baseFreq, 0);
				float4 uvw2 = float4(uvw * _NoiseFreq2 * baseFreq, 0);

				uvw1.xyz += _Scroll1.xyz * _Time.x;
				uvw2.xyz += _Scroll2.xyz * _Time.x;

				float n1 = tex3Dlod(_NoiseTex1, uvw1).a;
				float n2 = tex3Dlod(_NoiseTex2, uvw2).a;
				float n = n1 * _NoiseAmp1 + n2 * _NoiseAmp2;

				n = saturate(n + _NoiseBias);

				float y = uvw.y - _Altitude0;
				float h = _Altitude1 - _Altitude0;
				n *= smoothstep(0, h * 0.1, y);
				n *= smoothstep(0, h * 0.4, h - y);

				return n;
			}

			//相函数
			float HenyeyGreenstein(float cosine)
			{
				float g2 = _HGCoeff * _HGCoeff;
				return 0.5 * (1 - g2) / pow(1 + g2 - 2 * _HGCoeff * cosine, 1.5);
			}

			//能量衰减公式
			float Beer(float depth)
			{
				return exp(-_Extinct * depth);
			}

			//能量2次衰减公式
			float BeerPowder(float depth)
			{
				return exp(-_Extinct * depth) * (1 - exp(-_Extinct * 2 * depth));
			}


			//计算光学衰减
			float MarchLight(float3 pos, float rand)
			{
				float3 light = _WorldSpaceLightPos0.xyz;
				float stride = (_Altitude1 - pos.y) / ((light.y*0.5+0.5) * _SampleCountL);

				pos += light * stride * rand;

				float depth = 0;
				UNITY_LOOP for (int s = 0; s < _SampleCountL; s++)
				{
					depth += SampleNoise(pos) * stride;
					pos += light * stride;
				}

				return BeerPowder(abs(depth));
			}


			fixed4 fragCloud(float2 iuv,float3 rayDir,float3 sky)
			{

				float3 ray = rayDir;
				int samples = lerp(_SampleCount1, _SampleCount0, ray.y);

				float dist0 = _Altitude0 / ray.y;
				float dist1 = _Altitude1 / ray.y;
				float stride = (dist1 - dist0) / samples;//采样步长

				if (ray.y < 0.01 || dist0 >= _FarDist) return fixed4(sky, 1);

				float3 light = _WorldSpaceLightPos0.xyz;
				float hg = HenyeyGreenstein(dot(ray, light));

				float2 uv = iuv + _Time.x;
				float offs = UVRandom(uv) * stride;

				float3 pos = _WorldSpaceCameraPos + ray * (dist0 + offs);//起点
				float3 acc = 0;

				float depth = 0;
				UNITY_LOOP for (int s = 0; s < samples; s++)
				{
					float n = SampleNoise(pos);
					if (n > 0)
					{
						float density = n * stride;
						float rand = UVRandom(uv + s + 1);
						float scatter = density * _Scatter * hg * MarchLight(pos, rand * 0.5);


						acc +=_CloudColor.rgb* _LightColor0 *_LightColor0* scatter * BeerPowder(depth);
						depth += density;
					}
					pos += ray * stride;
				}

				acc += Beer(depth) * sky;


				acc = lerp(acc, sky, saturate(dist0 / _FarDist));

				return half4(acc, 1);
			}
           
			
			VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.uv0 = v.texcoord0;
                o.posWorld = mul(unity_ObjectToWorld, v.vertex);
                float3 lightColor = _LightColor0.rgb;
                o.pos = UnityObjectToClipPos(v.vertex );
                UNITY_TRANSFER_FOG(o,o.pos);
                o.screenPos = o.pos;
                TRANSFER_VERTEX_TO_FRAGMENT(o)
                return o;
            }
            float4 frag(VertexOutput i) : COLOR {
                #if UNITY_UV_STARTS_AT_TOP
                    float grabSign = -_ProjectionParams.x;
                #else
                    float grabSign = _ProjectionParams.x;
                #endif
                i.screenPos = float4( i.screenPos.xy / i.screenPos.w, 0, 0 );
                i.screenPos.y *= _ProjectionParams.x;
                float2 sceneUVs = float2(1,grabSign)*i.screenPos.xy*0.5+0.5;
                float3 lightDirection = normalize(_WorldSpaceLightPos0.xyz);
                float3 lightColor = _LightColor0.rgb;
////// Lighting:
                float3 normalwPos = normalize(i.posWorld.xyz);
                float2 wRB = normalwPos.rb;
                float wG = saturate(normalwPos.g);
                float2 uv = (wRB+(wRB*(1.0 - wG)));//计算UV

                float4 _StarsTexture_var = tex2D(_StarsTexture,TRANSFORM_TEX(uv, _StarsTexture));

				//日晷
                float cycle = smoothstep( 0.4, 0.75, 0.5*dot(lightDirection,float3(0,1,0))+0.5 );

			
				//混合白天和黄昏天空色
				float3 blendDusk_DayTop = lerp(_Dusk.rgb,_DayTop.rgb, cycle);

				float3 blendDusk_Night = lerp(_Night.rgb, _Dusk.rgb, cycle);

				float3 star = _StarsTexture_var*pow(wG, _StarPosition)*_StarIntensity;

				//混合天空颜色
				float3 skyColor = lerp(star + blendDusk_Night,blendDusk_DayTop, cycle);
				

				//混合云颜色
				float3 cloud = fragCloud(uv, normalwPos, skyColor);


				//大地控制参数
				float groundFactor = saturate((((0.5*_GroundSharpness) + normalwPos.g) / _GroundSharpness));
				//混合大地颜色
				float3 blendGroundSky = lerp(_Ground.rgb, cloud, groundFactor);


				//水平线混合值
				float horizon = pow((1.0 - abs(normalwPos.g)), _HorizonSharpness);


				float sun_t = (_LightEccentricity*(1.0 - cycle));
				float LdotwPos = dot(normalwPos, lightDirection);
				float LdotwPos05 = (LdotwPos*0.5 + 0.5);
				//混合水平线颜色
				float3 blendHorizon = lerp(blendGroundSky,
					pow(_LightColor0.rgb, ((1.0 - horizon)*sun_t)), (horizon*(LdotwPos05 + pow(LdotwPos05, _nHorizonRelation))));



				//太阳控制参数，大小及锐利度
                float sunFactor = saturate((pow(saturate(LdotwPos),exp(_SunSize))*exp(_SunSharpness)));
				//月亮控制参数
				float moonFactor = saturate((pow(saturate((-1 * LdotwPos)), exp(_MoonSize))*exp(_MoonSharpness)));

				//混合太阳颜色
				float3 blendSun = lerp(blendHorizon,(1.0*pow(_LightColor0.rgb, (sun_t*(1.0 - sunFactor)))), sunFactor);

				//混合月亮颜色
				float3 blendMoon = lerp(blendSun,(1.0*_MoonColor.rgb), moonFactor);

                
				float3 allColor = max(blendMoon, 0.0);


				//屏幕抖动
                float ditherI = pow(_DitheringIntensity,_DitheringIntensity);
                float2 ditherUV = lerp(i.uv0,sceneUVs.rg,_ScreenSpaceNoise);
                float2 skew = ditherUV + 0.2127+ditherUV.x*0.3713*ditherUV.y;
                float2 rnd = 4.789*sin(489.123*(skew));
                float3 finalColor = lerp(allColor,(floor(((allColor*ditherI)+(2.0*(frac(rnd.x*rnd.y*(1 + skew.x)) -0.5))))/ditherI),_Dithering);


                fixed4 finalRGBA = fixed4(finalColor,1);
                UNITY_APPLY_FOG(i.fogCoord, finalRGBA);
                return finalRGBA;
            }
            ENDCG
        }
		
    }
    FallBack "Diffuse"
}
