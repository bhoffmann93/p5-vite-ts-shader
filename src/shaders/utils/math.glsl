// Pure math utilities — safe to include in both vertex and fragment shaders.
#define HALF_PI 1.57079632679
#define PI 3.14159265359
#define TAU 6.28318530718
#define EPSILON 1e-5 // 0.00001
#define eps32 1e-10
#define GOLDEN_ANGLE 2.39996322972865332
#define PHI 1.618033988749
#define PHI_CONJUGATE 0.61803398875

/*
** UV
*/

//one side will be 1 the other <1,>1
vec2 aspect01(vec2 uv, vec2 resolution) {
    float aspect = resolution.x / resolution.y;
    vec2 scale = resolution.x > resolution.y ? vec2(aspect, 1.0) : vec2(1.0, 1.0 / aspect);
    return (uv - 0.5) * scale + 0.5;
}

//Center at 0 and one Side 1.0
vec2 aspect11(vec2 uv, vec2 resolution) {
    return (2.0 * uv * resolution - resolution) / min(resolution.x, resolution.y);
}

bool isOutside01(vec2 uv) {
    return uv.x < 0.0 || uv.x > 1.0 || uv.y < 0.0 || uv.y > 1.0;
}

bool isInside01(vec2 uv) {
    return uv.x >= 0.0 && uv.x <= 1.0 && uv.y >= 0.0 && uv.y <= 1.0;
}

float inside01Mask(vec2 uv) {
    bool isInside = uv.x >= 0.0 && uv.x <= 1.0 && uv.y >= 0.0 && uv.y <= 1.0;
    return isInside ? 1.0 : 0.0;
}

vec2 toPolarN(vec2 uv, vec2 center) {
    vec2 localUv = uv - center;
    float radius = length(localUv) / sqrt(0.5); // normalize radius to [0,1]
    float angle = atan(localUv.y, localUv.x) / TAU + 0.5; // normalize angle to [0,1]
    return vec2(radius, angle);
}

//default center at (0.5, 0.5)
vec2 toPolarN(vec2 uv) {
    return toPolarN(uv, vec2(0.5));
}

vec2 toPolar(vec2 uv, vec2 center) {
    vec2 localUv = uv - center;
    float radius = length(localUv);
    float angle = atan(localUv.y, localUv.x); // returns [-π, π]
    return vec2(radius, angle);
}

vec2 scale(vec2 p, vec2 center, float scaleFactor) {
    return (p - center) / scaleFactor + center;
}

vec2 scale(vec2 p, vec2 center, vec2 scaleFactor) {
    return (p - center) / scaleFactor + center;
}

vec2 scale(vec2 p, float scaleFactor) {
    return scale(p, vec2(0.5), scaleFactor);
}

vec2 scale(vec2 p, vec2 scaleFactor) {
    return scale(p, vec2(0.5), scaleFactor);
}

// https://www.shadertoy.com/view/Nt2yzd
// https://math.stackexchange.com/questions/3020095/signed-angle-in-plane:
// "the ratio of the cross product and scalar product is the tangent of the angle"
// From [1]: "The tangent of the signed angle between a and b is det([ab]) / dot(ab)"
float signedAngle(vec2 a, vec2 b) {
    // atan(y, x) returns the angle whose arctangent is y / x. Value in [-pi, pi]
    return atan(a.x * b.y - a.y * b.x, dot(a, b));
}

vec2 trs(vec2 p, vec2 anchor, float angle, vec2 scale) {
    vec2 pos = p - anchor; //move to origin
    //rotation
    float c = cos(angle);
    float s = sin(angle);
    mat2 rot = mat2(c, s, -s, c);
    pos = rot * pos;
    pos = pos * scale;
    return pos + anchor; //moe back to anchor
}

vec2 direction(float angle) {
    return vec2(cos(angle), sin(angle));
}

float checkerboard(vec2 uv, vec2 tiles) {
    return mod(floor(uv.x * tiles.x) + floor(uv.y * tiles.y), 2.0);
}
/*
** UTILS
*/

float inv(float x) {
    return 1.0 - x;
}

