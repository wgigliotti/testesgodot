extends Sprite3D
class_name HealthBar3D

@export var show_value : bool = false
@onready var viewport = $Viewport
@onready var healthbar = $Viewport/HealthBar2D
# Called when the node enters the scene tree for the first time.
func _ready():
	texture = viewport.get_texture()
	if show_value:
		healthbar.show_value = true

func update_healthbar(value):
	healthbar.update_healthbar(value)
	
func fx_show_value():
	healthbar.show_value = true
	healthbar.fx_show_value()
	
func update_max(value):
	healthbar.update_max(value)
