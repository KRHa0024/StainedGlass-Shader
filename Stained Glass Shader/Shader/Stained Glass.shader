Shader "KRHa's Shaders/Stained Glass"
{
    Properties
    {
		_Color("Color", Color) = (1,1,1,1)
        _MainTex("Texture", 2D) = "white"{}
		m("基準の明度", Range(0, 1)) = 0.2
		a("設定した明度以下の場合の不透明度の値", Range(0, 1)) = 1
		b("設定した明度以上の場合の不透明度の値", Range(0, 1)) = 0.7
		_Glossiness("Smoothness", Range(0,1)) = 0.5
		_Metallic("Metallic", Range(0,1)) = 0.0
		rimColor("RimColor", Color) = (1,1,1,1)
		rimrange("RimRange", Range(0,10)) = 3.0
	}
		SubShader
		{
			Tags { "Queue" = "Transparent" }
			LOD 200
		

        CGPROGRAM
        #pragma surface surf Standard alpha:fade
        #pragma target 3.0

        struct Input
        {
            float2 uv_MainTex;
			float3 worldNormal;
			float3 viewDir;
        };
	sampler2D _MainTex;
	half _Glossiness;
	half _Metallic;
	fixed4 _Color;
	float a = 1.0;
	float b = 0.5;
	float m = 0.2;
	fixed4 rimColor = (1.0, 1.0, 1.0, 1.0);
	float rimrange = 3.0;

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
			fixed4 c = tex2D(_MainTex, IN.uv_MainTex) * _Color;
			o.Albedo = c.rgb;
			o.Alpha = (c.r*0.3 + c.g*0.6 + c.b*0.1 < m) ? a : b;
			o.Metallic = _Metallic;
			o.Smoothness = _Glossiness;
			float rim = 1 - saturate(dot(IN.viewDir, o.Normal));
			o.Emission = rimColor * pow(rim, rimrange);
        }
        ENDCG
    }
    FallBack "Diffuse"
}
