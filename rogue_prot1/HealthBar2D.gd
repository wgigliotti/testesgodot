extends Node2D


var bar_red = "res://arts/healthbar/horizontal_bar_red.png"
var bar_green = "res://arts/healthbar/horizontal_bar_green.png"
var bar_yellow = "res://arts/healthbar/horizontal_bar_yellow.png"

@export var show_value : bool = false

@onready var healthbar = $HealthBar

@onready var label = $HealthBar/Label

func _ready():	
	bar_green = ImageTexture.create_from_image(Image.load_from_file(bar_green))
	bar_yellow = ImageTexture.create_from_image(Image.load_from_file(bar_yellow))
	bar_red = ImageTexture.create_from_image(Image.load_from_file(bar_red))
	
	if show_value:
		label.show()
		
func fx_show_value():
	label.show()
	
func _process(_delta):
	global_rotation = 0

func update_healthbar(value):
	healthbar.texture_progress = bar_green
	if value < healthbar.max_value * 0.7:
		healthbar.texture_progress = bar_yellow
	if value < healthbar.max_value * 0.35:
		healthbar.texture_progress = bar_red
	label.text = str(value)
	if value < 0 or value > healthbar.max_value:
		hide()
	else:
		show()
		
	$HealthBar.value = value
	

func update_max(value):
	$HealthBar.max_value = value
