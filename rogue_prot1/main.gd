extends Node


@export var mob : PackedScene

var nextMob
# Called when the node enters the scene tree for the first time.
func _ready():
	nextMob = Time.get_ticks_msec() + randi_range(0, 500)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if nextMob < Time.get_ticks_msec():
		createNewMob()
		nextMob = Time.get_ticks_msec() + randi_range(0, 1000)
		
func createNewMob():
	var newMob = mob.instantiate()
	add_child(newMob)
	newMob.global_position = Vector3(0,0,0)
	
