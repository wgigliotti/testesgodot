@tool
extends CharacterBody3D

class_name CharacterBase

@onready var vision : Area3D = get_node("Vision")
@onready var vision_shape : CollisionShape3D = vision.get_node("Shape")
@onready var pivot : Node3D = get_node("Pivot")
@onready var character_sheet : CharacterSheet = get_node("CharacterSheet") 
@onready var healthbar = get_node("HealthBar3D")
@onready var animationPlayer = pivot.get_node("Model").get_node("AnimationPlayer")

var _SPEED : float = 10

var active_animation = { "name": "Idle", "scale": 1, "start":null, "end":null}
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var dead : bool = false

func _ready():
	if  Engine.is_editor_hint():
		return
		
	init_attributes()
	

func init_attributes():	
	character_sheet.set_value(constants.CharacterAttributes.NAME, self.name)
	_SPEED = character_sheet.get_value(constants.CharacterAttributes.SPEED)
	
	healthbar.update_max(character_sheet.get_value(constants.CharacterAttributes.HEALTH_MAX))
	healthbar.update_healthbar(character_sheet.get_value(constants.CharacterAttributes.HEALTH_CURRENT))
	
	print("%d - %d" % [character_sheet.get_value(constants.CharacterAttributes.HEALTH_MAX), character_sheet.get_value(constants.CharacterAttributes.HEALTH_CURRENT)])
	
	update_vision(character_sheet.get_value(constants.CharacterAttributes.DISTANCE_VISION))
	
	character_sheet.connect_signal_for_property(constants.CharacterAttributes.HEALTH_CURRENT, func(from, to) : healthbar.update_healthbar(to))
	character_sheet.connect_signal_for_property(constants.CharacterAttributes.HEALTH_MAX, func(from, to) : healthbar.update_max(to))
	character_sheet.connect_signal_for_property(constants.CharacterAttributes.SPEED, func(from, to) : _SPEED = to)
	character_sheet.connect_signal_for_property(constants.CharacterAttributes.DISTANCE_VISION, func(from, to) : update_vision(to))
	
	
func update_vision(value):
	vision.get_node("Shape").shape.radius = value

func get_character_sheet() -> CharacterSheet:
	return character_sheet

func refreshAnimation():
	var animationName = active_animation.name
	var speed_scale = active_animation.scale
	var start_time= active_animation.start
	var end_time= active_animation.end
	
	if !animationPlayer.is_playing() or animationPlayer.current_animation != animationName:
		animationPlayer.speed_scale = speed_scale
		
		animationPlayer.play(animationName)
		if start_time != null:
			animationPlayer.seek(start_time)
	else:
		if end_time != null and animationPlayer.current_animation_position >= end_time:
			animationPlayer.stop()
			animationPlayer.play(animationName)			
			animationPlayer.seek(start_time)

func get_vision() -> Area3D :
	return vision
	
func _physics_process(delta):
	if  Engine.is_editor_hint():			
		return
	
	if dead:
		velocity.y -= 10 * delta 	
	else:
		refreshAnimation()	
		
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	move_and_slide()


func get_pivot() -> Node3D :	
	return pivot
	
func move(move_speed : float, delta : float, direction : Vector3):
	move_speed = move_speed * _SPEED
	velocity = direction * move_speed	
	
	if not is_on_floor():
		velocity.y -= gravity * delta
	move_and_slide()
	

func _check_warning_search(node_check, node_name, nodes, message, warnings):
	for child in nodes:
		if node_check.call(child): 
			if node_name == null or child.name == node_name:
				return
	
	warnings.append(message)

func _check_pivot_warnings(warnings):
	var pivot = null
	for child in get_children():
		if child is Node3D:
			if child.name != "Pivot":
				continue
			pivot = child
	
	if pivot == null:
		warnings.append("This character has no Pivot. Consider adding a Node3D named 'Pivot' as a child and a Model inside")
		return
	
	for child in pivot.get_children():
		if child.name == "Model":
			return
	warnings.append("This character need a Model inside the Pivot Node3D node.")
	
func _get_configuration_warnings() -> PackedStringArray:
	var warnings:PackedStringArray = []	
	_check_warning_search(func(x): return x is Area3D, "Vision", get_children(), "This character has no Vision. Consider adding an Area3D named 'Vision' as a child.", warnings)
	_check_warning_search(func(x): return x is CharacterSheet, null, get_children(), "This character has no CharacterSheet. Consider adding an CharacterSheet as a child.", warnings)
	_check_pivot_warnings(warnings)
	_check_warning_search(func(x): return x is HealthBar3D, null, get_children(), "This character has no HealthBar3D. Consider adding an HealthBar3D as a child.", warnings)
	
	
	return warnings
