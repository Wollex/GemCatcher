extends Area2D


class_name Gem

signal gem_off_screen

@onready var gem: Area2D = $"."
const SPEED: float = 400.0

const BPM: float = 120.0
var beat_interval: float = 60.0
var last_beat: int = -1

@export var stamina_gain: float = 5.0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:	
	gem.position.y += SPEED*delta
	
	if position.y > Game.get_vpr().end.y:
		gem_off_screen.emit()
		die()
		

func die() -> void:
	set_process(false)
	queue_free()
func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("paddle"):
		area.add_stamina(stamina_gain)
	die()
