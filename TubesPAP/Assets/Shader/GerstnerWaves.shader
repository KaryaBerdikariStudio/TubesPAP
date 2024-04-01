Shader "Custom/Waves" {
	Properties {
		_Color ("Color", Color) = (1,1,1,1)
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_Glossiness ("Smoothness", Range(0,1)) = 0.5
		_Metallic ("Metallic", Range(0,1)) = 0
		_Wave0 ("Wave 0 (dir, steepness, wavelength)", Vector) = (1,0,0.5,10)
		_Wave1 ("Wave 1", Vector) = (0,1,0.25,20)
		_Wave2 ("Wave 2", Vector) = (1,1,0.15,10)
		_Wavelength1 ("Wavelength1",float) = 3
		_Wavelength2 ("Wavelength2",float) = 2
		_Wavelength3 ("Wavelength3",float) = 7
		_Steepness1	("Steepness1", Range(0,1)) = 0.25
		_Steepness2	("Steepness2", Range(0,1)) = 0.25
		_Steepness3	("Steepness3", Range(0,1)) = 0.25
		_Direction1 ("Direction1", Vector) = (1,1,0,0)
		_Direction2 ("Direction2", Vector) = (1,0.6,0,0)
		_Direction3 ("Direction3", Vector) = (1,1.3,0,0)
	}
	SubShader {
		Tags { "RenderType"="Transparent" "Queue"="Transparent" }
		LOD 200


		CGPROGRAM
		#pragma surface surf Standard alpha vertex:vert addshadow fullforwardshadows
		#pragma target 3.0

		#pragma shader_feature _DUAL_GRID
		

		
		sampler2D _MainTex;

		struct Input {
			float2 uv_MainTex;
		};

		half _Glossiness;
		half _Metallic;
		fixed4 _Color;
		float4 _Wave0, _Wave1, _Wave2;
		

		float _Wavelength1 (){
			return _Wave0.w;
		}

		float _Wavelength2 (){
			return _Wave1.w;
		}

		float _Wavelength3 (){
			return _Wave2.w;
		}

		float _Steepness1 (){
			return _Wave0.z;
		}
		float _Steepness2 (){
			return _Wave1.z;
		}

		float _Steepness3 (){
			return _Wave2.z;
		}

		float2 _Direction1 (){
			return _Wave0.xy;
		}

		float2 _Direction2 (){
			return _Wave1.xy;
		}

		float2 _Direction3 (){
			return _Wave2.xy;
		}

		float3 GerstnerWave (float4 wave, float3 p ,inout float3 tangent, inout float3 binormal){
			float steepness = wave.z;
			float wavelength = wave.w;

			//Untuk bikin gelombang pakai fungsi sinus
			float k = 2 * UNITY_PI / wavelength;
			float c = sqrt(9.8/k);
			float2 d = normalize(wave.xy);
			float f = k * (dot(d, p.xz) - c * _Time.y);

			//Kecuraman laut
			float a = steepness / k;

			//normalisasi vektor tangen cahaya 
			tangent += float3(
				-d.x * d.x * (steepness * sin(f)),
				d.x * (steepness * cos(f)),
				-d.x * d.y * (steepness * sin(f))
			);
			binormal += float3(
				-d.x * d.y * (steepness * sin(f)),
				d.y * (steepness * cos(f)),
				-d.y * d.y * (steepness * sin(f))
			);


			return float3(
				d.x * (a * cos(f)),
				a * sin(f),
				d.y * (a * cos(f))
			);


		}

		
		

		
		void vert(inout appdata_full vertexData) {
			float3 gridPoint = vertexData.vertex.xyz;
			float3 tangent = float3(1, 0, 0);
			float3 binormal = float3(0, 0, 1);
			float3 p = gridPoint;
			p += GerstnerWave(_Wave0, gridPoint, tangent, binormal);
			p += GerstnerWave(_Wave1, gridPoint, tangent, binormal);
			p += GerstnerWave(_Wave2, gridPoint, tangent, binormal);
			float3 normal = normalize(cross(binormal, tangent));
			vertexData.vertex.xyz = p;
			vertexData.normal = normal;
		}

		void surf (Input IN, inout SurfaceOutputStandard o) {
			fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
			o.Albedo = c.rgb;
			o.Metallic = _Metallic;
			o.Smoothness = _Glossiness;
			o.Alpha = c.a;
		}
		ENDCG
	}
	Fallback "Diffuse"
}