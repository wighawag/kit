precision mediump float;
uniform sampler2D tex;
varying vec2 vTextureCoord;
varying float vAlpha;


void main(void)
{
    vec4 texColor =  texture2D (tex, vTextureCoord).rgba;

    texColor = texColor * vAlpha;

    gl_FragColor = texColor;
}
