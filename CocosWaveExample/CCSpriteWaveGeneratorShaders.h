/*
 * Copyright (c) 2013 Kalpesh Solanki
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 *
 */

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
                                                                                                  \n\
                                                                                                  \n\
    float radius = 3.0;                                                                           \n\
    float d = distance(RippleOrigin,texCoord/Scale);                                              \n\
    if(d < radius && CauseRippleFlag == true){                                                    \n\
          val = .5;                                                                               \n\
    }                                                                                             \n\
     gl_FragColor = vec4(vec3(val*.99),1.0);                                                      \n\
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
