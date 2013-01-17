
#ifdef GL_ES                                                                                      
precision highp float;                                                                             
#endif                                                                                             

varying vec2 v_texCoord;                                                                           
uniform sampler2D u_texture;                                                                       
uniform sampler2D HeightField;
uniform vec2 Scale;                                                                                

varying vec2 v_texCoordRight;
varying vec2 v_texCoordLeft;
varying vec2 v_texCoordTop;
varying vec2 v_texCoordBottom;

void main(){                                                                                       
    vec2 texCoord = v_texCoord;

    //Apply HeightField
    float Xoffset = texture2D(HeightField,v_texCoordLeft).x -
                            2.0*texture2D(HeightField,v_texCoordRight).x ;
    float Yoffset = texture2D(HeightField,v_texCoordTop).x -
                            2.0*texture2D(HeightField,v_texCoordBottom).x;


    //float shading = HFOffset;
    vec4 bgColor = texture2D(u_texture,vec2(texCoord.x-20.0*Xoffset*Scale.x,
                                    texCoord.y-20.0*Yoffset*Scale.y));
    gl_FragColor = bgColor;
}