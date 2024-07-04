shader_type sky;
render_mode use_half_res_pass;


uniform float SunSetDuration = 0.1;

group_uniforms skyColors;
uniform vec3 dayColor: source_color;
uniform vec3 dayTopColor: source_color;
uniform vec3 nightColor: source_color;
uniform vec3 nightTopColor: source_color;
uniform vec3 sunriseColor: source_color;
uniform vec3 sunsetColor: source_color;
uniform float horizon_falloff: hint_range(0.0, 1.0, 0.1) = 0.7;
uniform vec3 horizon_color_day: source_color;
uniform vec3 horizon_color_sunset : source_color = vec3(1.0, 1.0, 1.0);
uniform vec3 horizon_color_night : source_color;

// Clouds Stuff
group_uniforms clouds;
uniform sampler2D clouds_texture: filter_linear_mipmap;
uniform sampler2D clouds_distort_texture: filter_linear_mipmap;
uniform sampler2D clouds_noise_texture: filter_linear_mipmap;
uniform vec3 clouds_main_color: source_color = vec3(1.0, 1.0, 1.0);
uniform vec3 clouds_edge_color: source_color = vec3(1.0, 1.0, 1.0);
uniform vec3 cloudsSunsetEdgeColor: source_color = vec3(1.0, 1.0, 1.0);
uniform float clouds_speed: hint_range(0.0, 0.1, 0.01);
uniform float clouds_scale: hint_range(0.0, 1.0, 0.01);
uniform float clouds_cutoff: hint_range(0.0, 1.0, 0.01);
uniform float clouds_fuzziness: hint_range(0.0, 1.0, 0.01);

group_uniforms stars;
uniform sampler2D stars_texture: filter_linear_mipmap;
uniform float stars_cutoff;
uniform float stars_speed: hint_range(0.0, 0.1);

group_uniforms sun;
uniform vec3 sunColor: source_color;
uniform vec3 sunColorSunrise: source_color;
uniform float sunSize = 0.2;
uniform float sun_blur: hint_range(0.01, 1.0) = 0.4;

group_uniforms moon;
uniform vec3 moonColor: source_color;
uniform float moonSize = 0.1;
uniform float moonOffset = 0.05;


