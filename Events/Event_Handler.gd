extends Node2D

func event_won_mission(player, current_event):
	player.money += current_event.win_money
	player.food += current_event.win_food
	player.fuel += current_event.win_fuel
	player.ammo += current_event.win_ammo
	player.condition += round(current_event.win_condition)
	
	player.update_labels()

func event_failed_mission(player, current_event):
	player.money += current_event.fail_money
	player.food += current_event.fail_food
	player.fuel += current_event.fail_fuel
	player.ammo += current_event.fail_ammo
	
	var damage = current_event.fail_condition * (1000 - player.bodyPart.armor) / 1000
	player.condition += round(damage)
	
	player.update_labels()
