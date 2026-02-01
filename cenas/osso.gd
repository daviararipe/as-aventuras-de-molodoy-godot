extends Area2D

signal osso_coletado

func _ready():
	add_to_group("ossos") # garante que o osso entre no grupo automaticamente

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("jogador"):
		emit_signal("osso_coletado")
		$AudioStreamPlayer2D.play()
		await $AudioStreamPlayer2D.finished
		queue_free()