void sky() {
	float colorGradient = clamp(EYEDIR.y, 0.0, 1.0);
	vec3 skyColor = vec3(0.0, 0.0, 0.0);
	float currentAngle = LIGHT0_DIRECTION.y;
	float currentSide = LIGHT0_DIRECTION.z;
	
	// Changing Colors
	vec3 currentSunColor = sunColor;
	vec3 cloudOutlienColor = clouds_edge_color;
		
	// Sun Color
	if (currentAngle > -SunSetDuration-0.1 && currentAngle < -0.0 + 0.1) {
		if (currentSide > 0.0) { // sunset
			cloudOutlienColor = cloudsSunsetEdgeColor;
			currentSunColor = mix(sunColorSunrise, sunColor, abs(LIGHT0_DIRECTION.y/SunSetDuration));
		} else { // sunrise
			cloudOutlienColor = cloudsSunsetEdgeColor;
			currentSunColor = mix(sunColorSunrise, sunColor, abs(LIGHT0_DIRECTION.y/SunSetDuration));
		}
	} 
	
	// Sun
	float sunDirection = distance(EYEDIR.xyz, LIGHT0_DIRECTION);
	float sunPosition = 1.0 - clamp(sunDirection/sunSize, 0.0, 1.0);
	float sunDisk = clamp(sunPosition / sun_blur, sunPosition, 1.0);
	vec4 sun = vec4(currentSunColor, sunDisk);
	
	// Moon
	float moonDirection = distance(EYEDIR.xyz, -LIGHT0_DIRECTION);
	float moonPosition = 1.0 - clamp(moonDirection/moonSize, 0.0, 1.0);
	float moonDisk = step(moonSize, moonPosition);
	
	float moonCrescentDirection = distance(vec3(EYEDIR.x + moonOffset, EYEDIR.yz), -LIGHT0_DIRECTION);
	float moonCrescentPosition = 1.0 - clamp(moonCrescentDirection/moonSize, 0.0, 1.0);
	float moonCrescentDisk = step(moonSize, moonCrescentPosition);
	vec4 moon = vec4(moonColor, clamp((moonDisk - moonCrescentDisk), 0.0, 1.0));
	
	
	// Horizon Glow from https://godotshaders.com/shader/stylized-sky-shader-with-clouds/
	float horizon = 0.5 - abs(EYEDIR.y + horizon_falloff);
	vec3 horizon_glow_amount_day = clamp(horizon * clamp(LIGHT0_DIRECTION.y, 0.0, 1.0), 0.0, 1.0) * horizon_color_day;
	vec3 horizon_glow_amount_sunset = clamp(horizon * clamp(1.0 - abs(LIGHT0_DIRECTION.y), 0.0, 1.0), 0.0, 1.0) * horizon_color_sunset;
	vec3 horizon_glow_night = clamp(horizon * clamp(-LIGHT0_DIRECTION.y, 0.0, 1.0), 0.0, 1.0) * horizon_color_night;
	vec3 horizon_glow =  horizon_glow_amount_sunset + horizon_glow_night;
	
	
	// Sky Gradient
	vec3 blue = dayColor;
	vec3 green = sunriseColor;
	vec3 red = nightColor;
	vec3 pink = sunsetColor;

	if (currentAngle > 0.0 && currentAngle < SunSetDuration) {
		if (currentSide > 0.0) { // upper pink gradient
			vec3 skyColorGradient = mix(pink, blue, colorGradient);
			skyColor = mix(skyColorGradient, blue, abs(LIGHT0_DIRECTION.y/SunSetDuration));
		} else { // green upper gradient
			vec3 skyColorGradient = mix(green, blue, colorGradient);
			skyColor = mix(skyColorGradient, blue, LIGHT0_DIRECTION.y/SunSetDuration);
		}
	} else if (currentAngle > SunSetDuration && currentAngle < 1.0) { // Day Gradient
		skyColor = mix(dayColor, dayTopColor, colorGradient);
	} else if (currentAngle < 0.0 && currentAngle < -SunSetDuration) {  // Night Gradient
		skyColor = mix(nightColor, nightTopColor, colorGradient);
	} else if (currentAngle > -SunSetDuration && currentAngle < -0.0) {
		if (currentSide > 0.0) { // pink lower gradient
			vec3 skyColorGradient = mix(red, pink , colorGradient);
			skyColor = mix(skyColorGradient, red, abs(LIGHT0_DIRECTION.y/SunSetDuration));
		} else { // green lower gradient
			vec3 skyColorGradient = mix(red, green, colorGradient);
			skyColor = mix(skyColorGradient, red, abs(LIGHT0_DIRECTION.y/SunSetDuration));
		}
	} 
	
	// Star Stuff from https://godotshaders.com/shader/stylized-sky-shader-with-clouds/
	vec2 sky_uv = EYEDIR.xz / EYEDIR.y;
	vec3 stars = texture(stars_texture, sky_uv + (stars_speed * TIME)).rgb;
	stars *= clamp(-LIGHT0_DIRECTION.y, 0.0, 1.0);
	stars = step(stars_cutoff, stars);

	// Clouds from https://godotshaders.com/shader/stylized-sky-shader-with-clouds/
	float clouds_movement = TIME * clouds_speed * 0.5;
	float clouds_base_noise = texture(clouds_texture, (sky_uv + clouds_movement ) * clouds_scale).r;
	float noise1 = texture(clouds_distort_texture, (sky_uv + clouds_base_noise + (clouds_movement * 0.75)) * clouds_scale).r;
	float noise2 = texture(clouds_noise_texture, (sky_uv + noise1 + (clouds_movement * 0.25)) * clouds_scale).r;
	float clouds_noise_value = clamp(noise1 * noise2, 0.0, 1.0) * clamp(EYEDIR.y, 0.0, 1.0);
	float clouds_value = clamp(smoothstep(clouds_cutoff, clouds_cutoff + clouds_fuzziness, clouds_noise_value), 0.0, 1.0);
	vec3 clouds = mix(cloudOutlienColor,  clouds_main_color , clouds_value) * clouds_value;
	
	float clouds_negative = 1.0 - clouds_value;

	skyColor = mix(skyColor, sun.rgb, sun.a);
	skyColor = mix(skyColor, moon.rgb, moon.a);
	vec3 sky = horizon_glow + skyColor +  stars +clouds; //clouds
	COLOR = sky;
}
