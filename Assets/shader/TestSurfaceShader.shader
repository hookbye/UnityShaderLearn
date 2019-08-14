Shader "Custom/TestSurfaceShader" {
	Properties {
		_Color ("Color", Color) = (1,1,1,1)
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_Glossiness ("Smoothness", Range(0,1)) = 0.5
		_Metallic ("Metallic", Range(0,1)) = 0.0
		_Reflower("Reflower",Range(0,1)) = 0.5
		_CubeMap("CubeMap",CUBE)=""{}
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		Cull off
		
		CGPROGRAM
		// Physically based Standard lighting model, and enable shadows on all light types
		#pragma surface surf BlinnPhong addshadow //Standard fullforwardshadows

		// Use shader model 3.0 target, to get nicer looking lighting
		#pragma target 3.0

		sampler2D _MainTex;
		samplerCUBE _CubeMap;
		float _Reflower;
		struct Input {
			float2 uv_MainTex;
			float4 vertCol;
			float3 worldRefl;
		};

		half _Glossiness;
		half _Metallic;
		fixed4 _Color;

		// Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
		// See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
		// #pragma instancing_options assumeuniformscaling
		UNITY_INSTANCING_CBUFFER_START(Props)
			// put more per-instance properties here
		UNITY_INSTANCING_CBUFFER_END

		void MyVert(inout appdata_full v, out Input IN)
        {
            UNITY_INITIALIZE_OUTPUT(Input, IN);
            v.vertex.y = sin(_Time.y + v.vertex.x);
            float absh = abs(v.vertex.y);
            IN.vertCol = float4(absh, absh, absh, 1.0);
        }

		void surf (Input IN, inout SurfaceOutput o) {
			// Albedo comes from a texture tinted by color
			fixed4 c = tex2D (_MainTex, IN.uv_MainTex); //* _Color;
			float2 uvScroll1 = IN.uv_MainTex;
			float2 uvScroll2 = IN.uv_MainTex;
			uvScroll1 += float2(0.1*_Time.y,0.5*_Time.y);
			uvScroll2 += float2(0.2*_Time.y,0.5*_Time.y);
			half4 w = tex2D(_MainTex,uvScroll1);
			half4 w2 = tex2D(_MainTex,uvScroll2);
			o.Albedo = IN.vertCol.rgb*c.rgb;//w.rgb*0.5+w2.rgb*0.5;
			// Metallic and smoothness come from slider variables
			// o.Metallic = _Metallic;
			// o.Smoothness = _Glossiness;
			o.Emission = texCUBE(_CubeMap,IN.worldRefl).rgb*_Reflower;
			o.Alpha = c.a;

		}
		ENDCG
	}
	// FallBack "Diffuse"
}
