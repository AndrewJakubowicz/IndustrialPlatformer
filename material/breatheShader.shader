shader_type canvas_item;

uniform vec2 scale_up = vec2(0.2, 0.2);

void vertex () {
	vec2 scale = vec2(1) + abs(sin(TIME)) * scale_up;
	VERTEX = (EXTRA_MATRIX * vec4((VERTEX * scale), 0, 0)).xy;
}