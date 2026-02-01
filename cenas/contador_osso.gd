extends Control

var total_ossos: int = 0
var ossos_coletados: int = 0

@onready var label_quantidade: Label = $LabelTitulo
@onready var label_osso: Label = $LabelOsso

func _ready() -> void:
	_atualizar_label()

# Define o total de ossos no início do jogo
func definir_total(total: int) -> void:
	total_ossos = total
	_atualizar_label()

# Adiciona +1 quando o jogador coleta um osso
func adicionar_osso() -> void:
	ossos_coletados += 1
	_atualizar_label()

# Atualiza o texto do contador (ex: "2 / 6")
func _atualizar_label() -> void:
	if label_osso:
		label_osso.text = "%d / %d" % [ossos_coletados, total_ossos]
