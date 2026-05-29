extends Node2D

var save_path = "user://variable.save"
var wood = 0
var click_power = 1
var axe_skill_cost = 15
var worker_cost = 50
var wood_sec = 0
var axe_reforge_cost = 1200
var bulldozers_cost = 25000
var axe_skills_amount = 0
var worker_amount = 0
var axe_reforge_amount = 0
var bulldozers_amount = 0
var shop_open = false
var tree_wood_amount
var handsaw_cost = 250
var handsaw_amount = 0
var lumberjack_team_cost = 3000
var lumberjack_team_amount = 0
var chainsaw_fleet_cost = 8500
var chainsaw_fleet_amount = 0
var tree_harvester_cost = 65000
var tree_havester_amount = 0
var industrial_mulcher_cost = 90000
var industrial_mulcher_amount = 0
var shop_tab = 1
var click_multiplier = 1
var reinforced_gloves_toggle:bool = false
var worker_efficency = 1
var coffee_machine_toggle = false
var version = 0.1
var steel_axe_head_toggle = false
var turbochargers_toggle = false
var log_flume_toggle = false
var gps_mapping_toggle = false
var shift_management_toggle = false
var carbon_fiber_saws_toggle = false
var diamond_coated_teeth_toggle = false
var automation_logic_controller_toggle = false
var vertical_intergration_toggle = false
var the_eternal_forest_toggle = false
var vehicle_efficency = 1
var chainsaw_fleet_efficency = 1
var currency_button_tab = 1
var golden_seed = 0
var seed_gain
var prestiges = 0
var cost_multiplier = 1.2
var theyre_mine_toggle = false
var fertile_soil_toggle = false
var smart_workers_toggle = false
var autobuyer_i_toggle = false
var golden_saw_toggle = false
var saw_efficency_toggle = false
var prestige_boost_toggle = false
var discount_toggle = false
var autobuyer_ii_toggle = false
var autobuyer_iii_toggle = false
var golden_seed_multipiler = 1

func _ready() -> void:
	load_data()
	$Unused.hide()

