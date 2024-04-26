extends Node
class_name Behavior

var object : MobEngine

func on_attach(object_to_connect: MobEngine):
	object = object_to_connect

func check_execution(_target, _delta):
	pass

func start_execution(_target):
	pass
	
func run_execution(_delta):
	pass
	
func finish_execution():
	pass

func on_detach():
	pass
