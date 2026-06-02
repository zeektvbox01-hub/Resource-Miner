extends Node2D

# ============================================================================
# CONSTANTS
# ============================================================================
const SAVE_PATH = "user://variable.save"
const VERSION = 1
const MAX_WOOD = 100000000000
const MAX_CLICK_POWER = 50000000000
const MAX_WOOD_SEC = 50000000000
const COST_MULTIPLIER_DEFAULT = 1.35

# ============================================================================
# UPGRADE DEFINITIONS (Data-Driven Approach)
# ============================================================================
class UpgradeData:
	var id: String
	var base_cost: float
	var cost_multiplier: float
	var base_income: float
	var amount: int = 0
	
	func _init(p_id: String, p_cost: float, p_multiplier: float, p_income: float):
		id = p_id
		base_cost = p_cost
		cost_multiplier = p_multiplier
		base_income = p_income

# Multi-time upgrades
var upgrades = {
	"axe_skill": UpgradeData.new("axe_skill", 15, COST_MULTIPLIER_DEFAULT, 1),
	"worker": UpgradeData.new("worker", 50, 1.2, 1),
	"hand_saw": UpgradeData.new("hand_saw", 250, COST_MULTIPLIER_DEFAULT, 4),
	"axe_reforge": UpgradeData.new("axe_reforge", 1200, COST_MULTIPLIER_DEFAULT, 15),
	"lumberjack_team": UpgradeData.new("lumberjack_team", 3000, COST_MULTIPLIER_DEFAULT, 25),
	"chainsaw_fleet": UpgradeData.new("chainsaw_fleet", 8500, COST_MULTIPLIER_DEFAULT, 80),
	"bulldozers": UpgradeData.new("bulldozers", 25000, COST_MULTIPLIER_DEFAULT, 200),
	"tree_harvester": UpgradeData.new("tree_harvester", 65000, COST_MULTIPLIER_DEFAULT, 600),
	"industrial_mulcher": UpgradeData.new("industrial_mulcher", 90000, COST_MULTIPLIER_DEFAULT, 1000),
}

# One-time upgrades (toggle-based)
var one_time_upgrades = {
	"reinforced_gloves": false,
	"coffee_machine": false,
	"steel_axe_head": false,
	"turbochargers": false,
	"log_flume": false,
	"gps_mapping": false,
	"shift_management": false,
	"carbon_fiber_saws": false,
	"diamond_coated_teeth": false,
	"automation_logic_controller": false,
	"vertical_intergration": false,
	"the_eternal_forest": false,
	"lunch_break_schudule": false,
}

# Prestige upgrades (toggle-based)
var prestige_upgrades = {
	"theyre_mine": false,
	"fertile_soil": false,
	"smart_workers": false,
	"autobuyer_i": false,
	"golden_saw": false,
	"saw_efficency": false,
	"prestige_boost": false,
	"discount": false,
	"autobuyer_ii": false,
	"autobuyer_iii": false,
}

# ============================================================================
# GAME STATE
# ============================================================================
var wood: int = 0
var wood_sec: float = 0
var golden_seed: int = 0
var prestiges: int = 0

# Click mechanics
var click_power: int = 1
var click_multiplier: float = 1.0
var crictical_click: float = 0.0

# Efficiency multipliers
var worker_efficency: float = 1.0
var vehicle_efficency: float = 1.0
var chainsaw_fleet_efficency: float = 1.0
var idle_efficency: float = 1.0
var golden_seed_multipiler: float = 1.0

# Game state
var cost_multiplier: float = COST_MULTIPLIER_DEFAULT
var shop_open: bool = false
var shop_tab: int = 1
var currency_button_tab: int = 1
var last_save_time: int = 0

# ============================================================================
# LIFECYCLE
# ============================================================================
func _ready() -> void:
	load_data()
	$Unused.hide()

func _process(_delta: float) -> void:
	update_ui()
	handle_input()
	handle_shop_state()

func _on_wood_timer_timeout() -> void:
	if wood < MAX_WOOD and wood_sec < MAX_WOOD_SEC:
		wood += int(wood_sec)

func _on_autosave_timer_timeout() -> void:
	save()

# ============================================================================
# UI UPDATES
# ============================================================================
func update_ui() -> void:
	update_currency_display()
	update_upgrade_displays()
	update_clamp_values()

func update_currency_display() -> void:
	if wood < 100000000001:
		$"Currency Bar"/Wood.text = str(wood)
	if wood_sec < 50000000001:
		$"Currency Bar/Wood per sec".text = str(int(wood_sec)) + "/sec"
	if golden_seed < 100001:
		$"Currency Bar/Golden Seeds".text = str(golden_seed)
	$Instruction.text = "Click to get " + str(click_power) + " wood"

