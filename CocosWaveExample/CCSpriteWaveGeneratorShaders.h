//
//  CCSpriteWaveGeneratorShaders.h
//  CocosShaderEffects
//
//  Created by Kalpesh Solanki on 1/14/13.
//
//

#ifndef CocosShaderEffects_CCSpriteWaveGeneratorShaders_h
#define CocosShaderEffects_CCSpriteWaveGeneratorShaders_h

const GLchar * _heighfield_frag_shader =

"#ifdef GL_ES                                                                                     \n\
precision highp float;                                                                            \n\
#endif                                                                                            \n\
                                                                                                  \n\
varying vec2 v_texCoord;                                                                          \n\
uniform sampler2D u_texture;                                                                      \n\
uniform sampler2D HeightFieldB;                                                                   \n\
uniform bool CauseRippleFlag;                                                                     \n\
uniform vec2 RippleOrigin;                                                                        \n\
uniform vec2 Scale;                                                                               \n\
                                                                                                  \n\
void main(){                                                                                      \n\
    vec2 texCoord = v_texCoord;                                                                   \n\
    float offset = 1.0;                                                                           \n\
    float val = (texture2D(u_texture, vec2(texCoord.x + offset*Scale.x,texCoord.y)).x +           \n\
                 texture2D(u_texture, vec2(texCoord.x - offset*Scale.x,texCoord.y)).x +           \n\
                 texture2D(u_texture, vec2(texCoord.x,texCoord.y + offset*Scale.y)).x +           \n\
                 texture2D(u_texture, vec2(texCoord.x,texCoord.y - offset*Scale.y)).x)/2.0 -      \n\
    texture2D(HeightFieldB,texCoord).x;                                                           \n\
                                                                                                  \n\
                                                                                                  \n\
    if(texCoord.x/Scale.x > 1.0 && texCoord.y/Scale.y > 1.0 && val > 0.01)                        \n\{                                                                                         \n\
        gl_FragColor.rgb = vec3(val);                                                             \n\
    }                                                                                             \n\
    else{                                                                                         \n\
        gl_FragColor = vec4(vec3(0.0),1.0);                                                       \n\
    }                                                                                             \n\
                                                                                                  \n\
    float radius = 3.0;                                                                           \n\
    float d = distance(RippleOrigin,texCoord/Scale);                                              \n\
    if(d < radius && CauseRippleFlag == true){                                                    \n\
        gl_FragColor = vec4(vec3(0.8),1.0);//Force                                                \n\
    }                                                                                             \n\
                                                                                                  \n\
}                                                                                                 \n\
";

const GLchar* _ripple_frag_shader =
"#ifdef GL_ES                                                                                      \n\
precision highp float;                                                                             \n\
#endif                                                                                             \n\
                                                                                                   \n\
varying vec2 v_texCoord;                                                                           \n\
uniform sampler2D u_texture;                                                                       \n\
uniform sampler2D HeightField;                                                                     \n\
uniform vec2 Scale;                                                                                \n\
                                                                                                   \n\
void main(){                                                                                       \n\
    vec2 texCoord = v_texCoord;                                                                    \n\
                                                                                                   \n\
    //Apply HeightField                                                                            \n\
    float offset = 5.0;                                                                            \n\
    float Xoffset = texture2D(HeightField,vec2(texCoord.x-offset*Scale.x,texCoord.y)).x -          \n\
                    2.0*texture2D(HeightField,vec2(texCoord.x+offset*Scale.x,texCoord.y)).x ;      \n\
    float Yoffset = texture2D(HeightField,vec2(texCoord.x,texCoord.y-offset*Scale.y)).x -          \n\
                    2.0*texture2D(HeightField,vec2(texCoord.x,texCoord.y+offset*Scale.y)).x;       \n\
                                                                                                   \n\
                                                                                                   \n\
    float shading = Xoffset;                                                                       \n\
    vec4 bgColor = texture2D(u_texture,vec2(texCoord.x-20.0*Xoffset*Scale.x,                       \n\
                                     texCoord.y-20.0*Yoffset*Scale.y));                            \n\
    gl_FragColor = bgColor;                                                                        \n\
}";


#endif
