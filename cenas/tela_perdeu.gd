extends Node


func _on_botao_perdeu_pressed() -> void:
	get_tree().change_scene_to_file("res://cenas/jogo.tscn")