float invstep(float edge, float x) {
    return 1.0 - step(edge, x);
}

float halfstep(float x) {
    return step(0.5, x);
}

float saturate(float x) {
    return clamp(x, 0.0, 1.0);
}

vec2 saturate(vec2 x) {
    return clamp(x, vec2(0.0), vec2(1.0));
}

vec3 saturate(vec3 x) {
    return clamp(x, vec3(0.0), vec3(1.0));
}

float inverseLerp(float a, float b, float v) {
    return (v - a) / (b - a);
}

vec2 inverseLerp(vec2 a, vec2 b, vec2 v) {
    return (v - a) / (b - a);
}

float inverseLerpClamped(float a, float b, float v) {
    return clamp((v - a) / (b - a), 0.0, 1.0);
}

vec2 inverseLerpClamped(vec2 a, vec2 b, vec2 v) {
    return clamp((v - a) / (b - a), 0.0, 1.0);
}

float linearstep(float a, float b, float value) {
    return clamp((value - a) / (b - a), 0.0, 1.0);
}

float map(float value, float min1, float max1, float min2, float max2) {
    return min2 + (value - min1) * (max2 - min2) / (max1 - min1);
}

vec2 map(vec2 value, vec2 min1, vec2 max1, vec2 min2, vec2 max2) {
    return min2 + (value - min1) * (max2 - min2) / (max1 - min1);
}

// spread from 0.5
// range 0.5 == x [0.0 - 1.0]
//x [0.0, 1.0] to [0.0 - range / 2.0, 1.0 + range / 2.0]
float symmetricMix(float x, float range) {
    return mix(0.5 - range, 0.5 + range, x);
}

// spread from 0.0
// range 1.0 =  x[-0.5, 0.5]
// x [0.0, 1.0] to [-range / 2.0, range / 2.0]
float spread(float x, float range) {
    return range * (0.5 - (1.0 - x));
}

vec2 spread(vec2 x, vec2 range) {
    return range * (0.5 - (1.0 - x));
}

//mask 1.0 between edge0 edge1 otherwise 0
float isolate(float edge0, float edge1, float x) {
    return step(edge0, x) * (1. - step(edge1, x));
}

// triangle [0.0, 1.0]
float riseFall(float x) {
    return 1.0 - abs(2.0 * x - 1.0);
}

//https://iquilezles.org/articles/smoothstepintegral/
//smoothly accelerate to constant speed
float smoothstepIntegral(float time, in float duration) {
    if(time >= duration)
        return time - 0.5 * duration;
    float f = time / duration;
    return f * f * f * (duration - time * 0.5);
}

float smootherstep(float edge0, float edge1, float x) {
    x = clamp((x - edge0) / (edge1 - edge0), 0.0, 1.0);
    return x * x * x * (x * (x * 6.0 - 15.0) + 10.0);
}

//https://www.shadertoy.com/view/NsVSWy
// Err function approximation
float erf(in float x) {
    return sign(x) * sqrt(1.0 - exp2(-1.787776 * x * x));
}

// Gaussian filtered blurry rectangle
//https://www.shadertoy.com/view/NsVSWy
float gaussianRect(in vec2 p, in vec2 b, in float w) {
    float u = erf((p.x + b.x) / w) - erf((p.x - b.x) / w);
    float v = erf((p.y + b.y) / w) - erf((p.y - b.y) / w);
    return u * v / 4.0;
}

float gaussianStep(float dist, float sigma) {
    // We scale by sqrt(2) approx 1.414 to align sigma with standard pixel units
    return 0.5 + 0.5 * erf(dist / (sigma * 1.414));
}

//https://iquilezles.org/articles/functions/
float expStep(float x, float k) {
    return exp2(-pow(x, k));
}

//from https://www.shadertoy.com/user/Dave_Hoskins/
//good for sharp fades
float expstep(float edge0, float edge1, float x) {
    float t = (x - edge0) / (edge1 - edge0);
    return clamp(exp((t - .9825) * 3.) - .0525, 0.0, 1.0);
}

