extends CharacterBody3D


const SPEED = 20.0

@onready var visao = $Visao

@onready var animationPlayer = $Pivot/Model.get_node("AnimationPlayer")

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

var to_chase
var objective : Vector3
var forget_distance = 90*90

var life = 2

func _ready():
	life = 1 + randf_range(0,2)

func _physics_process(delta):
	# Add the gravity.
	
	if life < -15:
		return
	
	life -= delta
	
	var deaths = ["Death_A", "Death_B", "Death_C_Skeletons"]
	if life <= 0:		
		$CollisionShape3D.disabled = true
		animationPlayer.play(deaths[randi_range(0,2)])
		life = -20
		return
	
	velocity = Vector3.ZERO
	
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	if to_chase != null:
		var dir : Vector3 = to_chase.global_position - self.global_position		
		if dir.length_squared() > forget_distance:
			forget()
		else:
			dir = dir.normalized()
			$Pivot.basis = Basis.looking_at(dir)
			velocity = dir * SPEED
	
	if velocity != Vector3.ZERO:
		#$Pivot.basis = Basis.looking_at(velocity)
		if !animationPlayer.is_playing() or animationPlayer.current_animation != "Walking_A":
			animationPlayer.play("Walking_A")
		
	move_and_slide()


func _on_area_3d_body_entered(body):	
	if to_chase == null: 
		to_chase = body


func forget():	
	to_chase = get_next_target()
	
		
func get_next_target():
	var next = null
	var dist = 0
	for body in visao.get_overlapping_bodies():
		var ndist = body.global_position.distance_squared_to(self.global_position)
		if next == null or ndist < dist:
			next = body
			dist = ndist
		
	return next
		
		
		
