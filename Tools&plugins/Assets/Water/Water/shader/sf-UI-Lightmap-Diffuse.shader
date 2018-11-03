// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Shader created with Shader Forge v1.30 
// Shader Forge (c) Neat Corporation / Joachim Holmer - http://www.acegikmo.com/shaderforge/
// Note: Manually altering this data may prevent you from opening it in Shader Forge
/*SF_DATA;ver:1.30;sub:START;pass:START;ps:flbk:,iptp:0,cusa:False,bamd:0,lico:1,lgpr:1,limd:0,spmd:1,trmd:0,grmd:0,uamb:False,mssp:True,bkdf:False,hqlp:False,rprd:False,enco:False,rmgx:True,rpth:0,vlit:False,simplebake:False,suppproj:False,simplepbl:False,sh:False,vtps:0,hqsc:True,nrmq:1,nrsp:0,vomd:0,spxs:False,tesm:0,olmd:1,culm:0,bsrc:0,bdst:1,dpts:2,wrdp:True,dith:0,rfrpo:True,rfrpn:Refraction,coma:15,ufog:False,ugoelinearfog:True,goelinearintensity:False,aust:False,igpj:False,qofs:0,qpre:1,rntp:1,fgom:False,fgoc:False,fgod:False,fgor:False,fgmd:0,fgcr:0.8970588,fgcg:0.06596022,fgcb:0.06596022,fgca:1,fgde:0.01,fgrn:-181.73,fgrf:300,stcl:False,stva:128,stmr:255,stmw:255,stcp:6,stps:0,stfa:0,stfz:0,ofsf:0,ofsu:0,f2p0:False,fnsp:False,fnfb:False;n:type:ShaderForge.SFN_Final,id:4013,x:33613,y:32633,varname:node_4013,prsc:2|custl-6575-OUT;n:type:ShaderForge.SFN_Color,id:1304,x:32401,y:32511,ptovrint:False,ptlb:Color,ptin:_Color,varname:node_1304,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,c1:1,c2:1,c3:1,c4:1;n:type:ShaderForge.SFN_Tex2d,id:4595,x:32401,y:32320,ptovrint:False,ptlb:MainTex,ptin:_MainTex,varname:node_4595,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,ntxv:0,isnm:False;n:type:ShaderForge.SFN_Slider,id:4388,x:32225,y:32732,ptovrint:False,ptlb:Illumin,ptin:_Illumin,varname:node_4388,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:1,max:2;n:type:ShaderForge.SFN_Multiply,id:4267,x:32780,y:32499,varname:node_4267,prsc:2|A-4595-RGB,B-1304-RGB,C-4388-OUT,D-1763-OUT;n:type:ShaderForge.SFN_ValueProperty,id:4820,x:32274,y:32881,ptovrint:False,ptlb:GlobalLight,ptin:_GlobalLight,varname:node_4820,prsc:2,glob:True,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:1;n:type:ShaderForge.SFN_Vector1,id:9787,x:32237,y:32967,varname:node_9787,prsc:2,v1:1;n:type:ShaderForge.SFN_Add,id:1763,x:32480,y:32881,varname:node_1763,prsc:2|A-4820-OUT,B-9787-OUT;n:type:ShaderForge.SFN_Tex2d,id:22,x:32375,y:33097,ptovrint:False,ptlb:LightmapTex,ptin:_LightmapTex,varname:node_22,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,ntxv:0,isnm:False|UVIN-4273-UVOUT;n:type:ShaderForge.SFN_Multiply,id:6575,x:33070,y:32744,varname:node_6575,prsc:2|A-4267-OUT,B-22-RGB;n:type:ShaderForge.SFN_TexCoord,id:4273,x:32053,y:33100,varname:node_4273,prsc:2,uv:1;proporder:1304-4595-4388-22;pass:END;sub:END;*/

Shader "sf/UI-Lightmap-Diffuse" {
    Properties {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("MainTex", 2D) = "white" {}
        _Illumin ("Illumin", Range(0, 2)) = 1
        _LightmapTex ("LightmapTex", 2D) = "white" {}
    }
    SubShader {
        Tags {
            "RenderType"="Opaque"
        }
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
            #pragma multi_compile_fwdbase_fullshadows
            #pragma exclude_renderers d3d11_9x xbox360 xboxone ps3 ps4 psp2 
            #pragma target 3.0
            #pragma multi_compile GOE_FLINEAR_OFF GOE_FLINEAR_ON
            uniform fixed4 _GOEFogColor;
            uniform float _GOEFogStart;
            uniform float _GOEFogEnd;
            uniform float4 _Color;
            uniform sampler2D _MainTex; uniform float4 _MainTex_ST;
            uniform float _Illumin;
            uniform float _GlobalLight;
            uniform sampler2D _LightmapTex; uniform float4 _LightmapTex_ST;
            struct VertexInput {
                float4 vertex : POSITION;
                float2 texcoord0 : TEXCOORD0;
                float2 texcoord1 : TEXCOORD1;
            };
            struct VertexOutput {
                float4 pos : SV_POSITION;
                float2 uv0 : TEXCOORD0;
                float2 uv1 : TEXCOORD1;
                #ifdef GOE_FLINEAR_ON
                float fogFactor : TEXCOORD2;
                #endif
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.uv0 = v.texcoord0;
                o.uv1 = v.texcoord1;
                o.pos = UnityObjectToClipPos(v.vertex );
                #ifdef GOE_FLINEAR_ON
                o.fogFactor = (_GOEFogEnd - o.pos.z) / (_GOEFogEnd - _GOEFogStart);
                #endif
                return o;
            }
            float4 frag(VertexOutput i) : COLOR {
////// Lighting:
                float4 _MainTex_var = tex2D(_MainTex,TRANSFORM_TEX(i.uv0, _MainTex));
                float4 _LightmapTex_var = tex2D(_LightmapTex,TRANSFORM_TEX(i.uv1, _LightmapTex));
                float3 finalColor = ((_MainTex_var.rgb*_Color.rgb*_Illumin*(_GlobalLight+1.0))*_LightmapTex_var.rgb);
                fixed4 finalRGBA = fixed4(finalColor,1);
                #ifdef GOE_FLINEAR_ON
                finalRGBA.rgb = lerp(_GOEFogColor.rgb, finalRGBA.rgb, saturate(i.fogFactor));
                #endif
                return finalRGBA;
            }
            ENDCG
        }
    }
    FallBack "Diffuse"
    CustomEditor "ShaderForgeMaterialInspector"
}
