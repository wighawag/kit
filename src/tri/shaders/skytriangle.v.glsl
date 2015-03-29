attribute vec2 position;

uniform mat4 V;
uniform mat4 P;

varying vec3 texCoords;

void main()
{
	gl_Position = vec4(position, 0, 1);
	texCoords = (V * P * gl_Position).xyz;
} 