func update_upgrade_displays() -> void:
	# Multi-time upgrades
	var upgrade_node = $"Shop/Multi-Time Upgrades"
	
	$"Shop/Multi-Time Upgrades/Axe Skills".text = "Axe Skills - %d wood\n(%d/click -> %d/click)" % [
		int(upgrades["axe_skill"].base_cost * pow(upgrades["axe_skill"].cost_multiplier, upgrades["axe_skill"].amount)),
		click_power, click_power + int(1 * click_multiplier)
	]
	$"Shop/Multi-Time Upgrades/Worker".text = "Worker - %d wood\n(%d/sec -> %d/sec)" % [
		int(upgrades["worker"].base_cost * pow(upgrades["worker"].cost_multiplier, upgrades["worker"].amount)),
		int(wood_sec), int(wood_sec + 1 * worker_efficency)
	]
	$"Shop/Multi-Time Upgrades/Hand Saw".text = "Hand Saw - %d wood\n(%d/sec -> %d/sec)" % [
		int(upgrades["hand_saw"].base_cost * pow(upgrades["hand_saw"].cost_multiplier, upgrades["hand_saw"].amount)),
		int(wood_sec), int(wood_sec + 4)
	]
	$"Shop/Multi-Time Upgrades/Axe Reforge".text = "Axe Reforge - %d wood\n(%d/click -> %d/click)" % [
		int(upgrades["axe_reforge"].base_cost * pow(upgrades["axe_reforge"].cost_multiplier, upgrades["axe_reforge"].amount)),
		click_power, click_power + int(15 * click_multiplier)
	]
	$"Shop/Multi-Time Upgrades/Lumberjack Team".text = "Lumberjack Team - %d wood\n(%d/sec -> %d/sec)" % [
		int(upgrades["lumberjack_team"].base_cost * pow(upgrades["lumberjack_team"].cost_multiplier, upgrades["lumberjack_team"].amount)),
		int(wood_sec), int(wood_sec + 25)
	]
	$"Shop/Multi-Time Upgrades/Chainsaw Fleet".text = "Chainsaw Fleet - %d wood\n(%d/sec -> %d/sec)" % [
		int(upgrades["chainsaw_fleet"].base_cost * pow(upgrades["chainsaw_fleet"].cost_multiplier, upgrades["chainsaw_fleet"].amount)),
		int(wood_sec), int(wood_sec + int(80 * chainsaw_fleet_efficency))
	]
	$"Shop/Multi-Time Upgrades/Bulldozers".text = "Bulldozers - %d wood\n(%d/sec -> %d/sec)" % [
		int(upgrades["bulldozers"].base_cost * pow(upgrades["bulldozers"].cost_multiplier, upgrades["bulldozers"].amount)),
		int(wood_sec), int(wood_sec + int(200 * vehicle_efficency))
	]
	$"Shop/Multi-Time Upgrades/Tree Harvester".text = "Tree Harvester - %d wood\n(%d/sec -> %d/sec)" % [
		int(upgrades["tree_harvester"].base_cost * pow(upgrades["tree_harvester"].cost_multiplier, upgrades["tree_harvester"].amount)),
		int(wood_sec), int(wood_sec + int(600 * vehicle_efficency))
	]
	$"Shop/Multi-Time Upgrades/Industrial Mulcher".text = "Industrial Mulcher - %d wood\n(%d/sec -> %d/sec)" % [
		int(upgrades["industrial_mulcher"].base_cost * pow(upgrades["industrial_mulcher"].cost_multiplier, upgrades["industrial_mulcher"].amount)),
		int(wood_sec), int(wood_sec + int(1000 * vehicle_efficency))
	]
	$"Shop/Multi-Time Upgrades/Axe Skills/Axe Skill Amount".text = str(upgrades["axe_skill"].amount)
	$"Shop/Multi-Time Upgrades/Worker/Worker Amount".text = str(upgrades["worker"].amount)
	$"Shop/Multi-Time Upgrades/Hand Saw/Hand Saw Amount".text = str(upgrades["hand_saw"].amount)
	$"Shop/Multi-Time Upgrades/Axe Reforge/Axe Reforge Amount".text = str(upgrades["axe_reforge"].amount)
	$"Shop/Multi-Time Upgrades/Lumberjack Team/Lumberjack Team Amount".text = str(upgrades["lumberjack_team"].amount)
	$"Shop/Multi-Time Upgrades/Chainsaw Fleet/Chainsaw Fleet Amount".text = str(upgrades["chainsaw_fleet"].amount)
	$"Shop/Multi-Time Upgrades/Bulldozers/Bulldozers Amount".text = str(upgrades["bulldozers"].amount)
	$"Shop/Multi-Time Upgrades/Tree Harvester/Tree Harvester Amount".text = str(upgrades["tree_harvester"].amount)
	$"Shop/Multi-Time Upgrades/Industrial Mulcher/Industrial Mulcher Amount".text = str(upgrades["industrial_mulcher"].amount)

func update_clamp_values() -> void:
	click_power = clampi(click_power, 0, MAX_CLICK_POWER)
	wood_sec = clampf(wood_sec, 0, MAX_WOOD_SEC)
	wood = clampi(wood, 0, MAX_WOOD)
	if wood > 9999999:
		$"Shop/One-Time Upgrades/Prestige".show()
	else:
		$"Shop/One-Time Upgrades/Prestige".hide()

func handle_input() -> void:
	if Input.is_action_pressed("+ 1000000 wood"):
		wood += 1000000
	if Input.is_action_pressed("+ 1000 golden seeds"):
		golden_seed += 1000

