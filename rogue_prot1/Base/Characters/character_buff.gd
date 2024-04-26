extends Node
class_name CharacterBuff

var buff_name : String

var attributes : Dictionary = {}
var on_hit : Callable
var on_hitted : Callable
var character : CharacterSheet
var time
var timer : Timer

	
func on_hit_imp(_attacker : CharacterSheet, _target : CharacterSheet, _attack : CharacterAttack, _efficiency : float = 1):
	pass

func on_hitted_imp(_attacker : CharacterSheet, _target : CharacterSheet, _attack : CharacterAttack, _efficiency : float = 1):
	pass

func attach(character_to : CharacterSheet):
	character = character_to	
	if time != null:
		active_time()
	character.add_child(self)

func release():
	character.remove_buff(self)
	queue_free()	

func active_time():
	timer = Timer.new()
	timer.wait_time = time
	timer.one_shot = true
	timer.connect("timeout", release)
	#timer.timeout.connect(release)
	timer.autostart = true	
	add_child(timer)
