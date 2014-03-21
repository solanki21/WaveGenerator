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