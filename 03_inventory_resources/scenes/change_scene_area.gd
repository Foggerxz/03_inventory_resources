extends Area2D

# Путь к сцене, на которую нужно перейти (можно перетащить файл сцены прямо сюда)
@export_file("*.tscn") var target_scene: String = "res://scenes/Rocks.tscn"

func _on_body_entered(body: Node2D) -> void:
	# Проверяем, что в зону вошел именно игрок, а не враг или предмет
	if body.name == "Player":
		# Переходим на новую сцену
		get_tree().change_scene_to_file(target_scene)