func handle_shop_state() -> void:
	if shop_open:
		$"Shop/Shop Background".show()
		$Shop/Tabs.show()
		$Clicker.hide()
		$Trees.hide()
		$"Save+Load".hide()
		show_shop_tab(shop_tab)
	else:
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
	else:
		$"Currency Bar/Wood Icon".hide()
		$"Currency Bar/Wood per sec".hide()
		$"Currency Bar/Wood".hide()
		$"Currency Bar/Gold Seed Icon".show()
		$"Currency Bar/Golden Seeds".show()

func show_shop_tab(tab: int) -> void:
	match tab:
		1:
			$"Shop/One-Time Upgrades".hide()
			$"Shop/Multi-Time Upgrades".show()
			$"Shop/Prestige Upgrades".hide()
		2:
			$"Shop/Multi-Time Upgrades".hide()
			$"Shop/One-Time Upgrades".show()
			$"Shop/Prestige Upgrades".hide()
		3:
			$"Shop/Multi-Time Upgrades".hide()
			$"Shop/One-Time Upgrades".hide()
			$"Shop/Prestige Upgrades".show()

func _on_multi_time_upgrades_tab_pressed() -> void:
	shop_tab = 1

func _on_one_time_upgrades_tab_pressed() -> void:
	shop_tab = 2

# ============================================================================
# CLICK MECHANICS
# ============================================================================
func _on_clicker_pressed() -> void:
	var critical_roll: float = randf()
	if crictical_click + 1 > round(critical_roll * 1000.0) / 1000.0:
		wood += int(click_power * click_multiplier * 2)
	else:
		wood += int(click_power * click_multiplier)

func _on_tree_pressed() -> void:
	var tree_wood_amount = randi() % 6
	if tree_wood_amount == 2:
		wood += 1 * click_power
	if tree_wood_amount == 3:
		wood += 1 * click_power
	if tree_wood_amount == 4:
		wood += 2 * click_power
	if tree_wood_amount == 5:
		wood += 3 * click_power

# ============================================================================
# MULTI-TIME UPGRADE PURCHASES
# ============================================================================
func try_buy_upgrade(upgrade_id: String) -> bool:
	if not upgrade_id in upgrades:
		return false
	
	var upgrade = upgrades[upgrade_id]
	var current_cost = int(upgrade.base_cost * pow(upgrade.cost_multiplier, upgrade.amount))
	
	if wood >= current_cost and current_cost < 100000000001:
		wood -= current_cost
		upgrade.amount += 1
		return true
	return false

func _on_axe_skills_pressed() -> void:
	if wood > upgrades["axe_skill"].base_cost * pow(upgrades["axe_skill"].cost_multiplier, upgrades["axe_skill"].amount) - 1:
		if upgrades["axe_skill"].base_cost * pow(upgrades["axe_skill"].cost_multiplier, upgrades["axe_skill"].amount) < 100000000001:
			wood -= int(upgrades["axe_skill"].base_cost * pow(upgrades["axe_skill"].cost_multiplier, upgrades["axe_skill"].amount))
			click_power += int(1 * click_multiplier)
			upgrades["axe_skill"].amount += 1

func _on_worker_pressed() -> void:
	if wood > upgrades["worker"].base_cost * pow(upgrades["worker"].cost_multiplier, upgrades["worker"].amount) - 1:
		if upgrades["worker"].base_cost * pow(upgrades["worker"].cost_multiplier, upgrades["worker"].amount) < 100000000001:
			wood -= int(upgrades["worker"].base_cost * pow(upgrades["worker"].cost_multiplier, upgrades["worker"].amount))
			wood_sec += 1 * cost_multiplier
			upgrades["worker"].amount += 1

func _on_hand_saw_pressed() -> void:
	if wood > upgrades["hand_saw"].base_cost * pow(upgrades["hand_saw"].cost_multiplier, upgrades["hand_saw"].amount) - 1:
		if upgrades["hand_saw"].base_cost * pow(upgrades["hand_saw"].cost_multiplier, upgrades["hand_saw"].amount) < 100000000001:
			wood -= int(upgrades["hand_saw"].base_cost * pow(upgrades["hand_saw"].cost_multiplier, upgrades["hand_saw"].amount))
			wood_sec += 4
			upgrades["hand_saw"].amount += 1

func _on_axe_reforge_pressed() -> void:
	if wood > upgrades["axe_reforge"].base_cost * pow(upgrades["axe_reforge"].cost_multiplier, upgrades["axe_reforge"].amount) - 1:
		if upgrades["axe_reforge"].base_cost * pow(upgrades["axe_reforge"].cost_multiplier, upgrades["axe_reforge"].amount) < 100000000001:
			wood -= int(upgrades["axe_reforge"].base_cost * pow(upgrades["axe_reforge"].cost_multiplier, upgrades["axe_reforge"].amount))
			click_power += int(15 * click_multiplier)
			upgrades["axe_reforge"].amount += 1

