Shader "Unlit/VertexOffset"
{
    Properties
    {
        _ColorA("Color A", Color) = (1, 1, 1, 1)
        _ColorB("Color B", Color) = (1, 1, 1, 1)
        _Scale("UV Scale", Float) = 1
        _Offset("UV Offset", Float) = 0
        _WaveAmplitude("Wave Amplitude", Range(0, 0.2)) = 0.1
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

            #include "UnityCG.cginc"

            #define TAU 6.28318530718

            float4 _ColorA;
            float4 _ColorB;
            float _Scale;
            float _Offset;
            float _WaveAmplitude;

            struct MeshData
            {
                float4 vertex : POSITION;
                float3 normals : NORMAL;
                float4 uv0 : TEXCOORD0;
            };

            struct Interpolators
            {
                float4 vertex : SV_POSITION;
                float3 normal : TEXCOORD0;
                float2 uv : TEXCOORD1;
            };

            Interpolators vert (MeshData v)
            {
                float wave = cos( (v.uv0.y - _Time.y * 0.1) * TAU * 5);
                float wave2 = cos( (v.uv0.x - _Time.y * 0.1) * TAU * 5);

                v.vertex.y = wave * wave2 * _WaveAmplitude;

                Interpolators o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.normal = UnityObjectToWorldNormal(v.normals);
                o.uv = v.uv0;
                return o;
            }

            float4 frag (Interpolators i) : SV_Target
            {
                float wave = cos( (i.uv.y - _Time.y * 0.1) * TAU * 5) * 0.5 + 0.5;

                return wave;
            }
            ENDCG
        }
    }
}
