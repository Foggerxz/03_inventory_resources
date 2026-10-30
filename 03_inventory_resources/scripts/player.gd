extends CharacterBody2D

var speed = 40
@export var anim: AnimatedSprite2D

# Ссылка на текст над головой игрока
@onready var name_label = $NameLabel

func _ready():
	# Присваиваем тексту значение из глобального скрипта при старте игры
	name_label.text = Global.player_name
	Global.add_item(item_resources)

func _physics_process(_delta):
	var input = Vector2(Input.get_action_strength('ui_right') - Input.get_action_strength('ui_left'), Input.get_action_strength('ui_down') - Input.get_action_strength('ui_up'))
	velocity = input.normalized() * speed
	
	# Отмена расчета движения и тд
	if is_sitting:
		velocity = Vector2.ZERO
		move_and_slide()
		return
		
	# Поворот спрайта в зависимости от направления персонажа
	if input.x > 0:
		anim.flip_h = true
		hand.flip_h = true
		hand.position.x = abs(hand.position.x) # Сдвигаем топор влево (лицом вправо)
	elif input.x < 0:
		anim.flip_h = false
		hand.flip_h = false
		hand.position.x = -abs(hand.position.x)  # Сдвигаем топор вправо (лицом влево)

		
	# Переключение состояний анимации
	if input != Vector2.ZERO:
		anim.play('walk')
	else:
		anim.play('idle')
	
	move_and_slide()

# Флаг для sit
var is_sitting = false

# Функция мониторит все, что нажал игрок
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed('next_item'):
		change_selection(1)
	if event.is_action_pressed('prev_item'):
		change_selection(-1)
	if event.is_action_pressed('item_to_drop'):
		drop_item()
		
	if event.is_action_pressed('use_tool'):
	# Ищем инструмент в инвентаре
		var tool_item = null
		for item in Global.inventory:
			if item.is_tool:
				tool_item = item
				break # Нашли топор
	
	# Если топор найден в инвентаре
		if tool_item != null:
			if hand.texture == tool_item.icon:
				hand.texture = null
			else:
				hand.texture = tool_item.icon


	if event.is_action_pressed('interact'):
		if is_sitting:
			is_sitting = false
			anim.play('idle')
		else:
			is_sitting = true
			anim.play('sit')
@export var hand: Sprite2D
@export var item_resources: ItemData # Сюда закиньте топор, это будет 1 предмет
var equipped_tool: ItemData

func update_hand_visual():
	var item = Global.inventory[Global.active_slot_index]
	if item:
		hand.texture = item.icon
		equipped_tool = item if item.is_tool else null
	else:
		hand.texture = null
		equipped_tool = null

func change_selection(direction: int):
	if Global.inventory.size() == 0: return
	Global.update_selection_visual.emit()
	
	# Алгоритм зацикливания индекса
	Global.active_slot_index = (Global.active_slot_index + direction) % Global.inventory.size()
	if Global.active_slot_index < 0: Global.active_slot_index = Global.inventory.size() - 1
	
	update_hand_visual()
	
@export var item_world_scene: PackedScene

func drop_item():
	if Global.inventory.size() > 0:
		var item_to_drop = Global.inventory[Global.active_slot_index]
		Global.inventory.remove_at(Global.active_slot_index)
		
		# Спавним предмет в мире
		spawn_dropped_item(item_to_drop)
		
		# Корректируем индекс и обновляем всё
		Global.active_slot_index = clamp(Global.active_slot_index, 0, Global.inventory.size() - 1)
		Global.inventory_updated.emit()
		update_hand_visual()

func spawn_dropped_item(item_to_drop: ItemData):
	var new_item = item_world_scene.instantiate()
	
	new_item.item_resources = item_to_drop
	
	var random_offset = Vector2(randf_range(-15, 15), randf_range(-15, 15))
	new_item.position = self.position + random_offset
	
	get_tree().current_scene.add_child(new_item)
