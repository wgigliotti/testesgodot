extends Node2D


var bar_red = "res://arts/healthbar/horizontal_bar_red.png"
var bar_green = "res://arts/healthbar/horizontal_bar_green.png"
var bar_yellow = "res://arts/healthbar/horizontal_bar_yellow.png"

@onready var healthbar = $HealthBar

func _ready():	
	pass
	
func _process(_delta):
	global_rotation = 0

func update_healthbar(value):
	healthbar.texture_progress = ImageTexture.create_from_image(Image.load_from_file(bar_green))
	if value < healthbar.max_value * 0.7:
		healthbar.texture_progress = ImageTexture.create_from_image(Image.load_from_file(bar_yellow))
	if value < healthbar.max_value * 0.35:
		healthbar.texture_progress = ImageTexture.create_from_image(Image.load_from_file(bar_red))
	
	if value < 0 or value > healthbar.max_value:
		hide()
	else:
		show()
		
	$HealthBar.value = value
	

func update_max(value):
	$HealthBar.max_value = value
