Shader "CustomShadow/ShadowMap"
{
    Properties
    {
        _dark ("shadow strength", Range(0, 1.0)) = 0.0
        _depthBias ("Depth Bias", Range(0, 0.2)) = 0.1
        _normalBais ("Normal Bias",Range(0, 0.2)) = 0.1
        _ambientColor ("Ambient Color", Color) = (0,0,0,0)
		_diffuseColor ("Diffuse Color", Color) = (1,1,1,1)
		_specularColor ("Specular Color", Color) = (1,1,1,1)
		_specularShininess ("Specular Shininess", Range(1,128)) = 10
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float4 color : COLOR;
                float3 normal : NORMAL;
            };

            struct v2f
            {                
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
                float4 shadowPos : TEXCOORD1;
                float3 wpos		: TEXCOORD7;
                float4 color : COLOR;
                float3 normal	: NORMAL;
            };


            float4x4 shadow_transform_mat;
            sampler2D _MainTex;
            float4 _MainTex_ST;

            v2f vert (appdata v)
            {
                // 计算出该点在灯光下的深度
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.wpos = mul(UNITY_MATRIX_M, v.vertex).xyz;

                o.color = v.color;
				o.uv = v.uv;
				o.normal = mul((float3x3)UNITY_MATRIX_M, v.normal); 
                
                // o.uv = TRANSFORM_TEX(v.uv, _MainTex);

                float4 wpos = mul(unity_ObjectToWorld,v.vertex);
                o.shadowPos = mul(shadow_transform_mat,wpos);
                // o.shadowPos.xyz /= o.shadowPos.w;

                return o;
            }

                        //光照参数
            float4 _MyLightDir;
            float4 _ambientColor;
			float4 _diffuseColor;
			float4 _specularColor;
			float  _specularShininess;
            float _depthBias;
            float _normalBais;

            float _dark;//阴影强度

            sampler2D shadowMap_data;     

            float4 basicLighting(float3 wpos, float3 normal)
			{
				float3 N = normalize(normal);
				float3 L = normalize(-_MyLightDir.xyz);
				float3 V = normalize(wpos - _WorldSpaceCameraPos);

				float3 R = reflect(L,N);

				float4 ambient  = _ambientColor;
				float4 diffuse  = _diffuseColor * max(0, dot(N,L));

				float  specularAngle = max(0, dot(R,V));
				float4 specular = _specularColor * pow(specularAngle, _specularShininess);

				float4 color = 0;
				color += ambient;
				color += diffuse;
				color += specular;

				return color;
			}       

            float4 shadow(v2f i)
			{
                float4 deepVec = i.shadowPos;
                // 正数化
                float3 compare = deepVec.xyz*0.5+0.5;
                // 因为像素精度较低 倾斜平面的时候减去一个值矫正一下]
                // float cur_depth = compare.z - _depthBias;
                // 另一种方法是通过法线方向求出偏移量
                
                float cur_depth = compare.z - _depthBias;
                // 获取深度贴图中的深度
                float orign_depth=tex2D(shadowMap_data,compare).r;

                // 比较
                // return float4(cur_depth,0,0,1);
                if(cur_depth<=orign_depth){
                    return float4(1,1,1,1);
                }else{
                    return float4(_dark,_dark,_dark,1);
                }
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                // fixed4 col = tex2D(_MainTex, i.uv);
                // apply fog
                // UNITY_APPLY_FOG(i.fogCoord, col);
                
                float4 s = shadow(i);

                // float4 c = basicLighting(i.wpos, i.normal);
                
				// return c * s;
                return s;
            }
            ENDCG
        }
    }
}
