attribute vec3 position;
attribute vec2 barycentre;
attribute float alpha;
attribute vec2 texCoords;
varying vec2 vTextureCoord;
varying float vAlpha;
uniform float teta;

void main(void) {
	vTextureCoord = texCoords;
	vAlpha = alpha;
    gl_Position = vec4( ((position.x-barycentre.x)*cos(teta)) - ((position.y-barycentre.y)*sin(teta))+barycentre.x ,((position.x-barycentre.x)*sin(teta)) + ((position.y-barycentre.y)*cos(teta))+barycentre.y ,position.z,1.0);
}