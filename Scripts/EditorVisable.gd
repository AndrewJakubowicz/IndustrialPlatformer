tool
extends Light2D

func _ready():
	if Engine.editor_hint:
		enabled = false
	else:
		enabled = true
