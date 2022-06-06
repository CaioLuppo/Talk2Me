extends KinematicBody2D

func _process(delta):
	if Input.is_action_pressed("ui_down"):
		walking()
	else:
		idle()

func walking():
	var timer = Timer.new()
	timer.time_left = 0.2
	timer.start()
	yield(timer, "timeout")
	position.y += 2
	$sprite.play('down')

func idle():
	$sprite.play('idle')
