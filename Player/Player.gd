extends CharacterBody2D

const PlayerHurtSound = preload("res://Player/player_hurt_sound.tscn")

@export var max_speed = 80
@export var acceleration = 400
@export var friction = 400 * 5

@onready var animationTree = $AnimationTree
@onready var animationState = animationTree.get("parameters/playback")
@onready var hurtbox = $Hurtbox
@onready var blinkAnimationPlayer = $BlinkAnimationPlayer

enum {
	MOVE,
	ROLL,
	ATTACK
}

@onready var roll_vector = animationTree.get("parameters/Roll/blend_position")
var stats = PlayerStats

var state = MOVE

func _ready():
	stats.no_health.connect(queue_free)
	animationTree.active = true

func _physics_process(delta):
	match state:
		MOVE:
			move_state(delta)
		ROLL:
			roll_state(delta)
		ATTACK:
			attack_state(delta)
	
func move_state(delta):
	var input = Vector2.ZERO
	input.x = Input.get_axis("ui_left", "ui_right")
	input.y = Input.get_axis("ui_up", "ui_down")
	
	input = input.normalized()
	
	if input != Vector2.ZERO:
		roll_vector = input
		animationTree.set("parameters/Idle/blend_position", input)
		animationTree.set("parameters/Run/blend_position", input)
		animationTree.set("parameters/Attack/blend_position", input)
		animationTree.set("parameters/Roll/blend_position", input)
		animationState.travel("Run")
		velocity = velocity.move_toward(input * max_speed, acceleration * delta)
	else:
		animationState.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
	
	move_and_slide()
	
	if Input.is_action_just_pressed("roll"):
		state = ROLL
		
	if Input.is_action_just_pressed("attack"):
		state = ATTACK
	
func attack_state(delta):
	velocity = Vector2.ZERO
	animationState.travel("Attack")
	
func attack_ended():
	state = MOVE
	
func roll_state(delta):
	velocity = roll_vector * max_speed * 1.5
	animationState.travel("Roll")
	move_and_slide()
	
func roll_ended():
	velocity = roll_vector * max_speed / 2
	state = MOVE

func _on_hurtbox_area_entered(area):
	stats.health -= area.damage
	hurtbox.start_invincibility(0.6)
	hurtbox.create_hit_effect()
	var playerHurtSound = PlayerHurtSound.instantiate()
	get_tree().current_scene.add_child(playerHurtSound)
	
func _on_hurtbox_invincibility_started():
	blinkAnimationPlayer.play("start")

func _on_hurtbox_invincibility_ended():
	blinkAnimationPlayer.play("stop")
