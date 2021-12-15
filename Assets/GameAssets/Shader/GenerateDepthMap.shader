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
                float4 vertex : POSITION;
				// 不能用SV_POSITION 在DX10以后的语义SV为不能改变的
				float4 pos : POSITION;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 pos : POSITION;
				float depth : TEXCOORD1;
            };

            v2f vert (appdata v)
            {
                v2f o;				
				float4 wpos = mul(unity_ObjectToWorld, v.pos);
				// 顶点世界坐标=>摄像机深度图视口坐标
				o.pos = mul(shadow_transform_mat, wpos);
				// 齐次空间的深度/所在点透视缩放
				float d = o.pos.z / o.pos.w;

				// 防止小于0
				d = d * 0.5 + 0.5;

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
