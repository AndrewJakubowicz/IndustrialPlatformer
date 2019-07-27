shader_type canvas_item;

uniform float time_factor = 18.0;
uniform float time_running = 0;
uniform bool on = false;
uniform vec4 flash_color = vec4(0.2, 0.1, 0.2, 1);

uniform vec2 scale_up = vec2(0.2, 0.1);

void fragment () {
	vec4 color = texture(TEXTURE, UV);
	if (on) {
		vec4 difference = abs(cos(time_factor*TIME)) * (flash_color - color);
		vec4 finalColor = color + difference;
		COLOR = vec4(finalColor.r, finalColor.g, finalColor.b, color.a);
	} else {
		COLOR = color;
	}
}

void vertex () {
	if (on) {
		vec2 scale = vec2(1) + abs(sin((time_factor/0.7) * TIME)) * scale_up;
		VERTEX = (EXTRA_MATRIX * vec4((VERTEX * scale), 0, 0)).xy;
	}
}