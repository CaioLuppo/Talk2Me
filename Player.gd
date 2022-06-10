extends KinematicBody2D

var speed = Vector2()

var current_state := 0 # Estado atual
enum {WALK, IDLE, PLAYING} # Estados

var playing = false

func _process(delta):
	match current_state:
		WALK:
			_walk()
			pass
		IDLE:
			_idle()
			pass
		PLAYING:
			_play()
			pass

# Funções de estado
func _walk():
	move()
	_move_and_slide()
	_set_state(_check_walk_state())

func _idle():
	$anim.play('idle')
	speed = Vector2(0,0)
	_set_state(_check_idle_state())

func _play():
	
	pass

# Helpers
func _move_and_slide():
	speed = move_and_slide(speed, Vector2.UP)

func move():
	if Input.is_action_pressed("ui_down"):
		speed.y = 105
		$anim.play('down')
	if Input.is_action_pressed("ui_up"):
		speed.y = -105
		$anim.play('up')

func _set_state(new_state):
	current_state = new_state

# Funções de checagem (O que pode tirar o player de tal estado?)
func _check_idle_state():
	var new_state = current_state
	if playing:
		new_state = PLAYING
	elif (Input.is_action_pressed("ui_up") or Input.is_action_pressed("ui_down")) and !playing:
		new_state = WALK
	return new_state

func _check_walk_state():
	var new_state = current_state
	if playing:
		new_state = PLAYING
	elif (!Input.is_action_pressed("ui_up") && !Input.is_action_pressed("ui_down")) and !playing:
		new_state = IDLE
	return new_state
