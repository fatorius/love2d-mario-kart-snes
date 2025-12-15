uniform float horizonY;
uniform float screenH;
uniform float screenW;

uniform vec2 scroll;

varying float vDepth;
varying vec2 vUV;

#ifdef VERTEX

vec4 position(mat4 transform_projection, vec4 vertex_position)
{
    float y = vertex_position.y;

    float depth = (y - horizonY) / (screenH - horizonY);
    depth = clamp(depth, 0.0, 1.0);

    float centerX = screenW * 0.5;

    float dx = vertex_position.x - centerX;

    float expansion = mix(1.0, 2.0, depth);

    float expandedX = centerX + dx * expansion;

    vertex_position.x = mix(vertex_position.x, expandedX, depth);

    vDepth = depth;
    vUV = VertexTexCoord.xy * depth;

    return transform_projection * vertex_position;
}

#endif


#ifdef PIXEL
vec4 effect(
    vec4 color,
    Image texture,
    vec2 texCoords,
    vec2 screenCoords
) {
    float depth = clamp(vDepth, 0.001, 1.0);

    vec2 uvLinear = texCoords + scroll;

    vec2 uvPerspective = (vUV / depth) + scroll;

    vec2 uv = mix(uvLinear, uvPerspective, depth);

    return Texel(texture, uv) * color;
}
#endif