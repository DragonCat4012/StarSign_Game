extends Node



#signal aloha(id: int)

# StarCounter
signal IncreaseStarCountProgress
signal DecreaseStarCountProgress

func signal_increased_star_count():
	IncreaseStarCountProgress.emit()

func signal_decreased_star_count():
	DecreaseStarCountProgress.emit()


# Inventory
signal InventoryWillBeShown
