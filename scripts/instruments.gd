extends Node

# Esse script guarda as funções de tocar instrumentos

var volume = -10
var playing = false

# PADRÃO DE NOTAS:
# C-0 CS-1 D-2 DS-3 etc.
var instrument = "clarinete"
var instruments = {
	"clarinete":[
		"res://src/instruments/Clarinete/C1.mp3", 
		"res://src/instruments/Clarinete/CS1.mp3",
		"res://src/instruments/Clarinete/D1.mp3",
		"res://src/instruments/Clarinete/DS1.mp3",
		"res://src/instruments/Clarinete/E1.mp3",
		"res://src/instruments/Clarinete/F1.mp3",
		"res://src/instruments/Clarinete/FS1.mp3",
		"res://src/instruments/Clarinete/G1.mp3",
		"res://src/instruments/Clarinete/GS1.mp3",
		"res://src/instruments/Clarinete/A1.mp3",
		"res://src/instruments/Clarinete/AS1.mp3",
		"res://src/instruments/Clarinete/B1.mp3"
		]}

# Cria os nós que receberão o áudio de cada nota, isso permite tocar em conjunto
func _ready():
	name = "notes"
	if instrument != "clarinete":
		for count in instruments[instrument].size():
			var nota = AudioStreamPlayer2D.new()
			nota.name = "note"+str(count)
			nota.stream = load(instruments[instrument][count])
			nota.volume_db = volume
			add_child(nota, true)
			var delay = Tween.new()
			nota.add_child(delay, true)
	else:
		var nota = AudioStreamPlayer2D.new()
		nota.name = "note"
		nota.volume_db = volume
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
	if instrument == "clarinete":
		playWindKey()
	else:
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
	if Input.is_action_just_pressed(key):
		onPressed(notenode)
	elif Input.is_action_just_released(key):
		onReleased(notenode)

# instrumento de sopro
var lastnote
func playWindKey():
	# Condições para as notas
	windKey("A1")
	windKey("AS1")
	windKey("B1")
	windKey("C1")
	windKey("CS1")
	windKey("D1")
	windKey("DS1")
	windKey("E1")
	windKey("F1")
	windKey("FS1")
	windKey("G1")
	windKey("GS1")
	
	# Quando solta a nota, verifica se a nota que soltou é a certa
	for note in noteList:
		if Input.is_action_just_released(note) && lastnote == note:
			onReleased($note)
	
	pass

func windKey(note:String):
	var n = $note
	if Input.is_action_just_pressed(note):
		loadNote(instruments[instrument][noteList.find(note)])
		onPressed(n)
		lastnote = note
	pass

# Helpers
func default(notenode):
	notenode.volume_db = volume

func onPressed(notenode):
	var delay = notenode.get_child(0)
	canVerify = true
	delay.stop(notenode, "volume_db")
	default(notenode)
	notenode.play()
	playing = true

func onReleased(notenode):
	var delay = notenode.get_child(0)
	delay.interpolate_property(notenode, "volume_db", volume, -80, 1, Tween.TRANS_LINEAR)
	delay.start()
	playing = false

func loadNote(path):
	$note.stream = load(path)