func _on_lumberjack_team_pressed() -> void:
	if wood > upgrades["lumberjack_team"].base_cost * pow(upgrades["lumberjack_team"].cost_multiplier, upgrades["lumberjack_team"].amount) - 1:
		if upgrades["lumberjack_team"].base_cost * pow(upgrades["lumberjack_team"].cost_multiplier, upgrades["lumberjack_team"].amount) < 100000000001:
			wood -= int(upgrades["lumberjack_team"].base_cost * pow(upgrades["lumberjack_team"].cost_multiplier, upgrades["lumberjack_team"].amount))
			wood_sec += 25
			upgrades["lumberjack_team"].amount += 1

func _on_chainsaw_fleet_pressed() -> void:
	if wood > upgrades["chainsaw_fleet"].base_cost * pow(upgrades["chainsaw_fleet"].cost_multiplier, upgrades["chainsaw_fleet"].amount) - 1:
		if upgrades["chainsaw_fleet"].base_cost * pow(upgrades["chainsaw_fleet"].cost_multiplier, upgrades["chainsaw_fleet"].amount) < 100000000001:
			wood -= int(upgrades["chainsaw_fleet"].base_cost * pow(upgrades["chainsaw_fleet"].cost_multiplier, upgrades["chainsaw_fleet"].amount))
			wood_sec += int(80 * chainsaw_fleet_efficency)
			upgrades["chainsaw_fleet"].amount += 1

func _on_bulldozers_pressed() -> void:
	if wood > upgrades["bulldozers"].base_cost * pow(upgrades["bulldozers"].cost_multiplier, upgrades["bulldozers"].amount) - 1:
		if upgrades["bulldozers"].base_cost * pow(upgrades["bulldozers"].cost_multiplier, upgrades["bulldozers"].amount) < 100000000001:
			wood -= int(upgrades["bulldozers"].base_cost * pow(upgrades["bulldozers"].cost_multiplier, upgrades["bulldozers"].amount))
			wood_sec += int(200 * vehicle_efficency)
			upgrades["bulldozers"].amount += 1

func _on_tree_harvester_pressed() -> void:
	if wood > upgrades["tree_harvester"].base_cost * pow(upgrades["tree_harvester"].cost_multiplier, upgrades["tree_harvester"].amount) - 1:
		if upgrades["tree_harvester"].base_cost * pow(upgrades["tree_harvester"].cost_multiplier, upgrades["tree_harvester"].amount) < 100000000001:
			wood -= int(upgrades["tree_harvester"].base_cost * pow(upgrades["tree_harvester"].cost_multiplier, upgrades["tree_harvester"].amount))
			wood_sec += int(600 * vehicle_efficency)
			upgrades["tree_harvester"].amount += 1

func _on_industrial_mulcher_pressed() -> void:
	if wood > upgrades["industrial_mulcher"].base_cost * pow(upgrades["industrial_mulcher"].cost_multiplier, upgrades["industrial_mulcher"].amount) - 1:
		if upgrades["industrial_mulcher"].base_cost * pow(upgrades["industrial_mulcher"].cost_multiplier, upgrades["industrial_mulcher"].amount) < 100000000001:
			wood -= int(upgrades["industrial_mulcher"].base_cost * pow(upgrades["industrial_mulcher"].cost_multiplier, upgrades["industrial_mulcher"].amount))
			wood_sec += int(1000 * vehicle_efficency)
			upgrades["industrial_mulcher"].amount += 1

# ============================================================================
# ONE-TIME UPGRADES
# ============================================================================
func _on_reinforced_gloves_pressed() -> void:
	if wood > 499:
		wood -= 500
		click_multiplier *= 2
		click_power += (upgrades["axe_reforge"].amount * 15) + upgrades["axe_skill"].amount
		one_time_upgrades["reinforced_gloves"] = true
		$"Shop/One-Time Upgrades/Reinforced Gloves".hide()
		save()

func _on_coffee_machine_pressed() -> void:
	if wood > 1199:
		wood -= 1200
		worker_efficency *= 1.1
		wood_sec += (upgrades["worker"].amount * 1 * (worker_efficency - 1))
		one_time_upgrades["coffee_machine"] = true
		$"Shop/One-Time Upgrades/Coffee Machine".hide()

func _on_steel_axe_head_pressed() -> void:
	if wood > 1199:
		wood -= 1200
		click_power += int(500 * click_multiplier)
		one_time_upgrades["steel_axe_head"] = true
		$"Shop/One-Time Upgrades/Steel Axe Head".hide()

func _on_lunch_break_schudule_pressed() -> void:
	if wood > 3999:
		wood -= 4000
		idle_efficency *= 1.15
		one_time_upgrades["lunch_break_schudule"] = true
		$"Shop/One-Time Upgrades/Lunch Break Schedule".hide()

func _on_turbochargers_pressed() -> void:
	if wood > 74999:
		wood -= 75000
		vehicle_efficency *= 1.25
		wood_sec += ((upgrades["bulldozers"].amount * 200) + (upgrades["tree_harvester"].amount * 600) + (upgrades["industrial_mulcher"].amount * 1000)) * (vehicle_efficency - 1)
		one_time_upgrades["turbochargers"] = true
		$"Shop/One-Time Upgrades/Turbochargers".hide()

func _on_log_flume_pressed() -> void:
	if wood > 199999:
		wood -= 200000
		cost_multiplier -= 0.01
		one_time_upgrades["log_flume"] = true
		$"Shop/One-Time Upgrades/Log Flume".hide()

