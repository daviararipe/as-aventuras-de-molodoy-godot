extends Node2D

@onready var contador = $Player/Control
var ossos = []
var total_ossos = 6
var ossos_coletados = 0

func _ready() -> void:
	if contador == null:
		push_error("Contador não encontrado! Verifique o caminho: $Player/Control")
		return
	
	await get_tree().process_frame

	ossos = get_tree().get_nodes_in_group("ossos")

	contador.definir_total(total_ossos)
	atualizar_contador()

	for osso in ossos:
		if not osso.is_connected("osso_coletado", Callable(self, "_on_osso_coletado")):
			osso.connect("osso_coletado", Callable(self, "_on_osso_coletado"))


# Quando coleta um osso
func _on_osso_coletado():
	ossos_coletados += 1
	contador.adicionar_osso()
	atualizar_contador()

	# Sempre mostra a pergunta ao coletar QUALQUER osso
	mostrar_pergunta_tabuada()


# Atualiza texto
func atualizar_contador():
	if contador.has_node("Label2"):
		contador.get_node("Label2").text = "%d / %d" % [ossos_coletados, total_ossos]


# Mostra cena da tabuada
func mostrar_pergunta_tabuada():
	var cena_pergunta = preload("res://cenas/pergunta_tabuada.tscn").instantiate()
	add_child(cena_pergunta)
	cena_pergunta.pergunta_concluida.connect(_on_pergunta_concluida)


# Resultado da pergunta
func _on_pergunta_concluida(correta: bool):
	if correta:
		# SE FOI O ÚLTIMO OSSO → VITÓRIA
		if ossos_coletados >= total_ossos:
			get_tree().change_scene_to_file("res://cenas/tela_ganhou.tscn")
	else:
		get_tree().change_scene_to_file("res://cenas/tela_perdeu.tscn")


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("jogador"):
		body.die()
