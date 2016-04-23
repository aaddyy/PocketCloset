precision highp float;
precision highp int;
precision highp sampler2D;

uniform sampler2D strokeSampler;
uniform sampler2D canvasSampler;

varying vec2 v_st;

void main()
{
    vec4 strokeColor = texture2D(strokeSampler, v_st);
    vec4 canvasColor = texture2D(canvasSampler, v_st);
 
 	vec4 result = strokeColor + canvasColor * (1.0 - strokeColor.a);
 	gl_FragColor = result;
}
