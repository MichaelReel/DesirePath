extends TileMap

onready var screen_size := get_viewport().size
onready var noise := OpenSimplexNoise.new()
onready var tile_ids := PoolIntArray()
onready var walkable_tile_ids := PoolIntArray()
onready var marker_tilemap := $Markers


func _ready() -> void:
	var tiled_area := Vector2(
		ceil(screen_size.x / self.cell_size.x),
		ceil(screen_size.y / self.cell_size.y)
	)
	
	setup_noise()
	setup_terrain_tile_ids()
	setup_walkable_tile_ids()
	setup_base_terrain(tiled_area)
	setup_markers(tiled_area)


func setup_noise() -> void:
	noise.lacunarity = 3
	noise.octaves = 4
	noise.period = 32.0
	noise.persistence = 0.2


func setup_terrain_tile_ids() -> void:
	"""The first row of tiles is the colour lerp for each noise height"""
	var tile_read_pos := Vector2(0,0)
	var tile_id := get_cellv(tile_read_pos)
	
	# Read the currently set tiles across to get the tile list
	while tile_id != INVALID_CELL:
		tile_ids.append(tile_id)
		tile_read_pos += Vector2.RIGHT
		tile_id = get_cellv(tile_read_pos)


func setup_walkable_tile_ids() -> void:
	"""The second row of tiles are the navigable tile types"""
	var tile_read_pos := Vector2(0,1)
	var tile_id := get_cellv(tile_read_pos)
	
	# Read the currently set tiles across to get the tile list
	while tile_id != INVALID_CELL:
		walkable_tile_ids.append(tile_id)
		tile_read_pos += Vector2.RIGHT
		tile_id = get_cellv(tile_read_pos)


func setup_base_terrain(tiled_area : Vector2) -> void:
	for y in range(int(tiled_area.y)):
		for x in range(int(tiled_area.x)):
			var tile_pos := Vector2(x, y)
			var noise_val := (noise.get_noise_2dv(tile_pos) + 1.0) / 2.0
			var noise_index := int(lerp(0, tile_ids.size(), noise_val))
			var tile_id := tile_ids[noise_index]
			set_cellv(tile_pos, tile_id)


func setup_markers(tiled_area : Vector2) -> void:
	for _i in range(10):
		var mark_pos := Vector2(randi() % int(tiled_area.x), randi() % int(tiled_area.y))
		var terrain_tile := get_cellv(mark_pos)
		if terrain_tile in walkable_tile_ids:
			marker_tilemap.set_cellv(mark_pos, 4)
