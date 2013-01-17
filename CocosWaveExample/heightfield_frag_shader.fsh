#ifdef GL_ES
precision highp float;                                                                            
#endif                                                                                            

varying vec2 v_texCoord;                                                                          
uniform sampler2D u_texture;                                                                      
uniform sampler2D HeightFieldB;                                                                   
uniform bool CauseRippleFlag;                                                                     
uniform vec2 RippleOrigin;                                                                        
uniform vec2 Scale;                                                                               

void main(){                                                                                      
vec2 texCoord = v_texCoord;

    float offset = 1.0;
    float val = (
                 texture2D(u_texture, vec2(texCoord.x + offset*Scale.x,texCoord.y)).x +
                texture2D(u_texture, vec2(texCoord.x - offset*Scale.x,texCoord.y)).x +
                texture2D(u_texture, vec2(texCoord.x,texCoord.y + offset*Scale.y)).x +
                texture2D(u_texture, vec2(texCoord.x,texCoord.y - offset*Scale.y)).x)/2.0 -
                texture2D(HeightFieldB,texCoord).x;

    float radius = 3.0;
    float d = distance(RippleOrigin,texCoord/Scale);
    if(d < radius && CauseRippleFlag == true){
            val = .5;
    }
    gl_FragColor = vec4(vec3(val*.99),1.0);
}                                                                                                 