func _process(_delta: float) -> void:
	if wood < 100000000001:
		$"Currency Bar"/Wood.text = str(wood)
	if wood_sec < 50000000001:
		$"Currency Bar/Wood per sec".text = str(wood_sec) + "/sec"
	if  golden_seed < 100001:
		$"Currency Bar/Golden Seeds".text = str(golden_seed)
	$Instruction.text = "Click to get " + str(click_power) + " wood"
	$"Shop/Multi-Time Upgrades/Axe Skills".text = "Axe Skills - %d wood\n(%d/click -> %d/click)" % [axe_skill_cost, click_power, click_power + (1 * click_multiplier)]
	$"Shop/Multi-Time Upgrades/Worker".text = "Worker - %d wood\n(%d/sec -> %d/sec)" % [worker_cost, wood_sec, wood_sec + 1 * int(worker_efficency)]
	$"Shop/Multi-Time Upgrades/Hand Saw".text = "Hand Saw - %d wood\n(%d/sec -> %d/sec)" % [handsaw_cost, wood_sec, wood_sec + 4]
	$"Shop/Multi-Time Upgrades/Axe Reforge".text = "Axe Reforge - %d wood\n(%d/click -> %d/click)" % [axe_reforge_cost, click_power, click_power + (15 * click_multiplier)]
	$"Shop/Multi-Time Upgrades/Lumberjack Team".text = "Lumberjack Team - %d wood\n(%d/sec -> %d/sec)" % [lumberjack_team_cost, wood_sec, wood_sec + 25]
	$"Shop/Multi-Time Upgrades/Chainsaw Fleet".text = "Chainsaw Fleet - %d wood\n(%d/sec -> %d/sec)" % [chainsaw_fleet_cost, wood_sec, wood_sec + (80 * chainsaw_fleet_efficency)]
	$"Shop/Multi-Time Upgrades/Bulldozers".text = "Bulldozers - %d wood\n(%d/sec -> %d/sec)" % [bulldozers_cost, wood_sec, wood_sec + (200 * vehicle_efficency)]
	$"Shop/Multi-Time Upgrades/Tree Harvester".text = "Tree Harvester - %d wood\n(%d/sec -> %d/sec)" % [tree_harvester_cost, wood_sec, wood_sec + (600 * vehicle_efficency)]
	$"Shop/Multi-Time Upgrades/Industrial Mulcher".text = "Industrial Mulcher - %d wood\n(%d/sec -> %d/sec)" % [industrial_mulcher_cost, wood_sec, wood_sec + (1000 * vehicle_efficency)]
	$"Shop/Multi-Time Upgrades/Axe Skills/Axe Skill Amount".text = str(axe_skills_amount)
	$"Shop/Multi-Time Upgrades/Worker/Worker Amount".text = str(worker_amount)
	$"Shop/Multi-Time Upgrades/Hand Saw/Hand Saw Amount".text = str(handsaw_amount)
	$"Shop/Multi-Time Upgrades/Axe Reforge/Axe Reforge Amount".text = str(axe_reforge_amount)
	$"Shop/Multi-Time Upgrades/Lumberjack Team/Lumberjack Team Amount".text = str(lumberjack_team_amount)
	$"Shop/Multi-Time Upgrades/Chainsaw Fleet/Chainsaw Fleet Amount".text = str(chainsaw_fleet_amount)
	$"Shop/Multi-Time Upgrades/Bulldozers/Bulldozers Amount".text = str(bulldozers_amount)
	$"Shop/Multi-Time Upgrades/Tree Harvester/Tree Harvester Amount".text = str(tree_havester_amount)
	$"Shop/Multi-Time Upgrades/Industrial Mulcher/Industrial Mulcher Amount".text = str(industrial_mulcher_amount)
	if click_power > 50000000000:
		click_power = 50000000000
	if wood_sec > 50000000000:
		wood_sec = 50000000000
	if wood > 100000000000:
		wood = 100000000000
	if shop_open == true:
		$"Shop/Shop Background".show()
		$Shop/Tabs.show()
		$Clicker.hide()
		$Trees.hide()
		$"Save+Load".hide()
		if shop_tab == 1:
			$"Shop/One-Time Upgrades".hide()
			$"Shop/Multi-Time Upgrades".show()
			$"Shop/Prestige Upgrades".hide()
		if shop_tab == 2:
			$"Shop/Multi-Time Upgrades".hide()
			$"Shop/One-Time Upgrades".show()
			$"Shop/Prestige Upgrades".hide()
		if shop_tab == 3:
			$"Shop/Multi-Time Upgrades".hide()
			$"Shop/One-Time Upgrades".hide()
			$"Shop/Prestige Upgrades".show()
	if shop_open == false:
		$"Shop/Shop Background".hide()
		$"Shop/Multi-Time Upgrades".hide()
		$Shop/Tabs.hide()
		$"Shop/One-Time Upgrades".hide()
		$Clicker.show()
		$Trees.show()
		$"Save+Load".show()
	if currency_button_tab == 1:
		$"Currency Bar/Wood Icon".show()
		$"Currency Bar/Wood per sec".show()
		$"Currency Bar/Wood".show()
		$"Currency Bar/Gold Seed Icon".hide()
		$"Currency Bar/Golden Seeds".hide()
	if currency_button_tab == 2:
		$"Currency Bar/Wood Icon".hide()
		$"Currency Bar/Wood per sec".hide()
		$"Currency Bar/Wood".hide()
		$"Currency Bar/Gold Seed Icon".show()
		$"Currency Bar/Golden Seeds".show()
	if Input.is_action_pressed("+ 1000000 wood"):
		wood += 1000000 #Debug Tool
	if Input.is_action_pressed("+ 1000 golden seeds"):
		golden_seed += 1000
	if wood > 9999999:
		$"Shop/One-Time Upgrades/Prestige".show()
	else:
		$"Shop/One-Time Upgrades/Prestige".hide()

