precision mediump float;
uniform sampler2D uTexture;
uniform vec2 uResolution;
uniform float uTime;
varying vec2 vTexCoord;

void main() {
    vec2 uv = vTexCoord;
    vec4 color = texture2D(uTexture, uv);
    gl_FragColor = color;
    // gl_FragColor = vec4(1.0, 0.0, 0.0, 1.0);
}