extends Node

func _ready():
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), -72)
	

func _on_start_music_timer_timeout():
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), 0)
