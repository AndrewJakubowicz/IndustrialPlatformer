extends Timer


func _on_Area2D__Start_timer_area_entered(area):
	start()

func _on_Area2D__End_timer_area_entered(area):
	stop()
