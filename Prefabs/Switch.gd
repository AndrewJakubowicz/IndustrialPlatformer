extends Node2D

onready var sprite = $Sprite

export (bool) var on = false
export (bool) var one_switch = false

signal toggled_switch

var switched = false

func _ready():
	update()

func toggle():
	print("toggled a switch")
	if one_switch:
		if switched:
			return
		switched = true
	on = not on
	emit_signal("toggled_switch")
	update()

func update():
	if on:
		sprite.frame = 0
	else:
		sprite.frame = 4

# If anything collides with this it is toggled
func _on_Area2D_area_entered(area):
	toggle()
