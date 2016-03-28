Shader "Custom/AlphaMask" 
{  
    Properties  
	{  
	    _MainTex ("Base (RGB) Trans (A)", 2D) = "white" {}  
	    _MaskTex ("Mask (A)", 2D) = "white" {}  
	}  
	
    Category  
    {  
    	Tags {"Queue"="Transparent" "IgnoreProjector"="True"}  
    	
        Lighting Off  
        ZWrite Off  
        Cull back  
        Fog { Mode Off }  
        Blend SrcAlpha OneMinusSrcAlpha
        
        SubShader  
        {  
            Pass  
            {  
                CGPROGRAM  
                #pragma vertex vert  
                #pragma fragment frag  
                sampler2D _MainTex;  
                sampler2D _MaskTex;  
                 
                struct appdata  
                {  
                    float4 vertex : POSITION;  
                    float4 texcoord : TEXCOORD0;  
                };  
                struct v2f  
                {  
                    float4 pos : SV_POSITION;  
                    float2 uv : TEXCOORD0;  
                };  
                
                v2f vert (appdata v)  
                {  
                    v2f o;  
                    o.pos = mul(UNITY_MATRIX_MVP, v.vertex);  
                    o.uv = v.texcoord;  
                    return o;  
            	} 
            	 
                half4 frag(v2f i) : COLOR  
                {  
                   fixed4 c = tex2D(_MainTex, i.uv); 
                   c.a *= ceil(tex2D(_MaskTex,i.uv).a);
                   return c;  
                }  
                ENDCG  
            }  
        } 
         
        SubShader  
        {            
             AlphaTest LEqual [_Progress]    
              Pass    
              {    
                 SetTexture [_MaskTex] {combine texture}    
                 SetTexture [_MainTex] {combine texture, previous}    
              }    
        }  
          
    }  
    Fallback "Transparent/VertexLit"  
}  