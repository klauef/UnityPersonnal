Shader "Personal/multiple light bump mapping and shadows"{

	Properties{
		_Tint("Tint", Color) = (1, 1, 1, 1)
		_MainTex("Albedo", 2D) = "white" {}
		[NoScaleOffset] _NormalMap("Normals", 2D) = "bump" {}
		_BumpScale("Bump Scale", Float) = 1
		_DetailTex("Detail Texture", 2D) = "gray" {}
		[NoScaleOffset] _DetailNormalMap("Detail Normals", 2D) = "bump" {}
		_DetailBumpScale("Detail Bump Scale", Float) = 1
		_Smoothness("Smoothness", Range(0, 1)) = 0.5
		[Gamma] _Metallic("Metallic", Range(0, 1)) = 0
	}

		SubShader{
			Pass{
				Tags {
					"LightMode" = "ForwardBase"
				}

				CGPROGRAM

				#pragma target 3.0
				#pragma vertex vertexShader
				#pragma fragment fragmentShader
				#define POINT

				#include "UnityPBSLighting.cginc"
				#include "AutoLight.cginc"

				#include "bumpMapping.cginc"


				ENDCG

			}

			//passe servant à ajouter les couleurs avec le même modèle
			Pass {
				Tags {
					"LightMode" = "ForwardAdd"
				}

				//precise que l'on souhaite mélanger les résultats avec les passes d'avant
				Blend One One
				ZWrite Off
				CGPROGRAM

				#pragma target 3.0

				#pragma vertex vertexShader
				#pragma fragment fragmentShader
				#define POINT

				#include "UnityPBSLighting.cginc"
				#include "AutoLight.cginc"

				#include "bumpMapping.cginc"

				ENDCG
			}

			Pass {
				Tags {
					"LightMode" = "ShadowCaster"
				}

				CGPROGRAM

				#pragma target 3.0

				#pragma vertex shadowVertexProgram
				#pragma fragment shadowFragmentProgram

				#include "shadowCast.cginc"

				ENDCG
			}
		}
}
