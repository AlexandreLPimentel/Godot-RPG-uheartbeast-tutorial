extends Node

@export var max_health: int = 1:
	get:
		return max_health
	set(value):
		max_health = max(value, 1)
		clamp_health(value)
		emit_signal("max_health_changed", max_health)
		
@onready var health = max_health:
	get:
		return health
	set(value):
		health = value
		emit_signal("health_changed", health)
		if health <= 0:
			emit_signal("no_health")

func clamp_health(value):
	if health != null:
		self.health = min(health, max_health)

signal no_health
signal health_changed(value)
signal max_health_changed(value)
