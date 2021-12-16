Shader "CustomShadow/GenerateDepthMap"
{
	Properties
	{
	}
	SubShader
	{
		Tags { "RenderType" = "Opaque" }
		LOD 100

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			// make fog work
			#pragma multi_compile_fog

			#include "UnityCG.cginc"

			float4x4 shadow_transform_mat;

            struct appdata
            {
				// 不能用SV_POSITION 在DX10以后的语义SV为不能改变的
				float4 pos		: POSITION;
				float4 color	: COLOR;
				float2 uv		: TEXCOORD0;
				float3 normal	: NORMAL;
            };

            struct v2f
            {
				float depth : TEXCOORD2;
            };

            v2f vert (appdata v)
            {
				v2f o;

				float4 wpos = mul(unity_ObjectToWorld, v.pos);
				o.pos = mul(shadow_transform_mat, wpos);//trans to light space
				float d = o.pos.z / o.pos.w;//perspective division
				d = d * 0.5 + 0.5;//NDC


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
