extends Control
class_name GridHighligher;

@onready var grid_map: GridWorldMap = get_parent() as GridWorldMap;

var hovered_cell: MapCell = null;

signal update_cell_drawing;

var SELECTION_COLOR: Color = Color(0.345, 0.196, 0.659, .3);
var ERROR_COLOR: Color = Color(0.369, 0.035, 0.035, .73);

func _ready() -> void:
	update_cell_drawing.connect(_on_update_cell_drawing);

func _on_update_cell_drawing() -> void:
	queue_redraw();

func _input(event: InputEvent) -> void:
	# Check if the player is moving the mouse:
	var hovered_cell_curr = hovered_cell;
	if event is InputEventMouseMotion:
		var mouse_pos = event.position;
		var cell_coords = grid_map.base_map.local_to_map(mouse_pos);
		if cell_coords != null:
			var cell_id = MapCell.generate_unique_id_from_vector2i(cell_coords);
			var cell = grid_map.get_map_cell_by_id(cell_id);
			if cell != null:
				hovered_cell = cell;
			else:
				hovered_cell = null;
	
	if hovered_cell != hovered_cell_curr:
		update_cell_drawing.emit();

func _draw() -> void:
	draw_grid();
	if hovered_cell != null:
		if hovered_cell.is_walkable:
			highlight_cell(hovered_cell, SELECTION_COLOR, true);
		else:
			highlight_cell(hovered_cell, ERROR_COLOR, true);

func get_isometric_cell_points(cell: MapCell, should_connect: bool) -> Array[Vector2]:
	var tilemap = grid_map.base_map;
	var tile_size = tilemap.tile_set.tile_size;

	var cell_coords = MapCell.generate_vector2i_from_unique_id(cell.id);
	var world_pos = tilemap.map_to_local(cell_coords)

	var half_w = tile_size.x / 2
	var half_h = tile_size.y / 2

	var points: Array[Vector2] = [
		world_pos + Vector2(0, -half_h),
		world_pos + Vector2(half_w, 0),
		world_pos + Vector2(0, half_h),
		world_pos + Vector2(-half_w, 0),	
	]

	if should_connect:
		points.append(points[0]);

	return points;

func draw_grid() -> void:
	var cells = grid_map.map;
	for cell in cells:
		var points = get_isometric_cell_points(cell, true);
		draw_polyline(points, Color(.7, .7, .7, .42), 0.2, true);

func highlight_cell(cell: MapCell, color: Color, filled: bool) -> void:
	var points = get_isometric_cell_points(cell, !filled);
	if filled:
		draw_colored_polygon(points, color);
	else:
		draw_polyline(points, color, 0.2, true);
