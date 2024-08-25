shader_type spatial;
render_mode cull_disabled;

uniform vec3 color: source_color;
uniform vec3 color2: source_color;
uniform sampler2D noise;
uniform float noiseScale = 20.0;
varying vec3 worldPos;
uniform bool enableSway = true;

void vertex() {
	worldPos = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
	float swayNoise = texture(noise, worldPos.xz / noiseScale).r * 6.0;
	float idk = 0.0;
	if (enableSway) {
		idk = sin(TIME/2.0+ swayNoise) *0.2 ;
	}
	
	MODELVIEW_MATRIX = VIEW_MATRIX * mat4(
		MODEL_MATRIX[0]+ vec4(idk, 0.0, 0.0, 0.0),
		MODEL_MATRIX[1] + vec4(0.0, 0.0, idk, 0.0),
		MODEL_MATRIX[2],
		MODEL_MATRIX[3]
	);
}

void fragment() {
	vec3 noiseLevel = texture(noise, worldPos.xz / noiseScale).rgb;
	ALBEDO = mix(color, color2, UV.y) * mix(color, color2, noiseLevel.r*2.0);
	if(!FRONT_FACING) {
		NORMAL = -NORMAL;
	}
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
