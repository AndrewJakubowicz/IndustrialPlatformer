extends Sprite

var flash_time = 0;
var on = false;

onready var mat_override = get_material().duplicate()

func _ready():
	set_material(mat_override)
	set_physics_process(false)

# Controls the shaders on the player.
func trigger_flash():
	on = true
	material.set_shader_param("on", on)
	
func disable_flash():
	on = false
	flash_time = 0
	material.set_shader_param("on", on)

func _process(delta):
	if on:
		flash_time += delta;
		material.set_shader_param("time_running", flash_time)


func _on_TakeDamageState_got_hit():
	trigger_flash()


func _on_TakeDamageState_recovered_hit():
	disable_flash()
