extends Node3D


# Called when the node enters the scene tree for the first time.
var target

var current_time
var velocity
var SPEED = 90
var time_limit = 5000 / SPEED
var dead = null

func _ready():
	current_time = Time.get_ticks_msec()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not target:
		queue_free()
		return
	
	if dead != null:
		if dead < Time.get_ticks_msec():
			queue_free()
		return
	
	var prop = (Time.get_ticks_msec() - current_time) / time_limit
	prop = prop if prop < 1 else 1
	var direction : Vector3 = target.global_position - global_position
	var size = direction.length()
	if size < 0.3:
		$particles.emitting = false
		dead = Time.get_ticks_msec() + 5000
		return
	
	direction = direction / size
	var vel : Vector3 = velocity * (1-prop) + direction * prop
	velocity = vel.normalized() * SPEED
	
	global_position = global_position + velocity * delta
	basis = Basis.looking_at(velocity)
	
	
	
	
	
