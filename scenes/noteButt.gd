extends TouchScreenButton

func _on_button_down():
	Input.action_press(self.name)
	pass # Replace with function body.


func _on_button_up():
	Input.action_release(self.name)
	pass # Replace with function body.


func _on_p_button_down():
	Input.action_press("play")
	pass # Replace with function body.

func _on_vibrato_button_down():
	Input.action_press("vibrato")
	pass # Replace with function body.


func _on_vibrato_button_up():
	Input.action_release("vibrato")
	pass # Replace with function body.
