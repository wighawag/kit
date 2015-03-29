precision mediump float;
uniform sampler2D tex;
uniform sampler2D normal;
varying vec2 vTextureCoord;
varying float vAlpha;

uniform vec3 lightPos;
uniform vec4 lightColor;      //light RGBA -- alpha is intensity
uniform vec2 resolution;      //resolution of screen need to know the position of the pixel
uniform vec4 ambientColor;    //ambient RGBA -- alpha is intensity
uniform vec3 falloff;
void main(void)
{
	//vec3 texNormal =  texture2D (uNormals, vTexCoord).rgb;
    //vec4 texColor =  texture2D (uColors, vTexCoord).rgba;
    vec3 texNormal =  texture2D (normal, vTextureCoord).rgb;
    vec4 texColor =  texture2D (tex, vTextureCoord).rgba;

    texColor = texColor * vAlpha;

	vec3 lightDir = vec3(lightPos.x / resolution.x, 1.0 - (lightPos.y / resolution.y), lightPos.z);
    lightDir = vec3(lightDir.xy - (gl_FragCoord.xy / resolution.xy), lightDir.z);

    lightDir.x *= resolution.x / resolution.y;

    float D = length(lightDir);

    vec3 N = normalize(texNormal * 2.0 - 1.0);
    vec3 L = normalize(lightDir);

    vec3 diffuse = (lightColor.rgb * lightColor.a) * max(dot(N, L), 0.0);
    vec3 ambient = ambientColor.rgb * ambientColor.a;
    float attenuation = 1.0 / ( falloff.x + (falloff.y*D) + (falloff.z*D*D) );

    vec3 intensity = ambient + diffuse * attenuation;
    vec3 finalColor = texColor.rgb * intensity;
    gl_FragColor = vec4(finalColor, texColor.a);
}
