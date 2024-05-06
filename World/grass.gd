extends Node2D

const GrassEffect = preload("res://Effects/grass_effect.tscn")

func create_grass_effect():
	var grassEffect = GrassEffect.instantiate()
	get_parent().add_child(grassEffect)
	grassEffect.position = position


func _on_hurtbox_area_entered(area):
	create_grass_effect()
	queue_free()
