extends Control

@onready var grid_map: GridWorldMap = get_parent() as GridWorldMap;

signal update_cell_drawing;

func _ready() -> void:
	update_cell_drawing.connect(_on_update_cell_drawing);

func _on_update_cell_drawing() -> void:
	queue_redraw();

func _draw() -> void:
	draw_cells();

func draw_cells() -> void:
	var cells = grid_map.map;
	var tilemap = grid_map.base_map
	var tile_size = tilemap.tile_set.tile_size

	for cell in cells:
		var cell_coords = MapCell.generate_vector2i_from_unique_id(cell.id);
		var world_pos = tilemap.map_to_local(cell_coords)

		var half_w = tile_size.x / 2
		var half_h = tile_size.y / 2

		var points = [
			world_pos + Vector2(0, -half_h),        # top
			world_pos + Vector2(half_w, 0),         # right
			world_pos + Vector2(0, half_h),         # bottom
			world_pos + Vector2(-half_w, 0),      # left	
		]

		var has_point = grid_map.astar.has_point(cell.id);
		if !has_point:\
			# Draw filled rectangle
			draw_colored_polygon(points, Color(1, 0, 0, 1));
		else:
			points.append(points[0]) # close the loop
			draw_polyline(points, Color(.7, .7, .7, .42), 0.4, true)
