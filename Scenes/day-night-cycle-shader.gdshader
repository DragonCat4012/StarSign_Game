shader_type sky;
render_mode use_half_res_pass;


uniform float SunSetDuration = 0.5;

group_uniforms skyColors;
uniform vec3 dayTopColor: source_color;
uniform vec3 nightTopColor: source_color;
uniform vec3 sunriseColor: source_color;
uniform vec3 sunsetColor: source_color;

group_uniforms deprecated;
uniform vec3 horizonSkyDay: source_color;
uniform vec3 topSkyNight: source_color;
uniform vec3 horizonSkyNight: source_color;
uniform vec3 topSunRiseSet: source_color;
uniform vec3 horizonSunRiseSet: source_color;

group_uniforms sun;
uniform vec3 sunColor: source_color;
uniform float sunSize = 0.1;

group_uniforms moon;
uniform vec3 moonColor: source_color;
uniform float moonSize = 0.1;
uniform float moonOffset = 0.05;

void sky() {
	float sunDirection = distance(EYEDIR.xyz, LIGHT0_DIRECTION);
	float sunPosition = 1.0 - clamp(sunDirection/sunSize, 0.0, 1.0);
	float sunDisk = step(sunSize, sunPosition);
	vec4 sun = vec4(sunColor, sunDisk);
	
	float moonDirection = distance(EYEDIR.xyz, -LIGHT0_DIRECTION);
	float moonPosition = 1.0 - clamp(moonDirection/moonSize, 0.0, 1.0);
	float moonDisk = step(moonSize, moonPosition);
	
	float moonCrescentDirection = distance(vec3(EYEDIR.x + moonOffset, EYEDIR.yz), -LIGHT0_DIRECTION);
	float moonCrescentPosition = 1.0 - clamp(moonCrescentDirection/moonSize, 0.0, 1.0);
	float moonCrescentDisk = step(moonSize, moonCrescentPosition);
	vec4 moon = vec4(moonColor, clamp((moonDisk - moonCrescentDisk), 0.0, 1.0));
	
	
	// Sky Gradient
	float colorGradient = clamp(EYEDIR.y, 0.0, 1.0);
	vec3 skyColor = vec3(0.0, 0.0, 0.0);
	float currentAngle = LIGHT0_DIRECTION.y;
	float currentSide = LIGHT0_DIRECTION.z;
	
	vec3 blue = dayTopColor;//vec3(0.0, 0.0, 1.0);
	vec3 green = sunriseColor;//vec3(0.0, 1.0, 0.0); 
	vec3 red = nightTopColor;//vec3(1.0, 0.0, 0.0);
	vec3 pink = sunsetColor;//vec3(1.0, 0.0, 1.0); 

	if (currentAngle > 0.0 && currentAngle < SunSetDuration) {
		if (currentSide > 0.0) { // upper pink gradient
			vec3 skyColorGradient = mix(pink, blue, colorGradient);
			skyColor = mix(skyColorGradient, blue, abs(LIGHT0_DIRECTION.y/SunSetDuration));
		} else { // green upper gradient
			vec3 skyColorGradient = mix(green, blue, colorGradient);
			skyColor = mix(skyColorGradient, blue, LIGHT0_DIRECTION.y/SunSetDuration);
		}
	} else if (currentAngle > SunSetDuration && currentAngle < 1.0) {
			skyColor = blue;
	} else if (currentAngle < 0.0 && currentAngle < -SunSetDuration) {
			skyColor = red;
	} else if (currentAngle > -SunSetDuration && currentAngle < -0.0) {
		if (currentSide > 0.0) { // pink lower gradient
			vec3 skyColorGradient = mix(red, pink , colorGradient);
			skyColor = mix(skyColorGradient, red, abs(LIGHT0_DIRECTION.y/SunSetDuration));
		} else { // green lower gradient
			vec3 skyColorGradient = mix(red, green, colorGradient);
			skyColor = mix(skyColorGradient, red, abs(LIGHT0_DIRECTION.y/SunSetDuration));
		}
	} 

		skyColor = mix(skyColor, sun.rgb, sun.a);
		skyColor = mix(skyColor, moon.rgb, moon.a);
		COLOR = skyColor;
	}
