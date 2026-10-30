extends Control

@onready var name_input = $NameInput
@onready var error_label = $ErrorLabel

func _ready():
	error_label.text = "" # Изначально текста ошибки нет

func _on_start_button_pressed():
	var entered_name = name_input.text.strip_edges() # Убираем лишние пробелы
	
	# Проверка на количество символов (больше 2)
	if entered_name.length() <= 2:
		error_label.text = "Имя должно быть длиннее 2 символов!"
	else:
		Global.player_name = entered_name 
		
		get_tree().change_scene_to_file("res://scenes/Main_Screen.tscn") 
