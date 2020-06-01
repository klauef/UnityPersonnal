#if !defined(MY_SHADOWS_INCLUDED)
#define MY_SHADOWS_INCLUDED

#include "UnityCG.cginc"			
#pragma multi_compile _ SHADOWS_SCREEN
#pragma multi_compile _ VERTEXLIGHT_ON

struct VertexData {
	float4 position : POSITION;
	float3 normal : NORMAL;
};

float4 shadowVertexProgram(VertexData v) : SV_POSITION{
	float4 position = UnityClipSpaceShadowCasterPos(v.position.xyz, v.normal);
	return UnityApplyLinearShadowBias(position);
}

half4 shadowFragmentProgram() : SV_TARGET{
	return 0;
}

#endif