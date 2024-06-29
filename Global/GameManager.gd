extends Node

# Weapon Switching
var weaponactive = false
# TODO: weapon type
var selectedWeaponIndex = 0

signal activateSword
signal hideWeapon

func _toggle_weapon():
	Log.info("Toggle Weapon")
	if weaponactive:
		weaponactive = false
		emit_signal("hideWeapon")
	else:
		weaponactive = true
		emit_signal("activateSword")
