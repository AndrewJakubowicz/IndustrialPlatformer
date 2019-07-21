tool
extends CanvasItem

func _ready():
	if Engine.editor_hint:
		visible = true
	else:
		visible = false
