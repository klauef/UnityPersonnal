Shader "Personal/Metallic multiple light point"{

	Properties{
		_Tint("Tint", Color) = (1, 1, 1, 1)
		_MainTex("Albedo", 2D) = "white" {}
		_Smoothness("Smoothness", Range(0, 1)) = 0.5
		[Gamma] _Metallic("Metallic", Range(0, 1)) = 0
		[MaterialToggle] _test("test", Float) = 0
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

				#include "pointLight.cginc"


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

				#include "pointLight.cginc"

				ENDCG
			}
		}
}
