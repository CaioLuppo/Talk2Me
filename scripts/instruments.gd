extends Node

# Esse script guarda as funções de tocar instrumentos

# PADRÃO DE NOTAS:
# C-0 CS-1 D-2 DS-3 etc.
var instrument = "clarinete"
var instruments = {
	"clarinete":[
		"res://src/instruments/Clarinete/C-1.wav", 
		"res://src/instruments/Clarinete/C#-1.wav",
		"res://src/instruments/Clarinete/D.wav",
		"res://src/instruments/Clarinete/D#-1.wav",
		"res://src/instruments/Clarinete/E-1.wav",
		"res://src/instruments/Clarinete/F-1.wav",
		"res://src/instruments/Clarinete/F#-1.wav",
		"res://src/instruments/Clarinete/G-1.wav",
		"res://src/instruments/Clarinete/G#-1.wav",
		"res://src/instruments/Clarinete/A-1.wav",
		"res://src/instruments/Clarinete/A#-1.wav",
		"res://src/instruments/Clarinete/B-1.wav"
		]
}
var playing = false
# Cria os nós que receberão o áudio de cada nota, isso permite tocar em conjunto
func _ready():
	name = "notes"
	for count in instruments[instrument].size():
		var nota = AudioStreamPlayer2D.new()
		nota.name = "note"+str(count)
		nota.stream = load(instruments[instrument][count])
		add_child(nota, true)
		var delay = Tween.new()
		nota.add_child(delay, true)

# Função para tocar
func play():
	# Animação
	if playing:
		$"../anim".play("clarinete")
	else:
		$"../anim".play("idleClarinete")
	
	# Notas
	playKey("C1", $note0)
	playKey("CS1", $note1)
	playKey("D1", $note2)
	playKey("DS1", $note3)
	playKey("E1", $note4)
	playKey("F1", $note5)
	playKey("FS1", $note6)
	playKey("G1", $note7)
	playKey("GS1", $note8)
	playKey("A1", $note9)
	playKey("AS1", $note10)
	playKey("B1", $note11)

var noteList = ["C1", "CS1", "D1", "DS1", "E1", "F1", "FS1", "G1", "GS1", "A1", "AS1", "B1"]
var canVerify = false

func _process(delta):
	if canVerify == true:
		for id in noteList:
			if Input.is_action_pressed(id):
				playing = true 

func playKey(key : String, notenode : Node):
	var delay = notenode.get_child(0)
	if Input.is_action_just_pressed(key):
		canVerify = true
		delay.stop(notenode, "volume_db")
		default(notenode)
		notenode.play()
		playing = true
	elif Input.is_action_just_released(key):
		delay.stop(notenode, "volume_db")
		delay.interpolate_property(notenode, "volume_db", 0, -80, 1, Tween.TRANS_LINEAR)
		delay.start()
		playing = false

func default(notenode):
	notenode.volume_db = 0
