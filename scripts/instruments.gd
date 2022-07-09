extends Node

################################################################################
#                                                                              #
#               SCRIPT DOS INSTRUMENTOS - BY: CAIO LUPPO RIBEIRO               #
#                                                                              #
################################################################################



# ---------------------------- Variáveis Genéricas -----------------------------

# Objetos instanciados:

var tw = Tween.new()
var timer = Timer.new()
var noteNode

# Configurações dos Audio Buses:

var instBusPitchEffect = AudioServer.get_bus_effect(1, 0)
var originalBusPitch = instBusPitchEffect.get("pitch_scale")



# ----------------------------- Funções Principais -----------------------------

var volume = -20
var playing = false

var intervals = {
	"C" : 1,
	"CS" : 2,
	"D" : 3,
	"DS" : 4,
	"E" : 5,
	"F" : 6,
	"FS" : 7,
	"G" : 8,
	"GS" : 9,
	"A" : 10,
	"AS" : 11,
	"B" : 12 }
var instrument = "clarinet"
var windInsts = ["clarinet"]
var stringInsts = ["piano"]

var isWind = instrument in windInsts
var isString = instrument in stringInsts


func _ready():  # Função executada assim que é isntanciado
	
	timer.connect("timeout", self, "_windTimeout")  # Conecta o timer
	
	add_child(tw)  # Adiciona o nó do Tween na cena, como filho do nó atual
	
	if isWind:
		var noteNodeInst = AudioStreamPlayer.new()
		noteNodeInst.mix_target = 2  # Seta o alvo do som para "center"
		noteNodeInst.name = "noteNode"  # Define o nome do nó
		noteNodeInst.volume_db = volume  # Define o volume dos intrumentos
		add_child(noteNodeInst)  # Adiciona o nó na cena
		noteNode = $noteNode
		timer.name = "LigatoTimer"
		add_child(timer)  # Timer que será utilizado para o "ligato"
		
	elif isString:
		
		pass
	
	noteNode.bus = "Instruments"  # Define por que ônibus o áudio sairá
	
	pass

func play():  # Função mestre que executa as outras e faz distinção
	
	# Animação
	if playing:
		$"../anim".play("clarinet")
	else:
		$"../anim".play("idleClarinet")
	
	# Funções para tocar em si
	if isWind:
		checkTimeOut()
		wind()
		vibrato()
	elif isString:
		pass
	
	
	pass



# --------------------------- Instrumentos de Sopro ----------------------------

var timeout = false
var lastNotePlayed
var vibrating = false


func wind():  # Função para tocar as notas dos instrumentos de sopro
	for octave in range(1, 4):
		for note in intervals:
			if Input.is_action_just_pressed(note+str(octave)):
				noteNode.stream = load("res://src/instruments/"+instrument+"/C"+str(octave)+".mp3")
				noteNode.pitch_scale = pitchGuess(intervals[note] - 1)
				if timeout:
					noteNode.play()
				elif !timeout or playing:
					if instrument == "clarinete" && octave == 1:
						noteNode.play(.12)
					else:
						noteNode.play(.07)
				playing = true
				lastNotePlayed = note+str(octave)
			if Input.is_action_just_released(note+str(octave)):
				timeout = false
				timer.wait_time = 0.4
				timer.start()
				if lastNotePlayed == note+str(octave):
					noteNode.stop()
					playing = false

func _windTimeout():  # Quando o timer do wind terminar
	timeout = true
	pass

func vibrato():  # Funcão para o vibrato
	
	# Aumenta e diminui o pitch/frequencia da nota caso o botão de vibrato seja pressionado
	
	if Input.is_action_pressed("vibrato") && vibrating == false && playing:
		
		# Esta parte aumenta o pitch
		tw.interpolate_property(instBusPitchEffect, "pitch_scale", originalBusPitch, originalBusPitch + (0.0295 * 0.3), 0.12, Tween.TRANS_LINEAR)
		tw.start()
		vibrating = true
		
		# Esta parte diminui o pitch
		yield(tw, "tween_completed")
		tw.interpolate_property(instBusPitchEffect, "pitch_scale", instBusPitchEffect.get("pitch_scale"), originalBusPitch, 0.1, Tween.TRANS_LINEAR)
		tw.start()
		
		# Esta parte permite a reexecução do vibrato, após terminar de "vibrar"
		yield(tw, "tween_completed")
		vibrating = false



# ----------------------------- Funções auxiliares -----------------------------

func checkTimeOut():  # Função que garante que o nó pare de tocar
	if !timeout && !playing:
		noteNode.stop()

func pitchGuess(semitone):  # Função para calcular o pitch da nota
	return pow(2.0, float(float(semitone)/12.0))
