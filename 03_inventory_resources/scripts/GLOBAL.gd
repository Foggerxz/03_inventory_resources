extends Node 
@export var max_inventory_size: int = 10

var player_name: String = ""
# Сигнал передает имя предмета 
# Сигнал уведомления об обновлении инвентаря (удаляем старый сигнал)
signal inventory_updated
var inventory: Array[ItemData] = []

func add_item(new_item: ItemData):
	var item_found = false
	
	# Проверяем, есть ли уже такой предмет, у которого количество МЕНЬШЕ 10
	for item in inventory:
		if item.name == new_item.name and item.amount < 10:
			item.amount += 1
			item_found = true
			inventory_updated.emit()
			break # Выходим из цикла, предмет успешно добавлен в неполный стак
			
	# Если неполный стак не найден (или его нет, или все существующие уже по 10 шт)
	if not item_found:
		# Проверяем, есть ли вообще место в инвентаре для нового слота/стака
		if inventory.size() < max_inventory_size:
			# Создаем копию ресурса, чтобы новые стаки не ссылались на один и тот же объект в памяти
			var item_clone = new_item.duplicate()
			item_clone.amount = 1 # Начинаем новый стак с 1 предмета
			
			inventory.append(item_clone)
			inventory_updated.emit()
		else:
			print("Инвентарь полон! Нет места для нового стака.")




var active_slot_index: int = 0
signal update_selection_visual
