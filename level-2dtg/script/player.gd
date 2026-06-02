extends CharacterBody2D


const SPEED = 200.0
const JUMP_VELOCITY = -400.0
var has_ball = false
var held_ball = null
var pickup_cooldown = 0.0

func _physics_process(delta: float) -> void:
	
	#Get the input direction and handle the movement/deceleration.
	
	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	var direction_y := Input.get_axis("up", "down")
	if direction_y:
		velocity.y = direction_y * SPEED
	else:
		velocity.y = move_toward(velocity.y, 0, SPEED)

	move_and_slide()
	

		
func pickup_ball(ball):
	#if theres still a cooldown dont pick the ball up
	if pickup_cooldown > 0:
		return
	#if i already have a ball then i cant pick another to avoid glitches
	if has_ball:
		return
	
	has_ball = true
	held_ball = ball
	#hide the ball
	ball.visible = false
	#ball cant be picked up again
	ball.get_node("CollisionShape2D").disabled = true
	
	$ballsprite.visible = true
	$ballsprite.play("dribble")

func drop_ball():
	 #if the player doesn't have the ball, stop the function
	if not has_ball:
		return
	 #the player no longer has the ball
	has_ball = false

	#show ground ball again
	held_ball.visible = true
	#turn the ball's collision back on so it can be picked up later
	held_ball.get_node("CollisionShape2D").disabled = false

	#move ground ball to player's position
	held_ball.global_position = global_position

	#hide hand ball (sprite in player hand)
	$ballsprite.visible = false

	#forget which ball we were holding
	held_ball = null
	#delay so i dont insta pick it up
	pickup_cooldown = 0.2
	
	
func _process(delta):
	#cooldown for picking up ball so it dosent insta pick back up
	if pickup_cooldown > 0:
		pickup_cooldown -= delta
	#Dropping the ball
	if Input.is_action_just_pressed("drop"):
		drop_ball()
