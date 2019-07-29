extends Position2D

onready var player = load("res://Prefabs/Player.tscn")
onready var camera = load("res://Prefabs/CustomCamera2D.tscn")

var curr_player = null

func spawn_player ():
	var p = player.instance()
	p.position = position
	p.connect("reload_checkpoint", self, "spawn_player")
	p.friction = 20
	get_tree().get_root().add_child(p)
	p.add_child(camera.instance())
	curr_player = p



func _on_ScoreBall_collected_checkpoint(global_position):
	position = global_position