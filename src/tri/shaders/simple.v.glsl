attribute vec3 position;

uniform mat4 V;
uniform mat4 P;

void main()
{
	gl_Position = P * V * vec4(position, 1);
} 
