
attribute vec4 a_position;
attribute vec2 a_texCoord;
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

attribute vec4 a_color;
uniform		mat4 u_MVPMatrix;
uniform   vec2 Scale;
#ifdef GL_ES
varying lowp vec4 v_fragmentColor;
varying mediump vec2 v_texCoord;
varying mediump vec2 v_texCoordRight;
varying mediump vec2 v_texCoordLeft;
varying mediump vec2 v_texCoordTop;
varying mediump vec2 v_texCoordBottom;
#else
varying vec4 v_fragmentColor;
varying vec2 v_texCoord;
varying vec2 v_texCoordRight;
varying vec2 v_texCoordLeft;
varying vec2 v_texCoordTop;
varying vec2 v_texCoordBottom;
#endif

void main()
{
    gl_Position = u_MVPMatrix * a_position;
    v_fragmentColor = a_color;
    v_texCoord = a_texCoord;

    float offset = 5.0;
    vec2 scale = Scale*offset;
    
    v_texCoordRight = a_texCoord;
    v_texCoordRight.x = a_texCoord.x + scale.x;
    
        v_texCoordLeft = a_texCoord;
        v_texCoordLeft.x = a_texCoord.x - scale.x;
    
        v_texCoordTop = a_texCoord;
        v_texCoordTop.y = a_texCoord.y - scale.y;
    
        v_texCoordBottom = a_texCoord;
        v_texCoordBottom.y = a_texCoord.y + scale.y;
}