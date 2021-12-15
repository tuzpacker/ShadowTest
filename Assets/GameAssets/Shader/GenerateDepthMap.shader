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
				// ������SV_POSITION ��DX10�Ժ������SVΪ���ܸı��
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
				// ������������=>��������ͼ�ӿ�����
				o.pos = mul(shadow_transform_mat, wpos);
				// ��οռ�����/���ڵ�͸������
				float d = o.pos.z / o.pos.w;

				// ��ֹС��0
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
