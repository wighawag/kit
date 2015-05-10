uniform mat4 viewproj;
attribute vec3 position;
attribute vec4 color;

varying vec4 fColor;


void main()
{
	gl_Position = viewproj*vec4(position,1.0);
	fColor = color;
} 
