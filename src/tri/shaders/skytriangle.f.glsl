precision mediump float;
varying vec3 texCoords;
uniform samplerCube cubeTexture;

void main () {
  gl_FragColor = textureCube(cubeTexture, texCoords);
}