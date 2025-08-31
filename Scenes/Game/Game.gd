extends Node2D

class_name Game

var _score: int = 0
const EXPLODE = preload("res://assets/explode.wav")
const GEM = preload("res://Scenes/Gem/Gem.tscn")
const MARGIN: float = 70


@onready var spawn_timer: Timer = $SpawnTimer
@onready var paddle: Area2D = $Paddle
@onready var score_sound: AudioStreamPlayer2D = $ScoreSound
@onready var sound: AudioStreamPlayer = $Sound
@onready var score_label: Label = $ScoreLabel

static var _vp_r: Rect2
static func get_vpr() -> Rect2:
	return _vp_r

func _ready() -> void:
	update_vp()
	get_viewport().size_changed.connect(update_vp)
	spawn_gem()
	
	
func update_vp() -> void:
	_vp_r = get_viewport_rect()
	

func spawn_gem()-> void:
	var new_gem: Gem = GEM.instantiate()
	var x_pos: float = randf_range(_vp_r.end.x - MARGIN, _vp_r.position.x + MARGIN)
	new_gem.position = Vector2(x_pos, MARGIN)
	new_gem.gem_off_screen.connect(_on_gem_off_screen)
	add_child(new_gem)
	
func stop_all() -> void:
	sound.stop()
	sound.stream = EXPLODE
	sound.play()
	spawn_timer.stop()
	paddle.set_process(false)
	for child in get_children():
		if child is Gem:
			child.set_process(false)

func _on_timer_timeout() -> void:
	spawn_gem()


func _on_gem_off_screen() -> void:
	stop_all()
	
	




func _on_paddle_area_entered(area: Area2D) -> void:
	if score_sound.playing == false:
		_score += 1
		score_label.text = str(_score).pad_zeros(3)
		score_sound.position = area.position
		score_sound.play()
		
