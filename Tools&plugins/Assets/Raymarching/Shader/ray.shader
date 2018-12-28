Shader "ZHT/raymarching"
{
	Properties
	{
		_Color("Color",Color)=(1,1,1,1)
		_randius("r",Float) = 0.5
	}
		SubShader
		{
			Tags { "RenderType" = "Opaque" }
			LOD 100

			Pass
			{
		blend srcAlpha oneMinusSrcAlpha
		cull off
			Tags{"LightMode"="ForwardBase"}
				CGPROGRAM
				#pragma vertex vert
				#pragma fragment frag

				#include "UnityCG.cginc"
				#include "Lighting.cginc"
	#define STEP_SIZE 0.01
	#define STEPS 64
	#define MINDISTANCE 0.00001
				struct appdata
				{
					float4 vertex : POSITION;
					float2 uv : TEXCOORD0;
				};

				struct v2f
				{
					float4 wpos : TEXCOORD0;
					float4 vertex : SV_POSITION;
				};

				float4 _Color;
				float4 _Centre;
				float _randius;
				float sdf_sphere(float3 p, float3 c, float r)
				{
					return distance(p, c) - r;
				}
				float sdf_box(float3 p, float3 c, float3 s)
				{
					float x = max
					(p.x - _Centre.x - float3(s.x / 2., 0, 0),
						_Centre.x - p.x - float3(s.x / 2., 0, 0)
					);

					float y = max
					(p.y - _Centre.y - float3(s.y / 2., 0, 0),
						_Centre.y - p.y - float3(s.y / 2., 0, 0)
					);

					float z = max
					(p.z - _Centre.z - float3(s.z / 2., 0, 0),
						_Centre.z - p.z - float3(s.z / 2., 0, 0)
					);

					float d = x;
					d = max(d, y);
					d = max(d, z);
					return d;
				}
				float vmax(float3 v)
				{
					return max(max(v.x, v.y), v.z);
				}
				float sdf_boxcheap(float3 p, float3 c, float3 s)
				{
					return vmax(abs(p - c) - s);
				}
				float sdf_blend(float d1, float d2, float a)
				{
					return a * d1 + (1 - a) * d2;
				}
				float map0(float3 pos)
				{
					return sdf_sphere(pos, 0, 2); //  sphere
				}
				float map1(float3 pos)
				{
					return min
					(
						sdf_sphere(pos, -float3 (1.5, 0, 0), 2), // Left sphere
						sdf_sphere(pos, +float3 (1.5, 0, 0), 2)  // Right sphere
					);
				}
				float map2(float3 p)
				{
					return max
					(
						sdf_box(p, -float3 (1.5, 0, 0), 2), // Left sphere
						sdf_box(p, +float3 (1.5, 0, 0), 2)  // Right sphere
					);
				}
				float map(float3 p)
				{
					return sdf_blend
					(
						sdf_sphere(p, 0, 2),
						sdf_box(p, 0, 2),
						(_SinTime[3] + 1.) / 2.
					);
				}
				
				float3 normal(float3 p)
				{
					const float eps = 0.01;

					return normalize
					(float3
						(map0(p + float3(eps, 0, 0)) - map0(p - float3(eps, 0, 0)),
							map0(p + float3(0, eps, 0)) - map0(p - float3(0, eps, 0)),
							map0(p + float3(0, 0, eps)) - map0(p - float3(0, 0, eps))
							)
					);
				}
				fixed4 simpleLambert(fixed3 normal, float3 viewDirection)
				{
					fixed3 lightDir = _WorldSpaceLightPos0.xyz;	// Light direction
					fixed3 lightCol = _LightColor0.rgb;		// Light color
					fixed NdotL = max(dot(normal, lightDir), 0);

					fixed3 h = (lightDir - viewDirection) / 2.;
					fixed s = pow(dot(normal, h), 256);

					fixed4 c;
					c.rgb = _Color*lightCol * NdotL+ 1 *  s;
					c.a = 1;
					return c;
				}
				fixed4 renderSurface(float3 p,float3 viewDirection)
				{
					
					float3 n = normal(p);
					return simpleLambert(n, viewDirection);
				}
				fixed4 raymarching(float3 pos,float3 dir)
				{
					for (int i = 0; i < STEPS; i++)
					{
						float dis = distance(pos, _Centre.xyz)- _randius;
						if (dis<MINDISTANCE)
						{
							//return i/(float)STEPS;
							return renderSurface(pos, dir);
						}
						pos += dir*dis;
					}
					return 0;
				}

			
				v2f vert(appdata v)
				{
					v2f o;
					o.vertex = UnityObjectToClipPos(v.vertex);
					o.wpos = mul(unity_ObjectToWorld, v.vertex);

					return o;
				}

				fixed4 frag(v2f i) : SV_Target
				{
					float3 wpos = i.wpos.xyz;
					float3 vdir = normalize(i.wpos.xyz - _WorldSpaceCameraPos.xyz);
					//float3 v = float3(0, 1, -10);
					return raymarching(wpos, vdir);
				}
				ENDCG
			}
		}
}
