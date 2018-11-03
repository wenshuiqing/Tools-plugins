// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Shader created with Shader Forge v1.35
// Shader Forge (c) Neat Corporation / Joachim Holmer - http://www.acegikmo.com/shaderforge/
// Note: Manually altering this data may prevent you from opening it in Shader Forge
/*SF_DATA;ver:1.35;sub:START;pass:START;ps:flbk:Standard,iptp:0,cusa:False,bamd:0,lico:0,lgpr:1,limd:0,spmd:1,trmd:0,grmd:0,uamb:True,mssp:True,bkdf:True,hqlp:True,rprd:False,enco:False,rmgx:True,imps:True,rpth:0,vtps:0,hqsc:True,nrmq:1,nrsp:0,vomd:0,spxs:False,tesm:0,olmd:1,culm:0,bsrc:0,bdst:1,dpts:2,wrdp:True,dith:0,atcv:False,rfrpo:False,rfrpn:Refraction,coma:15,ufog:False,aust:True,igpj:False,qofs:0,qpre:1,rntp:1,fgom:False,fgoc:False,fgod:False,fgor:False,fgmd:0,fgcr:0.5,fgcg:0.5,fgcb:0.5,fgca:1,fgde:0.01,fgrn:0,fgrf:300,stcl:False,stva:128,stmr:127,stmw:255,stcp:5,stps:0,stfa:0,stfz:0,ofsf:0,ofsu:0,f2p0:False,fnsp:False,fnfb:False;n:type:ShaderForge.SFN_Final,id:0,x:35217,y:32020,varname:node_0,prsc:2|emission-3891-OUT,custl-64-OUT,olwid-9558-OUT;n:type:ShaderForge.SFN_Dot,id:40,x:31815,y:32053,varname:node_40,prsc:1,dt:4|A-42-OUT,B-41-OUT;n:type:ShaderForge.SFN_NormalVector,id:41,x:31268,y:32289,prsc:2,pt:False;n:type:ShaderForge.SFN_LightVector,id:42,x:31268,y:32063,varname:node_42,prsc:2;n:type:ShaderForge.SFN_Add,id:55,x:33486,y:32274,varname:node_55,prsc:2|A-1691-OUT,B-9822-OUT,C-1699-OUT;n:type:ShaderForge.SFN_LightColor,id:63,x:33486,y:32106,varname:node_63,prsc:2;n:type:ShaderForge.SFN_Multiply,id:64,x:33743,y:32253,varname:node_64,prsc:2|A-63-RGB,B-55-OUT;n:type:ShaderForge.SFN_Tex2d,id:82,x:31268,y:31446,ptovrint:True,ptlb:MainTex,ptin:_MainTex,varname:_MainTex,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,ntxv:1,isnm:False;n:type:ShaderForge.SFN_Tex2d,id:6184,x:32410,y:32056,varname:_RampR,prsc:2,ntxv:0,isnm:False|UVIN-9337-OUT,TEX-5972-TEX;n:type:ShaderForge.SFN_Append,id:9337,x:32068,y:32053,varname:node_9337,prsc:1|A-40-OUT,B-5820-OUT;n:type:ShaderForge.SFN_Vector1,id:5820,x:31818,y:32227,varname:node_5820,prsc:1,v1:0.5;n:type:ShaderForge.SFN_Tex2dAsset,id:5972,x:32068,y:32293,ptovrint:True,ptlb:RampTex,ptin:_RampTex,varname:_RampTex,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,ntxv:0,isnm:False;n:type:ShaderForge.SFN_Color,id:7236,x:32401,y:32821,ptovrint:True,ptlb:RimColor,ptin:_RimColor,varname:_RimColor,prsc:0,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,c1:0.5,c2:0.5,c3:0.5,c4:1;n:type:ShaderForge.SFN_Tex2d,id:8918,x:31261,y:31732,varname:_MaskTex,prsc:2,ntxv:1,isnm:False|TEX-2141-TEX;n:type:ShaderForge.SFN_Lerp,id:1336,x:32874,y:31595,varname:node_1336,prsc:2|A-6795-OUT,B-8671-OUT,T-9410-OUT;n:type:ShaderForge.SFN_Multiply,id:6039,x:31568,y:31445,varname:node_6039,prsc:2|A-82-RGB,B-8918-B;n:type:ShaderForge.SFN_Slider,id:2235,x:33076,y:32811,ptovrint:True,ptlb:OutlineWidth,ptin:_OutlineWidth,varname:_OutlineWidth,prsc:0,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:0,max:1;n:type:ShaderForge.SFN_RemapRange,id:3314,x:33486,y:32638,varname:node_3314,prsc:2,frmn:0,frmx:1,tomn:0,tomx:0.1|IN-2235-OUT;n:type:ShaderForge.SFN_Multiply,id:9410,x:32699,y:32054,varname:node_9410,prsc:2|A-8918-G,B-6184-R,C-8797-OUT;n:type:ShaderForge.SFN_Color,id:3116,x:32103,y:31174,ptovrint:True,ptlb:ClothShadowColor,ptin:_ShadowColor,varname:_ShadowColor,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,c1:0.5,c2:0.5,c3:0.5,c4:1;n:type:ShaderForge.SFN_Color,id:684,x:32115,y:30957,ptovrint:True,ptlb:SkinShadowColor,ptin:_SkinShadowColor,varname:_SkinShadowColor,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,c1:0.5,c2:0.5,c3:0.5,c4:1;n:type:ShaderForge.SFN_Color,id:8179,x:32855,y:31358,ptovrint:True,ptlb:Color,ptin:_Color,varname:_Color,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,c1:0.5,c2:0.5,c3:0.5,c4:1;n:type:ShaderForge.SFN_Slider,id:4177,x:32262,y:32677,ptovrint:True,ptlb:RimStrenth,ptin:_RimWidth,varname:_RimWidth,prsc:0,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:0.99,max:2;n:type:ShaderForge.SFN_Transform,id:6552,x:31584,y:32491,varname:node_6552,prsc:2,tffrom:0,tfto:3|IN-41-OUT;n:type:ShaderForge.SFN_ComponentMask,id:1334,x:31815,y:32491,varname:node_1334,prsc:2,cc1:0,cc2:1,cc3:-1,cc4:-1|IN-6552-XYZ;n:type:ShaderForge.SFN_RemapRange,id:8472,x:32068,y:32491,varname:node_8472,prsc:2,frmn:-1,frmx:1,tomn:0,tomx:1|IN-1334-OUT;n:type:ShaderForge.SFN_Tex2d,id:7209,x:32414,y:32490,varname:_RimTex,prsc:2,ntxv:0,isnm:False|UVIN-8472-OUT,TEX-5972-TEX;n:type:ShaderForge.SFN_Multiply,id:9822,x:32702,y:32530,varname:node_9822,prsc:2|A-7209-G,B-4177-OUT,C-7236-RGB;n:type:ShaderForge.SFN_Multiply,id:9879,x:32093,y:31630,varname:node_9879,prsc:2|A-82-RGB,B-8806-OUT;n:type:ShaderForge.SFN_Tex2dAsset,id:2141,x:31049,y:31772,ptovrint:True,ptlb:ShadowTex,ptin:_ShadowTex,varname:_ShadowTex,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,ntxv:0,isnm:False;n:type:ShaderForge.SFN_OneMinus,id:8806,x:31829,y:31646,varname:node_8806,prsc:2|IN-8918-B;n:type:ShaderForge.SFN_Color,id:1751,x:31829,y:31231,ptovrint:True,ptlb:SkinChangeColor,ptin:_SkinChangeColor,varname:_SkinChangeColor,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,c1:0.5,c2:0.5,c3:0.5,c4:1;n:type:ShaderForge.SFN_Multiply,id:9228,x:32093,y:31424,varname:node_9228,prsc:2|A-1751-RGB,B-9881-OUT;n:type:ShaderForge.SFN_ComponentMask,id:757,x:31584,y:32293,varname:node_757,prsc:2,cc1:1,cc2:-1,cc3:-1,cc4:-1|IN-41-OUT;n:type:ShaderForge.SFN_RemapRange,id:8797,x:31815,y:32293,varname:node_8797,prsc:2,frmn:-1,frmx:1,tomn:0.5,tomx:1|IN-757-OUT;n:type:ShaderForge.SFN_Tex2d,id:2042,x:32414,y:32261,varname:_node_2042,prsc:2,ntxv:0,isnm:False|UVIN-8472-OUT,TEX-5972-TEX;n:type:ShaderForge.SFN_Multiply,id:1699,x:32702,y:32301,varname:node_1699,prsc:2|A-8918-R,B-2042-B,C-970-OUT;n:type:ShaderForge.SFN_Slider,id:970,x:32332,y:31915,ptovrint:True,ptlb:SpcStrenth,ptin:_SpcStrenth,varname:_SpcStrenth,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:0,max:10;n:type:ShaderForge.SFN_VertexColor,id:2702,x:33486,y:32447,varname:node_2702,prsc:2;n:type:ShaderForge.SFN_Multiply,id:9558,x:33763,y:32478,varname:node_9558,prsc:2|A-3314-OUT,B-2702-A;n:type:ShaderForge.SFN_Add,id:8671,x:32420,y:31609,varname:node_8671,prsc:2|A-9228-OUT,B-9879-OUT;n:type:ShaderForge.SFN_Multiply,id:1691,x:33146,y:31581,varname:node_1691,prsc:2|A-8179-RGB,B-1336-OUT;n:type:ShaderForge.SFN_Multiply,id:9881,x:31829,y:31445,varname:node_9881,prsc:2|A-6039-OUT,B-7655-OUT;n:type:ShaderForge.SFN_Vector1,id:7655,x:31568,y:31628,varname:node_7655,prsc:2,v1:2;n:type:ShaderForge.SFN_Multiply,id:7970,x:32420,y:31191,varname:node_7970,prsc:2|A-684-RGB,B-9228-OUT;n:type:ShaderForge.SFN_Multiply,id:6239,x:32420,y:31419,varname:node_6239,prsc:2|A-3116-RGB,B-9879-OUT;n:type:ShaderForge.SFN_Add,id:6795,x:32653,y:31324,varname:node_6795,prsc:2|A-7970-OUT,B-6239-OUT,C-7970-OUT;n:type:ShaderForge.SFN_Color,id:2190,x:34504,y:31638,ptovrint:False,ptlb:InnerGlowColor,ptin:_InnerGlowColor,varname:node_2190,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,c1:0,c2:0,c3:0,c4:1;n:type:ShaderForge.SFN_Vector1,id:2420,x:33463,y:31708,varname:node_2420,prsc:2,v1:2;n:type:ShaderForge.SFN_Subtract,id:8717,x:33796,y:31778,varname:node_8717,prsc:2|A-2420-OUT,B-1058-OUT;n:type:ShaderForge.SFN_Slider,id:1058,x:33402,y:31939,ptovrint:False,ptlb:InnerGlowRange,ptin:_InnerGlowRange,varname:node_1058,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:0,max:2;n:type:ShaderForge.SFN_Step,id:3424,x:34079,y:32035,cmnt:使用一个属性就可以控制有没有发光,varname:node_3424,prsc:2|A-7924-OUT,B-1058-OUT;n:type:ShaderForge.SFN_Fresnel,id:3338,x:34139,y:31602,varname:node_3338,prsc:2|NRM-6535-OUT,EXP-8717-OUT;n:type:ShaderForge.SFN_NormalVector,id:6535,x:33867,y:31602,prsc:2,pt:False;n:type:ShaderForge.SFN_Vector1,id:7924,x:33904,y:31972,varname:node_7924,prsc:2,v1:0.01;n:type:ShaderForge.SFN_Multiply,id:9039,x:34327,y:31854,varname:node_9039,prsc:2|A-3338-OUT,B-3424-OUT;n:type:ShaderForge.SFN_Multiply,id:3891,x:34880,y:31855,varname:node_3891,prsc:2|A-2190-RGB,B-9039-OUT;proporder:8179-1751-82-2141-5972-684-3116-7236-4177-2235-970-1058-2190;pass:END;sub:END;*/

