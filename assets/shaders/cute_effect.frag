#include <flutter/runtime_effect.glsl>

uniform vec2 resolution;
uniform float time;
uniform sampler2D image;

out vec4 fragColor;

void main() {
  vec2 uv = FlutterFragCoord().xy / resolution.xy;

  // Create a soft, moving gradient
  float noise = sin(uv.x * 10.0 + time) * 0.5 + 0.5;
  noise *= sin(uv.y * 8.0 + time * 0.8) * 0.5 + 0.5;

  // Sample the original image
  vec4 color = texture(image, uv);

  // Add a soft pink tint
  vec3 tint = vec3(1.0, 0.8, 0.9);

  // Create a dreamy effect
  float glow = sin(time * 0.5) * 0.1 + 0.1;
  vec3 finalColor = mix(color.rgb, tint, glow * noise);

  // Add a subtle vignette effect
  float vignette = 1.0 - smoothstep(0.5, 1.5, length(uv - 0.5) * 2.0);
  finalColor *= vignette;

  fragColor = vec4(finalColor, color.a);
}