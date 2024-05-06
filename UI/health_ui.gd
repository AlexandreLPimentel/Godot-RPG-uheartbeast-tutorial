extends Control

@onready var heartUIFull = $HeartUIFull
@onready var heartUIEmpty = $HeartUIEmpty
var original_hearts_size
var original_max_hearts_size

var max_hearts = 4:
	get:
		return max_hearts
	set(value):
		max_hearts = max(value, 1)
		if heartUIEmpty != null:
			heartUIEmpty.size = Vector2(original_max_hearts_size.x * max_hearts, original_max_hearts_size.y)
			if hearts == 0:
				heartUIEmpty.visible = false

var hearts = max_hearts:
	get:
		return hearts
	set(value):
		hearts = clamp(value, 0, max_hearts)
		if heartUIFull != null:
			heartUIFull.size = Vector2(original_hearts_size.x * hearts, original_hearts_size.y)
			if hearts == 0:
				heartUIFull.visible = false

func set_hearts(value):
	self.hearts = value
	
func set_max_hearts(value):
	self.max_hearts = value
			
func _ready():
	self.original_hearts_size = heartUIFull.size
	self.original_max_hearts_size = heartUIEmpty.size
	self.max_hearts = PlayerStats.max_health
	self.hearts = PlayerStats.health
	PlayerStats.connect("health_changed", Callable(self, "set_hearts"))
	PlayerStats.connect("max_health_changed", Callable(self, "set_max_hearts"))
