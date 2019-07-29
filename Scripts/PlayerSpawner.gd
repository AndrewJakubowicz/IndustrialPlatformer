extends Position2D

onready var player = load("res://Prefabs/Player.tscn")
onready var camera = load("res://Prefabs/CustomCamera2D.tscn")

func spawn_player ():
	var p = player.instance()
	p.position = position
	p.connect("reload_checkpoint", self, "spawn_player")
	p.friction = 20
	get_tree().get_root().add_child(p)
	p.add_child(camera.instance())

