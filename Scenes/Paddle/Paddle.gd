extends Area2D
class_name Paddle



var snap_target_x := 0.0
const SPEED: float = 1000
const SNAP_SPEED: float = 5000  # brzina paddle

@onready var holo: Sprite2D = $Holo
@onready var sprite: Sprite2D = $Sprite2D

signal stamina_changed(current: float, max: float)
var stamina: float = 100
const MAX_STAMINA: float = 100
const STAMINA_DRAIN: float = 30
const BOOST_SPEED: float = 1500
var boost_active:=false


var moving_left := false
var moving_right := false
var snapping := false
var holo_active := false

func _ready() -> void:
	add_to_group("paddle")
	emit_stamina()
	holo.z_index = 10
	holo.visible = false
	holo.top_level = true

func emit_stamina() -> void:
	stamina_changed.emit(stamina, MAX_STAMINA)
	
	
func _process(delta: float) -> void:
	var vp = Game.get_vpr()
	moving_left = Input.is_action_pressed("move_left")
	moving_right = Input.is_action_pressed("move_right")
	boost_active = Input.is_action_pressed("ability") and stamina > 0.0
	var direction = int(moving_right) - int(moving_left)
	var half_width = sprite.texture.get_width() / 2
	

	if boost_active and direction != 0:
		var before := stamina
		stamina -= STAMINA_DRAIN*delta
		if stamina <0.0:
			stamina = 0.0
			boost_active = false
		if stamina !=before:
			emit_stamina()
			
			
		var new_x = global_position.x + BOOST_SPEED * delta * direction
		new_x = clamp(new_x, half_width, vp.size.x - half_width)
		global_position.x = new_x
		holo.visible = false
		holo_active = false
		snapping = false
		return
		
	if direction != 0:
		if not holo_active:
			holo.global_position = global_position
			holo.visible = true
			holo_active = true
		
		var new_x = holo.global_position.x + SPEED * delta * direction
		new_x = clamp(new_x, half_width, vp.size.x - half_width)
		holo.global_position.x = new_x
		
		

		if snapping:
			snapping = false

	elif direction == 0 and holo_active and not snapping:
		snapping = true
		snap_target_x = holo.global_position.x
		

	if snapping:
		
		global_position.x = move_toward(global_position.x, snap_target_x, SNAP_SPEED * delta)
		global_position.x = clamp(global_position.x, half_width, vp.size.x - half_width)
		if abs(global_position.x - snap_target_x) <= 1.0:
			global_position.x = snap_target_x
			snapping = false
			holo.visible = false
			holo_active = false
			
			
			
func add_stamina(amount: float) -> void:
	var before := stamina
	stamina = min(MAX_STAMINA, stamina + amount)
	if stamina != before:
		emit_stamina()
