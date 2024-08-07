extends Node



#signal aloha(id: int)

# StarCounter
signal StarCollect(id: int)
signal IncreaseStarCountProgress
signal DecreaseStarCountProgress

func signal_increased_star_count():
	IncreaseStarCountProgress.emit()

func signal_decreased_star_count():
	DecreaseStarCountProgress.emit()


# Inventory
signal InventoryWillBeShown



# Tutorial
signal MovementEnterd
func signal_tutorial_enetred_movement_test():
	MovementEnterd.emit()
	
# Menu
signal EnteredOption(opt)
signal ExitedOption(opt)
signal ClickedOption(opt)
