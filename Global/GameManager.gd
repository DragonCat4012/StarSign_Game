extends Node

const TIME_PER_DAY = 0.005

# Debug
var isDebug = true

# Weapon Switching
var weaponactive = false
var selectedWeaponId = 0 # 0 = none
var currentWeapon: WeaponModel

signal showWeapon
signal hideWeapon
signal showWeaponById()

func _toggle_weapon():
	Log.info("Toggle Weapon")
	if selectedWeaponId == 0:
		return
	if weaponactive:
		weaponactive = false
		emit_signal("hideWeapon")
	else:
		weaponactive = true
		emit_signal("showWeapon")

func activate_weapon_from_inventory(weaponId: int):
	selectedWeaponId = weaponId
	Log.info("Activate Weapon from Inventory")
	Log.info(weaponId)
	weaponactive = true
	showWeaponById.emit()


# Manage Inventory data
@onready var INVENTORY = load("res://Ressources/Inventory/starSignMapping.tres")
