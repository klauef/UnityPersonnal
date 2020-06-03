#if !defined(MYLIGHTING)
#define MYLIGHTING
#include "UnityPBSLighting.cginc"
#pragma vertex vertexShader
#pragma fragment fragmentShader


float4 _Tint;

sampler2D _MainTex;
float4 _MainTex_ST;

sampler2D _NormalMap;
float _BumpScale;

sampler2D _HeightMap;
float _ParallaxFactor;

float _Smoothness;
float _Metallic;


struct VertexData {
	float4 position : POSITION;
	float3 normal : NORMAL;
	float4 tangent : TANGENT;
	float2 uv : TEXCOORD0;
};

struct Interpolators {
	float4 position : SV_POSITION;
	float4 uv : TEXCOORD0;
	float3 normal : TEXCOORD1;
	float4 tangent : TEXCOORD2;
	float3 worldPos : TEXCOORD3;
};

//function which initialize normal
void InitializeFragmentNormal(inout Interpolators i) {
	/*
	/////////bumpMap
	float2 du = float2(_HeightMap_TexelSize.x * 0.5, 0);
	float u1 = tex2D(_HeightMap, i.uv - du);
	float u2 = tex2D(_HeightMap, i.uv + du);

	float2 dv = float2(0, _HeightMap_TexelSize.y * 0.5);
	float v1 = tex2D(_HeightMap, i.uv - dv);
	float v2 = tex2D(_HeightMap, i.uv + dv);

	i.normal = float3(u1 - u2, 1, v1 - v2);
	*/
	float3 mainNormal = UnpackScaleNormal(tex2D(_NormalMap, i.uv.xy), _BumpScale);
	float3 tangentSpaceNormal = mainNormal.xzy;

	float3 binormal = cross(i.normal, i.tangent.xyz) * (i.tangent.w * unity_WorldTransformParams.w);
	i.normal = normalize(
		tangentSpaceNormal.x * i.tangent +
		tangentSpaceNormal.y * i.normal +
		tangentSpaceNormal.z * binormal
	);
}

//function which create a light
UnityLight CreateLight(Interpolators i) {
	UnityLight light;
	light.dir = normalize(_WorldSpaceLightPos0.xyz - i.worldPos);

	UNITY_LIGHT_ATTENUATION(attenuation, 0, i.worldPos);

	light.color = _LightColor0.rgb * attenuation;
	light.ndotl = DotClamped(i.normal, light.dir);
	return light;
}

Interpolators vertexShader(VertexData v) {
	Interpolators i;
	i.position = UnityObjectToClipPos(v.position);
	i.worldPos = mul(unity_ObjectToWorld, v.position);
	i.normal = UnityObjectToWorldNormal(v.normal);
	i.tangent = float4(UnityObjectToWorldDir(v.tangent.xyz), v.tangent.w);
	i.uv.xy = TRANSFORM_TEX(v.uv, _MainTex);
	return i;
}

float4 fragmentShader(Interpolators i) : SV_TARGET{

	InitializeFragmentNormal(i);

	float3 viewDir = normalize(_WorldSpaceCameraPos - i.worldPos);
	float3 albedo = tex2D(_MainTex, i.uv.xy).rgb * _Tint.rgb;

	float3 specularTint;
	float oneMinusReflectivity;
	albedo = DiffuseAndSpecularFromMetallic(
		albedo, _Metallic, specularTint, oneMinusReflectivity
	);

	UnityIndirect indirectLight;
	indirectLight.diffuse = 0;
	indirectLight.specular = 0;


	return UNITY_BRDF_PBS(
		albedo, specularTint,
		oneMinusReflectivity, _Smoothness,
		i.normal, viewDir,
		CreateLight(i), indirectLight
	);
	//return float4(diffuse + specular, 1);
}
#endif