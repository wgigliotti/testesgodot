extends CharacterBuff

var char_area : float
var char_area_square : float

@onready var shape : CollisionShape3D = $Area3D/CollisionShape3D
@onready var area : Area3D = $Area3D
@onready var fire = $Area3D/Fire2

@export var radius_base : float  = 1
@export var particles_base : int = 20
@export var ticks_millis : int = 250

var next_tick 


# Called when the node enters the scene tree for the first time.
func _ready():
	char_area = character.get_value(constants.CharacterAttributes.AREA_CHANGE)
	char_area_square = char_area * char_area
	
	shape.shape.radius = radius_base * char_area
	
	
	fire.amount = particles_base * char_area_square * 2
	fire.process_material.emission_ring_inner_radius = char_area * radius_base
	
	next_tick = Time.get_ticks_msec() + ticks_millis
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	area.global_position = character.get_parent().global_position
	var current_time = Time.get_ticks_msec()	
	
	if current_time > next_tick:		
		apply_damage_tick()
		next_tick = next_tick + ticks_millis
		
func apply_damage_tick():
	for body in area.get_overlapping_bodies():
		if body.is_in_group("mobs"):
			RulesBook.apply_attack(character, body.get_character_sheet(), $CharacterAttack, 1)
