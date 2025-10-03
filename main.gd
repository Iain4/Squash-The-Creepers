extends Node

@export var mob_scene: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	clear_mobs()
	$Hud.set_max_health($Player.health)
	$Hud.update_health($Player.health)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_mob_timer_timeout() -> void:
	var mob = mob_scene.instantiate()
	
	var mob_spawn_location = get_node("SpawnPath/SpawnLocation")
	mob_spawn_location.progress_ratio = randf()
	
	var player_position = $Player.position
	mob.initialize(mob_spawn_location.position, player_position)
	
	add_child(mob)
	

func clear_mobs():
	var mobs = get_tree().get_nodes_in_group("mob")
	if mobs != null:
		for mob in mobs:
			mob.queue_free()


func _on_player_hit() -> void:
	clear_mobs()
	$Hud.update_health($Player.health)


func _on_player_dead() -> void:
	$MobTimer.stop()
	# needes to also tell the hud


func _on_player_squish() -> void:
	$Hud.update_score($Player.score)
