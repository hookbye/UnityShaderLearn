Shader "Unlit/NewUnlitShader"
{
	Properties
	{
		_Color("Color",Color) = (1,0,1,0.5)
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

			fixed4 _Color;

			struct appdata
			{
				float4 vertex:POSITION;
				float2 uv:TEXCOORD;
			};

			struct v2f
			{
				float4 pos:SV_POSITION;
				float2 uv:TEXCOORD;
			};

			v2f vert(appdata v)
			{
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);
				o.uv = v.uv;
				return o;
			};

			fixed checker(float2 uv)
			{
				float2 repeatUV = uv*10;
				float2 c = floor(repeatUV)/2;
				float checker = frac(c.x+c.y)*2;
				return checker;
			};

			fixed frag(v2f i):SV_Target
			{
				fixed col = checker(i.uv);
				return col;
			};

			ENDCG
		}
	}
}
