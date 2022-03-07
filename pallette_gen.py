#!/usr/bin/env python3


# Gen tile data
for index in range(64):
    region_x = index % 8
    region_y = int((index) / 8)

    region_x *= 4
    region_y *= 4

    print(f'{index}/name = "pallette.png 0"')
    print(f'{index}/texture = ExtResource( 1 )')
    print(f'{index}/tex_offset = Vector2( 0, 0 )')
    print(f'{index}/modulate = Color( 1, 1, 1, 1 )')
    print(f'{index}/region = Rect2( {region_x}, {region_y}, 4, 4 )')
    print(f'{index}/tile_mode = 0')
    print(f'{index}/occluder_offset = Vector2( 0, 0 )')
    print(f'{index}/navigation_offset = Vector2( 0, 0 )')
    print(f'{index}/shape_offset = Vector2( 0, 0 )')
    print(f'{index}/shape_transform = Transform2D( 1, 0, 0, 1, 0, 0 )')
    print(f'{index}/shape_one_way = false')
    print(f'{index}/shape_one_way_margin = 0.0')
    print(f'{index}/shapes = [  ]')
    print(f'{index}/z_index = 0')

# Gen placement data
data_string = ""
for index in range(64):
    data_string += f", {index}, {index}, 0"
print(f"tile_data = PoolIntArray({data_string[1:]})")
