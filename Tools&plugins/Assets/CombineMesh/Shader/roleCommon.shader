// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Shader created with Shader Forge v1.35 
// Shader Forge (c) Neat Corporation / Joachim Holmer - http://www.acegikmo.com/shaderforge/
// Note: Manually altering this data may prevent you from opening it in Shader Forge
/*SF_DATA;ver:1.35;sub:START;pass:START;ps:flbk:Standard,iptp:0,cusa:False,bamd:0,lico:0,lgpr:1,limd:0,spmd:1,trmd:0,grmd:0,uamb:True,mssp:True,bkdf:True,hqlp:True,rprd:False,enco:False,rmgx:True,imps:True,rpth:0,vtps:0,hqsc:True,nrmq:1,nrsp:0,vomd:0,spxs:False,tesm:0,olmd:1,culm:0,bsrc:0,bdst:1,dpts:2,wrdp:True,dith:0,atcv:False,rfrpo:False,rfrpn:Refraction,coma:15,ufog:False,aust:True,igpj:False,qofs:0,qpre:1,rntp:1,fgom:False,fgoc:False,fgod:False,fgor:False,fgmd:0,fgcr:0.5,fgcg:0.5,fgcb:0.5,fgca:1,fgde:0.01,fgrn:0,fgrf:300,stcl:False,stva:128,stmr:127,stmw:255,stcp:5,stps:0,stfa:0,stfz:0,ofsf:0,ofsu:0,f2p0:False,fnsp:False,fnfb:False;n:type:ShaderForge.SFN_Final,id:0,x:35217,y:32020,varname:node_0,prsc:2|emission-573-OUT,custl-7268-OUT,olwid-9558-OUT;n:type:ShaderForge.SFN_Dot,id:40,x:31995,y:32076,varname:node_40,prsc:1,dt:4|A-42-OUT,B-41-OUT;n:type:ShaderForge.SFN_NormalVector,id:41,x:31448,y:32312,prsc:2,pt:False;n:type:ShaderForge.SFN_LightVector,id:42,x:31448,y:32086,varname:node_42,prsc:2;n:type:ShaderForge.SFN_Add,id:55,x:33666,y:32297,varname:node_55,prsc:2|A-1691-OUT,B-9822-OUT,C-1699-OUT,D-8676-OUT;n:type:ShaderForge.SFN_LightColor,id:63,x:33666,y:32129,varname:node_63,prsc:2;n:type:ShaderForge.SFN_Multiply,id:64,x:33923,y:32276,varname:node_64,prsc:2|A-63-RGB,B-55-OUT;n:type:ShaderForge.SFN_Tex2d,id:82,x:31448,y:31469,ptovrint:True,ptlb:MainTex,ptin:_MainTex,varname:_MainTex,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,ntxv:1,isnm:False;n:type:ShaderForge.SFN_Tex2d,id:6184,x:32590,y:32079,varname:_RampR,prsc:2,ntxv:0,isnm:False|UVIN-9337-OUT,TEX-5972-TEX;n:type:ShaderForge.SFN_Append,id:9337,x:32248,y:32076,varname:node_9337,prsc:1|A-40-OUT,B-5820-OUT;n:type:ShaderForge.SFN_Vector1,id:5820,x:31998,y:32250,varname:node_5820,prsc:1,v1:0.5;n:type:ShaderForge.SFN_Tex2dAsset,id:5972,x:32248,y:32316,ptovrint:True,ptlb:RampTex,ptin:_RampTex,varname:_RampTex,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,ntxv:0,isnm:False;n:type:ShaderForge.SFN_Color,id:7236,x:32581,y:32844,ptovrint:True,ptlb:RimColor,ptin:_RimColor,varname:_RimColor,prsc:0,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,c1:0.5,c2:0.5,c3:0.5,c4:1;n:type:ShaderForge.SFN_Tex2d,id:8918,x:31441,y:31755,varname:_MaskTex,prsc:2,ntxv:1,isnm:False|TEX-2141-TEX;n:type:ShaderForge.SFN_Lerp,id:1336,x:33054,y:31621,varname:node_1336,prsc:2|A-6795-OUT,B-8671-OUT,T-9410-OUT;n:type:ShaderForge.SFN_Multiply,id:6039,x:31748,y:31468,varname:node_6039,prsc:2|A-82-RGB,B-8918-B;n:type:ShaderForge.SFN_Slider,id:2235,x:33036,y:33066,ptovrint:True,ptlb:OutlineWidth,ptin:_OutlineWidth,varname:_OutlineWidth,prsc:0,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:0,max:1;n:type:ShaderForge.SFN_RemapRange,id:3314,x:33446,y:32893,varname:node_3314,prsc:2,frmn:0,frmx:1,tomn:0,tomx:0.1|IN-2235-OUT;n:type:ShaderForge.SFN_Multiply,id:9410,x:32879,y:32077,varname:node_9410,prsc:2|A-8918-G,B-6184-R,C-8797-OUT;n:type:ShaderForge.SFN_Color,id:3116,x:32283,y:31197,ptovrint:True,ptlb:ClothShadowColor,ptin:_ShadowColor,varname:_ShadowColor,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,c1:0.5,c2:0.5,c3:0.5,c4:1;n:type:ShaderForge.SFN_Color,id:684,x:32295,y:30980,ptovrint:True,ptlb:SkinShadowColor,ptin:_SkinShadowColor,varname:_SkinShadowColor,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,c1:0.5,c2:0.5,c3:0.5,c4:1;n:type:ShaderForge.SFN_Color,id:8179,x:33035,y:31381,ptovrint:True,ptlb:Color,ptin:_Color,varname:_Color,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,c1:0.5,c2:0.5,c3:0.5,c4:1;n:type:ShaderForge.SFN_Slider,id:4177,x:32442,y:32700,ptovrint:True,ptlb:RimStrenth,ptin:_RimWidth,varname:_RimWidth,prsc:0,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:0.99,max:2;n:type:ShaderForge.SFN_Transform,id:6552,x:31764,y:32514,varname:node_6552,prsc:2,tffrom:0,tfto:3|IN-41-OUT;n:type:ShaderForge.SFN_ComponentMask,id:1334,x:31995,y:32514,varname:node_1334,prsc:2,cc1:0,cc2:1,cc3:-1,cc4:-1|IN-6552-XYZ;n:type:ShaderForge.SFN_RemapRange,id:8472,x:32248,y:32514,varname:node_8472,prsc:2,frmn:-1,frmx:1,tomn:0,tomx:1|IN-1334-OUT;n:type:ShaderForge.SFN_Tex2d,id:7209,x:32594,y:32513,varname:_RimTex,prsc:2,ntxv:0,isnm:False|UVIN-8472-OUT,TEX-5972-TEX;n:type:ShaderForge.SFN_Multiply,id:9822,x:32882,y:32553,varname:node_9822,prsc:2|A-7209-G,B-4177-OUT,C-7236-RGB;n:type:ShaderForge.SFN_Multiply,id:9879,x:32273,y:31653,varname:node_9879,prsc:2|A-82-RGB,B-8806-OUT;n:type:ShaderForge.SFN_Tex2dAsset,id:2141,x:31229,y:31795,ptovrint:True,ptlb:ShadowTex,ptin:_ShadowTex,varname:_ShadowTex,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,ntxv:0,isnm:False;n:type:ShaderForge.SFN_OneMinus,id:8806,x:32009,y:31669,varname:node_8806,prsc:2|IN-8918-B;n:type:ShaderForge.SFN_Color,id:1751,x:32009,y:31254,ptovrint:True,ptlb:SkinChangeColor,ptin:_SkinChangeColor,varname:_SkinChangeColor,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,c1:0.5,c2:0.5,c3:0.5,c4:1;n:type:ShaderForge.SFN_Multiply,id:9228,x:32273,y:31447,varname:node_9228,prsc:2|A-1751-RGB,B-9881-OUT;n:type:ShaderForge.SFN_ComponentMask,id:757,x:31764,y:32316,varname:node_757,prsc:2,cc1:1,cc2:-1,cc3:-1,cc4:-1|IN-41-OUT;n:type:ShaderForge.SFN_RemapRange,id:8797,x:31995,y:32316,varname:node_8797,prsc:2,frmn:-1,frmx:1,tomn:0.5,tomx:1|IN-757-OUT;n:type:ShaderForge.SFN_Tex2d,id:2042,x:32594,y:32284,varname:_node_2042,prsc:2,ntxv:0,isnm:False|UVIN-8472-OUT,TEX-5972-TEX;n:type:ShaderForge.SFN_Multiply,id:1699,x:32882,y:32324,varname:node_1699,prsc:2|A-8918-R,B-2042-B,C-970-OUT;n:type:ShaderForge.SFN_Slider,id:970,x:32443,y:31934,ptovrint:True,ptlb:SpcStrenth,ptin:_SpcStrenth,varname:_SpcStrenth,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:0,max:10;n:type:ShaderForge.SFN_VertexColor,id:2702,x:33446,y:32702,varname:node_2702,prsc:2;n:type:ShaderForge.SFN_Multiply,id:9558,x:33723,y:32733,varname:node_9558,prsc:2|A-3314-OUT,B-2702-A;n:type:ShaderForge.SFN_Add,id:8671,x:32600,y:31632,varname:node_8671,prsc:2|A-9228-OUT,B-9879-OUT;n:type:ShaderForge.SFN_Multiply,id:1691,x:33326,y:31604,varname:node_1691,prsc:2|A-8179-RGB,B-1336-OUT;n:type:ShaderForge.SFN_Multiply,id:9881,x:32009,y:31468,varname:node_9881,prsc:2|A-6039-OUT,B-7655-OUT;n:type:ShaderForge.SFN_Vector1,id:7655,x:31748,y:31651,varname:node_7655,prsc:2,v1:2;n:type:ShaderForge.SFN_Multiply,id:7970,x:32600,y:31214,varname:node_7970,prsc:2|A-684-RGB,B-9228-OUT;n:type:ShaderForge.SFN_Multiply,id:6239,x:32600,y:31442,varname:node_6239,prsc:2|A-3116-RGB,B-9879-OUT;n:type:ShaderForge.SFN_Add,id:6795,x:32833,y:31347,varname:node_6795,prsc:2|A-7970-OUT,B-6239-OUT,C-7970-OUT;n:type:ShaderForge.SFN_Color,id:2190,x:33753,y:31500,ptovrint:False,ptlb:InnerGlowColor,ptin:_InnerGlowColor,varname:node_2190,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,c1:0,c2:0,c3:0,c4:1;n:type:ShaderForge.SFN_Vector1,id:2420,x:32712,y:31570,varname:node_2420,prsc:2,v1:2;n:type:ShaderForge.SFN_Subtract,id:8717,x:33054,y:31778,varname:node_8717,prsc:2|A-2420-OUT,B-1058-OUT;n:type:ShaderForge.SFN_Slider,id:1058,x:32443,y:31807,ptovrint:False,ptlb:InnerGlowRange,ptin:_InnerGlowRange,varname:node_1058,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:0,max:2;n:type:ShaderForge.SFN_Step,id:3424,x:33328,y:31897,cmnt:使用一个属性就可以控制有没有发光,varname:node_3424,prsc:2|A-7924-OUT,B-1058-OUT;n:type:ShaderForge.SFN_Fresnel,id:3338,x:33388,y:31464,varname:node_3338,prsc:2|NRM-6535-OUT,EXP-8717-OUT;n:type:ShaderForge.SFN_NormalVector,id:6535,x:33024,y:31202,prsc:2,pt:False;n:type:ShaderForge.SFN_Vector1,id:7924,x:33132,y:32014,varname:node_7924,prsc:2,v1:0.01;n:type:ShaderForge.SFN_Multiply,id:9039,x:33576,y:31716,varname:node_9039,prsc:2|A-3338-OUT,B-3424-OUT;n:type:ShaderForge.SFN_Multiply,id:3891,x:34129,y:31717,varname:node_3891,prsc:2|A-2190-RGB,B-9039-OUT;n:type:ShaderForge.SFN_ValueProperty,id:3714,x:33923,y:32157,ptovrint:False,ptlb:Fade,ptin:_Fade,varname:node_3714,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:0;n:type:ShaderForge.SFN_Step,id:6756,x:34134,y:32064,varname:node_6756,prsc:2|A-6293-OUT,B-3714-OUT;n:type:ShaderForge.SFN_Vector1,id:6293,x:33923,y:32046,varname:node_6293,prsc:2,v1:0.5;n:type:ShaderForge.SFN_Dot,id:8815,x:34345,y:31848,varname:node_8815,prsc:2,dt:0|A-3891-OUT,B-7346-OUT;n:type:ShaderForge.SFN_Vector3,id:7346,x:34134,y:31864,varname:node_7346,prsc:2,v1:0.299,v2:0.587,v3:0.114;n:type:ShaderForge.SFN_Lerp,id:384,x:34730,y:31945,varname:node_384,prsc:2|A-3891-OUT,B-8815-OUT,T-6756-OUT;n:type:ShaderForge.SFN_Lerp,id:9528,x:34686,y:32262,varname:node_9528,prsc:2|A-64-OUT,B-810-OUT,T-6756-OUT;n:type:ShaderForge.SFN_Dot,id:810,x:34505,y:32148,varname:node_810,prsc:2,dt:0|A-7346-OUT,B-64-OUT;n:type:ShaderForge.SFN_Color,id:5470,x:32903,y:32786,ptovrint:False,ptlb:self-luminous,ptin:_selfluminous,varname:node_2249,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,c1:0,c2:0,c3:0,c4:1;n:type:ShaderForge.SFN_Multiply,id:8676,x:33327,y:32557,varname:node_8676,prsc:2|A-8918-A,B-5470-RGB;n:type:ShaderForge.SFN_Multiply,id:573,x:35033,y:31940,varname:node_573,prsc:2|A-6426-R,B-384-OUT;n:type:ShaderForge.SFN_Multiply,id:7268,x:34976,y:32170,varname:node_7268,prsc:2|A-6426-R,B-9528-OUT;n:type:ShaderForge.SFN_Color,id:6426,x:34761,y:31721,ptovrint:False,ptlb:IsBlack,ptin:_IsBlack,varname:node_6426,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,c1:1,c2:1,c3:1,c4:1;proporder:8179-1751-82-2141-5972-684-3116-7236-4177-2235-970-1058-2190-3714-5470-6426;pass:END;sub:END;*/

