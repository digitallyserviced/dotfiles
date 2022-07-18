#version 300 es
// This is the Glyph vertex shader.
// It is responsible for placing the glyph images in the
// correct place on screen.

precision highp float;

in vec2 position;
in vec2 tex;
in vec4 fg_color;
in float has_color;
in float mix_value;
in vec3 hsv;
in vec4 alt_color;
in vec4 cursor_position;

uniform mat4 projection;
uniform vec2 resolution;
uniform float time;

out vec2 o_position;
out vec4 o_cursor_position;
out float o_has_color;
out vec2 o_tex;
out vec3 o_hsv;
out vec4 o_fg_color;
out vec4 o_fg_color_alt;
out float o_fg_color_mix;

void pass_through_vertex() {
  o_cursor_position = cursor_position;
  o_position = position;
  o_tex = tex;
  o_has_color = has_color;
  o_fg_color = fg_color;
  o_fg_color_alt = alt_color;
  o_fg_color_mix = mix_value;
  o_hsv = hsv;
}
void doit(){

float alpha = max( 0.0, sin( time ) * 0.002 );

    vec3 p = vec3(position.xy,0.0); 			 // original position
    vec3 n = normalize( p ) * 0.2; // point on unit sphere

	// do linear interpolation
	vec3 v = n * alpha + p * ( 1.0 - alpha );

	// in case normalize fails...
	if( p == vec3( 0.0, 0.0, 0.0 ) )
	{
		v = p;
	}

	// continue the transformation.
	gl_Position += projection * vec4( v, 1.0 );
	/* gl_TexCoord[0] = gl_MultiTexCoord0; */
	/* gl_FrontColor = gl_Color; */
   }
vec4 getPosition() {
    vec2 aspect = vec2(resolution.x / resolution.y, 1);
    vec2 nextScreen = position.xy * aspect;
    vec2 prevScreen = cursor_position.xy * aspect;

    vec2 tangent = normalize(nextScreen - prevScreen);
    vec2 normal = vec2(-tangent.y, tangent.x);
    normal /= aspect;
normal *= (1.0 - pow(abs(tex.y - 0.5) * 2.0, 2.0)) * 0.5;
    
    vec4 current = vec4(position,0.0, 1.0);
    /* current.xy -= normal * side; */
    current.xy -= normal * -1.0;
    return current;
}
void main() {
  pass_through_vertex();

/* vec4 pos = getPosition(); */
/* vec4 vpos =  projection * vec4(position.xy, 0.0, 1.0); */
  // Use the adjusted cell position to render the quad
  /* gl_Position = (projection * 2.0) * pos; */

  /* vec2 pos = position + vec2(cos(time)*100.0, sin(time)*100.0); */
  vec2 pos = position;
  gl_Position = (projection) * vec4(pos, 0.0,1.0);
  /* doit(); */
}
