extends Node3D
class_name BaseTargetProjectile

# Called when the node enters the scene tree for the first time.
var target : CharacterBase
var actor : CharacterBase
var attack : CharacterAttack

@export var death_delay : int = 0
@export var PROJECTILE_SPEED : float = 60

var current_time
var velocity
var time_limit = 5000 / PROJECTILE_SPEED
var dead = false

func _ready():
	current_time = Time.get_ticks_msec()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not target:
		queue_free()
		return
	
	if dead:
		if current_time < Time.get_ticks_msec():
			queue_free()
		return
	
	
	var prop = (Time.get_ticks_msec() - current_time) / time_limit
	prop = prop if prop < 1 else 1
	var direction : Vector3 = target.global_position - global_position
	var size = direction.length()
	
	if size < 0.3:
		hit_target()
		queue_free()		
		return
	
	direction = direction / size
	var vel : Vector3 = velocity * (1-prop) + direction * prop
	velocity = vel.normalized() * PROJECTILE_SPEED
	
	global_position = global_position + velocity * delta
	basis = Basis.looking_at(velocity)
	
func hit_target():
	RulesBook.apply_attack(actor.get_character_sheet(), target.get_character_sheet(), attack )
