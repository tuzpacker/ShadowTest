Shader "CustomShadow/GenerateDepthMap"
{
	Properties
	{
	}
	SubShader
	{
		Tags { "RenderType" = "Opaque" }

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			#include "UnityCG.cginc"


            struct appdata
            {
				// 不能用SV_POSITION 在DX10以后的语义SV为不能改变的
				float4 pos		: POSITION;
            };

            struct v2f
            {
				float4 pos	: POSITION;
				float depth : TEXCOORD2;
            };

			float4x4 shadow_transform_mat;

            v2f vert (appdata v)
            {
				// v2f o;
				// float4 wpos = mul(unity_ObjectToWorld, v.pos);
				// o.pos = mul(shadow_transform_mat, wpos);//trans to light space
				// float d = o.pos.z;//透视除法（正交投影时可省略）
				// d = d * 0.5 + 0.5;//NDC

				// if (UNITY_NEAR_CLIP_VALUE == -1) {
				// 	d = d * 0.5 + 0.5;
				// }

				// o.depth = d;
				// return o;

				v2f o;

			#if true
				float4 wpos = mul(unity_ObjectToWorld, v.pos);
				o.pos = mul(MyShadowVP, wpos);//trans to light space
				float d = o.pos.z / o.pos.w;//透视除法（正交投影时可省略）
				d = d * 0.5 + 0.5;
			#else
				o.pos = UnityObjectToClipPos(v.pos);				
				float d = o.pos.z / o.pos.w;
				if (UNITY_NEAR_CLIP_VALUE == -1) {
					d = d * 0.5 + 0.5;
				}
				#if UNITY_REVERSED_Z
					d = 1 - d;
				#endif
			#endif

				o.depth = d;
				return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
				return float4(i.depth,0,0,1);
            }
            ENDCG
        }
    }
	//FallBack "Reflective/VertexLit"
}
