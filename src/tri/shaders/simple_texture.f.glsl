precision mediump float;
uniform sampler2D tex;
varying vec2 vTextureCoord;

void main(void)
{
   gl_FragColor = texture2D (tex, vTextureCoord).rgba;
}