//https://www.shadertoy.com/view/Xt23zV
// like triangle /\
float trianglestep(float edge0, float edge1, float x) {
    return 1.0 - abs(clamp((x - edge0) / (edge1 - edge0), 0.0, 1.0) - .5) * 2.0;
}

//https://www.shadertoy.com/view/Xt23zV
//like parabola
float parabolastep(float edge0, float edge1, float x) {
    x = 1.0 - abs(clamp((x - edge0) / (edge1 - edge0), 0.0, 1.0) - .5) * 2.0;
    return x * x * (3.0 - x - x);
}

float spikystep(float e0, float e1, float x, float steps, float spikyness) {
    x = clamp((x - e0) / (e1 - e0), 0.0, 1.0);
    float globalRamp = x * (steps - 1.0);
    float localSpikes = smoothstep(0.0, 1.0, fract(x * steps)) * spikyness;
    localSpikes = x == 1.0 ? spikyness : localSpikes;
    return (globalRamp + localSpikes) / (steps - 1.0 + spikyness);
}

//more values at edges useful eg for hash positions
float edgeBias(float x) {
    return (x < 0.5) ? 0.5 - sqrt(0.25 - (x - 0.5) * (x - 0.5)) : 0.5 + sqrt(0.25 - (x - 0.5) * (x - 0.5));
}

// triangle oscillates between 0 and 'length'.
// period == 2.0 * length, [0.0, length] range
// https://www.desmos.com/calculator/vcsjnyz7x4
float pingpong(float x, float length) {
    float m = length * 2.0;
    float modx = mod(mod(x, m) + m, m); // euclidean modulo
    return length - abs(modx - length);
}

//[-infinity, infinty]
// Quantizes value into discrete steps, with the last step being less than 1.0
float quantize(float value, float steps) {
    return floor(value * steps) / steps; //last step is < 1.0
}

//[-infinity, infinty]
// Quantizes value into discrete steps, with the last step being less than 1.0
vec2 quantize(vec2 value, vec2 steps) {
    return floor(value * steps) / steps;
}

//[-infinity, infinty]
// Quantizes value into discrete steps, with the last step being  1.0
float quantizeCeil(float value, float steps) {
    return floor(value * steps) / (steps - 1.0);
}

//[-infinity, infinty]
// Quantizes value into discrete steps, with the last step being  1.0
vec3 quantizeCeil(vec3 value, float steps) {
    return floor(value * steps) / (steps - 1.0);
}

/*
** SHAPING
*/

float absTweak(float x, float neg, float pos) {
    return max(-x * neg, x * pos);
}

// https://iquilezles.org/articles/functions/
// https://www.youtube.com/watch?v=-6Yb4X_GMOc
// use to smooth mirror functions
float smoothAbs(float x, float n) {
    return sqrt(x * x + n * n);
}

// https ://iquilezles.org/articles/functions/
// replace clamp / max(x, e) smooth with tweakable lower knee
// soft clipping: smooth edges of sdf, max(dist, 0.001) 
float almostIdentity(float x, float m, float e) {
    if(x > m)
        return x;
    float a = 2.0 * e - m;
    float b = 2.0 * m - 3.0 * e;
    float t = x / m;
    return (a * t + b) * t * t + e;
}

//for 0-1 like almost identity linear at 1.0it
float almostUnitIdentity(float x) {
    return x * x * (2.0 - x);
}

//https://iquilezles.org/articles/smin/
//distorts everywhere
float sminExponential(float a, float b, float k) {
    float res = exp2(-k * a) + exp2(-k * b);
    return -log2(res) / k;
}

// quadratic polynomial
float sminQuadPoly(float a, float b, float k) {
    float h = clamp(0.5 + 0.5 * (b - a) / k, 0.0, 1.0);
    return mix(b, a, h) - k * h * (1.0 - h);
}

//recommended for sdf blending 
float sminCubicPoly(float a, float b, float k) {
    k *= 6.0;
    float h = max(k - abs(a - b), 0.0) / k;
    return min(a, b) - h * h * h * k * (1.0 / 6.0);
}

