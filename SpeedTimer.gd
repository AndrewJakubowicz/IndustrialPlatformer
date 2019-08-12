extends Node2D

onready var timer = $SpeedrunTimer
onready var label1 = $SpeedText
onready var label2 = $SpeedText2


var hours = 0
var minutes = 0
var seconds = 0
var milliseconds = 0

var started = false

func _ready():
	timer.connect("timeout", self, "handle_second")

func _process(delta):
	if not started:
		return
	milliseconds += delta * 1000
	if milliseconds > 1000:
		seconds += milliseconds / 1000
		milliseconds = int(milliseconds) % 1000
	if seconds > 59:
		seconds = 0
		minutes += 1
	if minutes > 59:
		minutes = 0
		hours += 1

func handle_second():
	label1.text = "%2d:%2d:%2d:%3d" % [hours, minutes, seconds, milliseconds]
	label2.text = "%2d:%2d:%2d:%3d" % [hours, minutes, seconds, milliseconds]

func start():
	print_debug("start timer")
	started = true

func _on_Area2D_area_entered(area):
	start() # Replace with function body.
