extends Node
class_name CharacterSheet

var sheet : Dictionary = {}
@export var sheet_data : JSON
var signals : Dictionary = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	sheet = sheet_data.data.duplicate(true)
	
func connect_signal_for_property(property_name, callable : Callable):
	if !signals.has(property_name):		
		var new_signal_for = Signal(self, "_signal_" + property_name)
		add_user_signal(new_signal_for.get_name())
		signals[property_name] = new_signal_for
	
	var signal_to_connect = signals[property_name]
	signal_to_connect.connect(callable)
	
	return signals[property_name]
	
func set_value(property_name, value):
	if ! sheet.has(property_name):
		sheet[property_name] = null
	
	if sheet[property_name] != value:
		var old_value = sheet[property_name]
		sheet[property_name] = value
		
		if signals.has(property_name):			
			signals[property_name].emit(old_value, value)
		
func get_value(property_name):
	if ! sheet.has(property_name):
		return null
	
	return sheet[property_name]
		
func apply_hit(_baddie : CharacterSheet, attack : CharacterAttack):
	var health = get_value("health") - attack.damage
	set_value("health", health)

