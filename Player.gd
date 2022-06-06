extends KinematicBody2D

func _process(delta):
	if Input.is_action_pressed("ui_down"):
		walking()
	else:
		idle()

func walking():
	position.y += 2
	$sprite.play('down')

func idle():
	$sprite.play('idle')
