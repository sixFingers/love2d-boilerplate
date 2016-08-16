#ifdef VERTEX
    uniform mat4 u_model;
    uniform mat4 u_view;
    uniform mat4 u_projection;

    vec4 position(mat4 transform_projection, vec4 vertex_position)
    {
        return u_projection * u_view * u_model * vertex_position;
    }
#endif

#ifdef PIXEL
    vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords)
    {
        vec4 texturecolor = Texel(texture, texture_coords);
        return texturecolor * color;
    }
#endif