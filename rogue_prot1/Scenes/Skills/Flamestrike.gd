extends Node3D


@onready var fire = $Fire
@onready var smoke = $Smoke
@onready var fire2 = $Fire2
@onready var shape = $Area/Shape

@export var particles_base : int = 20
@export var radius_base : float  = 1 

var char_area : float
var char_area_square : float
var actor : CharacterBase
var attack : CharacterAttack
var active
# Called when the node enters the scene tree for the first time.
func _ready():

	
	char_area = actor.get_character_sheet().get_value(constants.CharacterAttributes.AREA_CHANGE)
	char_area_square = char_area * char_area
	
	shape.shape.radius = radius_base * char_area * 2
	
	fire.amount = particles_base * char_area_square
	fire.process_material.emission_ring_inner_radius = char_area * radius_base
	
	fire2.amount = particles_base * char_area_square * 2
	fire2.process_material.emission_ring_inner_radius = char_area * radius_base * 2
	
	
	active = Time.get_ticks_msec() + 200
	fire.emitting = true
	smoke.emitting = true
	fire2.emitting = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Time.get_ticks_msec() > active:
		$Area.monitoring = false
	
	if not $Fire.emitting:	
		queue_free()


func _on_area_body_entered(body):
	if ! body.is_in_group("mobs"):
		return 
	var dist_square = global_position.distance_squared_to(body.global_position)
	var efficiency = 0.5 if dist_square > char_area_square else 1
	RulesBook.apply_attack(actor.get_character_sheet(), body.get_character_sheet(), attack, efficiency)
	
	