func _on_gps_mapping_pressed() -> void:
	if wood > 499999:
		wood -= 500000
		crictical_click += 0.044
		one_time_upgrades["gps_mapping"] = true
		$"Shop/One-Time Upgrades/GPS Mapping".hide()

func _on_shift_management_pressed() -> void:
	if wood > 1499999:
		wood -= 1500000
		idle_efficency *= 2
		one_time_upgrades["shift_management"] = true
		$"Shop/One-Time Upgrades/Shift Management".hide()

func _on_carbon_fiber_saws_pressed() -> void:
	if wood > 24999999:
		wood -= 25000000
		chainsaw_fleet_efficency *= 3
		wood_sec += int(chainsaw_fleet_efficency * 80 * (chainsaw_fleet_efficency - 1))
		one_time_upgrades["carbon_fiber_saws"] = true
		$"Shop/One-Time Upgrades/Carbon Fiber Saws".hide()

func _on_diamond_coated_teeth_pressed() -> void:
	if wood > 99999999:
		wood -= 100000000
		click_multiplier *= 4
		click_power += (((upgrades["axe_reforge"].amount * 15) + upgrades["axe_skill"].amount) * int(click_multiplier - 1))
		one_time_upgrades["diamond_coated_teeth"] = true
		$"Shop/One-Time Upgrades/Diamond-Coated Teeth".hide()

func _on_automation_logic_controller_pressed() -> void:
	if wood > 499999999:
		wood -= 500000000
		cost_multiplier -= 0.02
		one_time_upgrades["automation_logic_controller"] = true
		$"Shop/One-Time Upgrades/Automation Logic Controller".hide()

func _on_vertical_intergration_pressed() -> void:
	if wood > 2499999999:
		wood -= 25000000
		wood_sec *= 10
		one_time_upgrades["vertical_intergration"] = true
		$"Shop/One-Time Upgrades/Vertical Intergration".hide()

func _on_the_eternal_forest_pressed() -> void:
	if wood > 9999999999:
		wood -= 10000000000
		click_power *= 10
		wood_sec *= 10
		one_time_upgrades["the_eternal_forest"] = true
		$"Shop/One-Time Upgrades/The Eternal Forest".hide()

# ============================================================================
# PRESTIGE SYSTEM
# ============================================================================
func _on_prestige_pressed() -> void:
	set_process(false)
	
	# Calculate seed gain
	var seed_gain = sqrt(wood / 1000.0) * golden_seed_multipiler
	if seed_gain > 0:
		golden_seed += int(seed_gain)
	
	# Reset progression
	reset_progression()
	
	# Apply prestige synergies
	if prestige_upgrades["theyre_mine"]:
		apply_synergies()
	
	if prestige_upgrades["fertile_soil"]:
		click_power *= 4
		wood_sec *= 4
	
	if prestige_upgrades["smart_workers"]:
		worker_efficency *= 5
		wood_sec += int(upgrades["worker"].amount * 1 * (worker_efficency - 1))
	
	prestiges += 1
	save()
	load_data()

func reset_progression() -> void:
	wood = 0
	click_power = 1
	wood_sec = 0
	
	for upgrade in upgrades.values():
		upgrade.amount = 0
	
	worker_efficency = 1
	click_multiplier = 1
	vehicle_efficency = 1
	chainsaw_fleet_efficency = 1
	
	if not prestige_upgrades["theyre_mine"]:
		for key in one_time_upgrades:
			one_time_upgrades[key] = false

func apply_synergies() -> void:
	var click_multiplier_synergy = 0
	var worker_synergy = 0
	var wood_sec_synergy = 0
	var click_power_synergy = 0
	
	if one_time_upgrades["reinforced_gloves"]:
		click_multiplier *= 2
		click_multiplier_synergy += 1
	if one_time_upgrades["gps_mapping"]:
		click_multiplier *= 4
		click_multiplier_synergy += 1
	if one_time_upgrades["diamond_coated_teeth"]:
		click_multiplier *= 8
		click_multiplier_synergy += 1
	if click_multiplier_synergy == 3:
		click_multiplier *= 10
	
	if one_time_upgrades["coffee_machine"]:
		worker_efficency *= 1.1
		worker_synergy += 1
	if one_time_upgrades["shift_management"]:
		worker_efficency *= 2
		worker_synergy += 1
	if worker_synergy == 2:
		worker_efficency *= 3
	
	if one_time_upgrades["vertical_intergration"]:
		wood_sec *= 3
		wood_sec_synergy += 1
	if one_time_upgrades["steel_axe_head"]:
		click_power += int(50 * click_multiplier)
		click_power_synergy += 1
	if one_time_upgrades["the_eternal_forest"]:
		wood_sec *= 10
		click_power *= int(10 * click_multiplier)
		click_power_synergy += 1
		wood_sec_synergy += 1
	if click_power_synergy == 2:
		click_power *= int(15 * click_multiplier)
	if wood_sec_synergy == 2:
		wood_sec *= 15