Shader "ZHT/roleCommon" {
    Properties {
        _Color ("Color", Color) = (0.5,0.5,0.5,1)
        _SkinChangeColor ("SkinChangeColor", Color) = (0.5,0.5,0.5,1)
        _MainTex ("MainTex", 2D) = "gray" {}
        _ShadowTex ("ShadowTex", 2D) = "white" {}
        _RampTex ("RampTex", 2D) = "white" {}
        _SkinShadowColor ("SkinShadowColor", Color) = (0.5,0.5,0.5,1)
        _ShadowColor ("ClothShadowColor", Color) = (0.5,0.5,0.5,1)
        _RimColor ("RimColor", Color) = (0.5,0.5,0.5,1)
        _RimWidth ("RimStrenth", Range(0, 2)) = 0.99
        _OutlineWidth ("OutlineWidth", Range(0, 1)) = 0
        _SpcStrenth ("SpcStrenth", Range(0, 10)) = 0
        _InnerGlowRange ("InnerGlowRange", Range(0, 2)) = 0
        _InnerGlowColor ("InnerGlowColor", Color) = (0,0,0,1)
        _Fade ("Fade", Float ) = 0
        _selfluminous ("self-luminous", Color) = (0,0,0,1)
        _IsBlack ("IsBlack", Color) = (1,1,1,1)
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
            #include "AutoLight.cginc"
#pragma multi_compile Quality_High_ON Quality_High_OFF
            #pragma multi_compile_fwdbase_fullshadows
            #pragma only_renderers d3d9 d3d11 glcore gles gles3 metal 
            #pragma target 3.0
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
            uniform float4 _IsBlack;
            struct VertexInput {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float2 texcoord0 : TEXCOORD0;
            };
            struct VertexOutput {
                float4 pos : SV_POSITION;
                float2 uv0 : TEXCOORD0;
                float4 posWorld : TEXCOORD1;
                float3 normalDir : TEXCOORD2;
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.uv0 = v.texcoord0;
                o.normalDir = UnityObjectToWorldNormal(v.normal);
                o.posWorld = mul(unity_ObjectToWorld, v.vertex);
                float3 lightColor = _LightColor0.rgb;
                o.pos = UnityObjectToClipPos(v.vertex );
                return o;
            }
            float4 frag(VertexOutput i) : COLOR {
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

			float3 tempColor =   node_64
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
    FallBack "Standard"
    CustomEditor "ShaderForgeMaterialInspector"
}
