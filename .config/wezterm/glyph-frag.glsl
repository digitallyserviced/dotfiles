#version 300 es
// This is the Glyph fragment shader.
// It is responsible for laying down the glyph graphics on top of the other layers.
#extension GL_EXT_blend_func_extended: enable
precision highp float;
#define PI 3.14159265359

in vec2 o_position;
in float o_has_color;
in vec2 o_tex;
in vec3 o_hsv;
in vec4 o_fg_color;
in vec4 o_fg_color_alt;
in float o_fg_color_mix;

// The color + alpha
layout(location=0, index=0) out vec4 color;
// Individual alpha channels for RGBA in color, used for subpixel
// antialiasing blending
layout(location=0, index=1) out vec4 colorMask;

uniform vec3 foreground_text_hsb;
uniform sampler2D atlas_nearest_sampler;
uniform sampler2D atlas_linear_sampler;
uniform bool subpixel_aa;
uniform float time;
/* uniform float delta; */
uniform vec2 resolution;
/* #define iResolution (vec2(1800.0,900.0).xy) */
#define iResolution (resolution.xy)
/* #define iTime (time / (pow(10.0,7.0))) */
#define time (time * 0.0015)
#define iTime (time * 0.00015)
#define u_resolution (resolution)
#define u_time (time)
/**/
/* float random(in float x){ */
/*     return fract(sin(x)*43758.5453); */
/* } */
/**/
/* float random(in vec2 st){ */
/*     return fract(sin(dot(st.xy ,vec2(12.9898,78.233))) * 43758.5453); */
/* } */
/**/
/* float randomChar(in vec2 outer,in vec2 inner){ */
/*     float grid = 5.; */
/*     vec2 margin = vec2(.2,.05); */
/*     float seed = 23.; */
/*     vec2 borders = step(margin,inner)*step(margin,1.-inner); */
/*     return step(.5,random(outer*seed+floor(inner*grid))) * borders.x * borders.y; */
/* } */
/**/
/* vec3 matrix(in vec2 st){ */
/*     float rows = 50.0; */
/*     vec2 ipos = floor(st*rows)+vec2(1.,0.); */
/**/
/*     ipos += vec2(.0,floor(iTime*20.*random(ipos.x))); */
/**/
/*     vec2 fpos = fract(st*rows); */
/*     vec2 center = (.5-fpos); */
/**/
/*     float pct = random(ipos); */
/*     float glow = (1.-dot(center,center)*3.)*2.0; */
/**/
/*     return vec3(randomChar(ipos,fpos) * pct * glow); */
/* } */
/**/
/* vec4 junk( vec4 fragColor, vec2 fragCoord ){ */
/* 	vec2 st = fragCoord.xy / iResolution.xy; */
/*     st.y *= iResolution.y/iResolution.x; */
/**/
/* 	fragColor = vec4(matrix(st),1.0); */
/*         return fragColor; */
/* } */
vec3 rgb2hsv(vec3 c)
{
    vec4 K = vec4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
    vec4 p = mix(vec4(c.bg, K.wz), vec4(c.gb, K.xy), step(c.b, c.g));
    vec4 q = mix(vec4(p.xyw, c.r), vec4(c.r, p.yzx), step(p.x, c.r));

    float d = q.x - min(q.w, q.y);
    float e = 1.0e-10;
    return vec3(abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x);
}

vec3 hsv2rgb(vec3 c)
{
    vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
    vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
    return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
}

const vec3 unit3 = vec3(1.0);

vec4 apply_hsv(vec4 c, vec3 transform)
{
  if (transform == unit3) {
    return c;
  }
  vec3 hsv = rgb2hsv(c.rgb) * transform;
  return vec4(hsv2rgb(hsv).rgb, c.a);
}

/*
float to_srgb(float x) {
  if (x <= 0.0031308) {
    return 12.92 * x;
  }
  return 1.055 * pow(x, (1.0 / 2.4)) - 0.055;
}

vec3 to_srgb(vec3 c) {
  return vec3(to_srgb(c.r), to_srgb(c.g), to_srgb(c.b));
}

vec4 to_srgb(vec4 v) {
  return vec4(to_srgb(v.rgb), v.a);
}
*/

vec4 to_srgb(vec4 linearRGB)
{
  bvec3 cutoff = lessThan(linearRGB.rgb, vec3(0.0031308));
  vec3 higher = vec3(1.055)*pow(linearRGB.rgb, vec3(1.0/2.4)) - vec3(0.055);
  vec3 lower = linearRGB.rgb * vec3(12.92);

  return vec4(mix(higher, lower, cutoff), linearRGB.a);
}



float random(in float x){ return fract(sin(x)*43758.5453); }
float random(in vec2 st){ return fract(sin(dot(st.xy ,vec2(12.9898,78.233))) * 43758.5453); }

float randomChar(vec2 outer,vec2 inner){
    float grid = 1.25;
    vec2 margin = vec2(.2,.205);
    vec2 borders = step(margin,inner)*step(margin,1.-inner);
    vec2 ipos = floor(inner*grid);
    vec2 fpos = fract(inner*grid);
    return step(.5,random(outer*64.+ipos)) * borders.x * borders.y * step(0.01,fpos.x) * step(0.01,fpos.y);
}

