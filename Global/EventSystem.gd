extends Node



#signal aloha(id: int)

# StarCounter
signal IncreaseStarCountProgress
signal DecreaseStarCountProgress
signal PublishMaxStarCount(count: int)
signal PublishInitStarCount(count: int)

func signal_increased_star_count():
	IncreaseStarCountProgress.emit()

func signal_decreased_star_count():
	DecreaseStarCountProgress.emit()

func signal_max_star_count(value: int):
	PublishMaxStarCount.emit()
	
func signal_initial_star_count(value: int):
	PublishInitStarCount.emit()
