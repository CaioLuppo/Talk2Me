extends KinematicBody2D

var speed = Vector2()
var instruments = load("res://scripts/instruments.gd").new()

var added = false

var current_state := 0 # Estado atual
enum {WALK, IDLE, PLAY} # Estados

var playing = false

func _ready():
	instruments.name = "notes"
	pass

func _process(delta):
	if Input.is_action_just_pressed("play"):
		playing = true
		current_state = PLAY
	match current_state:
		WALK:
			walk()
			pass
		IDLE:
			idle()
			pass
		PLAY:
			playInstrument()
			pass

# Funções de estado
func walk():
	playing = false
	move()
	_move_and_slide()
	set_state(check_walk_state())

func idle():
	playing = false
	$anim.play('idle')
	speed = Vector2(0,0)
	set_state(check_idle_state())

func playInstrument():

	if added == false:
		added = true
		add_child(instruments)
	
	playing = true
	instruments.play()
	set_state(check_play_state())


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

func set_state(new_state):
	current_state = new_state


# Funções de checagem (O que pode tirar o player de tal estado?)
func check_play_state():
	var new_state = current_state
	if (Input.is_action_pressed("ui_up") or Input.is_action_pressed("ui_down")) and !playing:
		new_state = WALK
	if Input.is_action_just_pressed("exit"):
		instruments.playing = false
		added = false
		remove_child($notes)
		new_state = IDLE
	return new_state

func check_idle_state():
	var new_state = current_state
	if playing:
		new_state = PLAY
	elif Input.is_action_pressed("ui_up") or Input.is_action_pressed("ui_down") and !playing:
		new_state = WALK
	return new_state

func check_walk_state():
	var new_state = current_state
	if playing:
		new_state = PLAY
	elif !Input.is_action_pressed("ui_up") && !Input.is_action_pressed("ui_down") and !playing:
		new_state = IDLE
	return new_state
