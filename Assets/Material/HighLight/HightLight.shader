Shader "Custom/HightLight"
{
    Properties
    {
        _Diffuse("Diffuse",Color)=(1,1,1,1)
        _Specular("Specular",Color)=(1,1,1,1)
        _Gloss("Gloss",Range(8.0,256))=20
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100
        
    pass{
        CGPROGRAM

        #pragma vertex vert
        #pragma fragment frag

        #include "UnityCG.cginc"
        #include "Lighting.cginc"

        struct appdata
        {
            float4 vertex :POSITION;
            float3 normal:NORMAL;
        };

        struct v2f
        {
            float4 pos:SV_POSITION;
            float3 worldNormal:TEXTCOORD0;
            float3 worldPos:TEXTCOORD1;
        };

        fixed4 _Diffuse;
        fixed4 _Specular;
        float _Gloss;

        v2f vert(appdata v)
        {
            v2f o;
            o.pos=UnityObjectToClipPos(v.vertex);
            o.worldNormal=normalize(mul(v.normal,(float3x3)unity_WorldToObject));
            o.worldPos=mul(unity_ObjectToWorld,v.vertex);

            return o;
        }

        fixed4 frag(v2f i):SV_Target
        {

                        
            fixed3 ambient=UNITY_LIGHTMODEL_AMBIENT.xyz;
            

            fixed3 worldLightDir=normalize(_WorldSpaceLightPos0.xyz);

            fixed3 diffuse=_LightColor0.rgb*_Diffuse.rgb*saturate(dot(i.worldNormal,worldLightDir));
            //For Phong Light Model
            //fixed3 reflectDir=normalize(reflect(-worldLightDir,i.worldNormal));
            //For BlinPhong Light Model
            
            
            fixed3 viewDir=normalize(_WorldSpaceLightPos0.xyz-i.worldPos.xyz);

            fixed3 Hdir=normalize(viewDir+worldLightDir);


            //fixed3 specular=_LightColor0.rgb*_Specular.rgb*pow(saturate(dot(reflectDir,viewDir)),_Gloss);

            fixed3 specular=_LightColor0.rgb*_Specular.rgb*pow(saturate(dot(i.worldNormal,Hdir)),_Gloss);

          
            
            return fixed4(ambient+specular+diffuse,1.0);
        }
        
        ENDCG
}    }
    FallBack "Diffuse"
}
