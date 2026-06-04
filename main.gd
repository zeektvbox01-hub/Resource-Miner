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
	"worker": UpgradeData.new("worker", 50, COST_MULTIPLIER_DEFAULT, 1),
	"hand_saw": UpgradeData.new("hand_saw", 250, COST_MULTIPLIER_DEFAULT, 4),
	"axe_reforge": UpgradeData.new("axe_reforge", 1200, COST_MULTIPLIER_DEFAULT, 15),
	"reinforced_handle": UpgradeData.new("reinforced_handle", 2500, COST_MULTIPLIER_DEFAULT, 40),
	"lumberjack_team": UpgradeData.new("lumberjack_team", 3000, COST_MULTIPLIER_DEFAULT, 35),
	"titanium_edge": UpgradeData.new("titanimum_edge", 8000, COST_MULTIPLIER_DEFAULT, 120),
	"chainsaw_fleet": UpgradeData.new("chainsaw_fleet", 8500, COST_MULTIPLIER_DEFAULT, 110),
	"bulldozers": UpgradeData.new("bulldozers", 25000, COST_MULTIPLIER_DEFAULT, 300),
	"diamond_plating": UpgradeData.new("diamond_plating", 35000, COST_MULTIPLIER_DEFAULT, 450),
	"tree_harvester": UpgradeData.new("tree_harvester", 65000, COST_MULTIPLIER_DEFAULT, 600),
	"industrial_mulcher": UpgradeData.new("industrial_mulcher", 90000, COST_MULTIPLIER_DEFAULT, 1000),
	"plasma_cutter": UpgradeData.new("plasma_cutter", 140000, COST_MULTIPLIER_DEFAULT, 1800),
	"mass_processing_plant": UpgradeData.new("mass_processing_plant", 160000, COST_MULTIPLIER_DEFAULT, 2200),
	"automated_logging_rig": UpgradeData.new("automated_logging_rig", 555000, COST_MULTIPLIER_DEFAULT, 8000),
	"monoculer_slicer": UpgradeData.new("monocular_slicer", 600000, COST_MULTIPLIER_DEFAULT, 8000),
	"bio_diesel_fleet": UpgradeData.new("bio_diesel_fleet", 1900000, COST_MULTIPLIER_DEFAULT, 28000),
	"gravity_axe": UpgradeData.new("gravity_axe", 22000000, COST_MULTIPLIER_DEFAULT, 35000),
	"forest_strip_miner": UpgradeData.new("forest_strip_miner", 7500000, COST_MULTIPLIER_DEFAULT, 110000),
	"quantum_disintegrator": UpgradeData.new("quantum_disintegrator", 25000000, COST_MULTIPLIER_DEFAULT, 320000),
	"atomic_harvester": UpgradeData.new("atomic_harvester", 40000000, COST_MULTIPLIER_DEFAULT, 850000),
	"monocular_separator": UpgradeData.new("monocular_separator", 110000000, COST_MULTIPLIER_DEFAULT, 1600000),
	"solar_forged_blade": UpgradeData.new("solar_forged_blade", 120000000, COST_MULTIPLIER_DEFAULT, 1700000),
	"orbital_collecter": UpgradeData.new("solar_forged_blade", 480000000, COST_MULTIPLIER_DEFAULT, 7500000),
	"reality_ripper": UpgradeData.new("solar_forged_blade", 600000000, COST_MULTIPLIER_DEFAULT, 9000000),
	"continental_logger": UpgradeData.new("continental_logger", 2200000000, COST_MULTIPLIER_DEFAULT, 32000000),
	"the_infinite_click": UpgradeData.new("the_infinite_click", 4000000000, COST_MULTIPLIER_DEFAULT, 55000000),
	"galatic_harvester": UpgradeData.new("galatic_harvester", 4500000000, COST_MULTIPLIER_DEFAULT, 110000000),
	"big_bang_strike": UpgradeData.new("big_bang_strike", 5000000000, COST_MULTIPLIER_DEFAULT, 115000000),
	"nebula_processer": UpgradeData.new("nebula_processer", 12000000000, COST_MULTIPLIER_DEFAULT, 320000000),
	"planetery_extraction_node": UpgradeData.new("planetery_extraction_node", 13000000000, COST_MULTIPLIER_DEFAULT, 360000000),
	"supernova_chopper": UpgradeData.new("supernova_chopper", 15000000000, COST_MULTIPLIER_DEFAULT, 430000000),
	"black_hole_extractor": UpgradeData.new("black_hole_extractor", 45000000000, COST_MULTIPLIER_DEFAULT, 1400000000000),
	"galaxy_splitter": UpgradeData.new("galaxy_splitter", 50000000000, COST_MULTIPLIER_DEFAULT, 1600000000000),
	"solar_system_silo":UpgradeData.new("solar_system_silo", 85000000000, COST_MULTIPLIER_DEFAULT, 3000000000000),
	"dyson_sphere_network": UpgradeData.new("dyson_sphere_network", 160000000000, COST_MULTIPLIER_DEFAULT, 6000000000000),
	"dimension_sphere": UpgradeData.new("dimension_sphere", 180000000000, COST_MULTIPLIER_DEFAULT, 7500000000000),
	"physics_rewriter": UpgradeData.new("physics_rewriter", 400000000000, COST_MULTIPLIER_DEFAULT, 18000000000000),
	"timeline_convergence": UpgradeData.new("timeline_convergence", 400000000000, COST_MULTIPLIER_DEFAULT, 18000000000000),
	"infinite_energy_engine": UpgradeData.new("infinite_energy_engine", 550000000000, COST_MULTIPLIER_DEFAULT, 26000000000000),
	"absolute_tap": UpgradeData.new("absolute_tap", 850000000000, COST_MULTIPLIER_DEFAULT, 26000000000000),
	"resource_singualrity": UpgradeData.new("resource_singularity", 900000000000, COST_MULTIPLIER_DEFAULT, 26000000000000),
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
	"golden_axe": false,
	"saw_efficency": false,
	"prestige_boost": false,
	"discount": false,
	"autobuyer_ii": false,
	"wood_bank": false,
	"new_tools": false,
	"golden_saw": false,
	"autobuyer_iii": false,
	"seed_boost": false,
	"discount+": false,
	"golden_handle": false,
	"autobuyer_boost": false,
	"cost_efficency": false,
	"autobuyer_iv": false,
	"cosmic_hq": false,
	"golden_plasma_cutter": false,
	"wood_saving_account": false,
	"autobuyer_v": false,
	"milky_way_hq": false,
	"careful_scavenging": false,
	"autobuyer_vi": false,
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
	if OS.get_name() == "Web":
		# Web-specific settings
		get_window().gui_embed_subwindows = true
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
	for upgrade_id in upgrades:
		var upgrade = upgrades[upgrade_id]
		var current_cost = upgrade.base_cost * pow(upgrade.cost_multiplier, upgrade.amount)
		var next_income = upgrade.base_income
		
		var node_path = "Shop/Multi-Time Upgrades/" + upgrade_id.to_pascal_case()
		var amount_node_path = node_path + "/Amount"
		
		if has_node(node_path):
			var display_cost = format_number(current_cost)
			var display_current_income = format_number(wood_sec)
			var display_next_income = format_number(wood_sec + next_income)
			
			get_node(node_path).text = "%s - %s wood\n(%s/sec -> %s/sec)" % [
				upgrade_id.to_pascal_case(),
				display_cost,
				display_current_income,
				display_next_income
			]
		
		if has_node(amount_node_path):
			get_node(amount_node_path).text = str(upgrade.amount)

func format_number(num: float) -> String:
	if num >= 1e15:  # Quadrillion
		return "%.2fQ" % (num / 1e15)
	elif num >= 1e12:  # Trillion
		return "%.2fT" % (num / 1e12)
	elif num >= 1e9:  # Billion
		return "%.2fB" % (num / 1e9)
	elif num >= 1e6:  # Million
		return "%.2fM" % (num / 1e6)
	elif num >= 1e3:  # Thousand
		return "%.2fK" % (num / 1e3)
	else:
		return "%.0f" % num

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
	if crictical_click  > round(critical_roll * 1000.0) / 1000.0:
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
			wood_sec += 1 * worker_efficency
			upgrades["worker"].amount += 1

func _on_hand_saw_pressed() -> void:
	if wood > upgrades["hand_saw"].base_cost * pow(upgrades["hand_saw"].cost_multiplier, upgrades["hand_saw"].amount) - 1:
		if upgrades["hand_saw"].base_cost * pow(upgrades["hand_saw"].cost_multiplier, upgrades["hand_saw"].amount) < 100000000001:
			wood -= int(upgrades["hand_saw"].base_cost * pow(upgrades["hand_saw"].cost_multiplier, upgrades["hand_saw"].amount))
			wood_sec += 4 
			upgrades["hand_saw"].amount += 1

