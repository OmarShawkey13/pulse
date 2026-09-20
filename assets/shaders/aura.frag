#version 460 core
#include <flutter/runtime_effect.glsl>

uniform float uTime;
uniform vec2 uSize;
uniform vec4 uColor;

out vec4 fragColor;

// A small, deterministic field: three sine waves are much cheaper than
// per-pixel hash/noise + FBM while still giving the aura a living motion.
void main() {
    vec2 size = max(uSize, vec2(1.0));
    vec2 uv = FlutterFragCoord().xy / size;
    vec2 p = (uv - 0.5) * 2.0;
    p.x *= size.x / size.y;

    float time = uTime * 0.45;
    float wave =
        sin(p.x * 2.4 + time) * 0.45 +
        cos(p.y * 2.1 - time * 0.8) * 0.35 +
        sin((p.x + p.y) * 1.7 + time * 0.55) * 0.20;

    float distanceFromCenter = length(p);
    float glow = 1.0 - smoothstep(0.15, 1.25, distanceFromCenter);
    float intensity = 0.78 + wave * 0.18;
    vec3 color = uColor.rgb * intensity;

    fragColor = vec4(color, glow * 0.62);
}
