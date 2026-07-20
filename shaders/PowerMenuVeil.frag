#version 440

layout(location = 0) out vec4 fragColor;

layout(std140, binding = 0) uniform buf {
    mat4 qt_Matrix;
    float qt_Opacity;
    vec4 veilColor;
    float veilOpacity;
} ubuf;

float interleavedGradientNoise(vec2 position) {
    return fract(52.9829189 * fract(dot(position, vec2(0.06711056, 0.00583715))));
}

void main() {
    float scaledOpacity = clamp(ubuf.veilOpacity, 0.0, 1.0) * 255.0;
    float lowerOpacity = floor(scaledOpacity);
    float opacityFraction = fract(scaledOpacity);
    float ditherThreshold = interleavedGradientNoise(gl_FragCoord.xy);
    float ditheredOpacity = (lowerOpacity + step(ditherThreshold, opacityFraction)) / 255.0;

    fragColor = vec4(ubuf.veilColor.rgb * ditheredOpacity, ditheredOpacity) * ubuf.qt_Opacity;
}
