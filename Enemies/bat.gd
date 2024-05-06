extends CharacterBody2D

const EnemyDeathEffect = preload("res://Effects/enemy_death_effect.tscn")

@onready var stats = $Stats
@onready var player_detection_zone = $PlayerDetectionZone
@onready var sprite = $AnimatedSprite
@onready var hurtbox = $Hurtbox
@onready var softCollison = $SoftCollision
@onready var wanderController = $WanderController
@onready var animationPlayer = $AnimationPlayer

enum {
	IDLE,
	WANDER,
	CHASE
}

@export var ACCELERATION = 300
@export var MAX_SPEED = 30
@export var FRICTION = 400

var state = IDLE

func _physics_process(delta):	
	match state:
		IDLE:
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
			seek_player()
			if wanderController.get_time_left() == 0:
				state = pick_random_state([IDLE, WANDER])
				wanderController.start_wander_timer(randf_range(1, 3))
		WANDER:
			seek_player()
			if wanderController.get_time_left() == 0:
				state = pick_random_state([IDLE, WANDER])
				wanderController.start_wander_timer(randf_range(1, 3))
				
			var direction = global_position.direction_to(wanderController.target_position)
			sprite.flip_h = direction.x < 0
			velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
				
			if global_position.distance_to(wanderController.target_position) <= 1:
				state = pick_random_state([IDLE, WANDER])
				wanderController.start_wander_timer(randf_range(1, 3))
		CHASE:
			var player = player_detection_zone.player
			if player != null:
				var direction = global_position.direction_to(player.global_position)
				sprite.flip_h = direction.x < 0
				velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
			else:
				state = IDLE
				
	if softCollison.is_colliding():
		velocity += softCollison.get_push_vector() * delta * 400
	move_and_slide()

func seek_player():
	if player_detection_zone.can_see_player():
		state = CHASE
		
func pick_random_state(state_list: Array):
	state_list.shuffle()
	return state_list.pop_front()

func _on_hurtbox_area_entered(area):
	stats.health -= area.damage
	var direction = (position - area.owner.position).normalized()
	velocity = direction * 180
	hurtbox.create_hit_effect()
	hurtbox.start_invincibility(0.4)

func _on_stats_no_health():
	var deathEffect = EnemyDeathEffect.instantiate()
	get_parent().add_child(deathEffect)
	deathEffect.position = position
	queue_free()


func _on_hurtbox_invincibility_started():
	animationPlayer.play("start")


func _on_hurtbox_invincibility_ended():
	animationPlayer.play("stop")