# ============================================================================
# PRESTIGE UPGRADES
# ============================================================================
func _on_prestige_shop_pressed() -> void:
	if prestiges > 0:
		shop_tab = 3

func _on_theyre_mine_pressed() -> void:
	if golden_seed > 4:
		golden_seed -= 5
		prestige_upgrades["theyre_mine"] = true
		$"Shop/Prestige Upgrades/They're mine!".hide()

func _on_fertile_soil_pressed() -> void:
	if golden_seed > 9:
		golden_seed -= 10
		click_power *= 4
		wood_sec *= 4
		prestige_upgrades["fertile_soil"] = true
		$"Shop/Prestige Upgrades/Fertile Soil".hide()

func _on_smart_workers_pressed() -> void:
	if golden_seed > 9:
		golden_seed -= 10
		worker_efficency *= 5
		wood_sec += int(upgrades["worker"].amount * 1 * (worker_efficency - 1))
		prestige_upgrades["smart_workers"] = true
		$"Shop/Prestige Upgrades/Smart Workers".hide()

func _on_autobuyer_i_pressed() -> void:
	if golden_seed > 19:
		golden_seed -= 20
		prestige_upgrades["autobuyer_i"] = true
		$"Shop/Prestige Upgrades/Autobuyer I".hide()

func _on_golden_saw_pressed() -> void:
	if golden_seed > 24:
		golden_seed -= 25
		click_power *= 10
		prestige_upgrades["golden_saw"] = true
		$"Shop/Prestige Upgrades/Golden Saw".hide()

func _on_saw_efficency_pressed() -> void:
	if golden_seed > 49:
		golden_seed -= 50
		wood_sec *= 15
		prestige_upgrades["saw_efficency"] = true
		$"Shop/Prestige Upgrades/Saw Efficency".hide()

func _on_prestige_boost_pressed() -> void:
	if golden_seed > 99:
		golden_seed -= 100
		golden_seed_multipiler *= 2
		prestige_upgrades["prestige_boost"] = true
		$"Shop/Prestige Upgrades/Prestige Boost".hide()

func _on_discount_pressed() -> void:
	pass

func _on_autobuyer_ii_pressed() -> void:
	if golden_seed > 99:
		golden_seed -= 100
		prestige_upgrades["autobuyer_ii"] = true
		$"Shop/Prestige Upgrades/Autobuyer II".hide()

func _on_autobuyer_iii_pressed() -> void:
	if golden_seed > 199:
		golden_seed -= 200
		prestige_upgrades["autobuyer_iii"] = true
		$"Shop/Prestige Upgrades/Autobuyer III".hide()

# ============================================================================
# AUTOBUYER SYSTEM
# ============================================================================
func _on_autobuyer_timer_timeout() -> void:
	if prestige_upgrades["autobuyer_i"]:
		autobuyer_tier_1()
	if prestige_upgrades["autobuyer_ii"]:
		autobuyer_tier_2()
	if prestige_upgrades["autobuyer_iii"]:
		autobuyer_tier_3()

func autobuyer_tier_1() -> void:
	if wood > int(upgrades["axe_skill"].base_cost * pow(upgrades["axe_skill"].cost_multiplier, upgrades["axe_skill"].amount)) - 1:
		if int(upgrades["axe_skill"].base_cost * pow(upgrades["axe_skill"].cost_multiplier, upgrades["axe_skill"].amount)) < 100001:
			wood -= int(upgrades["axe_skill"].base_cost * pow(upgrades["axe_skill"].cost_multiplier, upgrades["axe_skill"].amount))
			click_power += int(1 * click_multiplier)
			upgrades["axe_skill"].amount += 1
	if wood > int(upgrades["worker"].base_cost * pow(upgrades["worker"].cost_multiplier, upgrades["worker"].amount)) - 1:
		if int(upgrades["worker"].base_cost * pow(upgrades["worker"].cost_multiplier, upgrades["worker"].amount)) < 100001:
			wood -= int(upgrades["worker"].base_cost * pow(upgrades["worker"].cost_multiplier, upgrades["worker"].amount))
			wood_sec += 1 * cost_multiplier
			upgrades["worker"].amount += 1
	if wood > int(upgrades["worker"].base_cost * pow(upgrades["worker"].cost_multiplier, upgrades["worker"].amount)) - 1:
		if int(upgrades["worker"].base_cost * pow(upgrades["worker"].cost_multiplier, upgrades["worker"].amount)) < 100001:
			wood -= int(upgrades["worker"].base_cost * pow(upgrades["worker"].cost_multiplier, upgrades["worker"].amount))
			wood_sec += 1 * cost_multiplier
			upgrades["worker"].amount += 1
	if wood > int(upgrades["axe_reforge"].base_cost * pow(upgrades["axe_reforge"].cost_multiplier, upgrades["axe_reforge"].amount)) - 1:
		if int(upgrades["axe_reforge"].base_cost * pow(upgrades["axe_reforge"].cost_multiplier, upgrades["axe_reforge"].amount)) < 100001:
			wood -= int(upgrades["axe_reforge"].base_cost * pow(upgrades["axe_reforge"].cost_multiplier, upgrades["axe_reforge"].amount))
			click_power += int(1 * click_multiplier)
			upgrades["axe_skill"].amount += 1
	if wood > int(upgrades["lumberjack_team"].base_cost * pow(upgrades["lumberjack_team"].cost_multiplier, upgrades["lumberjack_team"].amount)) - 1:
		if int(upgrades["lumberjack_team"].base_cost * pow(upgrades["lumberjack_team"].cost_multiplier, upgrades["lumberjack_team"].amount)) < 100001:
			wood -= int(upgrades["lumberjack_team"].base_cost * pow(upgrades["lumberjack_team"].cost_multiplier, upgrades["lumberjack_team"].amount))
			wood_sec += 25
			upgrades["lumberjack_team"].amount += 1
	if wood > int(upgrades["chainsaw_fleet"].base_cost * pow(upgrades["chainsaw_fleet"].cost_multiplier, upgrades["chainsaw_fleet"].amount)) - 1:
		if int(upgrades["chainsaw_fleet"].base_cost * pow(upgrades["chainsaw_fleet"].cost_multiplier, upgrades["chainsaw_fleet"].amount)) < 100001:
			wood -= int(upgrades["chainsaw_fleet"].base_cost * pow(upgrades["chainsaw_fleet"].cost_multiplier, upgrades["chainsaw_fleet"].amount))
			wood_sec += int(80 * chainsaw_fleet_efficency)
			upgrades["chainsaw_fleet"].amount += 1
	if wood > int(upgrades["bulldozers"].base_cost * pow(upgrades["bulldozers"].cost_multiplier, upgrades["bulldozers"].amount)) - 1:
		if int(upgrades["bulldozers"].base_cost * pow(upgrades["bulldozers"].cost_multiplier, upgrades["bulldozers"].amount)) < 100001:
			wood -= int(upgrades["bulldozers"].base_cost * pow(upgrades["bulldozers"].cost_multiplier, upgrades["bulldozers"].amount))
			wood_sec += int(200 * vehicle_efficency)
			upgrades["bulldozers"].amount += 1