float smin(float a, float b, float k) {
    return sminExponential(a, b, k);
}

vec3 smin(vec3 a, vec3 b, float k) {
    return vec3(smin(a.x, b.x, k), smin(a.y, b.y, k), smin(a.z, b.z, k));
}

float smax(float a, float b, float k) {
    return smin(a, b, -k);
}

float tan01(float x) {
    return 0.5 + 0.5 * tan((x - 0.5) * PI);
}

// circ [-1.0, 1.0]
// Note: This creates a semicircle. 
// At x = -1 or x = 1, the result is 0. At x = 0, the result is 1.
float circShape(float x) {
    return sqrt(max(0.0, 1.0 - (x * x)));
}

/**
 * sqrtShape [0.0, 1.0]
 * k = 4.0 reaches a peak of 1.0 at x = 0.5.
 * k = 1.0 reaches a peak of 0.5 at x = 0.5 (Half-circle arc).
 */
float sqrtShape(float x, float k) {
    return sqrt(max(0.0, k * x * (1.0 - x)));
}

// Normalized version (0 to 1 to 0)
float sqrtShape01(float x) {
    return sqrt(max(0.0, 4.0 * x * (1.0 - x)));
}

float sqrtShape(vec2 uv, float k) {
    return sqrtShape(uv.x, k) * sqrtShape(uv.y, k);
}

float sqrtShape(vec2 uv) {
    return sqrtShape01(uv.x) * sqrtShape01(uv.y);
}

float diamond(vec2 uv) {
    return max(abs(uv.x - 0.5), abs(uv.y - 0.5)) * 2.0; //chebyshev
}

float diamond2(vec2 uv) {
    return abs(uv.x - 0.5) + abs(uv.y - 0.5); //manhattan
}

float gain(float x, float k) {
    float a = 0.5 * pow(2.0 * ((x < 0.5) ? x : 1.0 - x), k);
    return (x < 0.5) ? a : 1.0 - a;
}

//k == 1.0 so x falls to o at 1.0
//k >= 1.0 even sharper
//https://iquilezles.org/articles/functions/
float expImpulse(float x, float k) {
    float h = k * x;
    return h * exp(1.0 - h);
}

//https://iquilezles.org/articles/functions/
//f == value where it lands [0.0,1.0]
float expSustainedImpulse(float x, float f, float k) {
    float s = max(x - f, 0.0);
    return min(x * x / (f * f), 1.0 + (2.0 / f) * s * exp(-k * s));
}

//similar to expImpulse
float quaImpulse(float k, float x) {
    return 2.0 * sqrt(k) * x / (1.0 + k * x * x);
}

//similar to expImpulse
//n: degree of polynomial
float polyImpulse(float k, float n, float x) {
    return (n / (n - 1.0)) *
        pow((n - 1.0) * k, 1.0 / n) *
        x / (1.0 + k * pow(x, n));
}

//like impulse 0-1-0 with sin wave bouncing
float sinc(float x, float k) {
    float a = PI * (k * x - 1.0);
    return sin(a) / a;
}

//https://iquilezles.org/articles/functions/
//is cut off so for smooth out masks that go beyond 01 use gauss
float parabola(float x, float k) {
    return pow(4.0 * x * (1.0 - x), k);
}

float parabola(float x) {
    return parabola(x, 2.0);
}

//sits at x 0 so range [-sth,sth]
float gauss(float x, float e) {
    return exp(-pow(x, 2.) / e);
}

//https://iquilezles.org/articles/functions/
float pcurve(float x, float a, float b) {
    float k = pow(a + b, a + b) / (pow(a, a) * pow(b, b));
    return k * pow(x, a) * pow(1.0 - x, b);
}

//https://iquilezles.org/articles/functions/
//quadratic falloff reaches 0.0 at m
float truncfallof(float x, float m) {
    x /= m;
    return (x - 2.0) * x + 1.0;
}

