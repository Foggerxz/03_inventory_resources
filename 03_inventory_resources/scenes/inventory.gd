extends CanvasLayer

@export var grid: GridContainer
@export var max_inventory_size: int = 10


	

func _ready():
	Global.inventory_updated.connect(refresh_ui)
	Global.update_selection_visual.connect(update_selection_visual)
	refresh_ui()

func refresh_ui():
	# Очистка старых слотов
	for child in grid.get_children(): child.queue_free()
	
	# Создание новых на основе данных из Global
	for item in Global.inventory:
		var slot = Button.new()
		slot.icon = item.icon
		# Отображаем количество, если оно больше 1 (чтобы не спамить единичками)
		if item.amount > 1:
			slot.text = str(item.amount) 
		
		slot.icon_alignment = HORIZONTAL_ALIGNMENT_CENTER
		slot.custom_minimum_size = Vector2(25, 25)
		grid.add_child(slot)


func update_selection_visual():
	var slots = grid.get_children()
	for i in range(slots.size()):
		if i == Global.active_slot_index:
			slots[i].grab_focus()
		else:
			slots[i].release_focus()
