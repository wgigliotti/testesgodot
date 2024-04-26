extends Area3D


func get_buff() -> CharacterBuff:
	var buff = CharacterBuff.new()
	buff.buff_name = "LIFE STEAL"
	buff.on_hit = func(attacker : CharacterSheet, _target : CharacterSheet, _attack : CharacterAttack, _efficiency : float = 1): 
		RulesBook.heal_character(attacker, 5)
	return buff
