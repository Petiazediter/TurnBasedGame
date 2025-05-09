extends Node2D
class_name GridWorldMap

@onready var base_map: TileMapLayer = $GridMapGroundLevel;
@onready var props_map: TileMapLayer = $GridMapPropsLevel;

var astar: AStar2D = AStar2D.new();
var map: Array[MapCell] = [];

func _ready() -> void:
	link_astar();

func link_astar() -> void:
	astar.clear();
	create_points();
	connect_points();

func create_points() -> void:
	for cell in base_map.get_used_cells():
		var cell_coords = Vector2i(cell.x, cell.y);
		var cell_id = MapCell.generate_unique_id_from_vector2i(cell_coords);
		var map_cell = MapCell.new(cell_id,true);
		map.append(map_cell);

		var prop_cell = props_map.get_cell_tile_data(cell_coords);
		if prop_cell != null:
			map_cell.set_walkable(false);

		if map_cell.is_walkable:
			astar.add_point(cell_id, cell_coords);


func connect_points() -> void:
	for cell in base_map.get_used_cells():
		var cell_coords = Vector2i(cell.x, cell.y);
		var cell_id = MapCell.generate_unique_id_from_vector2i(cell_coords);
		var neighbors = base_map.get_surrounding_cells(cell_coords);
		for neighbor in neighbors:
			var neighbor_id = MapCell.generate_unique_id_from_vector2i(neighbor);
			if astar.has_point(neighbor_id) and astar.has_point(cell_id):
				astar.connect_points(cell_id, neighbor_id, true);

func get_map_cell_by_id(cell_id: int) -> MapCell:
	for cell in map:
		if cell.id == cell_id:
			return cell;
	return null;