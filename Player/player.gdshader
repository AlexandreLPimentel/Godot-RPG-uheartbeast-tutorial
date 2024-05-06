shader_type canvas_item;

uniform bool active = false;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec4 previous_color = texture(TEXTURE, UV);
	if(active) {
		COLOR = vec4(1.0, 1.0, 1.0, previous_color.w);
	}
	else {
		COLOR = previous_color;
	}
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