func autobuyer_tier_2() -> void:
	if wood > int(upgrades["tree_harvester"].base_cost * pow(upgrades["tree_harvester"].cost_multiplier, upgrades["tree_harvester"].amount)) - 1:
		if int(upgrades["tree_harvester"].base_cost * pow(upgrades["tree_harvester"].cost_multiplier, upgrades["tree_harvester"].amount)) < 100001:
			wood -= int(upgrades["tree_harvester"].base_cost * pow(upgrades["tree_harvester"].cost_multiplier, upgrades["tree_harvester"].amount))
			wood_sec += int(600 * vehicle_efficency)
			upgrades["tree_harvester"].amount += 1
	if wood > int(upgrades["industrial_mulcher"].base_cost * pow(upgrades["industrial_mulcher"].cost_multiplier, upgrades["industrial_mulcher"].amount)) - 1:
		if int(upgrades["industrial_mulcher"].base_cost * pow(upgrades["industrial_mulcher"].cost_multiplier, upgrades["industrial_mulcher"].amount)) < 100001:
			wood -= int(upgrades["industrial_mulcher"].base_cost * pow(upgrades["industrial_mulcher"].cost_multiplier, upgrades["industrial_mulcher"].amount))
			wood_sec += int(1000 * vehicle_efficency)
			upgrades["industrial_mulcher"].amount += 1

func autobuyer_tier_3() -> void:
	pass

# ============================================================================
# SAVE/LOAD SYSTEM
# ============================================================================
func save() -> void:
	last_save_time = Time.get_ticks_msec() / 1000
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	
	file.store_var(VERSION)
	file.store_var(wood)
	file.store_var(click_power)
	file.store_var(wood_sec)
	file.store_var(golden_seed)
	file.store_var(prestiges)
	file.store_var(click_multiplier)
	file.store_var(worker_efficency)
	file.store_var(vehicle_efficency)
	file.store_var(chainsaw_fleet_efficency)
	file.store_var(idle_efficency)
	file.store_var(golden_seed_multipiler)
	file.store_var(cost_multiplier)
	file.store_var(crictical_click)
	file.store_var(last_save_time)
	
	# Save upgrade amounts
	file.store_var(upgrades["axe_skill"].amount)
	file.store_var(upgrades["worker"].amount)
	file.store_var(upgrades["hand_saw"].amount)
	file.store_var(upgrades["axe_reforge"].amount)
	file.store_var(upgrades["lumberjack_team"].amount)
	file.store_var(upgrades["chainsaw_fleet"].amount)
	file.store_var(upgrades["bulldozers"].amount)
	file.store_var(upgrades["tree_harvester"].amount)
	file.store_var(upgrades["industrial_mulcher"].amount)
	
	# Save one-time upgrade toggles
	for upgrade_id in one_time_upgrades:
		file.store_var(one_time_upgrades[upgrade_id])
	
	# Save prestige upgrade toggles
	for upgrade_id in prestige_upgrades:
		file.store_var(prestige_upgrades[upgrade_id])