func _on_clicker_pressed() -> void:
	wood += click_power * click_multiplier

func _on_axe_skills_pressed() -> void:
	if wood > axe_skill_cost - 1:
		if axe_skill_cost < 100000000001:
			wood -= round(axe_skill_cost) 
			click_power += 1 * click_multiplier
			axe_skill_cost *= cost_multiplier
			axe_skills_amount += 1

func _on_worker_pressed() -> void:
	if wood > worker_cost - 1:
		if worker_cost < 100000000001:
			wood -= round(worker_cost)
			wood_sec += 1 * cost_multiplier
			worker_cost *= 1.2
			worker_amount += 1

func _on_hand_saw_pressed() -> void:
	if wood > handsaw_cost - 1:
		if handsaw_cost < 100000000001:
			wood -= round(handsaw_cost)
			wood_sec += 4
			handsaw_cost *= cost_multiplier
			handsaw_amount += 1

func _on_axe_reforge_pressed() -> void:
	if wood > axe_reforge_cost - 1:
		if axe_reforge_cost < 100000000001:
			wood -= round(axe_reforge_cost)
			click_power += 15 * click_multiplier
			axe_reforge_cost *= cost_multiplier
			axe_reforge_amount += 1

func _on_lumberjack_team_pressed() -> void:
	if wood > lumberjack_team_cost - 1:
		if lumberjack_team_cost < 100000000001:
			wood -= round(lumberjack_team_cost)
			wood_sec += 25
			lumberjack_team_cost *= cost_multiplier
			lumberjack_team_amount += 1

func _on_chainsaw_fleet_pressed() -> void:
	if wood > chainsaw_fleet_cost - 1:
		if chainsaw_fleet_cost < 100000000001:
			wood -= round(chainsaw_fleet_cost)
			wood_sec += 80 * chainsaw_fleet_efficency
			chainsaw_fleet_cost *= cost_multiplier
			chainsaw_fleet_amount += 1

func _on_bulldozers_pressed() -> void:
	if wood > bulldozers_cost - 1:
		if bulldozers_cost < 100000000001:
			wood -= round(bulldozers_cost)
			wood_sec += 200 * vehicle_efficency
			bulldozers_cost *= cost_multiplier
			bulldozers_amount += 1

func _on_tree_harvester_pressed() -> void:
	if wood > tree_harvester_cost - 1:
		if tree_harvester_cost < 100000000001:
			wood -= round(tree_harvester_cost)
			wood_sec += 600 * vehicle_efficency
			tree_harvester_cost *= cost_multiplier
			tree_havester_amount += 1

func _on_industrial_mulcher_pressed() -> void:
	if wood > industrial_mulcher_cost - 1:
		if industrial_mulcher_cost < 100000000001:
			wood -= round(industrial_mulcher_cost)
			wood_sec += 4000 * vehicle_efficency
			industrial_mulcher_cost *= cost_multiplier
			industrial_mulcher_amount += 1

func _on_wood_timer_timeout() -> void:
	if wood < 100000000001:
		if wood_sec < 50000000001:
			wood += wood_sec

func _on_shop_toggle_pressed() -> void:
	if shop_open == true:
		shop_open = false
	else:
		shop_open = true

func _on_tree_pressed() -> void:
	tree_wood_amount = randi() % 6
	if tree_wood_amount == 2:
		wood += 1 * click_power
	if tree_wood_amount == 3:
		wood += 1 * click_power
	if tree_wood_amount == 4:
		wood += 2 * click_power
	if tree_wood_amount == 5:
		wood += 3 * click_power

func _on_multi_time_upgrades_tab_pressed() -> void:
	shop_tab = 1

func _on_one_time_upgrades_tab_pressed() -> void:
	shop_tab = 2

