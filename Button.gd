extends Button


func _ready():
	text = "TRUMPET"
	pass # Replace with function body.


func _on_Button_button_up():
	$"../Player/notes".instrument = "trumpet"
	pass # Replace with function body.
