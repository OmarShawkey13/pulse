#version 460 core
#include <flutter/runtime_effect.glsl>

uniform float uTime;
uniform vec2 uSize;
uniform vec4 uColor;

out vec4 fragColor;

// Lightweight hash
float hash(vec2 p) {
    return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453);
}

// Lightweight noise
float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);

    float a = hash(i);
    float b = hash(i + vec2(1.0, 0.0));
    float c = hash(i + vec2(0.0, 1.0));
    float d = hash(i + vec2(1.0, 1.0));

    vec2 u = f * f * (3.0 - 2.0 * f);

    return mix(a, b, u.x) +
           (c - a) * u.y * (1.0 - u.x) +
           (d - b) * u.x * u.y;
}

// Reduced FBM (2 iterations only)
float fbm(vec2 p) {
    float v = 0.0;
    float a = 0.5;

    for (int i = 0; i < 2; i++) {
        v += a * noise(p);
        p *= 2.0;
        a *= 0.5;
    }
    return v;
}

void main() {
    vec2 uv = FlutterFragCoord().xy / uSize;
    vec2 p = (uv - 0.5) * 2.0;
    p.x *= uSize.x / uSize.y;

    float t = uTime * 0.08;

    // Light domain warp
    vec2 warp = vec2(
        fbm(p + t),
        fbm(p - t)
    ) * 0.3;

    float f = fbm(p + warp);

    float dist = length(p);

    // Soft glow mask
    float glow = smoothstep(1.2, 0.2, dist);

    vec3 color = uColor.rgb * (0.6 + f * 0.8);

    // Cheap glow instead of heavy bloom
    color += uColor.rgb * glow * 0.4;

    float alpha = glow * 0.7;

    fragColor = vec4(color, alpha);
}