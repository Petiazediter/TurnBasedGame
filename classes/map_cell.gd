class_name MapCell

var id: int;
var is_walkable: bool;

func _init(_id: int, _is_walkable: bool) -> void:
    id = _id;
    is_walkable = _is_walkable;

static func generate_unique_id_from_vector2i(position: Vector2i) -> int:
    var a = position.x;
    var b = position.y;

    var A: int;
    if ( a < 0): 
        A = -2 * a - 1;
    else:
        A = 2 * a;
    var B: int;
    if ( b < 0): 
        B = -2 * b - 1;
    else:
        B = 2 * b;

    # Source: https://stackoverflow.com/questions/919612/mapping-two-integers-to-one-in-a-unique-and-deterministic-way
    return (A + B) * (A + B + 1) / 2 + A;

static func generate_vector2i_from_unique_id(unique_id: int) -> Vector2i:
    # Inverse Cantor pairing to get (A, B)
    var w = int(floor((sqrt(8 * unique_id + 1) - 1) / 2))
    var t = (w * (w + 1)) / 2
    var A = int(unique_id - t)
    var B = int(w - A)

    # Inverse of signed-to-unsigned mapping
    var x = -((A + 1) / 2) if A % 2 else A / 2
    var y = -((B + 1) / 2) if B % 2 else B / 2

    return Vector2i(x, y)