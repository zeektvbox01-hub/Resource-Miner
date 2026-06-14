extends Node2D

# ============================================================================
# CONSTANTS
# ============================================================================
const SAVE_PATH = "user://variable.save"
const VERSION = 1
const MAX_WOOD = 1000000000000
const MAX_CLICK_POWER = 500000000000
const MAX_WOOD_SEC = 500000000000
const COST_MULTIPLIER_DEFAULT = 1.35
# Hard limit = max safe value for signed 64-bit int
const MAX_SIGNED_INT: int = 9223372036854775807
const MIN_SIGNED_INT: int = -9223372036854775808

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
	"monocular_slicer": UpgradeData.new("monocular_slicer", 600000, COST_MULTIPLIER_DEFAULT, 8000),
	"bio-diesel_fleet": UpgradeData.new("bio-diesel_fleet", 1900000, COST_MULTIPLIER_DEFAULT, 28000),
	"gravity_axe": UpgradeData.new("gravity_axe", 22000000, COST_MULTIPLIER_DEFAULT, 35000),
	"forest_strip-miner": UpgradeData.new("forest_strip-miner", 7500000, COST_MULTIPLIER_DEFAULT, 110000),
	"quantum_disintegrator": UpgradeData.new("quantum_disintegrator", 25000000, COST_MULTIPLIER_DEFAULT, 320000),
	"atomic_harvester": UpgradeData.new("atomic_harvester", 40000000, COST_MULTIPLIER_DEFAULT, 850000),
	"molecular_separator": UpgradeData.new("molecular_separator", 110000000, COST_MULTIPLIER_DEFAULT, 1600000),
	"solar-forged_blade": UpgradeData.new("solar-forged_blade", 120000000, COST_MULTIPLIER_DEFAULT, 1700000),
	"orbital_collecter": UpgradeData.new("orbital_collecter", 480000000, COST_MULTIPLIER_DEFAULT, 7500000),
	"reality_ripper": UpgradeData.new("reality_ripper", 600000000, COST_MULTIPLIER_DEFAULT, 9000000),
	"continental_logger": UpgradeData.new("continental_logger", 2200000000, COST_MULTIPLIER_DEFAULT, 32000000),
	"the_infinite_click": UpgradeData.new("the_infinite_click", 4000000000, COST_MULTIPLIER_DEFAULT, 55000000),
	"galactic_harvester": UpgradeData.new("galactic_harvester", 4500000000, COST_MULTIPLIER_DEFAULT, 110000000),
	"big_bang_strike": UpgradeData.new("big_bang_strike", 5000000000, COST_MULTIPLIER_DEFAULT, 115000000),
	"nebula_processor": UpgradeData.new("nebula_processor", 12000000000, COST_MULTIPLIER_DEFAULT, 320000000),
	"planetary_extraction_node": UpgradeData.new("planetary_extraction_node", 13000000000, COST_MULTIPLIER_DEFAULT, 360000000),
	"supernova_chopper": UpgradeData.new("supernova_chopper", 15000000000, COST_MULTIPLIER_DEFAULT, 430000000),
	"black_hole_extractor": UpgradeData.new("black_hole_extractor", 45000000000, COST_MULTIPLIER_DEFAULT, 1400000000),
	"galaxy_splitter": UpgradeData.new("galaxy_splitter", 50000000000, COST_MULTIPLIER_DEFAULT, 1600000000),
	"solar-system_silo":UpgradeData.new("solar_system_silo", 85000000000, COST_MULTIPLIER_DEFAULT, 3000000000),
	"dyson_sphere_network": UpgradeData.new("dyson_sphere_network", 160000000000, COST_MULTIPLIER_DEFAULT, 6000000000),
	"dimension_shear": UpgradeData.new("dimension_shear", 180000000000, COST_MULTIPLIER_DEFAULT, 7500000000),
	"physics_rewriter": UpgradeData.new("physics_rewriter", 400000000000, COST_MULTIPLIER_DEFAULT, 18000000000),
	"timeline_convergence": UpgradeData.new("timeline_convergence", 400000000000, COST_MULTIPLIER_DEFAULT, 18000000000),
	"infinite_energy_engine": UpgradeData.new("infinite_energy_engine", 550000000000, COST_MULTIPLIER_DEFAULT, 26000000000),
	"absolute_tap": UpgradeData.new("absolute_tap", 850000000000, COST_MULTIPLIER_DEFAULT, 45000000000),
	"resource_singularity": UpgradeData.new("resource_singularity", 900000000000, COST_MULTIPLIER_DEFAULT, 52000000000),
}

