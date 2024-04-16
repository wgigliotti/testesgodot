extends CharacterBody3D

# How fast the player moves in meters per second.
@export var speed = 14
# The downward acceleration when in the air, in meters per second squared.
@export var fall_acceleration = 75

@export var jump_impulse = 20

@export var bounce_impulse = 16

@onready var animationPlayer = $Pivot/Barbarian.get_node("AnimationPlayer")
@onready var fsm = $FiniteStateMachine
@onready var character_sheet = $CharacterSheet
@onready var signature_area = $Pivot/SignatureArea
@onready var healthbar = $HealthBar3D

var target_velocity = Vector3.ZERO
var dashing = false
var dashing_time 
var last_look = Vector3(1,0,0)
signal hit

func get_signature_area():
	return signature_area

func change_hp(from, to):
	print("Changed HP: " + str(from) + " to " + str(to))

func _ready():
	fsm.start_running(self)
	character_sheet.connect_signal_for_property("max_health", change_hp)
	var max_health = character_sheet.get_value("max_health")
	healthbar.update_max(max_health)
	healthbar.update_healthbar(max_health)
	

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
	
	
	
func _physics_process(delta):	
	fsm.run(delta)	
	
	if !is_on_floor():
		target_velocity.y = target_velocity.y - (fall_acceleration * delta)
	velocity = target_velocity
	move_and_slide()

func get_direction():
	var direction = Vector3.ZERO

	# We check for each move input and update the direction accordingly.
	if Input.is_action_pressed("ui_right"):
		direction.x += Input.get_action_strength("ui_right")
	if Input.is_action_pressed("ui_left"):
		direction.x -= Input.get_action_strength("ui_left")
	if Input.is_action_pressed("ui_down"):
		direction.z += Input.get_action_strength("ui_down")
	if Input.is_action_pressed("ui_up"):
		direction.z -= Input.get_action_strength("ui_up")
	
	if direction != Vector3.ZERO:
		if	direction.length_squared() > 1:
			direction = direction.normalized()
	return direction
		# Setting the basis property will affect the rotation of the node.
# And this function at the bottom.