func load_data() -> void:
	if not FileAccess.file_exists(SAVE_PATH):
		print("No Data is avalible")
		set_process(true)
		return
	
	set_process(false)
	var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	
	# Load basic state
	file.get_var()  # version
	wood = file.get_var()
	click_power = file.get_var()
	wood_sec = file.get_var()
	golden_seed = file.get_var()
	prestiges = file.get_var()
	click_multiplier = file.get_var()
	worker_efficency = file.get_var()
	vehicle_efficency = file.get_var()
	chainsaw_fleet_efficency = file.get_var()
	idle_efficency = file.get_var()
	golden_seed_multipiler = file.get_var()
	cost_multiplier = file.get_var()
	crictical_click = file.get_var()
	last_save_time = file.get_var()
	
	# Load upgrade amounts
	upgrades["axe_skill"].amount = file.get_var()
	upgrades["worker"].amount = file.get_var()
	upgrades["hand_saw"].amount = file.get_var()
	upgrades["axe_reforge"].amount = file.get_var()
	upgrades["lumberjack_team"].amount = file.get_var()
	upgrades["chainsaw_fleet"].amount = file.get_var()
	upgrades["bulldozers"].amount = file.get_var()
	upgrades["tree_harvester"].amount = file.get_var()
	upgrades["industrial_mulcher"].amount = file.get_var()
	
	# Load one-time upgrade toggles
	for upgrade_id in one_time_upgrades:
		one_time_upgrades[upgrade_id] = file.get_var()
	
	# Load prestige upgrade toggles
	for upgrade_id in prestige_upgrades:
		prestige_upgrades[upgrade_id] = file.get_var()
	
	# Hide purchased upgrades
	refresh_upgrade_visibility()
	
	# Calculate idle gains
	var current_time = Time.get_ticks_msec() / 1000.0
	var seconds_away = current_time - last_save_time
	wood += int(seconds_away * wood_sec * idle_efficency)
	
	file.close()
	set_process(true)

func refresh_upgrade_visibility() -> void:
	# One-time upgrades
	if one_time_upgrades["reinforced_gloves"]:
		$"Shop/One-Time Upgrades/Reinforced Gloves".hide()
	if one_time_upgrades["coffee_machine"]:
		$"Shop/One-Time Upgrades/Coffee Machine".hide()
	if one_time_upgrades["steel_axe_head"]:
		$"Shop/One-Time Upgrades/Steel Axe Head".hide()
	if one_time_upgrades["turbochargers"]:
		$"Shop/One-Time Upgrades/Turbochargers".hide()
	if one_time_upgrades["log_flume"]:
		$"Shop/One-Time Upgrades/Log Flume".hide()
	if one_time_upgrades["gps_mapping"]:
		$"Shop/One-Time Upgrades/GPS Mapping".hide()
	if one_time_upgrades["shift_management"]:
		$"Shop/One-Time Upgrades/Shift Management".hide()
	if one_time_upgrades["carbon_fiber_saws"]:
		$"Shop/One-Time Upgrades/Carbon Fiber Saws".hide()
	if one_time_upgrades["diamond_coated_teeth"]:
		$"Shop/One-Time Upgrades/Diamond-Coated Teeth".hide()
	if one_time_upgrades["automation_logic_controller"]:
		$"Shop/One-Time Upgrades/Automation Logic Controller".hide()
	if one_time_upgrades["vertical_intergration"]:
		$"Shop/One-Time Upgrades/Vertical Intergration".hide()
	if one_time_upgrades["the_eternal_forest"]:
		$"Shop/One-Time Upgrades/The Eternal Forest".hide()
	if one_time_upgrades["lunch_break_schudule"]:
		$"Shop/One-Time Upgrades/Lunch Break Schedule".hide()
	
	# Prestige upgrades
	if prestige_upgrades["theyre_mine"]:
		$"Shop/Prestige Upgrades/They're mine!".hide()
	if prestige_upgrades["fertile_soil"]:
		$"Shop/Prestige Upgrades/Fertile Soil".hide()
	if prestige_upgrades["smart_workers"]:
		$"Shop/Prestige Upgrades/Smart Workers".hide()
	if prestige_upgrades["autobuyer_i"]:
		$"Shop/Prestige Upgrades/Autobuyer I".hide()
	if prestige_upgrades["golden_saw"]:
		$"Shop/Prestige Upgrades/Golden Saw".hide()
	if prestige_upgrades["saw_efficency"]:
		$"Shop/Prestige Upgrades/Saw Efficency".hide()
	if prestige_upgrades["prestige_boost"]:
		$"Shop/Prestige Upgrades/Prestige Boost".hide()
	if prestige_upgrades["discount"]:
		$"Shop/Prestige Upgrades/Discount".hide()
	if prestige_upgrades["autobuyer_ii"]:
		$"Shop/Prestige Upgrades/Autobuyer II".hide()
	if prestige_upgrades["autobuyer_iii"]:
		$"Shop/Prestige Upgrades/Autobuyer III".hide()

func _on_save_button_pressed() -> void:
	save()

func _on_load_button_pressed() -> void:
	load_data()

func _on_shop_toggle_pressed() -> void:
	shop_open = !shop_open

func _on_currency_button_pressed() -> void:
	currency_button_tab = 2 if currency_button_tab == 1 else 1



func _on_lunch_break_schedule_pressed() -> void:
	pass # Replace with function body.
