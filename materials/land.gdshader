shader_type spatial;

uniform sampler2D control_texture : filter_nearest;
uniform sampler2D grass_texture_1 : filter_nearest;
uniform sampler2D grass_texture_2 : filter_nearest;
uniform vec3 grass_tint_1 : source_color;
uniform vec3 grass_tint_2 : source_color;
uniform vec3 dirt_tint_1 : source_color;
uniform float grass_cutoff : hint_range(-1,1);

void vertex() {
}

void fragment() {
	ROUGHNESS = 1.0;
	vec4 world = INV_VIEW_MATRIX * vec4(VERTEX, 1.0);
	//if (texture(control_texture, UV).x < 0.5) {

		vec3 worldNormal = (INV_VIEW_MATRIX * vec4(NORMAL.xyz, 0.0)).xyz;
		if (dot(worldNormal, vec3(0.0, 1.0, 0.0)) > grass_cutoff) {
			float black = texture(grass_texture_1, world.xz).x
				* texture(grass_texture_2, world.xz / 4.0).x
				* texture(grass_texture_1, world.xz / 2.0).x
				* texture(grass_texture_2, world.xz / 8.0).x
				* 4.0;
			ALBEDO = mix(grass_tint_1, grass_tint_2, black);
		} else {
			float black = texture(grass_texture_2, world.xz).x
				* texture(grass_texture_1, world.xy / 4.0).x
				* texture(grass_texture_2, world.xz / 2.0).x
				* texture(grass_texture_1, world.xy / 8.0).x
				* 4.0;
			ALBEDO = mix(vec3(0,0,0), dirt_tint_1, black);
		}

	//}
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
