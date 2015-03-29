attribute vec3 position;

uniform mat4 V;
uniform mat4 P;

varying vec3 texCoords;

void main()
{
	//gl_Position = vec4(position, 0, 1);
	//texCoords = (VP * gl_Position).xyz;
	texCoords = position;
	gl_Position = P * V * vec4(position, 1.0);
} 