func _on_reinforced_handle_pressed() -> void:
	if wood > upgrades["reinforced_handle"].base_cost * pow(upgrades["reinforced_handle"].cost_multiplier, upgrades["reinforced_handle"].amount) - 1:
		if upgrades["reinforced_handle"].base_cost * pow(upgrades["reinforced_handle"].cost_multiplier, upgrades["reinforced_handle"].amount) < 100000000001:
			wood -= int(upgrades["reinforced_handle"].base_cost * pow(upgrades["reinforced_handle"].cost_multiplier, upgrades["reinforced_handle"].amount))
			click_power += int(40 * click_multiplier)
			upgrades["reinforced_handle"].amount += 1

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

func _on_titanium_edge_pressed() -> void:
	if wood > upgrades["titanium_edge"].base_cost * pow(upgrades["titanium_edge"].cost_multiplier, upgrades["titanium_edge"].amount) - 1:
		if upgrades["titanium_edge"].base_cost * pow(upgrades["titanium_edge"].cost_multiplier, upgrades["titanium_edge"].amount) < 100000000001:
			wood -= int(upgrades["titanium_edge"].base_cost * pow(upgrades["titanium_edge"].cost_multiplier, upgrades["titanium_edge"].amount))
			click_power += int(120 * click_multiplier)
			upgrades["titanium_edge"].amount += 1

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

func _on_diamond_plating_pressed() -> void:
	if wood > upgrades["diamond_plating"].base_cost * pow(upgrades["diamond_plating"].cost_multiplier, upgrades["diamond_plating"].amount) - 1:
		if upgrades["diamond_plating"].base_cost * pow(upgrades["diamond_plating"].cost_multiplier, upgrades["diamond_plating"].amount) < 100000000001:
			wood -= int(upgrades["diamond_plating"].base_cost * pow(upgrades["diamond_plating"].cost_multiplier, upgrades["diamond_plating"].amount))
			click_power += int(120 * click_multiplier)
			upgrades["diamond_plating"].amount += 1

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

func _on_plasma_cutter_pressed() -> void:
	if wood > upgrades["plasma_cutter"].base_cost * pow(upgrades["plasma_cutter"].cost_multiplier, upgrades["plasma_cutter"].amount) - 1:
		if upgrades["plasma_cutter"].base_cost * pow(upgrades["plasma_cutter"].cost_multiplier, upgrades["plasma_cutter"].amount) < 100000000001:
			wood -= int(upgrades["plasma_cutter"].base_cost * pow(upgrades["plasma_cutter"].cost_multiplier, upgrades["plasma_cutter"].amount))
			click_power += int(1800 * click_multiplier)
			upgrades["plasma_cutter"].amount += 1

func _on_mass_processing_plant_pressed() -> void:
	if wood > upgrades["mass_processing_plant"].base_cost * pow(upgrades["mass_processing_plant"].cost_multiplier, upgrades["mass_processing_plant"].amount) - 1:
		if upgrades["mass_processing_plant"].base_cost * pow(upgrades["mass_processing_plant"].cost_multiplier, upgrades["mass_processing_plant"].amount) < 100000000001:
			wood -= int(upgrades["mass_processing_plant"].base_cost * pow(upgrades["mass_processing_plant"].cost_multiplier, upgrades["mass_processing_plant"].amount))
			wood_sec += 2200
			upgrades["mass_processing_plant"].amount += 1

func _on_automated_logging_rig_pressed() -> void:
	if wood > upgrades["automated_logging_rig"].base_cost * pow(upgrades["automated_logging_rig"].cost_multiplier, upgrades["automated_logging_rig"].amount) - 1:
		if upgrades["automated_logging_rig"].base_cost * pow(upgrades["automated_logging_rig"].cost_multiplier, upgrades["automated_logging_rig"].amount) < 100000000001:
			wood -= int(upgrades["automated_logging_rig"].base_cost * pow(upgrades["automated_logging_rig"].cost_multiplier, upgrades["automated_logging_rig"].amount))
			wood_sec += 8000
			upgrades["automated_logging_rig"].amount += 1

func _on_monocular_slicer_pressed() -> void:
	if wood > upgrades["monocular_slicer"].base_cost * pow(upgrades["monocular_slicer"].cost_multiplier, upgrades["monocular_slicer"].amount) - 1:
		if upgrades["monocular_slicer"].base_cost * pow(upgrades["monocular_slicer"].cost_multiplier, upgrades["monocular_slicer"].amount) < 100000000001:
			wood -= int(upgrades["monocular_slicer"].base_cost * pow(upgrades["monocular_slicer"].cost_multiplier, upgrades["monocular_slicer"].amount))
			click_power += int(8000 * click_multiplier)
			upgrades["monocular_slicer"].amount += 1

func _on_bio_diesel_fleet_pressed() -> void:
	if wood > upgrades["bio_diesel_fleet"].base_cost * pow(upgrades["bio_diesel_fleet"].cost_multiplier, upgrades["bio_diesel_fleet"].amount) - 1:
		if upgrades["bio_diesel_fleet"].base_cost * pow(upgrades["bio_diesel_fleet"].cost_multiplier, upgrades["bio_diesel_fleet"].amount) < 100000000001:
			wood -= int(upgrades["bio_diesel_fleet"].base_cost * pow(upgrades["bio_diesel_fleet"].cost_multiplier, upgrades["bio_diesel_fleet"].amount))
			wood_sec += 28000
			upgrades["bio_diesel_fleet"].amount += 1

func _on_gravity_axe_pressed() -> void:
	if wood > upgrades["gravity_axe"].base_cost * pow(upgrades["gravity_axe"].cost_multiplier, upgrades["gravity_axe"].amount) - 1:
		if upgrades["gravity_axe"].base_cost * pow(upgrades["gravity_axe"].cost_multiplier, upgrades["gravity_axe"].amount) < 100000000001:
			wood -= int(upgrades["gravity_axe"].base_cost * pow(upgrades["gravity_axe"].cost_multiplier, upgrades["gravity_axe"].amount))
			click_power += int(35000 * click_multiplier)
			upgrades["gravity_axe"].amount += 1

func _on_forest_strip_miner_pressed() -> void:
	if wood > upgrades["forest_strip_miner"].base_cost * pow(upgrades["forest_strip_miner"].cost_multiplier, upgrades["forest_strip_miner"].amount) - 1:
		if upgrades["forest_strip_miner"].base_cost * pow(upgrades["forest_strip_miner"].cost_multiplier, upgrades["forest_strip_miner"].amount) < 100000000001:
			wood -= int(upgrades["forest_strip_miner"].base_cost * pow(upgrades["forest_strip_miner"].cost_multiplier, upgrades["forest_strip_miner"].amount))
			wood_sec += 110000
			upgrades["forest_strip_miner"].amount += 1

func _on_quantum_disintegrator_pressed() -> void:
	if wood > upgrades["quantum_disintegrator"].base_cost * pow(upgrades["quantum_disintegrator"].cost_multiplier, upgrades["quantum_disintegrator"].amount) - 1:
		if upgrades["quantum_disintegrator"].base_cost * pow(upgrades["quantum_disintegrator"].cost_multiplier, upgrades["quantum_disintegrator"].amount) < 100000000001:
			wood -= int(upgrades["quantum_disintegrator"].base_cost * pow(upgrades["quantum_disintegrator"].cost_multiplier, upgrades["quantum_disintegrator"].amount))
			click_power += int(320000 * click_multiplier)
			upgrades["quantum_disintegrator"].amount += 1

func _on_atomic_harvester_pressed() -> void:
	if wood > upgrades["atomic_harvester"].base_cost * pow(upgrades["atomic_harvester"].cost_multiplier, upgrades["atomic_harvester"].amount) - 1:
		if upgrades["atomic_harvester"].base_cost * pow(upgrades["atomic_harvester"].cost_multiplier, upgrades["atomic_harvester"].amount) < 100000000001:
			wood -= int(upgrades["atomic_harvester"].base_cost * pow(upgrades["atomic_harvester"].cost_multiplier, upgrades["atomic_harvester"].amount))
			wood_sec += 850000
			upgrades["atomic_harvester"].amount += 1

func _on_molecular_separator_pressed() -> void:
	if wood > upgrades["molecular_separator"].base_cost * pow(upgrades["molecular_separator"].cost_multiplier, upgrades["molecular_separator"].amount) - 1:
		if upgrades["molecular_separator"].base_cost * pow(upgrades["molecular_separator"].cost_multiplier, upgrades["molecular_separator"].amount) < 100000000001:
			wood -= int(upgrades["molecular_separator"].base_cost * pow(upgrades["molecular_separator"].cost_multiplier, upgrades["molecular_separator"].amount))
			wood_sec += 1600000
			upgrades["molecular_separator"].amount += 1

