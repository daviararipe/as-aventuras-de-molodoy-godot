extends CanvasLayer

signal pergunta_concluida(correta: bool)

@onready var label_pergunta = $Label
@onready var input_resposta = $LineEdit
@onready var botao_confirmar = $Button

var resultado_correto = 0
var fechando = false

func _ready():
	randomize()
	botao_confirmar.pressed.connect(_verificar_resposta)
	gerar_pergunta()

func gerar_pergunta():
	var a = randi_range(1, 10)
	var b = randi_range(1, 10)
	resultado_correto = a * b
	label_pergunta.text = "Quanto é %d × %d ?" % [a, b]
	input_resposta.text = ""
	input_resposta.grab_focus()

func _verificar_resposta():
	if input_resposta.text == "":
		return

	var resposta = int(input_resposta.text)
	var correta = resposta == resultado_correto

	if correta:
		label_pergunta.text = "✅ Correto!"
	else:
		label_pergunta.text = "❌ Errado! Era %d." % [resultado_correto]

	if fechando:
		return

	fechando = true
	await esperar(1.0)

	if is_inside_tree():
		pergunta_concluida.emit(correta)
		queue_free()

func esperar(segundos: float) -> void:
	var tempo_inicial = Time.get_ticks_msec()
	while (Time.get_ticks_msec() - tempo_inicial) < int(segundos * 1000):
		if not is_inside_tree():
			return
		await get_tree().process_frame

func _input(event):
	# 👉 Agora só funciona com a tecla Enter. Espaço não funciona mais.
	if event is InputEventKey and event.pressed and not event.echo:
		if event.keycode == KEY_ENTER or event.keycode == KEY_KP_ENTER:
			botao_confirmar.emit_signal("pressed")
