precision mediump float;

#include "./utils/math.glsl"
#include "./utils/random.glsl"
#include "./utils/rotate.glsl"

uniform sampler2D uTexture;
uniform vec2 uResolution;
uniform float uTime;
uniform float uFrame;
varying vec2 vTexCoord;

vec3 filmGrain(vec3 color, float strength, float seed) {
    float noise = hash13(vec3(gl_FragCoord.xy, seed)) - 0.5;
    return screen(color, vec3(noise) * strength);
}

void main() {
    vec2 uv = vTexCoord;
    vec3 color = texture2D(uTexture, uv).rgb;

    // color = filmGrain(color, 0.1, uFrame);
    color += (1.0 / 255.0) * hash12(gl_FragCoord.xy + fract(uTime)) - (0.5 / 255.0); //dither reduce banding
    gl_FragColor = vec4(color, 1.0);
}