func _on_solar_forged_blade_pressed() -> void:
	if wood > upgrades["solar_forged_blade"].base_cost * pow(upgrades["solar_forged_blade"].cost_multiplier, upgrades["solar_forged_blade"].amount) - 1:
		if upgrades["solar_forged_blade"].base_cost * pow(upgrades["solar_forged_blade"].cost_multiplier, upgrades["solar_forged_blade"].amount) < 100000000001:
			wood -= int(upgrades["solar_forged_blade"].base_cost * pow(upgrades["solar_forged_blade"].cost_multiplier, upgrades["solar_forged_blade"].amount))
			click_power += int(1700000 * click_multiplier)
			upgrades["solar_forged_blade"].amount += 1

func _on_orbital_collecter_pressed() -> void:
	if wood > upgrades["orbital_collecter"].base_cost * pow(upgrades["orbital_collecter"].cost_multiplier, upgrades["orbital_collecter"].amount) - 1:
		if upgrades["orbital_collecter"].base_cost * pow(upgrades["orbital_collecter"].cost_multiplier, upgrades["orbital_collecter"].amount) < 100000000001:
			wood -= int(upgrades["orbital_collecter"].base_cost * pow(upgrades["orbital_collecter"].cost_multiplier, upgrades["orbital_collecter"].amount))
			wood_sec += 7500000
			upgrades["orbital_collecter"].amount += 1

func _on_reality_ripper_pressed() -> void:
	if wood > upgrades["reality_ripper"].base_cost * pow(upgrades["reality_ripper"].cost_multiplier, upgrades["reality_ripper"].amount) - 1:
		if upgrades["reality_ripper"].base_cost * pow(upgrades["reality_ripper"].cost_multiplier, upgrades["reality_ripper"].amount) < 100000000001:
			wood -= int(upgrades["reality_ripper"].base_cost * pow(upgrades["reality_ripper"].cost_multiplier, upgrades["reality_ripper"].amount))
			click_power += int(9000000 * click_multiplier)
			upgrades["reality_ripper"].amount += 1

func _on_continental_logger_pressed() -> void:
	if wood > upgrades["continental_logger"].base_cost * pow(upgrades["continental_logger"].cost_multiplier, upgrades["continental_logger"].amount) - 1:
		if upgrades["continental_logger"].base_cost * pow(upgrades["continental_logger"].cost_multiplier, upgrades["continental_logger"].amount) < 100000000001:
			wood -= int(upgrades["continental_logger"].base_cost * pow(upgrades["continental_logger"].cost_multiplier, upgrades["continental_logger"].amount))
			wood_sec += 32000000
			upgrades["continental_logger"].amount += 1

func _on_the_infinite_click_pressed() -> void:
	if wood > upgrades["infinite_click"].base_cost * pow(upgrades["infinite_click"].cost_multiplier, upgrades["infinite_click"].amount) - 1:
		if upgrades["infinite_click"].base_cost * pow(upgrades["infinite_click"].cost_multiplier, upgrades["infinite_click"].amount) < 100000000001:
			wood -= int(upgrades["infinite_click"].base_cost * pow(upgrades["infinite_click"].cost_multiplier, upgrades["infinite_click"].amount))
			click_power += int(55000000 * click_multiplier)
			upgrades["infinite_click"].amount += 1

func _on_galactic_harvester_pressed() -> void:
	if wood > upgrades["galactic_harvester"].base_cost * pow(upgrades["galactic_harvester"].cost_multiplier, upgrades["galactic_harvester"].amount) - 1:
		if upgrades["galactic_harvester"].base_cost * pow(upgrades["galactic_harvester"].cost_multiplier, upgrades["galactic_harvester"].amount) < 100000000001:
			wood -= int(upgrades["galactic_harvester"].base_cost * pow(upgrades["galactic_harvester"].cost_multiplier, upgrades["galactic_harvester"].amount))
			wood_sec += 110000000
			upgrades["galactic_harvester"].amount += 1

func _on_big_bang_strike_pressed() -> void:
	if wood > upgrades["big_bang_strike"].base_cost * pow(upgrades["big_bang_strike"].cost_multiplier, upgrades["big_bang_strike"].amount) - 1:
		if upgrades["big_bang_strike"].base_cost * pow(upgrades["big_bang_strike"].cost_multiplier, upgrades["big_bang_strike"].amount) < 100000000001:
			wood -= int(upgrades["big_bang_strike"].base_cost * pow(upgrades["big_bang_strike"].cost_multiplier, upgrades["big_bang_strike"].amount))
			click_power += int(115000000 * click_multiplier)
			upgrades["big_bang_strike"].amount += 1

func _on_nebula_processor_pressed() -> void:
	if wood > upgrades["nebula_processor"].base_cost * pow(upgrades["nebula_processor"].cost_multiplier, upgrades["nebula_processor"].amount) - 1:
		if upgrades["nebula_processor"].base_cost * pow(upgrades["nebula_processor"].cost_multiplier, upgrades["nebula_processor"].amount) < 100000000001:
			wood -= int(upgrades["nebula_processor"].base_cost * pow(upgrades["nebula_processor"].cost_multiplier, upgrades["nebula_processor"].amount))
			wood_sec += 320000000
			upgrades["nebula_processor"].amount += 1

func _on_planetary_extraction_node_pressed() -> void:
	if wood > upgrades["planetary_extraction_node"].base_cost * pow(upgrades["planetary_extraction_node"].cost_multiplier, upgrades["planetary_extraction_node"].amount) - 1:
		if upgrades["planetary_extraction_node"].base_cost * pow(upgrades["planetary_extraction_node"].cost_multiplier, upgrades["planetary_extraction_node"].amount) < 100000000001:
			wood -= int(upgrades["planetary_extraction_node"].base_cost * pow(upgrades["planetary_extraction_node"].cost_multiplier, upgrades["planetary_extraction_node"].amount))
			wood_sec += 360000000
			upgrades["planetary_extraction_node"].amount += 1

func _on_supernova_chopper_pressed() -> void:
	if wood > upgrades["supernova_chopper"].base_cost * pow(upgrades["supernova_chopper"].cost_multiplier, upgrades["supernova_chopper"].amount) - 1:
		if upgrades["supernova_chopper"].base_cost * pow(upgrades["supernova_chopper"].cost_multiplier, upgrades["supernova_chopper"].amount) < 100000000001:
			wood -= int(upgrades["supernova_chopper"].base_cost * pow(upgrades["supernova_chopper"].cost_multiplier, upgrades["supernova_chopper"].amount))
			click_power += int(430000000 * click_multiplier)
			upgrades["supernova_chopper"].amount += 1

func _on_black_hole_extractor_pressed() -> void:
	if wood > upgrades["black_hole_extractor"].base_cost * pow(upgrades["black_hole_extractor"].cost_multiplier, upgrades["black_hole_extractor"].amount) - 1:
		if upgrades["black_hole_extractor"].base_cost * pow(upgrades["black_hole_extractor"].cost_multiplier, upgrades["black_hole_extractor"].amount) < 100000000001:
			wood -= int(upgrades["black_hole_extractor"].base_cost * pow(upgrades["black_hole_extractor"].cost_multiplier, upgrades["black_hole_extractor"].amount))
			wood_sec += 1400000000
			upgrades["black_hole_extractor"].amount += 1

func _on_galaxy_spliitter_pressed() -> void:
	if wood > upgrades["galaxy_splitter"].base_cost * pow(upgrades["galaxy_splitter"].cost_multiplier, upgrades["galaxy_splitter"].amount) - 1:
		if upgrades["galaxy_splitter"].base_cost * pow(upgrades["galaxy_splitter"].cost_multiplier, upgrades["galaxy_splitter"].amount) < 100000000001:
			wood -= int(upgrades["galaxy_splitter"].base_cost * pow(upgrades["infinite_click"].cost_multiplier, upgrades["galaxy_splitter"].amount))
			click_power += int(1600000000 * click_multiplier)
			upgrades["galaxy_splitter"].amount += 1

func _on_solar_system_silo_pressed() -> void:
	if wood > upgrades["solar_system_silo"].base_cost * pow(upgrades["solar_system_silo"].cost_multiplier, upgrades["solar_system_silo"].amount) - 1:
		if upgrades["solar_system_silo"].base_cost * pow(upgrades["solar_system_silo"].cost_multiplier, upgrades["solar_system_silo"].amount) < 100000000001:
			wood -= int(upgrades["solar_system_silo"].base_cost * pow(upgrades["solar_system_silo"].cost_multiplier, upgrades["solar_system_silo"].amount))
			wood_sec += 3000000000
			upgrades["solar_system_silo"].amount += 1

