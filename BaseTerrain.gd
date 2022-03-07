extends TileMap

onready var screen_size := get_viewport().size
onready var noise := OpenSimplexNoise.new()
onready var tile_ids := []

func _ready() -> void:
	noise.lacunarity = 3
	noise.octaves = 4
	noise.period = 32.0
	noise.persistence = 0.2
	
	print(str(screen_size) + "/" + str(self.cell_size))
	
	var tiled_area := Vector2(
		ceil(screen_size.x / self.cell_size.x),
		ceil(screen_size.y / self.cell_size.y)
	)
	
	var tile_read_pos = Vector2(0,0)
	var tile_id = get_cellv(tile_read_pos)
	
	# Read the currently set tiles across to get the tile list
	while tile_id != INVALID_CELL:
		tile_ids.append(tile_id)
		tile_read_pos += Vector2.RIGHT
		if tile_read_pos.y > tiled_area.y:
			tile_read_pos.y = 0
			tile_read_pos += Vector2.DOWN
		tile_id = get_cellv(tile_read_pos)
	
	print (str(tiled_area))
	
	var min_noise : float = 0.0
	var max_noise : float = 0.0
	
	for y in range(int(tiled_area.y)):
		for x in range(int(tiled_area.x)):
			var tile_pos := Vector2(x, y)
			var noise_val := (noise.get_noise_2dv(tile_pos) + 1.0) / 2.0
			min_noise = min(min_noise, noise_val)
			max_noise = max(max_noise, noise_val)
			var noise_index := int(lerp(0, tile_ids.size(), noise_val))
			tile_id = tile_ids[noise_index]
			set_cellv(tile_pos, tile_id)
	
	print(str(min_noise) + " / " + str(max_noise))
