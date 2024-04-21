@tool
extends CharacterBody3D

class_name MobBase

@onready var vision : Area3D = get_node("Vision")
@onready var pivot : Node3D = get_node("Pivot")
@onready var animationPlayer = pivot.get_node("Model").get_node("AnimationPlayer")
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var active_animation = { "name": "Idle", "scale": 1, "start":null, "end":null}
@onready var character_sheet = $CharacterSheet
@onready var healthbar = $HealthBar3D


func _ready():
	var max_health = character_sheet.get_value("max_health")
	character_sheet.set_value("health", max_health)
	character_sheet.connect_signal_for_property("health", _on_health_change)
	character_sheet.set_value("name", self.name)
	healthbar.update_max(max_health)
	healthbar.update_healthbar(max_health)
	
func _on_health_change(from, to):
	healthbar.update_healthbar(to)
	print(self.name + ": Mob heath from " + str(from) + " to " + str(to))	


func setAnimation(animationName, speed_scale = 1, start_time=null, end_time=null):
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

func get_pivot() -> Node3D :	
	return pivot
	
func _physics_process(delta):
	if  Engine.is_editor_hint():			
		return
		
	setAnimation(active_animation.name, active_animation.scale, active_animation.start, active_animation.end )	
		
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	move_and_slide()
	
func _check_warning_search(node_check, node_name, message, warnings):
	for child in get_children():		
		if node_check.call(child): 
			if node_name == null or child.name == node_name:
				return
	
	warnings.append(message)
	

func _get_configuration_warnings() -> PackedStringArray:
	var warnings:PackedStringArray = []
	_check_warning_search(func(x): return x is MobEngine, null, "This mob has no Engine. Consider adding a MobEngine as a child.", warnings)
	_check_warning_search(func(x): return x is Area3D, "Vision", "This mob has no Vision. Consider adding an Area3D named 'Vision' as a child.", warnings)
	_check_warning_search(func(x): return x is CharacterSheet, null, "This mob has no CharacterSheet. Consider adding an CharacterSheet as a child.", warnings)
	
	return warnings
