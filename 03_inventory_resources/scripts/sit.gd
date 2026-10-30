# Флаг для sit
var is_sitting = false
# Функция мониторит все, что нажал игрок
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed('interact'):
		if is_sitting:
			is_sitting = false
			anim.play('idle')
			else:
				is_sitting = true
				anim.play('sit')
				
# Отмена расчета движения и тд
	if is_sitting:
		velocity = Vector2.ZERO
		move_and_slide()
		return
