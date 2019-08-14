Shader "Unlit/shinuvShader"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_Normal("NormalTex",2D)="white"{}
		_Angle("Angle",float) = 1
		_Frenquancy("Frenquency",float) = 1
	}
	SubShader
	{
		Tags { "RenderType"="Opaque" }
		LOD 100

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			// make fog work
			#pragma multi_compile_fog
			
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			
			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
				float3 normal : NORMAL;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				UNITY_FOG_COORDS(1)
				float4 vertex : SV_POSITION;
				float3 worldNormal : TEXCOORD1;
			};

			sampler2D _MainTex;
			sampler2D _Normal;
			float4 _MainTex_ST;
			
			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.vertex.y = o.vertex.y+ sin(_Time.y+o.vertex.x*5)*0.2;
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				o.uv += float2(0,_Time.y*0.2);
				// o.worldNormal = mul(v.normal,(float3x3)_Word2Object);
				UNITY_TRANSFER_FOG(o,o.vertex);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				// sample the texture
				fixed4 col = tex2D(_MainTex, i.uv);
				// apply fog
				fixed4 normalCol = tex2D(_Normal,i.worldNormal);
				float3 targetNormal = UnpackNormal(normalCol);
				UNITY_APPLY_FOG(i.fogCoord, col);
				col = col;//+float4(targetNormal,1);
				return col;
			}
			ENDCG
		}
	}
}
