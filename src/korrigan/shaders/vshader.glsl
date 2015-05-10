uniform mat4 viewproj;
attribute vec3 position;
attribute float alpha;
attribute vec2 texCoords;
varying vec2 vTextureCoord;
varying float vAlpha;

void main(void) {
	vTextureCoord = texCoords;
	vAlpha = alpha;
    gl_Position = viewproj*vec4(position,1.0);
}