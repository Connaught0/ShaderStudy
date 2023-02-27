Shader "ShaderStudy/Diffuse"
{
    Properties
    {
        _Diffuse("Diffuse",Color)=(1,1,1,1)
             _Specular("Specular",Color)=(1,1,1,1)
        _Gloss("Gloss",Range(8.0,256))=20
    }
    SubShader
    {
      Pass{
            Tags{"LightMode"="ForwardBase"}
            Cull Front
            CGPROGRAM

            #pragma vertex vert
            #pragma fragment frag

            #include"UnityCG.cginc"
            #include "Lighting.cginc"

            struct appdata
            {
                float4 vertex:POSITION;
                float3 normal:NORMAL;
                
            };

            struct v2f
            {
                float3 worldNormal:TEXTCOORD0;
                float4 pos:SV_POSITION;
                float3 worldPos:TEXTCOORD1;
                
            };

            float4 _Diffuse;

            v2f vert(appdata v)
            {
                v2f o;

                float3 normal=v.normal;
                
                v.vertex.xyz+=normal*0.02;//所有顶点沿着法线方向向外走了0.2个位置，所以其变大了0.02
                
                o.pos=UnityObjectToClipPos(v.vertex);

                o.worldPos=normalize(mul(unity_ObjectToWorld,v.vertex));
                
                //o.pos.x+=0.1;

                //o.worldNormal=normalize(mul(v.normal,(float3x3)unity_WorldToObject));

                return o;
            }

            float4 frag(v2f v):SV_Target
            {
                v.pos.xyz+=v.worldNormal*0.02;
                /*
                fixed3 ambient =UNITY_LIGHTMODEL_AMBIENT.xyz;

                fixed3 worldLight=normalize(_WorldSpaceLightPos0.xyz);

                float NdotL=0.5+0.5*dot(v.worldNormal,worldLight);

                float3 diffse=_LightColor0.rgb*_Diffuse.rgb*NdotL;
*/
                return fixed4(0,0,0,1.0);
            }
            
            ENDCG
            
            }
        Pass{
            Tags{"LightMode"="ForwardBase"}
            
            
            
            CGPROGRAM

            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"
            #include"Lighting.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv :TEXCOORD0;
                float3 normal:NORMAL;
            };

            struct v2f
            {
                float3 worldNormal:TEXTCOORD0;
                float4 pos :SV_POSITION;
                float3 worldPos:TEXTCOORD1;
            };

            float4 _Diffuse;
            fixed4 _Specular;
            float _Gloss;
            v2f vert(appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);

                 fixed3 worldNormal =normalize(mul(v.normal,(float3x3)unity_WorldToObject));

                o.worldNormal=worldNormal;
                o.worldPos=mul(unity_ObjectToWorld,v.vertex);

                return o;
            }

            float4 frag(v2f i):SV_Target
            {
                
                fixed3 ambient=UNITY_LIGHTMODEL_AMBIENT.xyz;

               
                fixed3 worldLight=normalize(_WorldSpaceLightPos0.xyz);


                float NdotL = 0.5+0.5*dot(i.worldNormal, worldLight);
                
	            if (NdotL > 0.6)
	            {
	            	NdotL = 1;
	            } 
	            else if (NdotL > 0.2)
	            {
	            	NdotL = 0.3;
	            } 
	            else 
	            {
	            	NdotL = 0.1;
	            }
                
                float3 diffuse=_LightColor0.rgb*_Diffuse.rgb*NdotL;

                
                fixed3 reflecrDir=normalize(reflect(-worldLight,i.worldNormal));

                fixed3 viewDir=normalize(_WorldSpaceCameraPos.xyz-i.worldPos.xyz);

                float spec=pow(saturate(dot(reflecrDir,viewDir)),_Gloss);

                if(spec>0.001)
                {
                    spec=1;
                }
                else
                {
                    spec=0;
                }

                fixed3 specular=_LightColor0.rgb*_Specular.rgb*spec;
                
                return fixed4(ambient+diffuse+specular ,1.0);
            }
            
            
            ENDCG
        }
        
        
    }
    FallBack "Diffuse"
}
