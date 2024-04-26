extends Area3D
class_name ThornBuff

static var attack : CharacterAttack

static func apply_thorn(attacker : CharacterSheet, target : CharacterSheet, _attack : CharacterAttack, _efficiency : float = 1):
	print("Entrou")
	RulesBook.apply_attack(target, attacker, attack, 1.1)
	RulesBook.heal_character(target, 1)

func _ready():
	if attack == null:
		attack = $CharacterAttack.duplicate()
		
func get_buff() -> CharacterBuff:
	var buff = CharacterBuff.new()
	buff.buff_name = "Thorn"
	buff.on_hitted = ThornBuff.apply_thorn
	return buff
