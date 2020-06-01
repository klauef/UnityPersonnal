Shader "Personal/Basic"{

	Properties{
		_Tint("Tint", Color) = (1, 1, 1, 1)
		_MainTex("Texture", 2D) = "white" {}
		_MainDetailTex("Texture detail", 2D) = "white" {}
	}

		SubShader{
			Pass{

				CGPROGRAM

				#pragma vertex vertexShader
				#pragma fragment fragmentShader

				#include "UnityCG.cginc"

				float4 _Tint;

				sampler2D _MainTex;
				float4 _MainTex_ST;

				sampler2D _MainDetailTex;
				float4 _MainDetailTex_ST;
				
				struct Interpolators {
					float4 position : SV_POSITION;
					float2 uv : TEXCOORD0;
					float2 uvDetail : TEXCOORD1;
				};

				struct VertexData {
					float4 position : POSITION;
					float2 uv : TEXCOORD0;
				};

				Interpolators vertexShader(VertexData v){
					Interpolators i;
					i.uv = TRANSFORM_TEX(v.uv, _MainTex);
					i.uvDetail = TRANSFORM_TEX(v.uv, _MainDetailTex);
					i.position = UnityObjectToClipPos(v.position);
					return i;
				}

				float4 fragmentShader(
					Interpolators i
				) : SV_TARGET { 
					float4 color = tex2D(_MainTex, i.uv) * _Tint;
					color *= tex2D(_MainDetailTex, i.uvDetail * 10);
					return color;
				}

			ENDCG

		}
	}
}