func _on_reinforced_gloves_pressed() -> void:
	if wood > 499:
		wood -= 500
		click_multiplier *= 2
		click_power += ((axe_reforge_amount * 15) + (axe_skills_amount))
		reinforced_gloves_toggle = true
		$"Shop/One-Time Upgrades/Reinforced Gloves".hide()
		save()

func save() -> void:
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	file.store_var(version)
	file.store_var(wood)
	file.store_var(click_power)
	file.store_var(axe_skill_cost)
	file.store_var(wood_sec)
	file.store_var(axe_reforge_cost)
	file.store_var(bulldozers_cost)
	file.store_var(axe_skills_amount)
	file.store_var(axe_reforge_amount)
	file.store_var(worker_amount)
	file.store_var(bulldozers_amount)
	file.store_var(handsaw_cost)
	file.store_var(handsaw_amount)
	file.store_var(lumberjack_team_amount)
	file.store_var(lumberjack_team_cost)
	file.store_var(chainsaw_fleet_amount)
	file.store_var(chainsaw_fleet_cost)
	file.store_var(tree_harvester_cost)
	file.store_var(tree_havester_amount)
	file.store_var(industrial_mulcher_amount)
	file.store_var(industrial_mulcher_cost)
	file.store_var(reinforced_gloves_toggle)
	file.store_var(click_multiplier)
	file.store_var(worker_efficency)
	file.store_var(coffee_machine_toggle)
	file.store_var(steel_axe_head_toggle)
	file.store_var(turbochargers_toggle)
	file.store_var(log_flume_toggle)
	file.store_var(gps_mapping_toggle)
	file.store_var(shift_management_toggle)
	file.store_var(carbon_fiber_saws_toggle)
	file.store_var(diamond_coated_teeth_toggle)
	file.store_var(automation_logic_controller_toggle)
	file.store_var(vertical_intergration_toggle)
	file.store_var(the_eternal_forest_toggle)
	file.store_var(vehicle_efficency)
	file.store_var(chainsaw_fleet_efficency)
	file.store_var(cost_multiplier)
	file.store_var(theyre_mine_toggle)
	file.store_var(fertile_soil_toggle)
	file.store_var(smart_workers_toggle)
	file.store_var(autobuyer_i_toggle)
	file.store_var(golden_saw_toggle)
	file.store_var(saw_efficency_toggle)
	file.store_var(prestige_boost_toggle)
	file.store_var(discount_toggle)
	file.store_var(autobuyer_ii_toggle)
	file.store_var(autobuyer_iii_toggle)
	file.store_var(golden_seed_multipiler)

