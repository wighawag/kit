
attribute vec3 position;
attribute vec2 texCoords;
varying vec2 vTextureCoord;

void main(void) {
	vTextureCoord = texCoords;
    gl_Position = vec4(position,1.0);
}