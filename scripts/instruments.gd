extends Node

# Esse script guarda as funções de tocar instrumentos

var volume = -10
var playing = false

# Notas
var noteList = [
	"C1", "CS1", "D1", "DS1", "E1", "F1", "FS1", "G1", "GS1", "A1", "AS1", "B1", # Primeira oitava
	"C2", "CS2", "D2", "DS2", "E2", "F2", "FS2", "G2", "GS2", "A2", "AS2", "B2" # Segunda oitava
	]

# Instrumentos
var instrument = "clarinete"
var instrumentNotes = {
	"clarinete":[
		# Primeira oitava
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
		"res://src/instruments/Clarinete/B1.mp3",
		# Segunda oitava
		"res://src/instruments/Clarinete/C2.mp3", 
		"res://src/instruments/Clarinete/CS2.mp3",
		"res://src/instruments/Clarinete/D2.mp3",
		"res://src/instruments/Clarinete/DS2.mp3",
		"res://src/instruments/Clarinete/E2.mp3",
		"res://src/instruments/Clarinete/F2.mp3",
		"res://src/instruments/Clarinete/FS2.mp3",
		"res://src/instruments/Clarinete/G2.mp3",
		"res://src/instruments/Clarinete/GS2.mp3",
		"res://src/instruments/Clarinete/A2.mp3",
		"res://src/instruments/Clarinete/AS2.mp3",
		"res://src/instruments/Clarinete/B2.mp3"
		]}

var windInstruments = ["clarinete", "flauta", "oboé", "trompete"]

var tw = Tween.new()

# Cria os nós que receberão o áudio de cada nota, isso permite tocar em conjunto
func _ready():
	
	name = "notes"
	add_child(tw)
	
	if instrument in windInstruments:
		var nota = AudioStreamPlayer.new()
		nota.name = "note"
		nota.volume_db = volume
		nota.mix_target = 2
		add_child(nota, true)
		var delay = Tween.new()
		nota.add_child(delay, true)
	else:
		for count in instrumentNotes[instrument].size():
			var nota = AudioStreamPlayer.new()
			nota.name = "note"+str(count)
			nota.stream = load(instrumentNotes[instrument][count])
			nota.volume_db = volume
			nota.mix_target = 2
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
	if instrument in windInstruments:
		playWindKey()
		vibrato()
	else:
		var count = 0
		for key in noteList:
			var nodeName = "note" + str(count)
			var node = get_node(nodeName)
			playKey(key, node)
			count += 1

# Funções específicas
var canVerify = false
var lastnote

func playKey(key : String, notenode : Node):
	if Input.is_action_just_pressed(key):
		onPressed(notenode)
	elif Input.is_action_just_released(key):
		onReleased(notenode)
		for note in noteList: # Verifica se tem tecla sendo pressionada, para a animação
			if Input.is_action_pressed(note):
				playing = true

func playWindKey(): # Função para instrumentos de sopro
	# Condições para as notas
	for key in noteList:
		windKey(key)
	
	# Quando solta a nota, verifica se a nota que soltou é a certa
	for note in noteList:
		if Input.is_action_just_released(note) && lastnote == note:
			onReleased($note)
	
	pass

func windKey(note:String):
	var n = $note
	if Input.is_action_just_pressed(note):
		loadNote(instrumentNotes[instrument][noteList.find(note)])
		onPressed(n)
		lastnote = note
	pass

var vibrating = false
func vibrato():
	# Aumenta e diminui o pitch/frequencia da nota caso o botão de vibrato seja pressionado
	var no = $note
	if Input.is_action_pressed("vibrato") && vibrating == false && playing:
		tw.interpolate_property(no, "pitch_scale", 1, 1.015, 0.1, Tween.TRANS_LINEAR)
		tw.start()
		vibrating = true
		yield(tw, "tween_completed")
		tw.interpolate_property(no, "pitch_scale", 1.015, 1, 0.1, Tween.TRANS_LINEAR)
		tw.start()
		yield(tw, "tween_completed")
		vibrating = false

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
