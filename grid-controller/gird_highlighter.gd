extends Control
class_name GridHighligher;

@onready var grid_map: GridWorldMap = get_parent() as GridWorldMap;

signal update_cell_drawing;

var SELECTION_COLOR: Color = Color(0.345, 0.196, 0.659, .3);
var ERROR_COLOR: Color = Color(0.369, 0.035, 0.035, .73);

var highlighted_cells: Array[MapCell] = [];
var error_highlighted_cells: Array[MapCell] = [];

func _ready() -> void:
	update_cell_drawing.connect(_on_update_cell_drawing);

func _on_update_cell_drawing() -> void:
	queue_redraw();

func select_cells(
	cells: Array[MapCell],
	error_non_walkable: bool = true,
	) -> void:
		self.highlighted_cells.clear();
		self.error_highlighted_cells.clear();
		for cell in cells:
			if cell.is_walkable or !error_non_walkable:
				self.highlighted_cells.append(cell);
			else:
				self.error_highlighted_cells.append(cell);
		update_cell_drawing.emit();

func _draw() -> void:
	draw_grid();
	for cell in highlighted_cells:
		highlight_cell(cell, SELECTION_COLOR, true);
	for cell in error_highlighted_cells:
		highlight_cell(cell, ERROR_COLOR, true);

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
