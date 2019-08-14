Shader "Unlit/Dissolve"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_NoiseTex ("NosieTex", 2D) = "white" {}
		_RampTex ("RampTex", 2D) = "white" {}
		_Threshold("Treshold",Range(0.0,1.0)) = 0.5
		_EdgeLen("EdgeLen",Range(0.0,0.2)) = 0.1
		_EdgeColor("EdgeColor",Color) = (0.5,0,0,1)
		_EdgeColor2("EdgeColor2",Color) = (0.5,0,0,1)
	}
	SubShader
	{
		Tags { "Queue"="Geometry" "RenderType"="Opaque" }
		LOD 100

		Pass
		{
			Cull off
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			// make fog work
			// #pragma multi_compile_fog
			
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				// UNITY_FOG_COORDS(1)
				float2 uvNoiseTex:TEXCOORD1;
				float4 vertex : SV_POSITION;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			sampler2D _NoiseTex;
			float4 _NoiseTex_ST;
			sampler2D _RampTex;
			float4 _RampTex_ST;
			float _Threshold;
			float _EdgeLen;     
			fixed4 _EdgeColor; 
			fixed4 _EdgeColor2; 
			
			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				o.uvNoiseTex = TRANSFORM_TEX(v.uv,_NoiseTex);
				// UNITY_TRANSFER_FOG(o,o.vertex);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				// sample the texture
				fixed cutout = tex2D(_NoiseTex,i.uvNoiseTex).b;
				clip(cutout-_Threshold);

				float degree = saturate((cutout-_Threshold)/_EdgeLen);
				fixed4 edgeColor = tex2D(_RampTex,float2(degree,degree));// lerp(_EdgeColor,_EdgeColor2,degree);

				fixed4 col = tex2D(_MainTex, i.uv);
				fixed4 finalColor = lerp(edgeColor,col,degree);
				// apply fog
				// UNITY_APPLY_FOG(i.fogCoord, col);
				return fixed4(finalColor.rgb,1);
			}
			ENDCG
		}
	}
}
