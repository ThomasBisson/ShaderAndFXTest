Shader "KoloMachine/SpotLight"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
		_CharacterPos("Character position", vector) = (0,0,0)
		_CircleRadius("Spotlight size", Range(0,20)) = 3
		_RingSize("Ring size", Range(0,5)) = 1
		_ColorTint("Color outside", Color) = (0,0,0,0)
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

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
				
				float3 worldPos : TEXTCOORD2; //World pos of that vertex
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

			float4 _CharacterPos;
			float _CircleRadius;
			float _RingSize;
			float4 _ColorTint;



            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                UNITY_TRANSFER_FOG(o,o.vertex);

				o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;

                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // put basic color to black
                fixed4 col = 0;
                // apply fog
                UNITY_APPLY_FOG(i.fogCoord, col);

				float dist = distance(i.worldPos, _CharacterPos.xyz);

				/*** Player spotlight ***/
				//if distance < radius, put the true color of the vertex
				if (dist < _CircleRadius)
					col = tex2D(_MainTex, i.uv);
				// Blending section
				else if (dist > _CircleRadius && dist < _CircleRadius + _RingSize) {
					float blendStrenght = dist - _CircleRadius;
					col = lerp(tex2D(_MainTex, i.uv), _ColorTint, blendStrenght / _RingSize);
				}
				//past both

                return col;
            }
            ENDCG
        }
    }
}