vec4 shit( vec4 fragColor, vec2 fragCoord ){
    vec2 st = fragCoord.st/u_resolution.xy;
    st.y *= u_resolution.y/u_resolution.x;
    vec3 color = vec3(0.0);

    float t = u_time*1.25;
    float rows = floor(50.);
    vec2 ipos = floor(st*rows);
    vec2 fpos = fract(st*rows);

    ipos.y += mod(floor(t*random(ipos.x+1.)),max(u_resolution.x,u_resolution.y));
vec2 center = (.5-fpos);
    float pct = 1.0;
    pct *= randomChar(ipos,fpos);
    pct *= random(ipos);
float glow = (1.-dot(center,center)*3.)*2.0;

    color -= vec3(0.643,0.851,0.690) * ( randomChar(ipos,fpos) * pct*glow );
    // color += pct*pct;
// vec3 color = vec3(0.643,0.851,0.690) * ( rchar(ipos,fpos) * pct );
    color +=  vec3(0.027,0.880,0.163) * pct+pct;
    // return color;
    fragColor = vec4( color , 1.0);
    return fragColor;
}

float rchar(in vec2 outer,in vec2 inner){
  float grid =70.;
    vec2 margin = vec2(-2.+random(.2),random(.15)*0.25);
    float seed = 200.-time*0.15;
    vec2 borders = step(margin,inner)*step(margin,3.-inner);
    return step(.75,random(outer*seed+floor(inner*grid))) * borders.x * borders.y;
}

vec3 matrix(in vec2 st){
    float rows = 100.0;
    vec2 ipos = floor(st*rows);

    ipos += vec2(.0,floor(time*10.*random(ipos.x)*0.2));


    vec2 fpos = fract(st*rows);
    vec2 center = (.5-fpos);

    float pct = random(ipos);
    float glow = (1.-dot(center,center)*3.)*2.0;

    vec3 color = vec3(0.643,0.851,0.690) * ( rchar(ipos,fpos) * pct );
    color +=  vec3(0.027,0.180,0.063) * pct; // * glow;
    color -= 0.2;
    return color;
    // return vec3(rchar(ipos,fpos) * pct * glow);
}

vec4 junk( vec4 fragColor, vec2 fragCoord ){
   vec2 st = fragCoord.st/resolution.xy;
    st.y *= resolution.y/resolution.x;
    vec3 color = vec3(0.0);

    color = matrix(st);
    fragColor = vec4( color* 0.2 , 1.0);
    return fragColor;
}
void main() {
  vec4 fg_color = mix(o_fg_color, o_fg_color_alt, o_fg_color_mix);
  /* vec4 fg_color = mix(o_fg_color, junk(o_fg_color, o_position), o_fg_color_mix); */
  if (o_has_color == 9.0) {
    // Solid color block
    /* color = fg_color * (o_position.xyyx * sin(delta) / 0.15) ; */
    color = fg_color;
    colorMask = vec4(1.0);
  } else if (o_has_color == 3.0) {
    // Solid color block
    color = fg_color;
  /* color=junk(fg_color, o_position); */
  color=mix(shit(color, o_tex), fg_color, o_fg_color_mix);
    colorMask = vec4(1.0);
  } else if (o_has_color == 2.0) {
    // The window background attachment
    color = texture(atlas_linear_sampler, o_tex);
    /* color += random(color.xy)*(iTime+1.0 / (pow(10.0,6.0)+0.1)); */
    /* color.rga *= random(color.xy); */
    // Apply window_background_image_opacity to the background image
    if (subpixel_aa) {
      colorMask = fg_color.aaaa;
    } else {
      color.a *= fg_color.a;
    }
  /* color=mix(color, junk(color, o_position), 0.2); */
  } else if (o_has_color == 1.0) {
    // the texture is full color info (eg: color emoji glyph)
    color = texture(atlas_nearest_sampler, o_tex);
    // this is the alpha
  /* color=junk(color, o_position); */
  color=mix(shit(color, o_tex), color, o_fg_color_mix);
    colorMask = color.aaaa;
  } else if (o_has_color == 4.0) {
    // Grayscale poly quad for non-aa text render layers
    colorMask = texture(atlas_nearest_sampler, o_tex);
    color = fg_color;
  color=junk(color, o_position);
    color.a *= colorMask.a;
  } else if (o_has_color == 0.0) {
    // the texture is the alpha channel/color mask
    colorMask = texture(atlas_nearest_sampler, o_tex);
    // and we need to tint with the fg_color
    color = fg_color;
    if (!subpixel_aa) {
      color.a = colorMask.a;
    }
    color = apply_hsv(color, foreground_text_hsb);
  }
/* vec2 st = o_position * (o_position.x/o_position.y); */
/* vec2 st = o_position.xy / (vec2(1800.0,900.0).xy); */
/**/
/* st = st * 2.0 - 1.0; */
/*     // Step will return 0.0 unless the value is over 0.5, */
/*     // in that case it will return 1.0 */
/*     float y = step(0.5,st.x); */
/**/
/**/
/*     vec3 fgColor = vec3(y); */
/**/
/*     float pct = plot(st,y); */
/*     fgColor = (1.0-pct)*fgColor+pct*vec3(0.0,1.0,0.0); */
/**/
/*     vec4 gColor = vec4(fgColor,1.0); */
  /*   color = mix(color, gColor, 0.5); */
  color = apply_hsv(color, o_hsv);
  /* color = apply_hsv(vec4(color.rgb * (st.x+1.0), 1.0), o_hsv); */
  /**/
  /* // We MUST output SRGB and tell glium that we do that (outputs_srgb), */
  /* // otherwise something in glium over-gamma-corrects depending on the gl setup. */
  color = to_srgb(color);
}
