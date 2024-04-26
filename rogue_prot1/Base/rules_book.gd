extends Node

func multiplicative(value : float, rate : float, increment : bool = true):
	return value * (1 + rate) if increment else value / (1 + rate)
	
func inverse_multiplicative(value : float, rate : float, increment : bool = true):
	return (1 - ((1-value)*(1-rate))) if increment else (1 - ((1-value)/(1-rate)))

var incrementAtt : Dictionary = {
	constants.CharacterAttributes.MAGIC_RESISTANCE : inverse_multiplicative,
	constants.CharacterAttributes.PHYSICAL_RESISTANCE : inverse_multiplicative
}

func get_increment_for(attribute : constants.CharacterAttributes) -> Callable:
	if incrementAtt.has(attribute):
		return incrementAtt[attribute]
	return multiplicative

func get_default_attribute(attribute : constants.CharacterAttributes):
	if constants.defaultAtt.has(attribute):
		return constants.defaultAtt[attribute]
	return 1
	
func apply_attack(attacker : CharacterSheet, target : CharacterSheet, attack : CharacterAttack, efficiency : float = 1):
	var health = target.get_value(constants.CharacterAttributes.HEALTH_CURRENT) - attack.damage * efficiency
	target.set_value(constants.CharacterAttributes.HEALTH_CURRENT, health)