func load_data() -> void:
	if FileAccess.file_exists(save_path):
		var file = FileAccess.open(save_path, FileAccess.READ)
		set_process(false)
		
		#  CORRECTED: Removed variables from inside get_var()
		version = file.get_var()
		wood = file.get_var()
		click_power = file.get_var()
		axe_skill_cost = file.get_var()
		wood_sec = file.get_var()
		axe_reforge_cost = file.get_var()
		bulldozers_cost = file.get_var()
		axe_skills_amount = file.get_var()
		axe_reforge_amount = file.get_var()
		worker_amount = file.get_var()
		bulldozers_amount = file.get_var()
		handsaw_cost = file.get_var()
		handsaw_amount = file.get_var()
		lumberjack_team_amount = file.get_var()
		lumberjack_team_cost = file.get_var()
		chainsaw_fleet_amount = file.get_var()
		chainsaw_fleet_cost = file.get_var()
		tree_harvester_cost = file.get_var()
		tree_havester_amount = file.get_var()
		industrial_mulcher_amount = file.get_var()
		industrial_mulcher_cost = file.get_var()
		reinforced_gloves_toggle = file.get_var()
		click_multiplier = file.get_var()
		worker_efficency = file.get_var()
		coffee_machine_toggle = file.get_var()
		steel_axe_head_toggle = file.get_var()
		turbochargers_toggle = file.get_var()
		log_flume_toggle = file.get_var()
		gps_mapping_toggle = file.get_var()
		shift_management_toggle = file.get_var()
		carbon_fiber_saws_toggle = file.get_var()
		diamond_coated_teeth_toggle = file.get_var()
		automation_logic_controller_toggle = file.get_var()
		vertical_intergration_toggle = file.get_var()
		the_eternal_forest_toggle = file.get_var()
		vehicle_efficency = file.get_var()
		chainsaw_fleet_efficency = file.get_var()
		cost_multiplier = file.get_var()
		theyre_mine_toggle = file.get_var()
		fertile_soil_toggle = file.get_var()
		smart_workers_toggle = file.get_var()
		autobuyer_i_toggle = file.get_var()
		golden_saw_toggle = file.get_var()
		saw_efficency_toggle = file.get_var()
		prestige_boost_toggle = file.get_var()
		discount_toggle = file.get_var()
		autobuyer_ii_toggle = file.get_var()
		autobuyer_iii_toggle = file.get_var()
		golden_seed_multipiler = file.get_var()
		file.close() # Good practice to close the file when done!
		if reinforced_gloves_toggle == true:
			$"Shop/One-Time Upgrades/Reinforced Gloves".hide()
		if coffee_machine_toggle == true:
			$"Shop/One-Time Upgrades/Coffee Machine".hide()
		if steel_axe_head_toggle == true:
			$"Shop/One-Time Upgrades/Steel Axe Head".hide()
		if turbochargers_toggle == true:
			$"Shop/One-Time Upgrades/Turbochargers".hide()
		if log_flume_toggle == true:
			$"Shop/One-Time Upgrades/Log Flume".hide()
		if gps_mapping_toggle == true:
			$"Shop/One-Time Upgrades/GPS Mapping".hide()
		if shift_management_toggle == true:
			$"Shop/One-Time Upgrades/Shift Management".hide()
		if carbon_fiber_saws_toggle == true:
			$"Shop/One-Time Upgrades/Carbon Fiber Saws".hide()
		if diamond_coated_teeth_toggle == true:
			$"Shop/One-Time Upgrades/Diamond-Coated Teeth".hide()
		if automation_logic_controller_toggle == true:
			$"Shop/One-Time Upgrades/Automation Logic Controller".hide()
		if vertical_intergration_toggle == true:
			$"Shop/One-Time Upgrades/Vertical Intergration".hide()
		if the_eternal_forest_toggle == true:
			$"Shop/One-Time Upgrades/The Eternal Forest".hide()
		if theyre_mine_toggle == true:
			$"Shop/Prestige Upgrades/They're mine!".hide()
		if fertile_soil_toggle == true:
			$"Shop/Prestige Upgrades/Fertile Soil".hide()
		if smart_workers_toggle == true:
			$"Shop/Prestige Upgrades/Smart Workers".hide()
		if autobuyer_i_toggle == true:
			$"Shop/Prestige Upgrades/Autobuyer I".hide()
		if golden_saw_toggle == true:
			$"Shop/Prestige Upgrades/Golden Saw".hide()
		if saw_efficency_toggle == true:
			$"Shop/Prestige Upgrades/Saw Efficency".hide()
		if prestige_boost_toggle == true:
			$"Shop/Prestige Upgrades/Prestige Boost".hide()
		if discount_toggle == true:
			$"Shop/Prestige Upgrades/Discount".hide()
		if autobuyer_ii_toggle == true:
			$"Shop/Prestige Upgrades/Autobuyer II".hide()
		if autobuyer_iii_toggle == true:
			$"Shop/Prestige Upgrades/Autobuyer III".hide()
		version = 0.1
		set_process(true)
	else:
		print("No Data is avalible")

func _on_save_button_pressed() -> void:
	save()

func _on_load_button_pressed() -> void:
	load_data()

func _on_coffee_machine_pressed() -> void:
	if wood > 1199:
		wood -= 1200
		worker_efficency *= 1.1
		wood_sec += (worker_amount * 1 * (worker_efficency - 1))  # Line to be tested
		coffee_machine_toggle = true
		$"Shop/One-Time Upgrades/Coffee Machine".hide()