func _on_dyson_sphere_network_pressed() -> void:
	if wood > upgrades["dyson_sphere_network"].base_cost * pow(upgrades["dyson_sphere_network"].cost_multiplier, upgrades["dyson_sphere_network"].amount) - 1:
		if upgrades["dyson_sphere_network"].base_cost * pow(upgrades["dyson_sphere_network"].cost_multiplier, upgrades["dyson_sphere_network"].amount) < 100000000001:
			wood -= int(upgrades["dyson_sphere_network"].base_cost * pow(upgrades["dyson_sphere_network"].cost_multiplier, upgrades["dyson_sphere_network"].amount))
			wood_sec += 6000000000
			upgrades["dyson_sphere_network"].amount += 1

func _on_dimension_shear_pressed() -> void:
	if wood > upgrades["dimension_shear"].base_cost * pow(upgrades["dimension_shear"].cost_multiplier, upgrades["dimension_shear"].amount) - 1:
		if upgrades["dimension_shear"].base_cost * pow(upgrades["dimension_shear"].cost_multiplier, upgrades["dimension_shear"].amount) < 100000000001:
			wood -= int(upgrades["dimension_shear"].base_cost * pow(upgrades["dimension_shear"].cost_multiplier, upgrades["dimension_shear"].amount))
			click_power += int(7500000000 * click_multiplier)
			upgrades["dimension_shear"].amount += 1

func _on_physics_rewriter_pressed() -> void:
	if wood > upgrades["physics_rewriter"].base_cost * pow(upgrades["physics_rewriter"].cost_multiplier, upgrades["physics_rewriter"].amount) - 1:
		if upgrades["physics_rewriter"].base_cost * pow(upgrades["physics_rewriter"].cost_multiplier, upgrades["physics_rewriter"].amount) < 100000000001:
			wood -= int(upgrades["physics_rewriter"].base_cost * pow(upgrades["physics_rewriter"].cost_multiplier, upgrades["physics_rewriter"].amount))
			click_power += int(18000000000 * click_multiplier)
			upgrades["physics_rewriter"].amount += 1

func _on_timeline_convergence_pressed() -> void:
	if wood > upgrades["timeline_convergence"].base_cost * pow(upgrades["timeline_convergence"].cost_multiplier, upgrades["timeline_convergence"].amount) - 1:
		if upgrades["timeline_convergence"].base_cost * pow(upgrades["timeline_convergence"].cost_multiplier, upgrades["timeline_convergence"].amount) < 100000000001:
			wood -= int(upgrades["timeline_convergence"].base_cost * pow(upgrades["timeline_convergence"].cost_multiplier, upgrades["timeline_convergence"].amount))
			wood_sec += 18000000000
			upgrades["timeline_convergence"].amount += 1

func _on_infinite_energy_engine_pressed() -> void:
	if wood > upgrades["infinite_energy_engine"].base_cost * pow(upgrades["infinite_energy_engine"].cost_multiplier, upgrades["infinite_energy_engine"].amount) - 1:
		if upgrades["infinite_energy_engine"].base_cost * pow(upgrades["infinite_energy_engine"].cost_multiplier, upgrades["infinite_energy_engine"].amount) < 100000000001:
			wood -= int(upgrades["infinite_energy_engine"].base_cost * pow(upgrades["infinite_energy_engine"].cost_multiplier, upgrades["infinite_energy_engine"].amount))
			wood_sec += 26000000000
			upgrades["infinite_energy_engine"].amount += 1

func _on_absolute_tap_pressed() -> void:
	if wood > upgrades["absolute_tap"].base_cost * pow(upgrades["absolute_tap"].cost_multiplier, upgrades["absolute_tap"].amount) - 1:
		if upgrades["absolute_tap"].base_cost * pow(upgrades["absolute_tap"].cost_multiplier, upgrades["absolute_tap"].amount) < 100000000001:
			wood -= int(upgrades["absolute_tap"].base_cost * pow(upgrades["absolute_tap"].cost_multiplier, upgrades["absolute_tap"].amount))
			click_power += int(45000000000 * click_multiplier)
			upgrades["absolute_tap"].amount += 1

func _on_resource_singularity_pressed() -> void:
	if wood > upgrades["resource_singularity"].base_cost * pow(upgrades["resource_singularity"].cost_multiplier, upgrades["resource_singularity"].amount) - 1:
		if upgrades["resource_singularity"].base_cost * pow(upgrades["resource_singularity"].cost_multiplier, upgrades["resource_singularity"].amount) < 100000000001:
			wood -= int(upgrades["resource_singularity"].base_cost * pow(upgrades["resource_singularity"].cost_multiplier, upgrades["resource_singularity"].amount))
			wood_sec += 45000000000
			upgrades["resource_singularity"].amount += 1

func _on_currency_button_pressed() -> void:
	currency_button_tab = 2 if currency_button_tab == 1 else 1

# ============================================================================
# ONE-TIME UPGRADES
# ============================================================================
func _on_reinforced_gloves_pressed() -> void:
	if wood > 499:
		wood -= 500
		click_multiplier *= 2
		click_power *= 2
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
		save()

func _on_steel_axe_head_pressed() -> void:
	if wood > 1199:
		wood -= 1200
		click_power += int(500 * click_multiplier)
		one_time_upgrades["steel_axe_head"] = true
		$"Shop/One-Time Upgrades/Steel Axe Head".hide()
		save()

func _on_lunch_break_schudule_pressed() -> void:
	if wood > 3999:
		wood -= 4000
		idle_efficency *= 1.15
		one_time_upgrades["lunch_break_schudule"] = true
		$"Shop/One-Time Upgrades/Lunch Break Schedule".hide()
		save()

func _on_turbochargers_pressed() -> void:
	if wood > 74999:
		wood -= 75000
		vehicle_efficency *= 1.25
		wood_sec += ((upgrades["bulldozers"].amount * 200) + (upgrades["tree_harvester"].amount * 600) + (upgrades["industrial_mulcher"].amount * 1000)) * (vehicle_efficency - 1)
		one_time_upgrades["turbochargers"] = true
		$"Shop/One-Time Upgrades/Turbochargers".hide()
		save()

func _on_log_flume_pressed() -> void:
	if wood > 199999:
		wood -= 200000
		cost_multiplier -= 0.01
		one_time_upgrades["log_flume"] = true
		$"Shop/One-Time Upgrades/Log Flume".hide()
		save()

func _on_gps_mapping_pressed() -> void:
	if wood > 499999:
		wood -= 500000
		crictical_click += 0.044
		one_time_upgrades["gps_mapping"] = true
		$"Shop/One-Time Upgrades/GPS Mapping".hide()
		save()

func _on_shift_management_pressed() -> void:
	if wood > 1499999:
		wood -= 1500000
		idle_efficency *= 2
		one_time_upgrades["shift_management"] = true
		$"Shop/One-Time Upgrades/Shift Management".hide()
		save()

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
		click_power *= 4
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

func _on_biomass_refining_pressed() -> void:
	pass # Replace with function body.

func _on_global_optimisation_pressed() -> void:
	pass # Replace with function body.

func _on_saw_upgrade_pressed() -> void:
	pass # Replace with function body.

func _on_salary_increase_pressed() -> void:
	pass # Replace with function body.

func _on_master_logger_pressed() -> void:
	pass # Replace with function body.

# ============================================================================
# PRESTIGE SYSTEM
# ============================================================================
func _on_prestige_pressed() -> void:
	set_process(false)
	
	# Calculate seed gain
	var seed_gain = sqrt(wood / 1000.0) * golden_seed_multipiler
	if seed_gain > 0:
		golden_seed += int(seed_gain)
	
		# Store 10% wood if wood_bank is unlocked
	var wood_to_keep = 0
	if prestige_upgrades["wood_bank"]:
		if prestige_upgrades["wood_saving_account"]:
				wood_to_keep = int(wood * 0.35) # Keep 35%
		else:
			wood_to_keep = int(wood * 0.1)  # Keep 10%
	else:
		if prestige_upgrades["wood_saving_account"]:
			wood_to_keep = int(wood * 0.2)  # Keep 20%
	
	# Reset progression
	reset_progression()
	
	# Add back the stored wood
	wood = wood_to_keep
	
	# Apply synergies
	if prestige_upgrades["theyre_mine"]:
		apply_synergies()
	
	#Do prestige upgrades
	if prestige_upgrades["fertile_soil"]:
		click_multiplier *= 4
		wood_sec *= 4
	if prestige_upgrades["smart_workers"]:
		worker_efficency *= 5
	if prestige_upgrades["golden_axe"]:
		click_multiplier *= 10
	if prestige_upgrades["saw_efficency"]:
		click_multiplier *= 15
	if prestige_upgrades["prestige_boost"]:
		golden_seed_multipiler *= 2
	if prestige_upgrades["discount"]:
		cost_multiplier -= 0.03
	if prestige_upgrades["new_tools"]:
		click_multiplier *= 6
		wood_sec *= 6
	if prestige_upgrades["seed_boost"]:
		golden_seed_multipiler *= 3
	if prestige_upgrades["discount+"]:
		cost_multiplier -= 0.04
	if prestige_upgrades["golden_handle"]:
		click_multiplier *= 30
	if prestige_upgrades["cosmic_hq"]:
		click_multiplier *= 8
		wood_sec *= 8
	if prestige_upgrades["golden_handle"]:
		click_multiplier *= 50
	if prestige_upgrades["milky_way_hq"]:
		click_multiplier *= 15
		wood_sec *= 15
	if prestige_upgrades["careful_scavenging"]:
		golden_seed_multipiler *= 5
	
	prestiges += 1
	save()
	load_data()

