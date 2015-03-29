package tri;

//TODO reuse vertex shader
//TODO should only need to compile once and link multiple time at kalatime
@shaders({vertex:"tri/shaders/skytriangle.v.glsl", fragment:"tri/shaders/skytriangle.f.glsl"})
class SkyTriangleProgram implements glee.GPUProgram{}