func _on_steel_axe_head_pressed() -> void:
	if wood > 1199:
		wood -= 1200
	click_power += 50 * click_multiplier
	steel_axe_head_toggle = true
	$"Shop/One-Time Upgrades/Steel Axe Head".hide()

func _on_turbochargers_pressed() -> void:
	if wood > 74999:
		wood -= 75000
		vehicle_efficency *= 1.25
		wood_sec += ((bulldozers_amount * 200) + (tree_havester_amount * 600) + (industrial_mulcher_amount * 1000)) * (vehicle_efficency - 1)  # Line to be tested
		coffee_machine_toggle = true
		$"Shop/One-Time Upgrades/Turbochargers".hide()

func _on_log_flume_pressed() -> void:
	if wood > 199999:
		wood -= 200000
		axe_skill_cost *= 0.9
		axe_reforge_cost *= 0.9
		worker_cost *= 0.9
		handsaw_cost *= 0.9
		lumberjack_team_cost *= 0.9
		chainsaw_fleet_cost *= 0.9
		bulldozers_cost *= 0.9
		tree_harvester_cost *= 0.9
		industrial_mulcher_cost *= 0.9
		log_flume_toggle = true
		$"Shop/One-Time Upgrades/Coffee Machine".hide()

func _on_gps_mapping_pressed() -> void:
	if wood > 499999:
		wood -= 500000
		click_multiplier *= 4
		click_power += (((axe_reforge_amount * 15) + (axe_skills_amount)) *(click_multiplier -1))
		gps_mapping_toggle = true
		$"Shop/One-Time Upgrades/GPS Mapping".hide()

func _on_shift_management_pressed() -> void:
	if wood > 1499999:
		wood -= 1500000
		worker_efficency *= 2
		wood_sec += (worker_amount * 1 * (worker_efficency - 1))  # Line to be tested
		shift_management_toggle = true
		$"Shop/One-Time Upgrades/Shift Management".hide()

func _on_carbon_fiber_saws_pressed() -> void:
	if wood > 24999999:
		wood -= 25000000
		chainsaw_fleet_efficency *= 3
		wood_sec += (chainsaw_fleet_efficency * 80 * (chainsaw_fleet_efficency - 1)) # Line to be tested
		carbon_fiber_saws_toggle = true
		$"Shop/One-Time Upgrades/Carbon Fiber Saws".hide()

func _on_diamond_coated_teeth_pressed() -> void:
	if wood > 99999999:
		wood -= 100000000
		click_multiplier *= 4
		click_power += (((axe_reforge_amount * 15) + (axe_skills_amount)) *(click_multiplier -1))
		diamond_coated_teeth_toggle = true
		$"Shop/One-Time Upgrades/Diamond-Coated Teeth".hide()

func _on_automation_logic_controller_pressed() -> void:
	if wood > 499999999:
		wood -= 500000000
		cost_multiplier -= 0.02
		automation_logic_controller_toggle = true
		$"Shop/One-Time Upgrades/Automation Logic Controller".hide()

func _on_vertical_intergration_pressed() -> void:
	if wood > 2499999999:
		wood -= 25000000
		wood_sec *= 10
		vertical_intergration_toggle = true
		$"Shop/One-Time Upgrades/Vertical Intergration".hide()

func _on_the_eternal_forest_pressed() -> void:
	if wood > 9999999999:
		wood -= 10000000000
		click_power *= 10
		wood_sec *= 10
		the_eternal_forest_toggle = true
		$"Shop/One-Time Upgrades/The Eternal Forest".hide()

func _on_autosave_timer_timeout() -> void:
	save()

func _on_currency_button_pressed() -> void:
	if currency_button_tab == 1:
		currency_button_tab = 2
	else:
		currency_button_tab = 1

