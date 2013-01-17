
attribute vec4 a_position;
attribute vec2 a_texCoord;
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