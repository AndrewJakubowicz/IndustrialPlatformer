extends Node2D

var mute = true

onready var hydrolics = [
	$Hydrolic1,
	$Hydrolic2
]

func play_hydrolic():
	if mute:
		return
	var sound = hydrolics[floor(rand_range(0, hydrolics.size()))]
	sound.play()


func _on_VisibilityNotifier2D_screen_entered():
#	mute = false
	pass


func _on_VisibilityNotifier2D_screen_exited():
#	mute = true
	pass


func _on_VisibilityNotifier2D_viewport_entered(viewport):
	mute = false


func _on_VisibilityNotifier2D_viewport_exited(viewport):
	mute = true
