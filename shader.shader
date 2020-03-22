shader_type canvas_item;

void fragment() {
	vec2 uv = SCREEN_UV;
	//uv.x = floor(uv.x * 640.0) / 640.0;
	//uv.y = floor(uv.y * 360.0) / 360.0;
	vec3 screen = texture(SCREEN_TEXTURE, uv).rgb;
	float value = (screen.r + screen.g + screen.b) / 3.0f;
	vec2 palette_uv = vec2(value, 0.0f);
	COLOR = texture(TEXTURE, palette_uv);
	
}