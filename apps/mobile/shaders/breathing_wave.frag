#version 460 core
#include <flutter/runtime_effect.glsl>

uniform vec2 u_size;
uniform float u_time;
uniform vec3 u_color;
uniform float u_intensity; // Controls height/speed of the wave (Emotional state mapping)

out vec4 fragColor;

void main() {
    vec2 uv = FlutterFragCoord().xy / u_size;

    // Center origin horizontally
    uv.x = uv.x * 2.0 - 1.0;

    // Create the wave shape using sine functions
    // Combining a few frequencies for a more organic feel
    float wave1 = sin(uv.x * 3.0 + u_time * 2.0) * 0.1 * u_intensity;
    float wave2 = sin(uv.x * 5.0 - u_time * 1.5) * 0.05 * u_intensity;
    float combinedWave = wave1 + wave2;

    // Calculate distance from center line (Y = 0.5) adjusted by the wave
    float dist = abs(uv.y - 0.5 - combinedWave);

    // Create the glow effect (smoothstep creates a nice feathered edge)
    // The glow falls off based on the distance from the wave line
    float glow = smoothstep(0.1 * u_intensity, 0.0, dist);

    // Edge fade to mask out the sides
    float edgeFade = smoothstep(1.0, 0.5, abs(uv.x));

    vec3 finalColor = u_color * glow * edgeFade;

    // The alpha represents the maximum intensity of the glow in this fragment
    fragColor = vec4(finalColor, glow * edgeFade);
}
