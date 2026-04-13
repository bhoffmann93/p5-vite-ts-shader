
/*
** HASHES
*/

// https://www.shadertoy.com/view/4djSRW
// Can produce Stripes when using uv: use gl_FragCoordinates.xy or scale uv up
// Temporal Noise -> use frame not time hash13(coords.xy, frame)

//hashes in out
float hash11(float p) {
    p = fract(p * .1031);
    p *= p + 33.33;
    p *= p + p;
    return fract(p);
}

//----------------------------------------------------------------------------------------
//  1 out, 2 in...
float hash12(vec2 p) {
    vec3 p3 = fract(vec3(p.xyx) * .1031);
    p3 += dot(p3, p3.yzx + 33.33);
    return fract((p3.x + p3.y) * p3.z);
}

//----------------------------------------------------------------------------------------
//  1 out, 3 in...
float hash13(vec3 p3) {
    p3 = fract(p3 * .1031);
    p3 += dot(p3, p3.zyx + 33.33);
    return fract((p3.x + p3.y) * p3.z);
}
//----------------------------------------------------------------------------------------
// 1 out 4 in...
float hash14(vec4 p4) {
    p4 = fract(p4 * vec4(.1031, .1030, .0973, .1099));
    p4 += dot(p4, p4.wzxy + 33.33);
    return fract((p4.x + p4.y) * (p4.z + p4.w));
}

//----------------------------------------------------------------------------------------
//  2 out, 1 in...
vec2 hash21(float p) {
    float n = fract(p * 0.1031);
    n *= n + 33.33;
    n *= n + n;
    return fract(vec2(n, n * 1.7));
}

//----------------------------------------------------------------------------------------
///  2 out, 2 in...
vec2 hash22(vec2 p) {
    vec3 p3 = fract(vec3(p.xyx) * vec3(.1031, .1030, .0973));
    p3 += dot(p3, p3.yzx + 33.33);
    return fract((p3.xx + p3.yz) * p3.zy);

}

//good for noise blurs
//----------------------------------------------------------------------------------------
///  2 out, 3 in...
vec2 hash23(vec3 p3) {
    p3 = fract(p3 * vec3(443.897, 441.423, .0973));
    p3 += dot(p3, p3.yzx + 19.19);
    return fract((p3.xx + p3.yz) * p3.zy);
}

//----------------------------------------------------------------------------------------
//  3 out, 1 in...
vec3 hash31(float p) {
    vec3 p3 = fract(vec3(p) * vec3(.1031, .1030, .0973));
    p3 += dot(p3, p3.yzx + 33.33);
    return fract((p3.xxy + p3.yzz) * p3.zyx);
}

//----------------------------------------------------------------------------------------
///  3 out, 2 in...
vec3 hash32(vec2 p) {
    vec3 p3 = fract(vec3(p.xyx) * vec3(.1031, .1030, .0973));
    p3 += dot(p3, p3.yxz + 33.33);
    return fract((p3.xxy + p3.yzz) * p3.zyx);
}

//----------------------------------------------------------------------------------------
///  3 out, 3 in...
vec3 hash33(vec3 p3) {
    p3 = fract(p3 * vec3(.1031, .1030, .0973));
    p3 += dot(p3, p3.yxz + 33.33);
    return fract((p3.xxy + p3.yxx) * p3.zyx);

}

//----------------------------------------------------------------------------------------
// 4 out, 1 in...
vec4 hash41(float p) {
    vec4 p4 = fract(vec4(p) * vec4(.1031, .1030, .0973, .1099));
    p4 += dot(p4, p4.wzxy + 33.33);
    return fract((p4.xxyz + p4.yzzw) * p4.zywx);

}

//----------------------------------------------------------------------------------------
// 4 out, 2 in...
vec4 hash42(vec2 p) {
    vec4 p4 = fract(vec4(p.xyxy) * vec4(.1031, .1030, .0973, .1099));
    p4 += dot(p4, p4.wzxy + 33.33);
    return fract((p4.xxyz + p4.yzzw) * p4.zywx);

}

//----------------------------------------------------------------------------------------
// 4 out, 3 in...
vec4 hash43(vec3 p) {
    vec4 p4 = fract(vec4(p.xyzx) * vec4(.1031, .1030, .0973, .1099));
    p4 += dot(p4, p4.wzxy + 33.33);
    return fract((p4.xxyz + p4.yzzw) * p4.zywx);
}

//----------------------------------------------------------------------------------------
// 4 out, 4 in...
vec4 hash44(vec4 p4) {
    p4 = fract(p4 * vec4(.1031, .1030, .0973, .1099));
    p4 += dot(p4, p4.wzxy + 33.33);
    return fract((p4.xxyz + p4.yzzw) * p4.zywx);
}

//Sin Hashes
float shash11(float n) {
    return fract(sin(n) * 43758.5453);
}

float shash12(vec2 coord) {
    return fract(sin(dot(coord.xy, vec2(12.9898, 78.233))) * 43758.5453);
}

vec2 shash22(vec2 p) {
    return fract(sin(vec2(dot(p, vec2(127.1, 311.7)), dot(p, vec2(269.5, 183.3)))) * 43758.5453);
}

float noise1d(float v) {
    return cos(v + cos(v * 90.1415) * 100.1415) * 0.5 + 0.5;
}

float noise(in vec2 x) {
    vec2 i = floor(x);
    vec2 f = fract(x);
    f = f * f * (3.0 - 2.0 * f);
    float n = i.x + i.y * 57.0;
    return mix(mix(shash11(n + 0.0), shash11(n + 1.0), f.x), mix(shash11(n + 57.0), shash11(n + 58.0), f.x), f.y);
}

// [0, steps]
float rndInt11(float seed, float steps) {
    return floor(hash11(seed) * (steps + 1.0));
}

// [0, steps]
vec2 rndInt21(float seed, vec2 steps) {
    vec2 h = hash21(seed);
    return floor(h * (steps + 1.0));
}

// [range.x, range.y]
float rndIntRange11(float seed, vec2 range) {
    return floor(mix(hash11(seed), range.x, range.y + 1.0));
}

// [range.x, range.y]
vec2 rndIntRange21(float seed, vec2 minRange, vec2 maxRange) {
    vec2 h = hash21(seed);
    return floor(mix(minRange, maxRange + vec2(1.0), h));
}

/**
 * Returns 1.0 if the tile index matches the target index, else 0.0.
 * Useful for isolating a specific cell in a grid. Stepping through random indices
 */
float getRandomIndexMask(float rndIndex, float index) {
    return step(index - 0.0001, rndIndex) * step(rndIndex, index + 0.0001);
}

/**
 * Returns a binary 1.0 or 0.0 based on a probability threshold.
 * Default threshold is 0.5. Step through multiple indices
 */
float getRandomIndicesMask(vec2 index, vec2 seed, float threshold) {
    return step(threshold, hash12(index + seed));
}

float getRandomIndicesMask(vec2 index, float seed, float threshold) {
    return step(threshold, hash12(index + seed));
}
