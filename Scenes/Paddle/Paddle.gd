extends Area2D

const SPEED: float = 1000

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:

	var movement: float = Input.get_axis("move_left", "move_right")
	position.x += SPEED * delta * movement

	var sprite_half_width = $Sprite2D.texture.get_width() / 2
	position.x = clampf(position.x, Game.get_vpr().position.x + sprite_half_width, Game.get_vpr().end.x - sprite_half_width)
