extends CanvasLayer
class_name GameUI

@onready var stamina_bg: Panel = $HUD/StaminaBG
@onready var stamina_fill: ColorRect = $HUD/StaminaBG/StaminaFill

var _max_w: float = 0.0


func _ready() -> void:
	await get_tree().process_frame
	_max_w = stamina_bg.size.x
	set_stamina_ratio(1.0)
	pass 


func set_stamina_ratio(ratio: float) -> void:
	ratio = clamp(ratio, 0.0, 1.0)
	stamina_fill.size.x = _max_w * ratio
	
	
func _process(delta: float) -> void:
	pass
