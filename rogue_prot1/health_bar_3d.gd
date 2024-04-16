extends Sprite3D

@onready var viewport = $Viewport
@onready var healthbar = $Viewport/HealthBar2D
# Called when the node enters the scene tree for the first time.
func _ready():
	texture = viewport.get_texture()

func update_healthbar(value):
	healthbar.update_healthbar(value)
	
func update_max(value):
	healthbar.update_max(value)