func reset_progression() -> void:
	wood = 0
	click_power = 1
	wood_sec = 0
	cost_multiplier = COST_MULTIPLIER_DEFAULT
	
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

func _on_golden_axe_pressed() -> void:
	if golden_seed > 24:
		golden_seed -= 25
		click_power *= 10
		click_multiplier *= 10
		prestige_upgrades["golden_axe"] = true
		$"Shop/Prestige Upgrades/Golden Saw".hide()

func _on_saw_efficency_pressed() -> void:
	if golden_seed > 49:
		golden_seed -= 50
		click_multiplier *= 15
		click_power *= 15
		prestige_upgrades["saw_efficency"] = true
		$"Shop/Prestige Upgrades/Saw Efficency".hide()

func _on_prestige_boost_pressed() -> void:
	if golden_seed > 99:
		golden_seed -= 100
		golden_seed_multipiler *= 2
		prestige_upgrades["prestige_boost"] = true
		$"Shop/Prestige Upgrades/Prestige Boost".hide()

func _on_discount_pressed() -> void:
	if golden_seed > 99:
		golden_seed -= 100
		cost_multiplier -= 0.03
		prestige_upgrades["discount"] = true
		$"Shop/Prestige Upgrades/Discount".hide()

func _on_autobuyer_ii_pressed() -> void:
	if golden_seed > 99:
		golden_seed -= 100
		prestige_upgrades["autobuyer_ii"] = true
		$"Shop/Prestige Upgrades/Autobuyer II".hide()

func _on_wood_bank_pressed() -> void:
	if golden_seed > 119:
		golden_seed -= 120
		prestige_upgrades["wood_bank"] = true
		$"Shop/Prestige Upgrades/Wood Bank".hide()

func _on_new_tools_pressed() -> void:
	if golden_seed > 149:
		golden_seed -= 150
		click_power *= 6
		wood_sec *= 6
		prestige_upgrades["new_tools"] = true
		$"Shop/Prestige Upgrades/New Tools".hide()

func _on_golden_saw_pressed() -> void:
	if golden_seed > 179:
		golden_seed -= 180
		click_power *= 20
		click_multiplier *= 20
		prestige_upgrades["golden_saw"] = true
		$"Shop/Prestige Upgrades/Golden Saw".hide()

func _on_autobuyer_iii_pressed() -> void:
	if golden_seed > 199:
		golden_seed -= 200
		prestige_upgrades["autobuyer_iii"] = true
		$"Shop/Prestige Upgrades/Autobuyer III".hide()

func _on_seed_boost_pressed() -> void:
	if golden_seed > 199:
		golden_seed -= 200
		golden_seed_multipiler *= 3
		prestige_upgrades["seed_boost"] = true
		$"Shop/Prestige Upgrades/Seed Boost".hide()

func _on_discount_tier_2_pressed() -> void:
	if golden_seed > 199:
		golden_seed -= 200
		cost_multiplier -= 0.04
		prestige_upgrades["discount+"] = true
		$"Shop/Prestige Upgrades/Discount+".hide()

func _on_golden_handle_pressed() -> void:
	if golden_seed > 299:
		golden_seed -= 300
		click_power *= 30
		click_multiplier *= 30
		prestige_upgrades["golden_handle"] = true
		$"Shop/Prestige Upgrades/Golden Handle".hide()

func _on_autobuyer_boost_pressed() -> void:
	if golden_seed > 399:
		golden_seed -= 400
		$"Timers/Autobuyer Timer".wait_time -= 30
		prestige_upgrades["autobuyer_boost"] = true
		$"Shop/Prestige Upgrades/Autobuyer Boost".hide()

func _on_cost_efficency_pressed() -> void:
	if golden_seed > 499:
		golden_seed -= 500
		cost_multiplier -= 0.05
		prestige_upgrades["cost_efficency"] = true
		$"Shop/Prestige Upgrades/Cost Efficency".hide()

func _on_autobuyer_iv_pressed() -> void:
	if golden_seed > 599:
		golden_seed -= 600
		prestige_upgrades["autobuyer_iv"] = true
		$"Shop/Prestige Upgrades/Autobuyer IV".hide()

func _on_cosmic_hq_pressed() -> void:
	if golden_seed > 749:
		golden_seed -= 750
		click_power *= 8
		wood_sec *= 8
		prestige_upgrades["cosmic_hq"] = true
		$"Shop/Prestige Upgrades/Cosmic HQ".hide()

func _on_golden_plasma_cutter_pressed() -> void:
	if golden_seed > 899:
		golden_seed -= 900
		click_power *= 50
		click_multiplier *= 50
		prestige_upgrades["golden_plasma_cutter"] = true
		$"Shop/Prestige Upgrades/Golden Plasma Cutter".hide()

func _on_wood_saving_account_pressed() -> void:
	if golden_seed > 999:
		golden_seed -= 1000
		prestige_upgrades["wood_saving_account"] = true
		$"Shop/Prestige Upgrades/Wood Saving Account".hide()

func _on_autobuyer_v_pressed() -> void:
	if golden_seed > 199:
		golden_seed -= 200
		prestige_upgrades["autobuyer_v"] = true
		$"Shop/Prestige Upgrades/Autobuyer V".hide()

func _on_milky_way_hq_pressed() -> void:
	if golden_seed > 1499:
		golden_seed -= 1500
		click_power *= 15
		wood_sec *= 15
		prestige_upgrades["milky_way_hq"] = true
		$"Shop/Prestige Upgrades/Milky Way HQ".hide()

func _on_careful_scavenging_pressed() -> void:
	if golden_seed > 1999:
		golden_seed -= 2000
		golden_seed_multipiler *= 5
		prestige_upgrades["careful_scavenging"] = true
		$"Shop/Prestige Upgrades/Careful Scavenging".hide()

func _on_autobuyer_vi_pressed() -> void:
	if golden_seed > 2499:
		golden_seed -= 2500
		prestige_upgrades["autobuyer_vi"] = true
		$"Shop/Prestige Upgrades/Autobuyer VI".hide()

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
	if prestige_upgrades["autobuyer_iv"]:
		autobuyer_tier_4()
	if prestige_upgrades["autobuyer_v"]:
		autobuyer_tier_5()
	if prestige_upgrades["autobuyer_vi"]:
		autobuyer_tier_6()

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
	if wood > int(upgrades["axe_reforge"].base_cost * pow(upgrades["axe_reforge"].cost_multiplier, upgrades["axe_reforge"].amount)) - 1:
		if int(upgrades["axe_reforge"].base_cost * pow(upgrades["axe_reforge"].cost_multiplier, upgrades["axe_reforge"].amount)) < 100001:
			wood -= int(upgrades["axe_reforge"].base_cost * pow(upgrades["axe_reforge"].cost_multiplier, upgrades["axe_reforge"].amount))
			click_power += int(1 * click_multiplier)
			upgrades["axe_skill"].amount += 1
	if wood > upgrades["reinforced_handle"].base_cost * pow(upgrades["reinforced_handle"].cost_multiplier, upgrades["reinforced_handle"].amount) - 1:
		if upgrades["reinforced_handle"].base_cost * pow(upgrades["reinforced_handle"].cost_multiplier, upgrades["reinforced_handle"].amount) < 100000000001:
			wood -= int(upgrades["reinforced_handle"].base_cost * pow(upgrades["reinforced_handle"].cost_multiplier, upgrades["reinforced_handle"].amount))
			click_power += int(40 * click_multiplier)
			upgrades["reinforced_handle"].amount += 1
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
	if wood > upgrades["titanium_edge"].base_cost * pow(upgrades["titanium_edge"].cost_multiplier, upgrades["titanium_edge"].amount) - 1:
		if upgrades["titanium_edge"].base_cost * pow(upgrades["titanium_edge"].cost_multiplier, upgrades["titanium_edge"].amount) < 100000000001:
			wood -= int(upgrades["titanium_edge"].base_cost * pow(upgrades["titanium_edge"].cost_multiplier, upgrades["titanium_edge"].amount))
			click_power += int(120 * click_multiplier)
			upgrades["titanium_edge"].amount += 1
	if wood > int(upgrades["bulldozers"].base_cost * pow(upgrades["bulldozers"].cost_multiplier, upgrades["bulldozers"].amount)) - 1:
		if int(upgrades["bulldozers"].base_cost * pow(upgrades["bulldozers"].cost_multiplier, upgrades["bulldozers"].amount)) < 100001:
			wood -= int(upgrades["bulldozers"].base_cost * pow(upgrades["bulldozers"].cost_multiplier, upgrades["bulldozers"].amount))
			wood_sec += int(200 * vehicle_efficency)
			upgrades["bulldozers"].amount += 1

