/**
 *
 * RenderPipeline
 *
 * Copyright (c) 2014-2016 tobspr <tobias.springer1@gmail.com>
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 *
 */

#version 430

#pragma include "Includes/Configuration.inc.glsl"
#pragma include "Includes/ColorSpaces/ColorSpaces.inc.glsl"

uniform sampler2D SourceTex;
uniform writeonly image2D RESTRICT DestTex;

void main() {
    ivec2 coord = ivec2(gl_FragCoord.xy);

    vec3 scene_color = texelFetch(SourceTex, coord, 0).xyz;
    float luma = get_luminance(scene_color);
    vec3 bloom_color = vec3(0);
    if (luma > GET_SETTING(Bloom, minimum_luminance)) {
        bloom_color = scene_color;
        bloom_color *= GET_SETTING(Bloom, bloom_strength) * 0.008;
        bloom_color *= 10.0;
    }

    #if DEBUG_MODE
        bloom_color *= 0;
    #endif

    imageStore(DestTex, coord, vec4(bloom_color, 0));
}
