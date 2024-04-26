extends Node

func multiplicative(value : float, rate : float, increment : bool = true):
	return value * (1 + rate) if increment else value / (1 + rate)
	
func inverse_multiplicative(value : float, rate : float, increment : bool = true):
	return (1 - ((1-value)*(1-rate))) if increment else (1 - ((1-value)/(1-rate)))
		   
var incrementAtt : Dictionary = {
	constants.CharacterAttributes.MAGIC_RESISTANCE : inverse_multiplicative,
	constants.CharacterAttributes.PHYSICAL_RESISTANCE : inverse_multiplicative,
	constants.CharacterAttributes.MISS_BASE_CHANCE:inverse_multiplicative,
	constants.CharacterAttributes.EVASION_BASE_CHANCE:inverse_multiplicative,
	constants.CharacterAttributes.CRITICAL_DAMAGE_BASE_CHANCE:inverse_multiplicative,
}

func get_increment_for(attribute : constants.CharacterAttributes) -> Callable:
	if incrementAtt.has(attribute):
		return incrementAtt[attribute]
	return multiplicative

func get_default_attribute(attribute : constants.CharacterAttributes):
	if constants.defaultAtt.has(attribute):
		return constants.defaultAtt[attribute]
	return 1

func heal_character(character: CharacterSheet, amount : float):
	var max_life = character.get_value(constants.CharacterAttributes.HEALTH_MAX)
	var health = character.get_value(constants.CharacterAttributes.HEALTH_CURRENT) + amount
	health = health if health <= max_life else max_life
	character.set_value(constants.CharacterAttributes.HEALTH_CURRENT, health)
	
	
func apply_attack(attacker : CharacterSheet, target : CharacterSheet, attack : CharacterAttack, efficiency : float = 1):
	var evaded = roll_hit_evasion_chances(attacker, target, attack)
	if evaded:
		return
	
	var damage = compute_damage(attacker, target, attack, efficiency)	
	
	var health = target.get_value(constants.CharacterAttributes.HEALTH_CURRENT) - damage
	target.set_value(constants.CharacterAttributes.HEALTH_CURRENT, health)
	for buff in attacker.on_hit_buffs:		
		print(buff.buff_name + " " + str(buff.on_hit))	
		buff.on_hit.call(attacker, target, attack, efficiency)
	for buff in target.on_hitted_buffs:
		print(buff.buff_name + " " + str(buff.on_hitted))		
		buff.on_hitted.call(attacker, target, attack, efficiency)

func roll_hit_evasion_chances(attacker : CharacterSheet, target : CharacterSheet, attack : CharacterAttack):
	var target_evasion = target.get_value(constants.CharacterAttributes.EVASION_BASE_CHANCE)
	var attacker_missing = attacker.get_value(constants.CharacterAttributes.MISS_BASE_CHANCE)
	var total_miss_chance = get_increment_for(constants.CharacterAttributes.MISS_BASE_CHANCE).call(target_evasion, attacker_missing)	
	
	return true if randf() <= total_miss_chance else false
	
func compute_damage(attacker : CharacterSheet, target : CharacterSheet, attack : CharacterAttack, efficiency):	
	var critical_check = roll_hit_critical_chances(attacker, target, attack)
	if critical_check:
		efficiency = efficiency * attack.critical_damage + attacker.get_value(constants.CharacterAttributes.CRITICAL_DAMAGE_CHANGE)
		
	var physical_damage = efficiency * attack.physical_damage * attacker.get_value(constants.CharacterAttributes.PHYSICAL_DAMANGE_CHANGE)
	physical_damage = physical_damage * (1-target.get_value(constants.CharacterAttributes.PHYSICAL_RESISTANCE))
	
	var magical_damage = efficiency * attack.magic_damage * attacker.get_value(constants.CharacterAttributes.MAGIC_DAMAGE_CHANGE)
	magical_damage = magical_damage * (1-target.get_value(constants.CharacterAttributes.MAGIC_RESISTANCE))
	
	return magical_damage + physical_damage
	
func roll_hit_critical_chances(attacker : CharacterSheet, target : CharacterSheet, attack : CharacterAttack):
	var attack_crit_chance = attack.critical_chance
	var char_crit_chance = attacker.get_value(constants.CharacterAttributes.CRITICAL_DAMAGE_BASE_CHANCE)
	var total_crit_chance = get_increment_for(constants.CharacterAttributes.CRITICAL_DAMAGE_BASE_CHANCE).call(attack_crit_chance, char_crit_chance)
	return true if randf() <= total_crit_chance else false