func autobuyer_tier_2() -> void:
	if wood > upgrades["diamond_plating"].base_cost * pow(upgrades["diamond_plating"].cost_multiplier, upgrades["diamond_plating"].amount) - 1:
		if upgrades["diamond_plating"].base_cost * pow(upgrades["diamond_plating"].cost_multiplier, upgrades["diamond_plating"].amount) < 100000000001:
			wood -= int(upgrades["diamond_plating"].base_cost * pow(upgrades["diamond_plating"].cost_multiplier, upgrades["diamond_plating"].amount))
			click_power += int(120 * click_multiplier)
			upgrades["diamond_plating"].amount += 1
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
	if wood > upgrades["plasma_cutter"].base_cost * pow(upgrades["plasma_cutter"].cost_multiplier, upgrades["plasma_cutter"].amount) - 1:
		if upgrades["plasma_cutter"].base_cost * pow(upgrades["plasma_cutter"].cost_multiplier, upgrades["plasma_cutter"].amount) < 100000000001:
			wood -= int(upgrades["plasma_cutter"].base_cost * pow(upgrades["plasma_cutter"].cost_multiplier, upgrades["plasma_cutter"].amount))
			click_power += int(1800 * click_multiplier)
			upgrades["plasma_cutter"].amount += 1
	if wood > upgrades["mass_processing_plant"].base_cost * pow(upgrades["mass_processing_plant"].cost_multiplier, upgrades["mass_processing_plant"].amount) - 1:
		if upgrades["mass_processing_plant"].base_cost * pow(upgrades["mass_processing_plant"].cost_multiplier, upgrades["mass_processing_plant"].amount) < 100000000001:
			wood -= int(upgrades["mass_processing_plant"].base_cost * pow(upgrades["mass_processing_plant"].cost_multiplier, upgrades["mass_processing_plant"].amount))
			wood_sec += 2200
			upgrades["mass_processing_plant"].amount += 1

func autobuyer_tier_3() -> void:
	if wood > upgrades["automated_logging_rig"].base_cost * pow(upgrades["automated_logging_rig"].cost_multiplier, upgrades["automated_logging_rig"].amount) - 1:
		if upgrades["automated_logging_rig"].base_cost * pow(upgrades["automated_logging_rig"].cost_multiplier, upgrades["automated_logging_rig"].amount) < 100000000001:
			wood -= int(upgrades["automated_logging_rig"].base_cost * pow(upgrades["automated_logging_rig"].cost_multiplier, upgrades["automated_logging_rig"].amount))
			wood_sec += 8000
			upgrades["automated_logging_rig"].amount += 1
	if wood > upgrades["monocular_slicer"].base_cost * pow(upgrades["monocular_slicer"].cost_multiplier, upgrades["monocular_slicer"].amount) - 1:
		if upgrades["monocular_slicer"].base_cost * pow(upgrades["monocular_slicer"].cost_multiplier, upgrades["monocular_slicer"].amount) < 100000000001:
			wood -= int(upgrades["monocular_slicer"].base_cost * pow(upgrades["monocular_slicer"].cost_multiplier, upgrades["monocular_slicer"].amount))
			click_power += int(8000 * click_multiplier)
			upgrades["monocular_slicer"].amount += 1
	if wood > upgrades["bio_diesel_fleet"].base_cost * pow(upgrades["bio_diesel_fleet"].cost_multiplier, upgrades["bio_diesel_fleet"].amount) - 1:
		if upgrades["bio_diesel_fleet"].base_cost * pow(upgrades["bio_diesel_fleet"].cost_multiplier, upgrades["bio_diesel_fleet"].amount) < 100000000001:
			wood -= int(upgrades["bio_diesel_fleet"].base_cost * pow(upgrades["bio_diesel_fleet"].cost_multiplier, upgrades["bio_diesel_fleet"].amount))
			wood_sec += 28000
			upgrades["bio_diesel_fleet"].amount += 1
	if wood > upgrades["gravity_axe"].base_cost * pow(upgrades["gravity_axe"].cost_multiplier, upgrades["gravity_axe"].amount) - 1:
		if upgrades["gravity_axe"].base_cost * pow(upgrades["gravity_axe"].cost_multiplier, upgrades["gravity_axe"].amount) < 100000000001:
			wood -= int(upgrades["gravity_axe"].base_cost * pow(upgrades["gravity_axe"].cost_multiplier, upgrades["gravity_axe"].amount))
			click_power += int(35000 * click_multiplier)
			upgrades["gravity_axe"].amount += 1

func autobuyer_tier_4() -> void:
	if wood > upgrades["forest_strip_miner"].base_cost * pow(upgrades["forest_strip_miner"].cost_multiplier, upgrades["forest_strip_miner"].amount) - 1:
		if upgrades["forest_strip_miner"].base_cost * pow(upgrades["forest_strip_miner"].cost_multiplier, upgrades["forest_strip_miner"].amount) < 100000000001:
			wood -= int(upgrades["forest_strip_miner"].base_cost * pow(upgrades["forest_strip_miner"].cost_multiplier, upgrades["forest_strip_miner"].amount))
			wood_sec += 110000
			upgrades["forest_strip_miner"].amount += 1
	if wood > upgrades["quantum_disintegrator"].base_cost * pow(upgrades["quantum_disintegrator"].cost_multiplier, upgrades["quantum_disintegrator"].amount) - 1:
		if upgrades["quantum_disintegrator"].base_cost * pow(upgrades["quantum_disintegrator"].cost_multiplier, upgrades["quantum_disintegrator"].amount) < 100000000001:
			wood -= int(upgrades["quantum_disintegrator"].base_cost * pow(upgrades["quantum_disintegrator"].cost_multiplier, upgrades["quantum_disintegrator"].amount))
			click_power += int(320000 * click_multiplier)
			upgrades["quantum_disintegrator"].amount += 1
	if wood > upgrades["atomic_harvester"].base_cost * pow(upgrades["atomic_harvester"].cost_multiplier, upgrades["atomic_harvester"].amount) - 1:
		if upgrades["atomic_harvester"].base_cost * pow(upgrades["atomic_harvester"].cost_multiplier, upgrades["atomic_harvester"].amount) < 100000000001:
			wood -= int(upgrades["atomic_harvester"].base_cost * pow(upgrades["atomic_harvester"].cost_multiplier, upgrades["atomic_harvester"].amount))
			wood_sec += 850000
			upgrades["atomic_harvester"].amount += 1
	if wood > upgrades["molecular_separator"].base_cost * pow(upgrades["molecular_separator"].cost_multiplier, upgrades["molecular_separator"].amount) - 1:
		if upgrades["molecular_separator"].base_cost * pow(upgrades["molecular_separator"].cost_multiplier, upgrades["molecular_separator"].amount) < 100000000001:
			wood -= int(upgrades["molecular_separator"].base_cost * pow(upgrades["molecular_separator"].cost_multiplier, upgrades["molecular_separator"].amount))
			wood_sec += 1600000
			upgrades["molecular_separator"].amount += 1
	if wood > upgrades["solar_forged_blade"].base_cost * pow(upgrades["solar_forged_blade"].cost_multiplier, upgrades["solar_forged_blade"].amount) - 1:
		if upgrades["solar_forged_blade"].base_cost * pow(upgrades["solar_forged_blade"].cost_multiplier, upgrades["solar_forged_blade"].amount) < 100000000001:
			wood -= int(upgrades["solar_forged_blade"].base_cost * pow(upgrades["solar_forged_blade"].cost_multiplier, upgrades["solar_forged_blade"].amount))
			click_power += int(1700000 * click_multiplier)
			upgrades["solar_forged_blade"].amount += 1

