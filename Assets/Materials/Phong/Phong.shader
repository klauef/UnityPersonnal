// UNITY_SHADER_NO_UPGRADE

Shader "Custom/Directional_sc_in_fragment.shader"
{
	Properties
	{
		_Kd("Couleur diffu objet", Color) = (1,1,1,1)
		_Ka("Couleur ambiant objet", Color) = (1,1,1,1)
		_Ks("Couleur spéculaire objet", Color) = (1,1,1,1)
	}

		SubShader
	{
		Tags
		{
			"LightMode" = "ForwardBase"
		}

		Pass
		{
			CGPROGRAM

			#pragma vertex   main_vert
			#pragma fragment main_frag

			#include "UnityCG.cginc"


			struct v2f
			{
				float4  pos         : SV_POSITION; // 'pos' name is expected by TRANSFER_VERTEX_TO_FRAGMENT
				float3 normal		: NORMAL;
			};

			v2f main_vert(appdata_base v)
			{
				v2f o;

				o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
				o.normal = v.normal;

				return o;
			}

			uniform fixed4 _Kd;
			uniform fixed4 _Ka;
			uniform fixed4 _Ks;
			uniform fixed4 _LightColor0;

			half4 main_frag(v2f i) : COLOR
			{
				float4 L = normalize(_WorldSpaceLightPos0 - i.pos);
				float4 R = normalize(2 * dot(float4(i.normal, 1.0), L) * float4(i.normal, 1.0) - L);
				float3 V = normalize(_WorldSpaceCameraPos - i.pos);
				float3 diffu = _LightColor0 * _Kd * max(dot(float4(i.normal, 1.0), L), 0.0);
				float3 speculaire = _LightColor0 * _Ks * pow(max(dot(R, V), 0.0), 100.0);

				float4 col = float4(diffu
					+ speculaire
					+ _Ka, 1.0);
				return col;
			}

			ENDCG
		}
	}
}