Shader "ZHT/outline1" {
	Properties{
		_OutlineWidth("OutlineWidth", Range(0, 1)) = 0

	}
		SubShader{
		Tags{
		"RenderType" = "Opaque"
	}
		Pass{
		Name "Outline"
		Tags{
	}
	//ZWrite Off
		Cull Front

		CGPROGRAM
#pragma vertex vert
#pragma fragment frag
#include "UnityCG.cginc"
#pragma fragmentoption ARB_precision_hint_fastest
#pragma multi_compile_shadowcaster
#pragma only_renderers d3d9 d3d11 glcore gles gles3 metal
#pragma target 3.0
		uniform fixed _OutlineWidth;
	struct VertexInput
	{
		float4 vertex : POSITION;
		float3 normal : NORMAL;
		float4 vertexColor : COLOR;
	};
	struct VertexOutput
	{
		float4 pos : SV_POSITION;
		float4 vertexColor : COLOR;
	};
	VertexOutput vert(VertexInput v)
	{
		VertexOutput o = (VertexOutput)0;
		o.vertexColor = v.vertexColor;
		o.pos = UnityObjectToClipPos(float4(v.vertex.xyz + v.normal*((_OutlineWidth*0.1 + 0.0)*o.vertexColor.a),1));
		return o;
	}
	float4 frag(VertexOutput i) : COLOR{
		return fixed4(float3(0,0,0),0);
	}
		ENDCG
	}
	}
		FallBack "Standard"
}