// https://iquilezles.org/articles/functions/
//Chances are you found yourself doing smoothstep(c-w,c,x)-smoothstep(c,c+w,x)
//very often as a way to select a region centered at c that goes from c-w to
//c+w. I know I do, and that's why I made this cubicPulse() below. You can
//also use it as a replacement for a gaussian with local support.
//parabola center 0.5 bell is at center 0 left 0 right
float cubicPulse(float center, float w, float x) {
    x = abs(x - center);
    if(x > w)
        return 0.0;
    x /= w;
    return 1.0 - x * x * (3.0 - 2.0 * x);
}

// not visivle at x 0.0 an 1.0
// x = 0.5 bell at center
// [0.0, 1.0]
float cubicPulse2(float center, float w, float x) {
    float d = abs(x - center);
    x = min(d, 1.0 - d);
    if(x > w)
        return 0.0;
    x /= w;
    return 1.0 - x * x * (3.0 - 2.0 * x);
}

float rationalBump(float x, float k) {
    return 1.0 / (1.0 + k * x * x);
}

float doubleBump(float x, float k) {
    return x / (1.0 + pow(x, k));
}

float tone(float x, float k) {
    return (k + 1.0) * x / (1.0 + k * x);
}

/*
** WAVES
*/

float triangle(float t, float frequency) {
    return abs(2.0 * (t * frequency - floor(t * frequency + 0.5)));
}

//[-1,1]
float sawtooth(float t, float frequency) {
    float x = t * frequency;
    return 2.0 * (x - floor(x)) - 1.0;
}

//[-1,1]
float square(float t, float frequency) {
    return sign(sin(2.0 * PI * t * frequency));
}

/*
** CURVES
*/

//this is 1d like on a line
float quadraticBezier(float t, float anchor1, float controlPoint, float anchor2) {
    float b = 2.0 * (1.0 - t) * t;
    float a = (1.0 - t) * (1.0 - t);
    float c = t * t;
    return a * anchor1 + b * controlPoint + c * anchor2;
}

vec2 quadraticBezier(float t, vec2 anchor1, vec2 controlPoint, vec2 anchor2) {
    float b = 2.0 * (1.0 - t) * t;
    float a = (1.0 - t) * (1.0 - t);
    float c = t * t;
    return a * anchor1 + b * controlPoint + c * anchor2;
}

float quadraticBezier01(float t, float p) {
    return quadraticBezier(t, 0.0, p, 1.0);
}

float cubicBezier(float t, float anchor1, float control1, float control2, float anchor2) {
    float t1 = 1.0 - t;
    return t1 * t1 * t1 * anchor1 + 3.0 * t1 * t1 * t * control1 + 3.0 * t1 * t * t * control2 + t * t * t * anchor2;
}

float cubicBezier01(float t, float p1, float p2) {
    return cubicBezier(t, 0.0, p1, p2, 1.0);
}

vec3 catmullRom(vec3 p0, vec3 p1, vec3 p2, vec3 p3, float t) {
    float t2 = t * t;
    float t3 = t2 * t;

    // Cattmull-Rom coefficients
    float b1 = -t3 + 2.0 * t2 - t;
    float b2 = 3.0 * t3 - 5.0 * t2 + 2.0;
    float b3 = -3.0 * t3 + 4.0 * t2 + t;
    float b4 = t3 - t2;

    return 0.5 * (b1 * p0 + b2 * p1 + b3 * p2 + b4 * p3);
}

float catmullRom(float p0, float p1, float p2, float p3, float t) {
    float t2 = t * t;
    float t3 = t2 * t;
    float b1 = -t3 + 2.0 * t2 - t;
    float b2 = 3.0 * t3 - 5.0 * t2 + 2.0;
    float b3 = -3.0 * t3 + 4.0 * t2 + t;
    float b4 = t3 - t2;
    return 0.5 * (b1 * p0 + b2 * p1 + b3 * p2 + b4 * p3);
}

vec2 catmullRom(vec2 p0, vec2 p1, vec2 p2, vec2 p3, float t) {
    float t2 = t * t;
    float t3 = t2 * t;
    float b1 = -t3 + 2.0 * t2 - t;
    float b2 = 3.0 * t3 - 5.0 * t2 + 2.0;
    float b3 = -3.0 * t3 + 4.0 * t2 + t;
    float b4 = t3 - t2;
    return 0.5 * (b1 * p0 + b2 * p1 + b3 * p2 + b4 * p3);
}

