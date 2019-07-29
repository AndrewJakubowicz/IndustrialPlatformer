extends Position2D

onready var player = preload("res://Prefabs/Player.tscn")
onready var camera = preload("res://Prefabs/CustomCamera2D.tscn")

var curr_player = null

func _ready():
	yield(get_tree().create_timer(1.0), "timeout")
	spawn_player()

func spawn_player ():
	print('spawned')
	var p = player.instance()
	p.position = position
	p.connect("reload_checkpoint", self, "spawn_player")
	p.friction = 20
	var c = camera.instance()
	c.make_current()
	p.add_child(c)
	get_parent().add_child(p)
	curr_player = p

func _on_ScoreBall_collected_checkpoint(global_position):
	position = global_position
	curr_player.reset_state()