func autobuyer_tier_5() -> void:
	if wood > upgrades["orbital_collecter"].base_cost * pow(upgrades["orbital_collecter"].cost_multiplier, upgrades["orbital_collecter"].amount) - 1:
		if upgrades["orbital_collecter"].base_cost * pow(upgrades["orbital_collecter"].cost_multiplier, upgrades["orbital_collecter"].amount) < 100000000001:
			wood -= int(upgrades["orbital_collecter"].base_cost * pow(upgrades["orbital_collecter"].cost_multiplier, upgrades["orbital_collecter"].amount))
			wood_sec += 7500000
			upgrades["orbital_collecter"].amount += 1
	if wood > upgrades["reality_ripper"].base_cost * pow(upgrades["reality_ripper"].cost_multiplier, upgrades["reality_ripper"].amount) - 1:
		if upgrades["reality_ripper"].base_cost * pow(upgrades["reality_ripper"].cost_multiplier, upgrades["reality_ripper"].amount) < 100000000001:
			wood -= int(upgrades["reality_ripper"].base_cost * pow(upgrades["reality_ripper"].cost_multiplier, upgrades["reality_ripper"].amount))
			click_power += int(9000000 * click_multiplier)
			upgrades["reality_ripper"].amount += 1
	if wood > upgrades["continental_logger"].base_cost * pow(upgrades["continental_logger"].cost_multiplier, upgrades["continental_logger"].amount) - 1:
		if upgrades["continental_logger"].base_cost * pow(upgrades["continental_logger"].cost_multiplier, upgrades["continental_logger"].amount) < 100000000001:
			wood -= int(upgrades["continental_logger"].base_cost * pow(upgrades["continental_logger"].cost_multiplier, upgrades["continental_logger"].amount))
			wood_sec += 32000000
			upgrades["continental_logger"].amount += 1
	if wood > upgrades["infinite_click"].base_cost * pow(upgrades["infinite_click"].cost_multiplier, upgrades["infinite_click"].amount) - 1:
		if upgrades["infinite_click"].base_cost * pow(upgrades["infinite_click"].cost_multiplier, upgrades["infinite_click"].amount) < 100000000001:
			wood -= int(upgrades["infinite_click"].base_cost * pow(upgrades["infinite_click"].cost_multiplier, upgrades["infinite_click"].amount))
			click_power += int(55000000 * click_multiplier)
			upgrades["infinite_click"].amount += 1

func autobuyer_tier_6() -> void:
	if wood > upgrades["galactic_harvester"].base_cost * pow(upgrades["galactic_harvester"].cost_multiplier, upgrades["galactic_harvester"].amount) - 1:
		if upgrades["galactic_harvester"].base_cost * pow(upgrades["galactic_harvester"].cost_multiplier, upgrades["galactic_harvester"].amount) < 100000000001:
			wood -= int(upgrades["galactic_harvester"].base_cost * pow(upgrades["galactic_harvester"].cost_multiplier, upgrades["galactic_harvester"].amount))
			wood_sec += 110000000
			upgrades["galactic_harvester"].amount += 1
	if wood > upgrades["big_bang_strike"].base_cost * pow(upgrades["big_bang_strike"].cost_multiplier, upgrades["big_bang_strike"].amount) - 1:
		if upgrades["big_bang_strike"].base_cost * pow(upgrades["big_bang_strike"].cost_multiplier, upgrades["big_bang_strike"].amount) < 100000000001:
			wood -= int(upgrades["big_bang_strike"].base_cost * pow(upgrades["big_bang_strike"].cost_multiplier, upgrades["big_bang_strike"].amount))
			click_power += int(115000000 * click_multiplier)
			upgrades["big_bang_strike"].amount += 1
	if wood > upgrades["nebula_processor"].base_cost * pow(upgrades["nebula_processor"].cost_multiplier, upgrades["nebula_processor"].amount) - 1:
		if upgrades["nebula_processor"].base_cost * pow(upgrades["nebula_processor"].cost_multiplier, upgrades["nebula_processor"].amount) < 100000000001:
			wood -= int(upgrades["nebula_processor"].base_cost * pow(upgrades["nebula_processor"].cost_multiplier, upgrades["nebula_processor"].amount))
			wood_sec += 320000000
			upgrades["nebula_processor"].amount += 1
	if wood > upgrades["planetary_extraction_node"].base_cost * pow(upgrades["planetary_extraction_node"].cost_multiplier, upgrades["planetary_extraction_node"].amount) - 1:
		if upgrades["planetary_extraction_node"].base_cost * pow(upgrades["planetary_extraction_node"].cost_multiplier, upgrades["planetary_extraction_node"].amount) < 100000000001:
			wood -= int(upgrades["planetary_extraction_node"].base_cost * pow(upgrades["planetary_extraction_node"].cost_multiplier, upgrades["planetary_extraction_node"].amount))
			wood_sec += 360000000
			upgrades["planetary_extraction_node"].amount += 1
	if wood > upgrades["supernova_chopper"].base_cost * pow(upgrades["supernova_chopper"].cost_multiplier, upgrades["supernova_chopper"].amount) - 1:
		if upgrades["supernova_chopper"].base_cost * pow(upgrades["supernova_chopper"].cost_multiplier, upgrades["supernova_chopper"].amount) < 100000000001:
			wood -= int(upgrades["supernova_chopper"].base_cost * pow(upgrades["supernova_chopper"].cost_multiplier, upgrades["supernova_chopper"].amount))
			click_power += int(430000000 * click_multiplier)
			upgrades["supernova_chopper"].amount += 1
	if wood > upgrades["black_hole_extractor"].base_cost * pow(upgrades["black_hole_extractor"].cost_multiplier, upgrades["black_hole_extractor"].amount) - 1:
		if upgrades["black_hole_extractor"].base_cost * pow(upgrades["black_hole_extractor"].cost_multiplier, upgrades["black_hole_extractor"].amount) < 100000000001:
			wood -= int(upgrades["black_hole_extractor"].base_cost * pow(upgrades["black_hole_extractor"].cost_multiplier, upgrades["black_hole_extractor"].amount))
			wood_sec += 1400000000
			upgrades["black_hole_extractor"].amount += 1
	if wood > upgrades["galaxy_splitter"].base_cost * pow(upgrades["galaxy_splitter"].cost_multiplier, upgrades["galaxy_splitter"].amount) - 1:
		if upgrades["galaxy_splitter"].base_cost * pow(upgrades["galaxy_splitter"].cost_multiplier, upgrades["galaxy_splitter"].amount) < 100000000001:
			wood -= int(upgrades["galaxy_splitter"].base_cost * pow(upgrades["infinite_click"].cost_multiplier, upgrades["galaxy_splitter"].amount))
			click_power += int(1600000000 * click_multiplier)
			upgrades["galaxy_splitter"].amount += 1
	if wood > upgrades["solar_system_silo"].base_cost * pow(upgrades["solar_system_silo"].cost_multiplier, upgrades["solar_system_silo"].amount) - 1:
		if upgrades["solar_system_silo"].base_cost * pow(upgrades["solar_system_silo"].cost_multiplier, upgrades["solar_system_silo"].amount) < 100000000001:
			wood -= int(upgrades["solar_system_silo"].base_cost * pow(upgrades["solar_system_silo"].cost_multiplier, upgrades["solar_system_silo"].amount))
			wood_sec += 3000000000
			upgrades["solar_system_silo"].amount += 1
	if wood > upgrades["dyson_sphere_network"].base_cost * pow(upgrades["dyson_sphere_network"].cost_multiplier, upgrades["dyson_sphere_network"].amount) - 1:
		if upgrades["dyson_sphere_network"].base_cost * pow(upgrades["dyson_sphere_network"].cost_multiplier, upgrades["dyson_sphere_network"].amount) < 100000000001:
			wood -= int(upgrades["dyson_sphere_network"].base_cost * pow(upgrades["dyson_sphere_network"].cost_multiplier, upgrades["dyson_sphere_network"].amount))
			wood_sec += 6000000000
			upgrades["dyson_sphere_network"].amount += 1
	if wood > upgrades["dimension_shear"].base_cost * pow(upgrades["dimension_shear"].cost_multiplier, upgrades["dimension_shear"].amount) - 1:
		if upgrades["dimension_shear"].base_cost * pow(upgrades["dimension_shear"].cost_multiplier, upgrades["dimension_shear"].amount) < 100000000001:
			wood -= int(upgrades["dimension_shear"].base_cost * pow(upgrades["dimension_shear"].cost_multiplier, upgrades["dimension_shear"].amount))
			click_power += int(7500000000 * click_multiplier)
			upgrades["dimension_shear"].amount += 1
	if wood > upgrades["physics_rewriter"].base_cost * pow(upgrades["physics_rewriter"].cost_multiplier, upgrades["physics_rewriter"].amount) - 1:
		if upgrades["physics_rewriter"].base_cost * pow(upgrades["physics_rewriter"].cost_multiplier, upgrades["physics_rewriter"].amount) < 100000000001:
			wood -= int(upgrades["physics_rewriter"].base_cost * pow(upgrades["physics_rewriter"].cost_multiplier, upgrades["physics_rewriter"].amount))
			click_power += int(18000000000 * click_multiplier)
			upgrades["physics_rewriter"].amount += 1
	if wood > upgrades["timeline_convergence"].base_cost * pow(upgrades["timeline_convergence"].cost_multiplier, upgrades["timeline_convergence"].amount) - 1:
		if upgrades["timeline_convergence"].base_cost * pow(upgrades["timeline_convergence"].cost_multiplier, upgrades["timeline_convergence"].amount) < 100000000001:
			wood -= int(upgrades["timeline_convergence"].base_cost * pow(upgrades["timeline_convergence"].cost_multiplier, upgrades["timeline_convergence"].amount))
			wood_sec += 18000000000
			upgrades["timeline_convergence"].amount += 1
	if wood > upgrades["infinite_energy_engine"].base_cost * pow(upgrades["infinite_energy_engine"].cost_multiplier, upgrades["infinite_energy_engine"].amount) - 1:
		if upgrades["infinite_energy_engine"].base_cost * pow(upgrades["infinite_energy_engine"].cost_multiplier, upgrades["infinite_energy_engine"].amount) < 100000000001:
			wood -= int(upgrades["infinite_energy_engine"].base_cost * pow(upgrades["infinite_energy_engine"].cost_multiplier, upgrades["infinite_energy_engine"].amount))
			wood_sec += 26000000000
			upgrades["infinite_energy_engine"].amount += 1
	if wood > upgrades["absolute_tap"].base_cost * pow(upgrades["absolute_tap"].cost_multiplier, upgrades["absolute_tap"].amount) - 1:
		if upgrades["absolute_tap"].base_cost * pow(upgrades["absolute_tap"].cost_multiplier, upgrades["absolute_tap"].amount) < 100000000001:
			wood -= int(upgrades["absolute_tap"].base_cost * pow(upgrades["absolute_tap"].cost_multiplier, upgrades["absolute_tap"].amount))
			click_power += int(45000000000 * click_multiplier)
			upgrades["absolute_tap"].amount += 1
	if wood > upgrades["resource_singularity"].base_cost * pow(upgrades["resource_singularity"].cost_multiplier, upgrades["resource_singularity"].amount) - 1:
		if upgrades["resource_singularity"].base_cost * pow(upgrades["resource_singularity"].cost_multiplier, upgrades["resource_singularity"].amount) < 100000000001:
			wood -= int(upgrades["resource_singularity"].base_cost * pow(upgrades["resource_singularity"].cost_multiplier, upgrades["resource_singularity"].amount))
			wood_sec += 45000000000
			upgrades["resource_singularity"].amount += 1