func _on_prestige_pressed() -> void:
	set_process(false)
	seed_gain = sqrt(wood/1000) * golden_seed_multipiler
	if seed_gain > 0:
		golden_seed += round(int(seed_gain))
	wood = 0
	click_power = 1
	axe_skill_cost = 15
	worker_cost = 50
	wood_sec = 0
	axe_reforge_cost = 1200
	bulldozers_cost = 25000
	axe_skills_amount = 0
	worker_amount = 0
	axe_reforge_amount = 0
	bulldozers_amount = 0
	shop_open = false
	handsaw_cost = 250
	handsaw_amount = 0
	lumberjack_team_cost = 3000
	lumberjack_team_amount = 0
	chainsaw_fleet_cost = 8500
	chainsaw_fleet_amount = 0
	tree_harvester_cost = 65000
	tree_havester_amount = 0
	industrial_mulcher_cost = 90000
	industrial_mulcher_amount = 0
	worker_efficency = 1
	click_multiplier = 1
	var click_multiplier_synergy = 0
	var worker_synergy = 0
	var wood_sec_synergy = 0
	var click_power_synergy = 0
	vehicle_efficency = 1
	chainsaw_fleet_efficency = 1
	if theyre_mine_toggle == false:
		reinforced_gloves_toggle = false
		coffee_machine_toggle = false
		steel_axe_head_toggle = false
		turbochargers_toggle = false
		log_flume_toggle = false
		gps_mapping_toggle = false
		shift_management_toggle = false
		carbon_fiber_saws_toggle = false
		diamond_coated_teeth_toggle = false
		automation_logic_controller_toggle = false
		vertical_intergration_toggle = false
		the_eternal_forest_toggle = false
	else:
		if reinforced_gloves_toggle == true:
			click_multiplier *= 2
			click_multiplier_synergy += 1
		if gps_mapping_toggle == true:
			click_multiplier *= 4
			click_multiplier_synergy += 1
		if diamond_coated_teeth_toggle == true:
			click_multiplier *= 8
			click_multiplier_synergy += 1
		if click_multiplier_synergy == 3:
			click_multiplier *= 10
		if coffee_machine_toggle == true:
			worker_efficency *= 1.1
			worker_synergy += 1
		if shift_management_toggle == true:
			worker_efficency *= 2
			worker_synergy += 1
		if worker_synergy == 2:
			worker_efficency *= 3
		if vertical_intergration_toggle == true:
			wood_sec *= 3
			wood_sec_synergy += 1
		if steel_axe_head_toggle == true:
			click_power += (50 * click_multiplier)
			click_power_synergy += 1
		if the_eternal_forest_toggle == true:
			wood_sec *= 10
			click_power *= (10 * click_multiplier)
			click_power_synergy += 1
			wood_sec_synergy += 1
		if click_power_synergy == 2:
			click_power *= (15 * click_multiplier)
		if wood_sec_synergy == 2:
			wood_sec *= 15
	if fertile_soil_toggle == true:
		wood_sec *= 4
	if smart_workers_toggle == true:
		worker_efficency *= 5
	prestiges += 1
	save()
	load_data()

func _on_prestige_shop_pressed() -> void:
	if prestiges > 0:
		shop_tab = 3

func _on_theyre_mine_pressed() -> void:
	if golden_seed > 4:
		golden_seed -= 5
		theyre_mine_toggle = true
		$"Shop/Prestige Upgrades/They're mine!".hide()

func _on_fertile_soil_pressed() -> void:
	if golden_seed > 9:
		golden_seed -= 10
		click_power *= 4
		wood_sec *= 4
		fertile_soil_toggle = true
		$"Shop/Prestige Upgrades/Fertile Soil".hide()

func _on_smart_workers_pressed() -> void:
	if golden_seed > 9:
		golden_seed -= 10
		worker_efficency *= 5
		wood_sec += (worker_amount * 1 * (worker_efficency - 1))  # Line to be tested
		smart_workers_toggle = true
		$"Shop/Prestige Upgrades/Smart Workers".hide()