/*
** BLENDING MODES
*/

vec3 overlay(vec3 base, vec3 blend) {
    return mix(2.0 * base * blend, 1.0 - 2.0 * (1.0 - base) * (1.0 - blend), step(0.5, base));
}

vec3 overlay(vec3 base, vec3 blend, float opacity) {
    return (overlay(base, blend) * opacity + base * (1.0 - opacity));
}

vec3 screen(vec3 base, vec3 blend) {
    return 1.0 - (1.0 - base.rgb) * (1.0 - blend.rgb);
}

vec3 screen(in vec3 base, in vec3 blend, float opacity) {
    return screen(base, blend) * opacity + base * (1.0 - opacity);
}

// ---- 8< ---- GLSL Number Printing - @P_Malin ---- 8< ----
// Creative Commons CC0 1.0 Universal (CC-0)
// https://www.shadertoy.com/view/4sBSWW

float digitBin(const int x) {
    return x == 0 ? 480599.0 : x == 1 ? 139810.0 : x == 2 ? 476951.0 : x == 3 ? 476999.0 : x == 4 ? 350020.0 : x == 5 ? 464711.0 : x == 6 ? 464727.0 : x == 7 ? 476228.0 : x == 8 ? 481111.0 : x == 9 ? 481095.0 : 0.0;
}

float printValue(vec2 vStringCoords, float fValue, float fMaxDigits, float fDecimalPlaces) {
    if((vStringCoords.y < 0.0) || (vStringCoords.y >= 1.0))
        return 0.0;

    bool bNeg = (fValue < 0.0);
    fValue += 1e-5; //WORKAROUND PRECISION ISSUE TO LOG EVEN NUMBERS
    fValue = abs(fValue);

    float fLog10Value = log2(abs(fValue)) / log2(10.0);
    float fBiggestIndex = max(floor(fLog10Value), 0.0);
    float fDigitIndex = fMaxDigits - floor(vStringCoords.x);
    float fCharBin = 0.0;
    if(fDigitIndex > (-fDecimalPlaces - 1.01)) {
        if(fDigitIndex > fBiggestIndex) {
            if((bNeg) && (fDigitIndex < (fBiggestIndex + 1.5)))
                fCharBin = 1792.0;
        } else {
            if(fDigitIndex == -1.0) {
                if(fDecimalPlaces > 0.0)
                    fCharBin = 2.0;
            } else {
                float fReducedRangeValue = fValue;
                if(fDigitIndex < 0.0) {
                    fReducedRangeValue = fract(fValue);
                    fDigitIndex += 1.0;
                }
                float fDigitValue = (abs(fReducedRangeValue / (pow(10.0, fDigitIndex))));
                fCharBin = digitBin(int(floor(mod(fDigitValue, 10.0))));
            }
        }
    }
    return floor(mod((fCharBin / pow(2.0, floor(fract(vStringCoords.x) * 4.0) + (floor(vStringCoords.y * 5.0) * 4.0))), 2.0));
}

float printValue(const in vec2 fragCoord, const in vec2 vPixelCoords, const in vec2 vFontSize, const in float fValue, const in float fMaxDigits, const in float fDecimalPlaces) {
    vec2 vStringCharCoords = (fragCoord.xy - vPixelCoords) / vFontSize;

    return printValue(vStringCharCoords, fValue, fMaxDigits, fDecimalPlaces);
}

//for aspect01 uv
float printValueBottomLeft(vec2 uv, float print) {
    return printValue((uv + vec2(0.01, -0.01)) * 25.0, print, 3.0, 2.0);
}

//for aspect01 uv
float printValueBottomRight(vec2 uv, float print) {
    return printValue((uv + vec2(-0.7, -0.01)) * 25.0, print, 2.0, 2.0);
}

// Original interface
// ---- 8< -------- 8< -------- 8< -------- 8< ----