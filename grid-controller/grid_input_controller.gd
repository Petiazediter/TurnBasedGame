extends Node

@onready var grid_map: GridWorldMap = get_parent() as GridWorldMap;
@onready var hovered_cell: MapCell = null;
@export var selection_controller: GridHighligher;


func _input(event: InputEvent) -> void:
    var hovered_cell_curr = hovered_cell;
    if event is InputEventMouseMotion:
        var mouse_pos = event.position
        var cell_coords = grid_map.base_map.local_to_map(mouse_pos)
        if cell_coords != null:
            var cell_id = MapCell.generate_unique_id_from_vector2i(cell_coords)
            var cell = grid_map.get_map_cell_by_id(cell_id)
            if cell != null:
                if cell != hovered_cell_curr:
                    hovered_cell = cell;
                    selection_controller.select_cells([cell], true);
            else:
                hovered_cell = null;
                selection_controller.select_cells([], false);
        else:
            hovered_cell = null;
            selection_controller.select_cells([], false);
