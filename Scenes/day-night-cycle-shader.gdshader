shader_type sky;
render_mode use_half_res_pass;


group_uniforms daySky;
uniform vec3 dayTopColor: source_color;
uniform vec3 dayBottomColor: source_color;
uniform vec3 daySunriseColor: source_color;
uniform vec3 daySunsetColor: source_color;

group_uniforms nightSky;
uniform vec3 nightTopColor: source_color;
uniform vec3 nightBottomColor: source_color;
uniform vec3 nightSunriseColor: source_color;
uniform vec3 nightSunsetColor: source_color;

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
	
	float colorGradient = clamp(EYEDIR.y, 0.0, 1.0);
	vec3 skyColorDay = mix(horizonSkyDay, dayTopColor, colorGradient);
	vec3 skyColorNight = mix (horizonSkyNight, topSkyNight, colorGradient);
	vec3 skyColorSunRiseSet = mix(horizonSunRiseSet, topSunRiseSet, colorGradient);
	vec3 skyColor = vec3(0.0, 0.0, 0.0);
	
	if (LIGHT0_DIRECTION.y < -0.5) { // Night
		skyColor = vec3(0.0, 0.0, 1.0); // blue
	} else if (LIGHT0_DIRECTION.y < 0.0) { // Sunset
		skyColor = vec3(1.0, 0.0, 1.0); // pink
	} else if (LIGHT0_DIRECTION.y > 0.5) { // day 
		skyColor = vec3(1.0, 1.0, 0.0); //yellow
	} else if (LIGHT0_DIRECTION.y > 0.0) { 
		skyColor = vec3(0.0, 1.0, 0.0); // green
	} else {  // sunrise
		skyColor = vec3(1.0, 0.0, 0.0); // red
	} 
/*	if (LIGHT0_DIRECTION.y > 0.0){
		if(LIGHT0_DIRECTION.y > 0.1) {
			skyColor = skyColorDay;
		} else {
			skyColor = mix(skyColorSunRiseSet, skyColorDay, LIGHT0_DIRECTION.y);
		}
	} else {
		if(LIGHT0_DIRECTION.y > -0.3) {
			skyColor = mix(skyColorSunRiseSet, skyColorNight, abs(LIGHT0_DIRECTION.y));
		} else {
			skyColor = skyColorNight;
		}
	}*/
	skyColor = mix(skyColor, sun.rgb, sun.a);
	skyColor = mix(skyColor, moon.rgb, moon.a);
	COLOR = skyColor;
}
