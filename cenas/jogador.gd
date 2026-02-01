extends CharacterBody2D

class_name Jogador

const SPEED = 100.0
const JUMP_VELOCITY = -300.0

@onready var anim = $AnimatedSprite2D

func _physics_process(delta: float) -> void:
	# Adiciona gravidade
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Pula se estiver no chão
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Movimento horizontal
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	
	# --- checar colisões mortais ---

# --- Animações ---
	if direction != 0:
		if anim.animation != "walk":
			anim.play("walk")
		anim.flip_h = direction < 0
	else:
	# Toca a animação de idle apenas se não estiver já tocando
		if anim.animation != "idle":
			anim.play("idle")

	# Se a idle já terminou, para no último frame
		if not anim.is_playing() and anim.animation == "idle":
			anim.stop()
			anim.frame = 3


func _on_animated_sprite_2d_animation_finished() -> void:
	if anim.animation == "idle":
		anim.stop()
		anim.frame = anim.sprite_frames.get_frame_count("idle") - 1
		

# Função de morte do personagem
func die():
	get_tree().change_scene_to_file("res://cenas/tela_perdeu.tscn")
	
