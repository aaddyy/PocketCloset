attribute mediump vec2 a_position;
attribute mediump vec4 texCoords;
attribute mediump vec2 alphaFactors;
//attribute mediump vec2 strokeCoords;
uniform mat4 mv_matrix;
varying mediump vec4 _texCoords;
varying mediump vec2 _alphaFactors;
//varying mediump vec2 _strokeCoords;
void main() {
    _texCoords = texCoords;
    _alphaFactors = alphaFactors;
    //_strokeCoords = strokeCoords;
    vec4 transformed = mv_matrix * vec4(a_position, 0.0, 1.0);
    gl_Position.xy = transformed.xy;
    gl_Position.zw = vec2(1.0);
}

