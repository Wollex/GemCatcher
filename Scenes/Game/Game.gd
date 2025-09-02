extends Node2D
class_name Game

const EXPLODE = preload("res://assets/explode.wav")
const GEM = preload("res://Scenes/Gem/Gem.tscn")

@onready var game_ui: GameUI = %GameUI
@onready var paddle: Paddle = $Paddle
@onready var score_sound: AudioStreamPlayer2D = $ScoreSound
@onready var sound: AudioStreamPlayer = $Sound
@onready var score_label: Label = $ScoreLabel


var _score: int = 0

const MARGIN: float = 70

static var _vp_r: Rect2
static func get_vpr() -> Rect2:
	return _vp_r

const BPM: float = 120.0
var beat_interval: float = 60.0 / BPM
var last_beat: int = -1

var last_gem_x: float = 0
var elapsed_time: float = 0.0
var speed: float = 2
var last_spawned_beat: int = -1


func _ready() -> void:
	update_vp()
	get_viewport().size_changed.connect(update_vp)
	await get_tree().process_frame
	paddle.stamina_changed.connect(_on_paddle_stamina_changed)
	
	
func update_vp() -> void:
	_vp_r = get_viewport_rect()
	

func spawn_gem(time_sec:float)-> void:
	var new_gem: Gem = GEM.instantiate()
	var center_x = _vp_r.size.x / 2
	var full_amplitude = (_vp_r.size.x / 2) - MARGIN
	var target_x = center_x + sin(time_sec * speed) * full_amplitude
	var step = 200
	var x_pos = last_gem_x + step * sign(target_x - last_gem_x)
	x_pos = clamp(x_pos, MARGIN, _vp_r.size.x - MARGIN)
	last_gem_x = x_pos
	new_gem.position = Vector2(x_pos, MARGIN)
	new_gem.gem_off_screen.connect(_on_gem_off_screen)
	add_child(new_gem)


	
func stop_all() -> void:
	sound.stop()
	sound.stream = EXPLODE
	sound.play()
	paddle.set_process(false)
	for child in get_children():
		if child is Gem:
			child.set_process(false)



func _on_gem_off_screen() -> void:
	pass
	


func _on_paddle_area_entered(area: Area2D) -> void:
	if score_sound.playing == false:
		_score += 1
		score_label.text = str(_score).pad_zeros(3)
		score_sound.position = area.position
		score_sound.play()
		
func animate_gems_on_beat() -> void:
	for child in get_children():
		if child is Gem:		
			child.scale = Vector2(1,1)
			
			var tw = child.create_tween()
			tw.tween_property(child, "scale", Vector2(1.2, 1.2), 0.1).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
			tw.tween_property(child, "scale", Vector2(1, 1), 0.1).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
			
func _process(delta: float) -> void:
	if sound and sound.playing:
		elapsed_time += delta
		var beat_index: int = int(floor(elapsed_time / beat_interval))
		
		if beat_index > last_beat:
			animate_gems_on_beat()
			last_beat = beat_index
			
		if beat_index > last_spawned_beat and (beat_index % 1) == 0:
			spawn_gem(elapsed_time)
			last_spawned_beat = beat_index
			
			
			
func _on_paddle_stamina_changed(current: float, max_value: float) -> void:
	var ratio := 0.0 if max_value == 0.0 else current / max_value
	if game_ui:
		game_ui.set_stamina_ratio(ratio)
		
		