func _on_autobuyer_i_pressed() -> void:
	if golden_seed > 19:
		golden_seed -= 20
		autobuyer_i_toggle = true
		$"Shop/Prestige Upgrades/Autobuyer I".hide()

func _on_golden_saw_pressed() -> void:
	if golden_seed > 24:
		golden_seed -= 25
		click_power *= 10
		golden_saw_toggle = true
		$"Shop/Prestige Upgrades/Golden Saw".hide()

func _on_saw_efficency_pressed() -> void:
	if golden_seed > 49:
		golden_seed -= 50
		wood_sec *= 15
		saw_efficency_toggle = true
		$"Shop/Prestige Upgrades/Saw Efficency".hide()

func _on_prestige_boost_pressed() -> void:
	if golden_seed > 99:
		golden_seed -= 100
		golden_seed_multipiler *= 2
		prestige_boost_toggle = true
		$"Shop/Prestige Upgrades/Prestige Boost".hide()

func _on_discount_pressed() -> void:
	pass # Replace with function body.

func _on_autobuyer_ii_pressed() -> void:
	if golden_seed > 99:
		golden_seed -= 100
		autobuyer_ii_toggle = true
		$"Shop/Prestige Upgrades/Autobuyer II".hide()

func _on_autobuyer_iii_pressed() -> void:
	if golden_seed > 199:
		golden_seed -= 200
		autobuyer_iii_toggle = true
		$"Shop/Prestige Upgrades/Autobuyer III".show()

func _on_autobuyer_timer_timeout() -> void:
	if autobuyer_i_toggle == true:
		if wood > axe_skill_cost - 1:
			if axe_skill_cost < 100001:
				wood -= round(axe_skill_cost) 
				click_power += 1 * click_multiplier
				axe_skill_cost *= cost_multiplier
				axe_skills_amount += 1
		if wood > worker_cost - 1:
			if worker_cost < 100001:
				wood -= round(worker_cost)
				wood_sec += 1 * cost_multiplier
				worker_cost *= 1.2
				worker_amount += 1
		if wood > worker_cost - 1:
			if worker_cost < 100001:
				wood -= round(worker_cost)
				wood_sec += 1 * cost_multiplier
				worker_cost *= 1.2
				worker_amount += 1
	if autobuyer_ii_toggle == true:
		if wood > axe_reforge_cost - 1:
			if axe_reforge_cost < 100001:
				wood -= round(axe_reforge_cost) 
				click_power += 1 * click_multiplier
				axe_skill_cost *= cost_multiplier
				axe_skills_amount += 1
		if wood > lumberjack_team_cost - 1:
			if lumberjack_team_cost < 100001:
				wood -= round(lumberjack_team_cost)
				wood_sec += 25
				lumberjack_team_cost *= cost_multiplier
				lumberjack_team_amount += 1
		if wood > chainsaw_fleet_cost - 1:
			if chainsaw_fleet_cost < 100001:
				wood -= round(chainsaw_fleet_cost)
				wood_sec += 80 * chainsaw_fleet_efficency
				chainsaw_fleet_cost *= cost_multiplier
				chainsaw_fleet_amount += 1
	if autobuyer_iii_toggle == true:
		if wood > bulldozers_cost - 1:
			if bulldozers_cost < 100001:
				wood -= round(bulldozers_cost)
				wood_sec += 200 * vehicle_efficency
				bulldozers_cost *= cost_multiplier
				bulldozers_amount += 1
		if wood > tree_harvester_cost - 1:
			if tree_harvester_cost < 100001:
				wood -= round(tree_harvester_cost)
				wood_sec += 600 * vehicle_efficency
				tree_harvester_cost *= cost_multiplier
				tree_havester_amount += 1
		if wood > industrial_mulcher_cost - 1:
			if industrial_mulcher_cost < 100001:
				wood -= round(industrial_mulcher_cost)
				wood_sec += 4000 * vehicle_efficency
				industrial_mulcher_cost *= cost_multiplier
				industrial_mulcher_amount += 1
