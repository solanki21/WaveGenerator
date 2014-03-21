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
