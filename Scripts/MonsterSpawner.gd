extends Position2D

enum MONSTER {
	SLIME
}

export (MONSTER) var spawn_type = MONSTER.SLIME
export (int) var max_health = 1

var monster_node = null

# Called when the node enters the scene tree for the first time.
func _ready():
	match spawn_type:
		MONSTER.SLIME:
			monster_node = load("res://Prefabs/SlimeEnemy.tscn")

# Trigger this to spawn a monster. Connect this method to a signal :)
func spawn_monster():
	var monster = monster_node.instance()
	monster.position = Vector2()
	monster.MAX_HEALTH = max_health
	add_child(monster)