# ============================================================================
# SAVE/LOAD SYSTEM
# ============================================================================
# CHANGE 1: File saving/loading won't work the same way on web
# Web doesn't have direct file system access
# Use ConfigFile instead for web compatibility

func save() -> void:
	var config = ConfigFile.new()
	
	# Save basic state
	config.set_value("game", "version", VERSION)
	config.set_value("game", "wood", wood)
	config.set_value("game", "click_power", click_power)
	config.set_value("game", "wood_sec", wood_sec)
	config.set_value("game", "golden_seed", golden_seed)
	config.set_value("game", "prestiges", prestiges)
	config.set_value("game", "click_multiplier", click_multiplier)
	config.set_value("game", "worker_efficency", worker_efficency)
	config.set_value("game", "vehicle_efficency", vehicle_efficency)
	config.set_value("game", "chainsaw_fleet_efficency", chainsaw_fleet_efficency)
	config.set_value("game", "idle_efficency", idle_efficency)
	config.set_value("game", "golden_seed_multipiler", golden_seed_multipiler)
	config.set_value("game", "cost_multiplier", cost_multiplier)
	config.set_value("game", "crictical_click", crictical_click)
	config.set_value("game", "last_save_time", last_save_time)
	
	# Save upgrade amounts
	for upgrade_id in upgrades:
		config.set_value("upgrades", upgrade_id, upgrades[upgrade_id].amount)
	
	# Save one-time upgrade toggles
	for upgrade_id in one_time_upgrades:
		config.set_value("one_time", upgrade_id, one_time_upgrades[upgrade_id])
	
	# Save prestige upgrade toggles
	for upgrade_id in prestige_upgrades:
		config.set_value("prestige", upgrade_id, prestige_upgrades[upgrade_id])
	
	# Save to file
	config.save(SAVE_PATH)

func load_data() -> void:
	if not FileAccess.file_exists(SAVE_PATH):
		print("No Data is avalible")
		set_process(true)
		return
	
	set_process(false)
	var config = ConfigFile.new()
	config.load(SAVE_PATH)
	
	# Load basic state
	wood = config.get_value("game", "wood", 0)
	click_power = config.get_value("game", "click_power", 1)
	wood_sec = config.get_value("game", "wood_sec", 0)
	golden_seed = config.get_value("game", "golden_seed", 0)
	prestiges = config.get_value("game", "prestiges", 0)
	click_multiplier = config.get_value("game", "click_multiplier", 1.0)
	worker_efficency = config.get_value("game", "worker_efficency", 1.0)
	vehicle_efficency = config.get_value("game", "vehicle_efficency", 1.0)
	chainsaw_fleet_efficency = config.get_value("game", "chainsaw_fleet_efficency", 1.0)
	idle_efficency = config.get_value("game", "idle_efficency", 1.0)
	golden_seed_multipiler = config.get_value("game", "golden_seed_multipiler", 1.0)
	cost_multiplier = config.get_value("game", "cost_multiplier", 1.35)
	crictical_click = config.get_value("game", "crictical_click", 0.0)
	last_save_time = config.get_value("game", "last_save_time", 0)
	
	# Load upgrade amounts
	for upgrade_id in upgrades:
		upgrades[upgrade_id].amount = config.get_value("upgrades", upgrade_id, 0)
	
	# Load one-time upgrade toggles
	for upgrade_id in one_time_upgrades:
		one_time_upgrades[upgrade_id] = config.get_value("one_time", upgrade_id, false)
	
	# Load prestige upgrade toggles
	for upgrade_id in prestige_upgrades:
		prestige_upgrades[upgrade_id] = config.get_value("prestige", upgrade_id, false)
	
	# Hide purchased upgrades
	refresh_upgrade_visibility()
	
	# Calculate idle gains
	var current_time = Time.get_ticks_msec() / 1000.0
	var seconds_away = current_time - last_save_time
	wood += int(seconds_away * wood_sec * idle_efficency)
	
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
	if prestige_upgrades["wood_bank"]:
		$"Shop/Prestige Upgrades/Wood Bank".hide()
	if prestige_upgrades["new_tools"]:
		$"Shop/Prestige Upgrades/New Tools".hide()
	if prestige_upgrades["golden_saw"]:
		$"Shop/Prestige Upgrades/Golden Saw".hide()
	if prestige_upgrades["autobuyer_iii"]:
		$"Shop/Prestige Upgrades/Autobuyer III".hide()
	if prestige_upgrades["seed_boost"]:
		$"Shop/Prestige Upgrades/Seed Boost".hide()
	if prestige_upgrades["discount+"]:
		$"Shop/Prestige Upgrades/Discount+".hide()
	if prestige_upgrades["golden_handle"]:
		$"Shop/Prestige Upgrades/Golden Axe".hide()
	if prestige_upgrades["autobuyer_boost"]:
		$"Shop/Prestige Upgrades/Autobuyer Boost".hide()
	if prestige_upgrades["autobuyer_iv"]:
		$"Shop/Prestige Upgrades/Autobuyer IV".hide()
	if prestige_upgrades["cosmic_hq"]:
		$"Shop/Prestige Upgrades/Cosmic HQ".hide()
	if prestige_upgrades["golden_plasma_cuttter"]:
		$"Shop/Prestige Upgrades/Golden Plasma Cutter".hide()
	if prestige_upgrades["wood_saving_account"]:
		$"Shop/Prestige Upgrades/Wood Saving Account".hide()
	if prestige_upgrades["autobuyer_v"]:
		$"Shop/Prestige Upgrades/Autobuyer V".hide()
	if prestige_upgrades["milky_way_hq"]:
		$"Shop/Prestige Upgrades/Milky Way HQ".hide()
	if prestige_upgrades["careful_scavenging"]:
		$"Shop/Prestige Upgrades/Careful Scavenging".hide()
	if prestige_upgrades["autobuyer_vi"]:
		$"Shop/Prestige Upgrades/Autobuyer VI".hide()

func _on_save_button_pressed() -> void:
	save()

func _on_load_button_pressed() -> void:
	load_data()

func _on_shop_toggle_pressed() -> void:
	shop_open = !shop_open
