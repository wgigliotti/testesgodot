extends CharacterBody3D

# How fast the player moves in meters per second.
@export var speed = 14
# The downward acceleration when in the air, in meters per second squared.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

@onready var animationPlayer = $Pivot/Barbarian.get_node("AnimationPlayer")
@onready var character_sheet = $CharacterSheet
@onready var signature_area = $Pivot/SignatureArea
@onready var healthbar = $HealthBar3D
@onready var stateChart = $StateChart
@onready var skills_node = $Skill

@export var signature_key : String = "ui_jump"

var target_velocity = Vector3.ZERO
var last_look = Vector3(1,0,0)

func get_character_sheet():
	return character_sheet

func get_signature_area():
	return signature_area
	
var active_animation = { "name": "Idle", "scale": 1, "start":null, "end":null}

var state_time
var direction = Vector3.ZERO

func _ready():	
	var max_health = character_sheet.get_value("max_health")
	character_sheet.set_value("health", max_health)
	healthbar.update_max(max_health)
	healthbar.update_healthbar(max_health)
	
	character_sheet.connect_signal_for_property("health", _on_health_change)
	healthbar.update_max(max_health)
	healthbar.update_healthbar(max_health)
	
	healthbar.fx_show_value()
	
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



func getPivot():
	return $Pivot
	
func look(to : Vector3):
	last_look = to
	
func move(move_speed, delta):
	move_speed = move_speed * speed
	target_velocity = direction * move_speed
	velocity = target_velocity
	
	if not is_on_floor():
		velocity.y -= gravity * delta
	move_and_slide()
	
func _physics_process(_delta):	
	update_direction()
	setAnimation(active_animation.name, active_animation.scale, active_animation.start, active_animation.end )	

	if Input.is_action_just_pressed("ui_jump"):
		stateChart.send_event("signature")		
	
	


func update_direction():
	var newdirection = Vector3.ZERO

	# We check for each move input and update the direction accordingly.
	if Input.is_action_pressed("ui_right"):
		newdirection.x += Input.get_action_strength("ui_right")
	if Input.is_action_pressed("ui_left"):
		newdirection.x -= Input.get_action_strength("ui_left")
	if Input.is_action_pressed("ui_down"):
		newdirection.z += Input.get_action_strength("ui_down")
	if Input.is_action_pressed("ui_up"):
		newdirection.z -= Input.get_action_strength("ui_up")
	
	if newdirection != Vector3.ZERO:
		if	newdirection.length_squared() > 1:
			newdirection = newdirection.normalized()
	direction = newdirection
	
func get_direction():
	return direction
	
func _on_idle_state_entered():
	active_animation = { "name": "Idle", "scale": 1, "start":null, "end":null}		

func _on_running_state_entered():
	active_animation = { "name": "Running_A", "scale": 1, "start":null, "end":null}

func _on_signature_state_entered():	
	$SignatureSkill.enter_skill(self)

func _on_running_state_physics_processing(delta):
	if direction == Vector3.ZERO:		
		stateChart.send_event("stop")
	
	getPivot().basis = Basis.looking_at(direction)
	move(1, delta)

func _on_signature_state_physics_processing(delta):
	var response = $SignatureSkill._process_skill(delta, Input.is_action_pressed(signature_key))
	if response:
		stateChart.send_event("idle")


func _on_idle_state_physics_processing(_delta):	
	if direction != Vector3.ZERO:
		stateChart.send_event("run")
		getPivot().basis = Basis.looking_at(direction)
	


func _on_signature_state_exited():
	for trash in skills_node.get_children():
		trash.queue_free()