# One-time upgrades (toggle-based)
var one_time_upgrades = {
	"reinforced_gloves": false,
	"coffee_machine": false,
	"lunch_break_schudule": false,
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
	"biomass_refining": false,
	"global_optimisation": false,
	"saw_upgrade": false,
	"salary_increase": false,
	"master_logger": false,
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
var wood_sec: int = 0
var wood_sec_multiplier :float = 1.0
var golden_seed: int = 0
var prestiges: int = 0

# Click mechanics
var click_power: int = 1
var click_multiplier: float = 1.0
var crictical_click: float = 0.2

# Efficiency multipliers
var worker_efficency: float = 1.0
var vehicle_efficency: float = 1.0
var chainsaw_fleet_efficency: float = 1.0
var idle_efficency: float = 1.0
var golden_seed_multiplier: float = 1.0

# Game state
var cost_multiplier: float = COST_MULTIPLIER_DEFAULT
var shop_open: bool = false
var shop_tab: int = 1
var currency_button_tab: int = 1
var last_save_time: float = 0
var idle_gains = 0

# ============================================================================
# LIFECYCLE
# ============================================================================
func _ready() -> void:
	if OS.get_name() == "Web":
		# Web-specific settings
		get_window().gui_embed_subwindows = true
	$Unused.hide()
	$"Idle Popup".hide()
	$"Music/Bird Music".play()
	$"Music/Rain Music".play()
	load_data()

func _process(_delta: float) -> void:
	update_ui()
	#handle_input()
	handle_shop_state()

func _on_wood_timer_timeout() -> void:
	if wood < MAX_WOOD and wood_sec > 0:
		wood += wood_sec
		cap_all()
		update_ui()

func _on_autosave_timer_timeout() -> void:
	save()

# ============================================================================
# UI UPDATES
# ============================================================================
func update_ui() -> void:
	update_currency_display()
	update_upgrade_displays()
	update_clamp_values()
	cap_all()

func capitalize_each_word(text: String) -> String:
	var parts = text.split(" ")
	for i in range(parts.size()):
		parts[i] = parts[i].capitalize()
	return " ".join(parts)

func update_currency_display() -> void:
	if wood < MAX_WOOD + 1:
		$"Currency Bar"/Wood.text = format_number(wood)
	if wood_sec < MAX_WOOD_SEC + 1:
		$"Currency Bar/Wood per sec".text = format_number(wood_sec) + "/sec"
	if golden_seed < 100001:
		$"Currency Bar/Golden Seeds".text = format_number(golden_seed)
	if click_power < MAX_CLICK_POWER + 1:
		$Instruction.text = "Click to get " + format_number(click_power) + " wood"

func update_upgrade_displays() -> void:
	for upgrade_id in upgrades:
		var upgrade = upgrades[upgrade_id]
		var current_cost = upgrade.base_cost * pow(upgrade.cost_multiplier, upgrade.amount)
		var next_income = upgrade.base_income 
		
		var node_name = capitalize_each_word(upgrade_id.replace("_", " "))
		var node_path = "Shop/Multi-Time Scroller/Multi-Time Upgrades/" + node_name
		var amount_node_path = node_path + "/Amount"
		
		if not has_node(node_path):
			continue
		
		var display_cost = format_number(safe_signed(current_cost))
		
		var is_click_upgrade = upgrade_id in ["axe_skill", "axe_reforge", "reinforced_handle", "titanium_edge", "diamond_plating", "plasma_cutter", "gravity_axe", "monocular_separator", "solar_forged_blade", "orbital_collecter", "reality_ripper", "the_infinite_click", "big_bang_strike","supervona_chopper","black_hole_extractor"]
		
		if is_click_upgrade:
			var display_current_click = format_number(click_power)
			var display_next_click = safe_signed(click_power + (next_income * click_multiplier))
			
			if display_next_click > MAX_CLICK_POWER:
				display_next_click = format_number(MAX_CLICK_POWER)
			else:
				display_next_click = format_number(display_next_click)
			
			get_node(node_path).text = "%s - %s wood\n(%s/click -> %s/click)" % [
				node_name,
				display_cost,
				display_current_click,
				display_next_click
			]
		else:
			var display_current_income = format_number(wood_sec)
			var display_next_income = safe_signed(wood_sec + (next_income * wood_sec_multiplier))
			
			if display_next_income > MAX_WOOD_SEC:
				display_next_income = format_number(MAX_WOOD_SEC)
			else:
				display_next_income = format_number(display_next_income)
			
			get_node(node_path).text = "%s - %s wood\n(%s/sec -> %s/sec)" % [
				node_name,
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
	if wood > MAX_WOOD + 1:
		wood = MAX_WOOD
	if wood_sec > MAX_WOOD_SEC + 1:
		wood_sec = MAX_WOOD_SEC
	if golden_seed > 100001:
		golden_seed = 100000
	if click_power > MAX_CLICK_POWER + 1:
		click_power = MAX_CLICK_POWER
	if wood > 9999999:
		$"Shop/One-Time Scroller/One-Time Upgrades/Prestige Button".show()
	else:
		$"Shop/One-Time Scroller/One-Time Upgrades/Prestige Button".hide()

# Safe conversion: never overflows, never goes negative
func safe_signed(value: float) -> int:
	return clamp(int(value), MIN_SIGNED_INT, MAX_SIGNED_INT)

# Auto-cap all your resources
func cap_all() -> void:
	wood = clamp(wood, 0, MAX_SIGNED_INT)
	wood_sec = clamp(wood_sec, 0, MAX_SIGNED_INT)
	click_power = clamp(click_power, 1, MAX_SIGNED_INT)

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
		$Instruction.hide()
		show_shop_tab(shop_tab)
	else:
		$"Shop/Shop Background".hide()
		$"Shop/Multi-Time Scroller".hide()
		$Shop/Tabs.hide()
		$"Shop/One-Time Scroller".hide()
		$"Shop/Prestige Scroller".hide()
		$Instruction.show()
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
			$"Shop/One-Time Scroller".hide()
			$"Shop/Multi-Time Scroller".show()
			$"Shop/Prestige Scroller".hide()
		2:
			$"Shop/Multi-Time Scroller".hide()
			$"Shop/One-Time Scroller".show()
			$"Shop/Prestige Scroller".hide()
		3:
			$"Shop/Multi-Time Scroller".hide()
			$"Shop/One-Time Scroller".hide()
			$"Shop/Prestige Scroller".show()

func _on_multi_time_upgrades_tab_pressed() -> void:
	shop_tab = 1

func _on_one_time_upgrades_tab_pressed() -> void:
	shop_tab = 2

# ============================================================================
# CLICK MECHANICS
# ============================================================================
func _on_clicker_pressed() -> void:
	if click_power > MAX_CLICK_POWER + 1:
		click_power = MAX_CLICK_POWER
	var critical_roll: float = randf()
	if crictical_click  > round(critical_roll * 1000.0) / 1000.0:
		wood += click_power * 2
	else:
		wood += click_power
	if wood > MAX_WOOD:
		wood = MAX_WOOD

func _on_tree_pressed() -> void:
	if click_power > MAX_CLICK_POWER + 1:
		click_power = MAX_CLICK_POWER
	var tree_wood_amount = randi() % 6
	if tree_wood_amount == 2:
		wood += click_power
	if tree_wood_amount == 3:
		wood += click_power
	if tree_wood_amount == 4:
		wood += 2 * click_power
	if tree_wood_amount == 5:
		wood += 3 * click_power
	if wood > MAX_WOOD:
		wood = MAX_WOOD

# ============================================================================
# MULTI-TIME UPGRADE PURCHASES
# ============================================================================
func try_buy_upgrade(upgrade_id: String) -> bool:
	if not upgrade_id in upgrades:
		return false
	
	var upgrade = upgrades[upgrade_id]
	var current_cost = safe_signed(upgrade.base_cost * pow(upgrade.cost_multiplier, upgrade.amount))
	
	if wood >= current_cost and current_cost < 100000000001:
		wood -= current_cost
		upgrade.amount += 1
		return true
	return false

func _on_axe_skill_pressed() -> void:
	if wood > upgrades["axe_skill"].base_cost * pow(upgrades["axe_skill"].cost_multiplier, upgrades["axe_skill"].amount) - 1:
		if upgrades["axe_skill"].base_cost * pow(upgrades["axe_skill"].cost_multiplier, upgrades["axe_skill"].amount) < 100000000001:
			wood -= safe_signed(upgrades["axe_skill"].base_cost * pow(upgrades["axe_skill"].cost_multiplier, upgrades["axe_skill"].amount))
			click_power += safe_signed(upgrades["axe_skill"].base_income * click_multiplier)
			upgrades["axe_skill"].amount += 1

func _on_worker_pressed() -> void:
	if wood > upgrades["worker"].base_cost * pow(upgrades["worker"].cost_multiplier, upgrades["worker"].amount) - 1:
		if upgrades["worker"].base_cost * pow(upgrades["worker"].cost_multiplier, upgrades["worker"].amount) < 100000000001:
			wood -= safe_signed(upgrades["worker"].base_cost * pow(upgrades["worker"].cost_multiplier, upgrades["worker"].amount))
			wood_sec += safe_signed(upgrades["worker"].base_income * worker_efficency * wood_sec_multiplier)
			upgrades["worker"].amount += 1

func _on_hand_saw_pressed() -> void:
	if wood > upgrades["hand_saw"].base_cost * pow(upgrades["hand_saw"].cost_multiplier, upgrades["hand_saw"].amount) - 1:
		if upgrades["hand_saw"].base_cost * pow(upgrades["hand_saw"].cost_multiplier, upgrades["hand_saw"].amount) < 100000000001:
			wood -= safe_signed(upgrades["hand_saw"].base_cost * pow(upgrades["hand_saw"].cost_multiplier, upgrades["hand_saw"].amount))
			wood_sec += safe_signed(upgrades["hand_saw"].base_income * wood_sec_multiplier)
			upgrades["hand_saw"].amount += 1

func _on_reinforced_handle_pressed() -> void:
	if wood > upgrades["reinforced_handle"].base_cost * pow(upgrades["reinforced_handle"].cost_multiplier, upgrades["reinforced_handle"].amount) - 1:
		if upgrades["reinforced_handle"].base_cost * pow(upgrades["reinforced_handle"].cost_multiplier, upgrades["reinforced_handle"].amount) < 100000000001:
			wood -= safe_signed(upgrades["reinforced_handle"].base_cost * pow(upgrades["reinforced_handle"].cost_multiplier, upgrades["reinforced_handle"].amount))
			click_power += safe_signed(upgrades["reinforced_handle"].base_cost * click_multiplier)
			upgrades["reinforced_handle"].amount += 1

func _on_axe_reforge_pressed() -> void:
	if wood > upgrades["axe_reforge"].base_cost * pow(upgrades["axe_reforge"].cost_multiplier, upgrades["axe_reforge"].amount) - 1:
		if upgrades["axe_reforge"].base_cost * pow(upgrades["axe_reforge"].cost_multiplier, upgrades["axe_reforge"].amount) < 100000000001:
			wood -= safe_signed(upgrades["axe_reforge"].base_cost * pow(upgrades["axe_reforge"].cost_multiplier, upgrades["axe_reforge"].amount))
			click_power += safe_signed(upgrades["axe_reforge"].base_cost * click_multiplier)
			upgrades["axe_reforge"].amount += 1

func _on_lumberjack_team_pressed() -> void:
	if wood > upgrades["lumberjack_team"].base_cost * pow(upgrades["lumberjack_team"].cost_multiplier, upgrades["lumberjack_team"].amount) - 1:
		if upgrades["lumberjack_team"].base_cost * pow(upgrades["lumberjack_team"].cost_multiplier, upgrades["lumberjack_team"].amount) < 100000000001:
			wood -= safe_signed(upgrades["lumberjack_team"].base_cost * pow(upgrades["lumberjack_team"].cost_multiplier, upgrades["lumberjack_team"].amount))
			wood_sec += safe_signed(upgrades["lumberjack_team"].base_cost * wood_sec_multiplier)
			upgrades["lumberjack_team"].amount += 1

func _on_titanium_edge_pressed() -> void:
	if wood > upgrades["titanium_edge"].base_cost * pow(upgrades["titanium_edge"].cost_multiplier, upgrades["titanium_edge"].amount) - 1:
		if upgrades["titanium_edge"].base_cost * pow(upgrades["titanium_edge"].cost_multiplier, upgrades["titanium_edge"].amount) < 100000000001:
			wood -= safe_signed(upgrades["titanium_edge"].base_cost * pow(upgrades["titanium_edge"].cost_multiplier, upgrades["titanium_edge"].amount))
			click_power += safe_signed(upgrades["titanium_edge"].base_cost * click_multiplier)
			upgrades["titanium_edge"].amount += 1

func _on_chainsaw_fleet_pressed() -> void:
	if wood > upgrades["chainsaw_fleet"].base_cost * pow(upgrades["chainsaw_fleet"].cost_multiplier, upgrades["chainsaw_fleet"].amount) - 1:
		if upgrades["chainsaw_fleet"].base_cost * pow(upgrades["chainsaw_fleet"].cost_multiplier, upgrades["chainsaw_fleet"].amount) < 100000000001:
			wood -= safe_signed(upgrades["chainsaw_fleet"].base_cost * pow(upgrades["chainsaw_fleet"].cost_multiplier, upgrades["chainsaw_fleet"].amount))
			wood_sec += safe_signed(upgrades["chainsaw_fleet"].base_cost * chainsaw_fleet_efficency * wood_sec_multiplier)
			upgrades["chainsaw_fleet"].amount += 1

func _on_bulldozers_pressed() -> void:
	if wood > upgrades["bulldozers"].base_cost * pow(upgrades["bulldozers"].cost_multiplier, upgrades["bulldozers"].amount) - 1:
		if upgrades["bulldozers"].base_cost * pow(upgrades["bulldozers"].cost_multiplier, upgrades["bulldozers"].amount) < 100000000001:
			wood -= safe_signed(upgrades["bulldozers"].base_cost * pow(upgrades["bulldozers"].cost_multiplier, upgrades["bulldozers"].amount))
			wood_sec += safe_signed(upgrades["bulldozers"].base_cost * vehicle_efficency * wood_sec_multiplier)
			upgrades["bulldozers"].amount += 1

func _on_diamond_plating_pressed() -> void:
	if wood > upgrades["diamond_plating"].base_cost * pow(upgrades["diamond_plating"].cost_multiplier, upgrades["diamond_plating"].amount) - 1:
		if upgrades["diamond_plating"].base_cost * pow(upgrades["diamond_plating"].cost_multiplier, upgrades["diamond_plating"].amount) < 100000000001:
			wood -= safe_signed(upgrades["diamond_plating"].base_cost * pow(upgrades["diamond_plating"].cost_multiplier, upgrades["diamond_plating"].amount))
			click_power += safe_signed(upgrades["diamond_plating"].base_cost * click_multiplier)
			upgrades["diamond_plating"].amount += 1

func _on_tree_harvester_pressed()-> void:
	if wood > upgrades["tree_harvester"].base_cost * pow(upgrades["tree_harvester"].cost_multiplier, upgrades["tree_harvester"].amount) - 1:
		if upgrades["tree_harvester"].base_cost * pow(upgrades["tree_harvester"].cost_multiplier, upgrades["tree_harvester"].amount) < 100000000001:
			wood -= safe_signed(upgrades["tree_harvester"].base_cost * pow(upgrades["tree_harvester"].cost_multiplier, upgrades["tree_harvester"].amount))
			wood_sec += safe_signed(upgrades["tree_harvester"].base_cost * vehicle_efficency * wood_sec_multiplier)
			upgrades["tree_harvester"].amount += 1

func _on_industrial_mulcher_pressed() -> void:
	if wood > upgrades["industrial_mulcher"].base_cost * pow(upgrades["industrial_mulcher"].cost_multiplier, upgrades["industrial_mulcher"].amount) - 1:
		if upgrades["industrial_mulcher"].base_cost * pow(upgrades["industrial_mulcher"].cost_multiplier, upgrades["industrial_mulcher"].amount) < 100000000001:
			wood -= safe_signed(upgrades["industrial_mulcher"].base_cost * pow(upgrades["industrial_mulcher"].cost_multiplier, upgrades["industrial_mulcher"].amount))
			wood_sec += safe_signed(upgrades["industrial_mulcher"].base_cost * vehicle_efficency * wood_sec_multiplier)
			upgrades["industrial_mulcher"].amount += 1

func _on_plasma_cutter_pressed() -> void:
	if wood > upgrades["plasma_cutter"].base_cost * pow(upgrades["plasma_cutter"].cost_multiplier, upgrades["plasma_cutter"].amount) - 1:
		if upgrades["plasma_cutter"].base_cost * pow(upgrades["plasma_cutter"].cost_multiplier, upgrades["plasma_cutter"].amount) < 100000000001:
			wood -= safe_signed(upgrades["plasma_cutter"].base_cost * pow(upgrades["plasma_cutter"].cost_multiplier, upgrades["plasma_cutter"].amount))
			click_power += safe_signed(upgrades["plasma_cutter"].base_cost * click_multiplier)
			upgrades["plasma_cutter"].amount += 1

func _on_mass_processing_plant_pressed() -> void:
	if wood > upgrades["mass_processing_plant"].base_cost * pow(upgrades["mass_processing_plant"].cost_multiplier, upgrades["mass_processing_plant"].amount) - 1:
		if upgrades["mass_processing_plant"].base_cost * pow(upgrades["mass_processing_plant"].cost_multiplier, upgrades["mass_processing_plant"].amount) < 100000000001:
			wood -= safe_signed(upgrades["mass_processing_plant"].base_cost * pow(upgrades["mass_processing_plant"].cost_multiplier, upgrades["mass_processing_plant"].amount))
			wood_sec += safe_signed(upgrades["mass_processing_plant"].base_cost * wood_sec_multiplier)
			upgrades["mass_processing_plant"].amount += 1

func _on_automated_logging_rig_pressed() -> void:
	if wood > upgrades["automated_logging_rig"].base_cost * pow(upgrades["automated_logging_rig"].cost_multiplier, upgrades["automated_logging_rig"].amount) - 1:
		if upgrades["automated_logging_rig"].base_cost * pow(upgrades["automated_logging_rig"].cost_multiplier, upgrades["automated_logging_rig"].amount) < 100000000001:
			wood -= safe_signed(upgrades["automated_logging_rig"].base_cost * pow(upgrades["automated_logging_rig"].cost_multiplier, upgrades["automated_logging_rig"].amount))
			wood_sec += safe_signed(upgrades["automated_logging_rig"].base_cost * wood_sec_multiplier)
			upgrades["automated_logging_rig"].amount += 1

func _on_monocular_slicer_pressed() -> void:
	if wood > upgrades["monocular_slicer"].base_cost * pow(upgrades["monocular_slicer"].cost_multiplier, upgrades["monocular_slicer"].amount) - 1:
		if upgrades["monocular_slicer"].base_cost * pow(upgrades["monocular_slicer"].cost_multiplier, upgrades["monocular_slicer"].amount) < 100000000001:
			wood -= safe_signed(upgrades["monocular_slicer"].base_cost * pow(upgrades["monocular_slicer"].cost_multiplier, upgrades["monocular_slicer"].amount))
			click_power += safe_signed(8000 * click_multiplier)
			upgrades["monocular_slicer"].amount += 1

func _on_bio_diesel_fleet_pressed() -> void:
	if wood > upgrades["bio-diesel_fleet"].base_cost * pow(upgrades["bio-diesel_fleet"].cost_multiplier, upgrades["bio-diesel_fleet"].amount) - 1:
		if upgrades["bio-diesel_fleet"].base_cost * pow(upgrades["bio-diesel_fleet"].cost_multiplier, upgrades["bio-diesel_fleet"].amount) < 100000000001:
			wood -= safe_signed(upgrades["bio-diesel_fleet"].base_cost * pow(upgrades["bio-diesel_fleet"].cost_multiplier, upgrades["bio-diesel_fleet"].amount))
			wood_sec += safe_signed(upgrades["bio-diesel_fleet"].base_cost * wood_sec_multiplier)
			upgrades["bio-diesel_fleet"].amount += 1

func _on_gravity_axe_pressed() -> void:
	if wood > upgrades["gravity_axe"].base_cost * pow(upgrades["gravity_axe"].cost_multiplier, upgrades["gravity_axe"].amount) - 1:
		if upgrades["gravity_axe"].base_cost * pow(upgrades["gravity_axe"].cost_multiplier, upgrades["gravity_axe"].amount) < 100000000001:
			wood -= safe_signed(upgrades["gravity_axe"].base_cost * pow(upgrades["gravity_axe"].cost_multiplier, upgrades["gravity_axe"].amount))
			click_power += safe_signed(upgrades["gravity_axe"].base_cost * click_multiplier)
			upgrades["gravity_axe"].amount += 1

func _on_forest_strip_miner_pressed() -> void:
	if wood > upgrades["forest-strip_miner"].base_cost * pow(upgrades["forest-strip_miner"].cost_multiplier, upgrades["forest-strip_miner"].amount) - 1:
		if upgrades["forest-strip_miner"].base_cost * pow(upgrades["forest-strip_miner"].cost_multiplier, upgrades["forest-strip_miner"].amount) < 100000000001:
			wood -= safe_signed(upgrades["forest-strip_miner"].base_cost * pow(upgrades["forest-strip_miner"].cost_multiplier, upgrades["forest-strip_miner"].amount))
			wood_sec += safe_signed(upgrades["forest-strip_miner"].base_cost * wood_sec_multiplier)
			upgrades["forest-strip_miner"].amount += 1

func _on_quantum_disintegrator_pressed() -> void:
	if wood > upgrades["quantum_disintegrator"].base_cost * pow(upgrades["quantum_disintegrator"].cost_multiplier, upgrades["quantum_disintegrator"].amount) - 1:
		if upgrades["quantum_disintegrator"].base_cost * pow(upgrades["quantum_disintegrator"].cost_multiplier, upgrades["quantum_disintegrator"].amount) < 100000000001:
			wood -= safe_signed(upgrades["quantum_disintegrator"].base_cost * pow(upgrades["quantum_disintegrator"].cost_multiplier, upgrades["quantum_disintegrator"].amount))
			click_power += safe_signed(upgrades["quantum_disintegrator"].base_cost * click_multiplier)
			upgrades["quantum_disintegrator"].amount += 1

func _on_atomic_harvester_pressed() -> void:
	if wood > upgrades["atomic_harvester"].base_cost * pow(upgrades["atomic_harvester"].cost_multiplier, upgrades["atomic_harvester"].amount) - 1:
		if upgrades["atomic_harvester"].base_cost * pow(upgrades["atomic_harvester"].cost_multiplier, upgrades["atomic_harvester"].amount) < 100000000001:
			wood -= safe_signed(upgrades["atomic_harvester"].base_cost * pow(upgrades["atomic_harvester"].cost_multiplier, upgrades["atomic_harvester"].amount))
			wood_sec += safe_signed(upgrades["atomic_harvester"].base_cost * wood_sec_multiplier)
			upgrades["atomic_harvester"].amount += 1

func _on_molecular_separator_pressed() -> void:
	if wood > upgrades["molecular_separator"].base_cost * pow(upgrades["molecular_separator"].cost_multiplier, upgrades["molecular_separator"].amount) - 1:
		if upgrades["molecular_separator"].base_cost * pow(upgrades["molecular_separator"].cost_multiplier, upgrades["molecular_separator"].amount) < 100000000001:
			wood -= safe_signed(upgrades["molecular_separator"].base_cost * pow(upgrades["molecular_separator"].cost_multiplier, upgrades["molecular_separator"].amount))
			wood_sec += safe_signed(upgrades["molecular_separator"].base_cost * wood_sec_multiplier)
			upgrades["molecular_separator"].amount += 1

func _on_solar_forged_blade_pressed() -> void:
	if wood > upgrades["solar-forged_blade"].base_cost * pow(upgrades["solar-forged_blade"].cost_multiplier, upgrades["solar-forged_blade"].amount) - 1:
		if upgrades["solar-forged_blade"].base_cost * pow(upgrades["solar-forged_blade"].cost_multiplier, upgrades["solar-forged_blade"].amount) < 100000000001:
			wood -= safe_signed(upgrades["solar-forged_blade"].base_cost * pow(upgrades["solar-forged_blade"].cost_multiplier, upgrades["solar-forged_blade"].amount))
			click_power += safe_signed(upgrades["solar-forged_blade"].base_cost * click_multiplier)
			upgrades["solar-forged_blade"].amount += 1

func _on_orbital_collecter_pressed() -> void:
	if wood > upgrades["orbital_collecter"].base_cost * pow(upgrades["orbital_collecter"].cost_multiplier, upgrades["orbital_collecter"].amount) - 1:
		if upgrades["orbital_collecter"].base_cost * pow(upgrades["orbital_collecter"].cost_multiplier, upgrades["orbital_collecter"].amount) < 100000000001:
			wood -= safe_signed(upgrades["orbital_collecter"].base_cost * pow(upgrades["orbital_collecter"].cost_multiplier, upgrades["orbital_collecter"].amount))
			wood_sec += safe_signed(upgrades["orbital_collecter"].base_cost * wood_sec_multiplier)
			upgrades["orbital_collecter"].amount += 1

func _on_reality_ripper_pressed() -> void:
	if wood > upgrades["reality_ripper"].base_cost * pow(upgrades["reality_ripper"].cost_multiplier, upgrades["reality_ripper"].amount) - 1:
		if upgrades["reality_ripper"].base_cost * pow(upgrades["reality_ripper"].cost_multiplier, upgrades["reality_ripper"].amount) < 100000000001:
			wood -= safe_signed(upgrades["reality_ripper"].base_cost * pow(upgrades["reality_ripper"].cost_multiplier, upgrades["reality_ripper"].amount))
			click_power += safe_signed(upgrades["reality_ripper"].base_cost * click_multiplier)
			upgrades["reality_ripper"].amount += 1

func _on_continental_logger_pressed() -> void:
	if wood > upgrades["continental_logger"].base_cost * pow(upgrades["continental_logger"].cost_multiplier, upgrades["continental_logger"].amount) - 1:
		if upgrades["continental_logger"].base_cost * pow(upgrades["continental_logger"].cost_multiplier, upgrades["continental_logger"].amount) < 100000000001:
			wood -= safe_signed(upgrades["continental_logger"].base_cost * pow(upgrades["continental_logger"].cost_multiplier, upgrades["continental_logger"].amount))
			wood_sec += safe_signed(upgrades["continental_logger"].base_cost * wood_sec_multiplier)
			upgrades["continental_logger"].amount += 1

func _on_the_infinite_click_pressed() -> void:
	if wood > upgrades["the_infinite_click"].base_cost * pow(upgrades["the_infinite_click"].cost_multiplier, upgrades["the_infinite_click"].amount) - 1:
		if upgrades["the_infinite_click"].base_cost * pow(upgrades["the_infinite_click"].cost_multiplier, upgrades["the_infinite_click"].amount) < 100000000001:
			wood -= safe_signed(upgrades["the_infinite_click"].base_cost * pow(upgrades["the_infinite_click"].cost_multiplier, upgrades["the_infinite_click"].amount))
			click_power += safe_signed(upgrades["the_infinite_click"].base_cost * click_multiplier)
			upgrades["the_infinite_click"].amount += 1

func _on_galactic_harvester_pressed() -> void:
	if wood > upgrades["galactic_harvester"].base_cost * pow(upgrades["galactic_harvester"].cost_multiplier, upgrades["galactic_harvester"].amount) - 1:
		if upgrades["galactic_harvester"].base_cost * pow(upgrades["galactic_harvester"].cost_multiplier, upgrades["galactic_harvester"].amount) < 100000000001:
			wood -= safe_signed(upgrades["galactic_harvester"].base_cost * pow(upgrades["galactic_harvester"].cost_multiplier, upgrades["galactic_harvester"].amount))
			wood_sec += safe_signed(upgrades["galactic_harvester"].base_cost * wood_sec_multiplier)
			upgrades["galactic_harvester"].amount += 1

func _on_big_bang_strike_pressed() -> void:
	if wood > upgrades["big_bang_strike"].base_cost * pow(upgrades["big_bang_strike"].cost_multiplier, upgrades["big_bang_strike"].amount) - 1:
		if upgrades["big_bang_strike"].base_cost * pow(upgrades["big_bang_strike"].cost_multiplier, upgrades["big_bang_strike"].amount) < 100000000001:
			wood -= safe_signed(upgrades["big_bang_strike"].base_cost * pow(upgrades["big_bang_strike"].cost_multiplier, upgrades["big_bang_strike"].amount))
			click_power += safe_signed(upgrades["big_bang_strike"].base_cost * click_multiplier)
			upgrades["big_bang_strike"].amount += 1

func _on_nebula_processor_pressed() -> void:
	if wood > upgrades["nebula_processor"].base_cost * pow(upgrades["nebula_processor"].cost_multiplier, upgrades["nebula_processor"].amount) - 1:
		if upgrades["nebula_processor"].base_cost * pow(upgrades["nebula_processor"].cost_multiplier, upgrades["nebula_processor"].amount) < 100000000001:
			wood -= safe_signed(upgrades["nebula_processor"].base_cost * pow(upgrades["nebula_processor"].cost_multiplier, upgrades["nebula_processor"].amount))
			wood_sec += safe_signed(upgrades["nebula_processor"].base_cost * wood_sec_multiplier)
			upgrades["nebula_processor"].amount += 1

func _on_planetary_extraction_node_pressed() -> void:
	if wood > upgrades["planetary_extraction_node"].base_cost * pow(upgrades["planetary_extraction_node"].cost_multiplier, upgrades["planetary_extraction_node"].amount) - 1:
		if upgrades["planetary_extraction_node"].base_cost * pow(upgrades["planetary_extraction_node"].cost_multiplier, upgrades["planetary_extraction_node"].amount) < 100000000001:
			wood -= safe_signed(upgrades["planetary_extraction_node"].base_cost * pow(upgrades["planetary_extraction_node"].cost_multiplier, upgrades["planetary_extraction_node"].amount))
			wood_sec += safe_signed(upgrades["planetary_extraction_node"].base_cost * wood_sec_multiplier)
			upgrades["planetary_extraction_node"].amount += 1

func _on_supernova_chopper_pressed() -> void:
	if wood > upgrades["supernova_chopper"].base_cost * pow(upgrades["supernova_chopper"].cost_multiplier, upgrades["supernova_chopper"].amount) - 1:
		if upgrades["supernova_chopper"].base_cost * pow(upgrades["supernova_chopper"].cost_multiplier, upgrades["supernova_chopper"].amount) < 100000000001:
			wood -= safe_signed(upgrades["supernova_chopper"].base_cost * pow(upgrades["supernova_chopper"].cost_multiplier, upgrades["supernova_chopper"].amount))
			click_power += safe_signed(upgrades["supervona_chopper"].base_cost * click_multiplier)
			upgrades["supernova_chopper"].amount += 1

func _on_black_hole_extractor_pressed() -> void:
	if wood > upgrades["black_hole_extractor"].base_cost * pow(upgrades["black_hole_extractor"].cost_multiplier, upgrades["black_hole_extractor"].amount) - 1:
		if upgrades["black_hole_extractor"].base_cost * pow(upgrades["black_hole_extractor"].cost_multiplier, upgrades["black_hole_extractor"].amount) < 100000000001:
			wood -= safe_signed(upgrades["black_hole_extractor"].base_cost * pow(upgrades["black_hole_extractor"].cost_multiplier, upgrades["black_hole_extractor"].amount))
			wood_sec += safe_signed(upgrades["black_hole_extractor"].base_cost * wood_sec_multiplier)
			upgrades["black_hole_extractor"].amount += 1

func _on_galaxy_spliitter_pressed() -> void:
	if wood > upgrades["galaxy_splitter"].base_cost * pow(upgrades["galaxy_splitter"].cost_multiplier, upgrades["galaxy_splitter"].amount) - 1:
		if upgrades["galaxy_splitter"].base_cost * pow(upgrades["galaxy_splitter"].cost_multiplier, upgrades["galaxy_splitter"].amount) < 100000000001:
			wood -= safe_signed(upgrades["galaxy_splitter"].base_cost * pow(upgrades["galaxy_splitter"].cost_multiplier, upgrades["galaxy_splitter"].amount))
			click_power += safe_signed(upgrades["galaxy_splitter"].base_cost * click_multiplier)
			upgrades["galaxy_splitter"].amount += 1

func _on_solar_system_silo_pressed() -> void:
	if wood > upgrades["solar-system_silo"].base_cost * pow(upgrades["solar-system_silo"].cost_multiplier, upgrades["solar-system_silo"].amount) - 1:
		if upgrades["solar-system_silo"].base_cost * pow(upgrades["solar-system_silo"].cost_multiplier, upgrades["solar-system_silo"].amount) < 100000000001:
			wood -= safe_signed(upgrades["solar-system_silo"].base_cost * pow(upgrades["solar-system_silo"].cost_multiplier, upgrades["solar-system_silo"].amount))
			wood_sec += safe_signed(upgrades["solar-system_silo"].base_cost * wood_sec_multiplier)
			upgrades["solar-system_silo"].amount += 1

func _on_dyson_sphere_network_pressed() -> void:
	if wood > upgrades["dyson_sphere_network"].base_cost * pow(upgrades["dyson_sphere_network"].cost_multiplier, upgrades["dyson_sphere_network"].amount) - 1:
		if upgrades["dyson_sphere_network"].base_cost * pow(upgrades["dyson_sphere_network"].cost_multiplier, upgrades["dyson_sphere_network"].amount) < 100000000001:
			wood -= safe_signed(upgrades["dyson_sphere_network"].base_cost * pow(upgrades["dyson_sphere_network"].cost_multiplier, upgrades["dyson_sphere_network"].amount))
			wood_sec += safe_signed(upgrades["dyson_sphere_network"].base_cost * wood_sec_multiplier)
			upgrades["dyson_sphere_network"].amount += 1

func _on_dimension_shear_pressed() -> void:
	if wood > upgrades["dimension_shear"].base_cost * pow(upgrades["dimension_shear"].cost_multiplier, upgrades["dimension_shear"].amount) - 1:
		if upgrades["dimension_shear"].base_cost * pow(upgrades["dimension_shear"].cost_multiplier, upgrades["dimension_shear"].amount) < 100000000001:
			wood -= safe_signed(upgrades["dimension_shear"].base_cost * pow(upgrades["dimension_shear"].cost_multiplier, upgrades["dimension_shear"].amount))
			click_power += safe_signed(upgrades["dimension_shear"].base_cost * click_multiplier)
			upgrades["dimension_shear"].amount += 1

func _on_physics_rewriter_pressed() -> void:
	if wood > upgrades["physics_rewriter"].base_cost * pow(upgrades["physics_rewriter"].cost_multiplier, upgrades["physics_rewriter"].amount) - 1:
		if upgrades["physics_rewriter"].base_cost * pow(upgrades["physics_rewriter"].cost_multiplier, upgrades["physics_rewriter"].amount) < 100000000001:
			wood -= safe_signed(upgrades["physics_rewriter"].base_cost * pow(upgrades["physics_rewriter"].cost_multiplier, upgrades["physics_rewriter"].amount))
			click_power += safe_signed(upgrades["physics_rewriter"].base_cost * click_multiplier)
			upgrades["physics_rewriter"].amount += 1

func _on_timeline_convergence_pressed() -> void:
	if wood > upgrades["timeline_convergence"].base_cost * pow(upgrades["timeline_convergence"].cost_multiplier, upgrades["timeline_convergence"].amount) - 1:
		if upgrades["timeline_convergence"].base_cost * pow(upgrades["timeline_convergence"].cost_multiplier, upgrades["timeline_convergence"].amount) < 100000000001:
			wood -= safe_signed(upgrades["timeline_convergence"].base_cost * pow(upgrades["timeline_convergence"].cost_multiplier, upgrades["timeline_convergence"].amount))
			wood_sec += safe_signed(upgrades["timeline_convergence"].base_cost * wood_sec_multiplier)
			upgrades["timeline_convergence"].amount += 1

func _on_infinite_energy_engine_pressed() -> void:
	if wood > upgrades["infinite_energy_engine"].base_cost * pow(upgrades["infinite_energy_engine"].cost_multiplier, upgrades["infinite_energy_engine"].amount) - 1:
		if upgrades["infinite_energy_engine"].base_cost * pow(upgrades["infinite_energy_engine"].cost_multiplier, upgrades["infinite_energy_engine"].amount) < 100000000001:
			wood -= safe_signed(upgrades["infinite_energy_engine"].base_cost * pow(upgrades["infinite_energy_engine"].cost_multiplier, upgrades["infinite_energy_engine"].amount))
			wood_sec += safe_signed(upgrades["infinite_energy_engine"].base_cost * wood_sec_multiplier)
			upgrades["infinite_energy_engine"].amount += 1

func _on_absolute_tap_pressed() -> void:
	if wood > upgrades["absolute_tap"].base_cost * pow(upgrades["absolute_tap"].cost_multiplier, upgrades["absolute_tap"].amount) - 1:
		if upgrades["absolute_tap"].base_cost * pow(upgrades["absolute_tap"].cost_multiplier, upgrades["absolute_tap"].amount) < 100000000001:
			wood -= safe_signed(upgrades["absolute_tap"].base_cost * pow(upgrades["absolute_tap"].cost_multiplier, upgrades["absolute_tap"].amount))
			click_power += safe_signed(upgrades["absolute_tap"].base_cost * click_multiplier)
			upgrades["absolute_tap"].amount += 1

func _on_resource_singularity_pressed() -> void:
	if wood > upgrades["resource_singularity"].base_cost * pow(upgrades["resource_singularity"].cost_multiplier, upgrades["resource_singularity"].amount) - 1:
		if upgrades["resource_singularity"].base_cost * pow(upgrades["resource_singularity"].cost_multiplier, upgrades["resource_singularity"].amount) < 100000000001:
			wood -= safe_signed(upgrades["resource_singularity"].base_cost * pow(upgrades["resource_singularity"].cost_multiplier, upgrades["resource_singularity"].amount))
			wood_sec += safe_signed(upgrades["resource_singularity"].base_cost * wood_sec_multiplier)
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
		$"Shop/One-Time Scroller/One-Time Upgrades/Reinforced Gloves".hide()
		save()

func _on_coffee_machine_pressed() -> void:
	if wood > 1199:
		wood -= 1200
		worker_efficency *= 1.1
		wood_sec += (upgrades["worker"].amount * 1 * (worker_efficency - 1))
		one_time_upgrades["coffee_machine"] = true
		$"Shop/One-Time Scroller/One-Time Upgrades/Coffee Machine".hide()
		save()

func _on_lunch_break_schudule_pressed() -> void:
	if wood > 3999:
		wood -= 4000
		idle_efficency *= 1.15
		one_time_upgrades["lunch_break_schudule"] = true
		$"Shop/One-Time Scroller/One-Time Upgrades/Lunch Break Schedule".hide()
		save()

func _on_steel_axe_head_pressed() -> void:
	if wood > 24999:
		wood -= 25000
		click_power += safe_signed(500 * click_multiplier)
		one_time_upgrades["steel_axe_head"] = true
		$"Shop/One-Time Scroller/One-Time Upgrades/Steel Axe Head".hide()
		save()

func _on_turbochargers_pressed() -> void:
	if wood > 74999:
		wood -= 75000
		vehicle_efficency *= 1.25
		wood_sec += ((upgrades["bulldozers"].amount * 200) + (upgrades["tree_harvester"].amount * 600) + (upgrades["industrial_mulcher"].amount * 1000)) * (vehicle_efficency - 1)
		one_time_upgrades["turbochargers"] = true
		$"Shop/One-Time Scroller/One-Time Upgrades/Turbochargers".hide()
		save()

func _on_log_flume_pressed() -> void:
	if wood > 199999:
		wood -= 200000
		cost_multiplier -= 0.01
		one_time_upgrades["log_flume"] = true
		$"Shop/One-Time Scroller/One-Time Upgrades/Log Flume".hide()
		save()

func _on_gps_mapping_pressed() -> void:
	if wood > 499999:
		wood -= 500000
		crictical_click += 0.4
		one_time_upgrades["gps_mapping"] = true
		$"Shop/One-Time Scroller/One-Time Upgrades/GPS Mapping".hide()
		save()

func _on_shift_management_pressed() -> void:
	if wood > 1499999:
		wood -= 1500000
		idle_efficency *= 2
		one_time_upgrades["shift_management"] = true
		$"Shop/One-Time Scroller/One-Time Upgrades/Shift Management".hide()
		save()

func _on_carbon_fiber_saws_pressed() -> void:
	if wood > 24999999:
		wood -= 25000000
		chainsaw_fleet_efficency *= 3
		wood_sec += safe_signed(chainsaw_fleet_efficency * 80 * (chainsaw_fleet_efficency - 1))
		one_time_upgrades["carbon_fiber_saws"] = true
		$"Shop/One-Time Scroller/One-Time Upgrades/Carbon Fiber Saws".hide()

func _on_diamond_coated_teeth_pressed() -> void:
	if wood > 99999999:
		wood -= 100000000
		click_multiplier *= 4
		click_power *= 4
		one_time_upgrades["diamond_coated_teeth"] = true
		$"Shop/One-Time Scroller/One-Time Upgrades/Diamond-Coated Teeth".hide()

func _on_automation_logic_controller_pressed() -> void:
	if wood > 499999999:
		wood -= 500000000
		cost_multiplier -= 0.02
		one_time_upgrades["automation_logic_controller"] = true
		$"Shop/One-Time Scroller/One-Time Upgrades/Automation Logic Controller".hide()

func _on_vertical_intergration_pressed() -> void:
	if wood > 2499999999:
		wood -= 25000000
		wood_sec *= 10
		wood_sec_multiplier *= 10
		one_time_upgrades["vertical_intergration"] = true
		$"Shop/One-Time Scroller/One-Time Upgrades/Vertical Intergration".hide()

func _on_the_eternal_forest_pressed() -> void:
	if wood > 9999999999:
		wood -= 10000000000
		click_power *= 10
		wood_sec *= 10
		click_multiplier *= 10
		wood_sec_multiplier *= 10
		one_time_upgrades["the_eternal_forest"] = true
		$"Shop/One-Time Scroller/One-Time Upgrades/The Eternal Forest".hide()

func _on_biomass_refining_pressed() -> void:
	if wood > 249999999999:
		wood -= 250000000000
		click_power *= 12
		wood_sec *= 12
		click_multiplier *= 12
		wood_sec_multiplier *= 12
		one_time_upgrades["biomass_refining"] = true
		$"Shop/One-Time Scroller/One-Time Upgrades/Biomass Refining".hide()

func _on_global_optimisation_pressed() -> void:
	if wood > 59999999999:
		wood -= 60000000000
		cost_multiplier -= 0.03
		one_time_upgrades["global_optimisation"] = true
		$"Shop/One-Time Scroller/One-Time Upgrades/Global Optimisation".hide()

func _on_saw_upgrade_pressed() -> void:
	if wood > 149999999999:
		wood -= 150000000000
		click_power *= 15
		click_multiplier *= 15
		one_time_upgrades["saw_upgrade"] = true
		$"Shop/One-Time Scroller/One-Time Upgrades/Saw Upgrade".hide()

func _on_salary_increase_pressed() -> void:
	if wood > 399999999999:
		wood -= 400000000000
		idle_efficency *= 5
		one_time_upgrades["salary_increase"] = true
		$"Shop/One-Time Scroller/One-Time Upgrades/Salary Increase".hide()
		save()

func _on_master_logger_pressed() -> void:
	if wood > 499999999999:
		wood -= 800000000000
		click_power *= 20
		click_multiplier *= 20
		one_time_upgrades["master_logger"] = true
		$"Shop/One-Time Scroller/One-Time Upgrades/Master Logger".hide()

# ============================================================================
# PRESTIGE SYSTEM
# ============================================================================
func _on_prestige_pressed() -> void:
	set_process(false)
	
	# Calculate seed gain
	var seed_gain = sqrt(wood / 1000.0) * golden_seed_multiplier
	if seed_gain > 0:
		if (golden_seed + seed_gain) < 100000:
			golden_seed += safe_signed(seed_gain)
		else:
			golden_seed = 100000
	
		# Store 10% wood if wood_bank is unlocked
	var wood_to_keep = 0
	if prestige_upgrades["wood_bank"]:
		if prestige_upgrades["wood_saving_account"]:
				wood_to_keep = safe_signed(wood * 0.35) # Keep 35%
		else:
			wood_to_keep = safe_signed(wood * 0.1)  # Keep 10%
	else:
		if prestige_upgrades["wood_saving_account"]:
			wood_to_keep = safe_signed(wood * 0.25)  # Keep 25%
	
	# Reset progression
	reset_progression()
	
	# Add back the stored wood
	wood = wood_to_keep
	
	# Apply one-time upgrades
	if prestige_upgrades["theyre_mine"]:
		apply_one_time_upgrades()
		update_clamp_values()
	
	#Do prestige upgrades
	apply_prestige_upgrades()
	update_clamp_values()
	
	prestiges += 1
	save()
	refresh_upgrade_visibility()
	set_process(true)

func reset_progression() -> void:
	wood = 0
	click_power = 1
	wood_sec = 0
	idle_efficency = 0
	crictical_click = 0.2
	cost_multiplier_setting() # Used for cost_multiplier
	
	for upgrade in upgrades.values():
		upgrade.amount = 0
	
	worker_efficency = 1
	click_multiplier = 1
	vehicle_efficency = 1
	chainsaw_fleet_efficency = 1
	
	if not prestige_upgrades["theyre_mine"]:
		for key in one_time_upgrades:
			one_time_upgrades[key] = false

func apply_one_time_upgrades() -> void:
	var click_multiplier_synergy = 0
	var idle_synergy = 0
	var discount_synergy = 0
	var wood_production_synergy = 0
	
	# Click Multiplier
	if one_time_upgrades["reinforced_gloves"]:
		click_multiplier *= 2
		click_multiplier_synergy += 1
	if one_time_upgrades["diamond_coated_teeth"]:
		click_multiplier *= 8
		click_multiplier_synergy += 1
	if one_time_upgrades["saw_upgrade"]:
		click_multiplier *= 15
		click_multiplier_synergy += 1
	if one_time_upgrades["master_logger"]:
		click_multiplier *= 20
		click_multiplier_synergy += 1
	if click_multiplier_synergy == 4:
		click_multiplier *= 2
	
	#Idling Multiplier
	if one_time_upgrades["lunch_break_schudule"]:
		idle_efficency *= 1.15
		idle_synergy += 1
	if one_time_upgrades["shift_management"]:
		idle_efficency *= 2
		idle_synergy += 1
	if one_time_upgrades["salary_increase"]:
		idle_efficency *= 5
		idle_synergy += 1
	if idle_synergy == 3:
		idle_efficency *= 2
	
	#Discount Multiplier
	if one_time_upgrades["log_flume"]:
		cost_multiplier -= 0.01
		discount_synergy += 1
	if one_time_upgrades["automation_logic_controller"]:
		cost_multiplier -= 0.02
		discount_synergy += 1
	if one_time_upgrades["global_optimisation"]:
		cost_multiplier -= 0.03
		discount_synergy += 1
	if discount_synergy == 3:
		cost_multiplier -= 0.01
	
	#Production Multiplier
	if one_time_upgrades["the_eternal_forest"]:
		click_multiplier *= 10
		wood_sec_multiplier *= 10
		wood_production_synergy += 1
	if one_time_upgrades['biomass_refining']:
		click_multiplier *= 12
		wood_sec_multiplier *= 12
		wood_production_synergy += 1
	if wood_production_synergy == 2:
		click_multiplier *= 5
		wood_production_synergy *= 5
	
	#Others
	if one_time_upgrades["coffee_machine"]:
		worker_efficency *= 1.1
	if one_time_upgrades["steel_axe_head"]:
		click_power += safe_signed(500 * click_multiplier)
	if one_time_upgrades["turbochargers"]:
		vehicle_efficency *= 1.25
	if one_time_upgrades["gps_mapping"]:
		crictical_click += 0.4
	if one_time_upgrades["carbon_fiber_saws"]:
		chainsaw_fleet_efficency *= 3

func apply_prestige_upgrades() -> void:
	var wood_production_synergy = 0
	var click_multiplier_synergy = 0
	var cost_multiplier_synergy = 0
	var golden_seed_multiplier_synergy = 0
	
	#Production
	if prestige_upgrades["fertile_soil"]:
		click_multiplier *= 4
		wood_sec_multiplier *= 4
		wood_production_synergy += 1
	if prestige_upgrades["new_tools"]:
		click_multiplier *= 6
		wood_sec_multiplier *= 6
		wood_production_synergy += 1
	if prestige_upgrades["cosmic_hq"]:
		click_multiplier *= 8
		wood_sec_multiplier *= 8
		wood_production_synergy += 1
	if prestige_upgrades["milky_way_hq"]:
		click_multiplier *= 15
		wood_sec_multiplier *= 15
		wood_production_synergy += 1
	if wood_production_synergy == 4:
		click_multiplier *= 2
		wood_sec_multiplier *= 2
	
	#Click Multiplier
	if prestige_upgrades["golden_axe"]:
		click_multiplier *= 10
		click_multiplier_synergy += 1
	if prestige_upgrades["saw_efficency"]:
		click_multiplier *= 15
		click_multiplier_synergy += 1
	if prestige_upgrades["golden_handle"]:
		click_multiplier *= 30
		click_multiplier_synergy += 1
	if prestige_upgrades["golden_handle"]:
		click_multiplier *= 50
		click_multiplier_synergy += 1
	if click_multiplier_synergy == 4:
		click_multiplier *= 3
	
	#Cost Multipilers
	if prestige_upgrades["discount"]:
		cost_multiplier -= 0.03
		cost_multiplier_synergy += 1
	if prestige_upgrades["discount+"]:
		cost_multiplier -= 0.04
		cost_multiplier_synergy += 1
	if prestige_upgrades["cost_efficency"]:
		cost_multiplier -= 0.05
		cost_multiplier_synergy += 1
	if cost_multiplier_synergy == 3:
		cost_multiplier -= 0.02
	
	#Golden Seed Multiplier
	if prestige_upgrades["prestige_boost"]:
		golden_seed_multiplier *= 2
		golden_seed_multiplier_synergy += 1
	if prestige_upgrades["seed_boost"]:
		golden_seed_multiplier *= 3
		golden_seed_multiplier_synergy += 1
	if prestige_upgrades["careful_scavenging"]:
		golden_seed_multiplier *= 5
		golden_seed_multiplier_synergy += 1
	if golden_seed_multiplier_synergy == 3:
		golden_seed_multiplier *= 3
	
	#Others
	if prestige_upgrades["smart_workers"]:
		worker_efficency *= 5

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
		$"Shop/Prestige Scroller/Prestige Upgrades/They're mine!".hide()
		save()

func _on_fertile_soil_pressed() -> void:
	if golden_seed > 9:
		golden_seed -= 10
		click_power *= 4
		click_multiplier *= 4
		wood_sec *= 4
		wood_sec_multiplier *= 4
		prestige_upgrades["fertile_soil"] = true
		$"Shop/Prestige Scroller/Prestige Upgrades/Fertile Soil".hide()
		save()

func _on_smart_workers_pressed() -> void:
	if golden_seed > 9:
		golden_seed -= 10
		worker_efficency *= 5
		wood_sec += safe_signed(upgrades["worker"].amount * 1 * (worker_efficency - 1))
		prestige_upgrades["smart_workers"] = true
		$"Shop/Prestige Scroller/Prestige Upgrades/Smart Workers".hide()
		save()

func _on_autobuyer_i_pressed() -> void:
	if golden_seed > 19:
		golden_seed -= 20
		prestige_upgrades["autobuyer_i"] = true
		$"Shop/Prestige Scroller/Prestige Upgrades/Autobuyer I".hide()
		save()

func _on_golden_axe_pressed() -> void:
	if golden_seed > 24:
		golden_seed -= 25
		click_power *= 10
		click_multiplier *= 10
		prestige_upgrades["golden_axe"] = true
		$"Shop/Prestige Scroller/Prestige Upgrades/Golden Axe".hide()

func _on_saw_efficency_pressed() -> void:
	if golden_seed > 49:
		golden_seed -= 50
		click_multiplier *= 15
		click_power *= 15
		prestige_upgrades["saw_efficency"] = true
		$"Shop/Prestige Scroller/Prestige Upgrades/Saw Efficency".hide()

func _on_prestige_boost_pressed() -> void:
	if golden_seed > 99:
		golden_seed -= 100
		golden_seed_multiplier *= 2
		prestige_upgrades["prestige_boost"] = true
		$"Shop/Prestige Scroller/Prestige Upgrades/Prestige Boost".hide()

func _on_discount_pressed() -> void:
	if golden_seed > 99:
		golden_seed -= 100
		cost_multiplier -= 0.03
		prestige_upgrades["discount"] = true
		$"Shop/Prestige Scroller/Prestige Upgrades/Discount".hide()

func _on_autobuyer_ii_pressed() -> void:
	if golden_seed > 99:
		golden_seed -= 100
		prestige_upgrades["autobuyer_ii"] = true
		$"Shop/Prestige Scroller/Prestige Upgrades/Autobuyer II".hide()

func _on_wood_bank_pressed() -> void:
	if golden_seed > 119:
		golden_seed -= 120
		prestige_upgrades["wood_bank"] = true
		$"Shop/Prestige Scroller/Prestige Upgrades/Wood Bank".hide()

func _on_new_tools_pressed() -> void:
	if golden_seed > 149:
		golden_seed -= 150
		click_power *= 6
		click_multiplier *= 6
		wood_sec *= 6
		wood_sec_multiplier *= 6
		prestige_upgrades["new_tools"] = true
		$"Shop/Prestige Scroller/Prestige Upgrades/New Tools".hide()

func _on_golden_saw_pressed() -> void:
	if golden_seed > 179:
		golden_seed -= 180
		click_power *= 20
		click_multiplier *= 20
		prestige_upgrades["golden_saw"] = true
		$"Shop/Prestige Scroller/Prestige Upgrades/Golden Saw".hide()

func _on_autobuyer_iii_pressed() -> void:
	if golden_seed > 199:
		golden_seed -= 200
		prestige_upgrades["autobuyer_iii"] = true
		$"Shop/Prestige Scroller/Prestige Upgrades/Autobuyer III".hide()

func _on_seed_boost_pressed() -> void:
	if golden_seed > 199:
		golden_seed -= 200
		golden_seed_multiplier *= 3
		prestige_upgrades["seed_boost"] = true
		$"Shop/Prestige Scroller/Prestige Upgrades/Seed Boost".hide()

func _on_discount_tier_2_pressed() -> void:
	if golden_seed > 199:
		golden_seed -= 200
		cost_multiplier -= 0.04
		prestige_upgrades["discount+"] = true
		$"Shop/Prestige Scroller/Prestige Upgrades/Discount+".hide()

func _on_golden_handle_pressed() -> void:
	if golden_seed > 299:
		golden_seed -= 300
		click_power *= 30
		click_multiplier *= 30
		prestige_upgrades["golden_handle"] = true
		$"Shop/Prestige Scroller/Prestige Upgrades/Golden Handle".hide()

func _on_autobuyer_boost_pressed() -> void:
	if golden_seed > 399:
		golden_seed -= 400
		$"Timers/Autobuyer Timer".wait_time -= 30
		prestige_upgrades["autobuyer_boost"] = true
		$"Shop/Prestige Scroller/Prestige Upgrades/Autobuyer Boost".hide()

func _on_cost_efficency_pressed() -> void:
	if golden_seed > 499:
		golden_seed -= 500
		cost_multiplier -= 0.05
		prestige_upgrades["cost_efficency"] = true
		$"Shop/Prestige Scroller/Prestige Upgrades/Cost Efficency".hide()

func _on_autobuyer_iv_pressed() -> void:
	if golden_seed > 599:
		golden_seed -= 600
		prestige_upgrades["autobuyer_iv"] = true
		$"Shop/Prestige Scroller/Prestige Upgrades/Autobuyer IV".hide()

func _on_cosmic_hq_pressed() -> void:
	if golden_seed > 749:
		golden_seed -= 750
		click_power *= 8
		click_multiplier *= 8
		wood_sec *= 8
		wood_sec_multiplier *= 8
		prestige_upgrades["cosmic_hq"] = true
		$"Shop/Prestige Scroller/Prestige Upgrades/Cosmic HQ".hide()

func _on_golden_plasma_cutter_pressed() -> void:
	if golden_seed > 899:
		golden_seed -= 900
		click_power *= 50
		click_multiplier *= 50
		prestige_upgrades["golden_plasma_cutter"] = true
		$"Shop/Prestige Scroller/Prestige Upgrades/Golden Plasma Cutter".hide()

func _on_wood_saving_account_pressed() -> void:
	if golden_seed > 999:
		golden_seed -= 1000
		prestige_upgrades["wood_saving_account"] = true
		$"Shop/Prestige Scroller/Prestige Upgrades/Wood Saving Account".hide()

func _on_autobuyer_v_pressed() -> void:
	if golden_seed > 199:
		golden_seed -= 200
		prestige_upgrades["autobuyer_v"] = true
		$"Shop/Prestige Scroller/Prestige Upgrades/Autobuyer V".hide()

func _on_milky_way_hq_pressed() -> void:
	if golden_seed > 1499:
		golden_seed -= 1500
		click_power *= 15
		click_multiplier *= 15
		wood_sec *= 15
		wood_sec_multiplier *= 15
		prestige_upgrades["milky_way_hq"] = true
		$"Shop/Prestige Scroller/Prestige Upgrades/Milky Way HQ".hide()

func _on_careful_scavenging_pressed() -> void:
	if golden_seed > 1999:
		golden_seed -= 2000
		golden_seed_multiplier *= 5
		prestige_upgrades["careful_scavenging"] = true
		$"Shop/Prestige Scroller/Prestige Upgrades/Careful Scavenging".hide()

func _on_autobuyer_vi_pressed() -> void:
	if golden_seed > 2499:
		golden_seed -= 2500
		prestige_upgrades["autobuyer_vi"] = true
		$"Shop/Prestige Scroller/Prestige Upgrades/Autobuyer VI".hide()

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
	_on_axe_skill_pressed()
	_on_worker_pressed()
	_on_axe_reforge_pressed()
	_on_reinforced_handle_pressed()
	_on_lumberjack_team_pressed()
	_on_chainsaw_fleet_pressed()
	_on_titanium_edge_pressed()
	_on_bulldozers_pressed()

func autobuyer_tier_2() -> void:
	_on_diamond_plating_pressed()
	_on_tree_harvester_pressed()
	_on_industrial_mulcher_pressed()
	_on_plasma_cutter_pressed()
	_on_mass_processing_plant_pressed()

func autobuyer_tier_3() -> void:
	_on_automated_logging_rig_pressed()
	_on_monocular_slicer_pressed()
	_on_bio_diesel_fleet_pressed()
	_on_gravity_axe_pressed()

func autobuyer_tier_4() -> void:
	_on_forest_strip_miner_pressed()
	_on_quantum_disintegrator_pressed()
	_on_atomic_harvester_pressed()
	_on_monocular_slicer_pressed()
	_on_solar_forged_blade_pressed()

func autobuyer_tier_5() -> void:
	_on_orbital_collecter_pressed()
	_on_reality_ripper_pressed()
	_on_continental_logger_pressed()
	_on_the_infinite_click_pressed()

func autobuyer_tier_6() -> void:
	_on_galactic_harvester_pressed()
	_on_big_bang_strike_pressed()
	_on_nebula_processor_pressed()
	_on_planetary_extraction_node_pressed()
	_on_supernova_chopper_pressed()
	_on_black_hole_extractor_pressed()
	_on_galaxy_spliitter_pressed()
	_on_solar_system_silo_pressed()
	_on_dyson_sphere_network_pressed()
	_on_dimension_shear_pressed()
	_on_physics_rewriter_pressed()
	_on_timeline_convergence_pressed()
	_on_infinite_energy_engine_pressed()
	_on_absolute_tap_pressed()
	_on_resource_singularity_pressed()
# ============================================================================
# SAVE/LOAD SYSTEM
# ============================================================================
# CHANGE 1: File saving/loading won't work the same way on web
# Web doesn't have direct file system access
# Use ConfigFile instead for web compatibility

func save() -> void:
	var config = ConfigFile.new()
	last_save_time = Time.get_unix_time_from_system()
	
	
	# Save basic state
	config.set_value("game", "wood", wood)
	config.set_value("game", "click_power", click_power)
	config.set_value("game", "wood_sec", wood_sec)
	config.set_value("game", "wood_sec_multiplier", wood_sec_multiplier)
	config.set_value("game", "golden_seed", golden_seed)
	config.set_value("game", "prestiges", prestiges)
	config.set_value("game", "click_multiplier", click_multiplier)
	config.set_value("game", "worker_efficency", worker_efficency)
	config.set_value("game", "vehicle_efficency", vehicle_efficency)
	config.set_value("game", "chainsaw_fleet_efficency", chainsaw_fleet_efficency)
	config.set_value("game", "idle_efficency", idle_efficency)
	config.set_value("game", "golden_seed_multiplier", golden_seed_multiplier)
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
		set_process(true)
		return
	set_process(false)
	$"Timers/Autosave Timer".stop()
	var config = ConfigFile.new()
	config.load(SAVE_PATH)
	
	# Load basic state
	wood = config.get_value("game", "wood", 0)
	click_power = config.get_value("game", "click_power", 1)
	wood_sec = config.get_value("game", "wood_sec", 0)
	wood_sec_multiplier = config.get_value("game", "wood_sec_multiplier", 1.0)
	golden_seed = config.get_value("game", "golden_seed", 0)
	prestiges = config.get_value("game", "prestiges", 0)
	click_multiplier = config.get_value("game", "click_multiplier", 1.0)
	worker_efficency = config.get_value("game", "worker_efficency", 1.0)
	vehicle_efficency = config.get_value("game", "vehicle_efficency", 1.0)
	chainsaw_fleet_efficency = config.get_value("game", "chainsaw_fleet_efficency", 1.0)
	idle_efficency = config.get_value("game", "idle_efficency", 1.0)
	golden_seed_multiplier = config.get_value("game", "golden_seed_multiplier", 1.0)
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
	set_process(true)
	idle_summary()



func refresh_upgrade_visibility() -> void:
	# One-time upgrades
	if one_time_upgrades["reinforced_gloves"]:
		$"Shop/One-Time Scroller/One-Time Upgrades/Reinforced Gloves".hide()
	if one_time_upgrades["coffee_machine"]:
		$"Shop/One-Time Scroller/One-Time Upgrades/Coffee Machine".hide()
	if one_time_upgrades["lunch_break_schudule"]:
		$"Shop/One-Time Scroller/One-Time Upgrades/Lunch Break Schedule".hide()
	if one_time_upgrades["steel_axe_head"]:
		$"Shop/One-Time Scroller/One-Time Upgrades/Steel Axe Head".hide()
	if one_time_upgrades["turbochargers"]:
		$"Shop/One-Time Scroller/One-Time Upgrades/Turbochargers".hide()
	if one_time_upgrades["log_flume"]:
		$"Shop/One-Time Scroller/One-Time Upgrades/Log Flume".hide()
	if one_time_upgrades["gps_mapping"]:
		$"Shop/One-Time Scroller/One-Time Upgrades/GPS Mapping".hide()
	if one_time_upgrades["shift_management"]:
		$"Shop/One-Time Scroller/One-Time Upgrades/Shift Management".hide()
	if one_time_upgrades["carbon_fiber_saws"]:
		$"Shop/One-Time Scroller/One-Time Upgrades/Carbon Fiber Saws".hide()
	if one_time_upgrades["diamond_coated_teeth"]:
		$"Shop/One-Time Scroller/One-Time Upgrades/Diamond-Coated Teeth".hide()
	if one_time_upgrades["automation_logic_controller"]:
		$"Shop/One-Time Scroller/One-Time Upgrades/Automation Logic Controller".hide()
	if one_time_upgrades["vertical_intergration"]:
		$"Shop/One-Time Scroller/One-Time Upgrades/Vertical Intergration".hide()
	if one_time_upgrades["the_eternal_forest"]:
		$"Shop/One-Time Scroller/One-Time Upgrades/The Eternal Forest".hide()
	if one_time_upgrades["biomass_refining"]:
		$"Shop/One-Time Scroller/One-Time Upgrades/Biomass Refining".hide()
	if one_time_upgrades["global_optimisation"]:
		$"Shop/One-Time Scroller/One-Time Upgrades/Global Optimisation".hide()
	if one_time_upgrades["saw_upgrade"]:
		$"Shop/One-Time Scroller/One-Time Upgrades/Saw Upgrade".hide()
	if one_time_upgrades["salary_increase"]:
		$"Shop/One-Time Scroller/One-Time Upgrades/Salary Increase".hide()
	if one_time_upgrades["master_logger"]:
		$"Shop/One-Time Scroller/One-Time Upgrades/Master Logger".hide()
	
	# Prestige upgrades
	if prestige_upgrades["theyre_mine"]:
		$"Shop/Prestige Scroller/Prestige Upgrades/They're mine!".hide()
	if prestige_upgrades["fertile_soil"]:
		$"Shop/Prestige Scroller/Prestige Upgrades/Fertile Soil".hide()
	if prestige_upgrades["smart_workers"]:
		$"Shop/Prestige Scroller/Prestige Upgrades/Smart Workers".hide()
	if prestige_upgrades["autobuyer_i"]:
		$"Shop/Prestige Scroller/Prestige Upgrades/Autobuyer I".hide()
	if prestige_upgrades["golden_saw"]:
		$"Shop/Prestige Scroller/Prestige Upgrades/Golden Saw".hide()
	if prestige_upgrades["saw_efficency"]:
		$"Shop/Prestige Scroller/Prestige Upgrades/Saw Efficency".hide()
	if prestige_upgrades["prestige_boost"]:
		$"Shop/Prestige Scroller/Prestige Upgrades/Prestige Boost".hide()
	if prestige_upgrades["discount"]:
		$"Shop/Prestige Scroller/Prestige Upgrades/Discount".hide()
	if prestige_upgrades["autobuyer_ii"]:
		$"Shop/Prestige Scroller/Prestige Upgrades/Autobuyer II".hide()
	if prestige_upgrades["wood_bank"]:
		$"Shop/Prestige Scroller/Prestige Upgrades/Wood Bank".hide()
	if prestige_upgrades["new_tools"]:
		$"Shop/Prestige Scroller/Prestige Upgrades/New Tools".hide()
	if prestige_upgrades["golden_saw"]:
		$"Shop/Prestige Scroller/Prestige Upgrades/Golden Saw".hide()
	if prestige_upgrades["autobuyer_iii"]:
		$"Shop/Prestige Scroller/Prestige Upgrades/Autobuyer III".hide()
	if prestige_upgrades["seed_boost"]:
		$"Shop/Prestige Scroller/Prestige Upgrades/Seed Boost".hide()
	if prestige_upgrades["discount+"]:
		$"Shop/Prestige Scroller/Prestige Upgrades/Discount+".hide()
	if prestige_upgrades["golden_handle"]:
		$"Shop/Prestige Scroller/Prestige Upgrades/Golden Axe".hide()
	if prestige_upgrades["autobuyer_boost"]:
		$"Shop/Prestige Scroller/Prestige Upgrades/Autobuyer Boost".hide()
	if prestige_upgrades["autobuyer_iv"]:
		$"Shop/Prestige Scroller/Prestige Upgrades/Autobuyer IV".hide()
	if prestige_upgrades["cosmic_hq"]:
		$"Shop/Prestige Scroller/Prestige Upgrades/Cosmic HQ".hide()
	if prestige_upgrades["golden_plasma_cutter"]:
		$"Shop/Prestige Scroller/Prestige Upgrades/Golden Plasma Cutter".hide()
	if prestige_upgrades["wood_saving_account"]:
		$"Shop/Prestige Scroller/Prestige Upgrades/Wood Saving Account".hide()
	if prestige_upgrades["autobuyer_v"]:
		$"Shop/Prestige Scroller/Prestige Upgrades/Autobuyer V".hide()
	if prestige_upgrades["milky_way_hq"]:
		$"Shop/Prestige Scroller/Prestige Upgrades/Milky Way HQ".hide()
	if prestige_upgrades["careful_scavenging"]:
		$"Shop/Prestige Scroller/Prestige Upgrades/Careful Scavenging".hide()
	if prestige_upgrades["autobuyer_vi"]:
		$"Shop/Prestige Scroller/Prestige Upgrades/Autobuyer VI".hide()

func _on_save_button_pressed() -> void:
	save()

func _on_load_button_pressed() -> void:
	load_data()

func _on_shop_toggle_pressed() -> void:
	shop_open = !shop_open

#================================================================
# IDLING
#=================================================================
func idle_summary() -> void:
	$"Idle Popup".show()
	var current_time = Time.get_unix_time_from_system()
	var seconds_away = round(current_time - last_save_time)
	show_idle_summary(seconds_away)
	idle_gains = safe_signed(round(seconds_away * wood_sec * idle_efficency))
	if idle_gains + wood > MAX_WOOD:
		idle_gains = MAX_WOOD - wood
	$"Idle Popup/Idle Gains Wood".text = format_number(idle_gains)
	$"Timers/Autosave Timer".start()

func _on_idle_gains_claim_pressed() -> void:
	wood += idle_gains
	$"Idle Popup".hide()
	save()

func show_idle_summary(seconds) -> void:
	var days_total = 0
	var hours_total = 0
	var minute_total = 0
	if seconds >= 86400:
		days_total = floor(seconds/84800)
		seconds -= days_total * 84800
	if seconds >= 3600:
		hours_total = floor(seconds/3600)
		seconds -= hours_total * 3600
	if seconds >= 60:
		minute_total = floor(seconds / 60)
		seconds -= minute_total * 60
	$"Idle Popup/Offline Time".text = "%s d,%s h,%s m,%s s" %[days_total,hours_total,minute_total,seconds]

#==========================================================================
# OTHERS
#==========================================================================

func cost_multiplier_setting() -> void:
	if prestiges == 0:
		cost_multiplier = 1.25
	elif 4 > prestiges:
		cost_multiplier = COST_MULTIPLIER_DEFAULT
	elif 6 > prestiges:
		cost_multiplier = 1.4
	else:
		cost_multiplier = 1.5


func _on_rain_music_timer_timeout() -> void:
	$"Music/Rain Music".play()
