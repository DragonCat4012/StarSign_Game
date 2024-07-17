extends Node

var activeQuests : Array[Quest]= []


func get_quest_array() -> Array:
	return activeQuests.map(func(quest): return quest.title)

func add_quest(quest: Quest):
	activeQuests.append(quest)

func _remove_quest(quest: Quest):
	activeQuests.erase(quest)

func remove_quest_from_title(title: String):
	for quest in activeQuests:
		if quest.title == title:
			activeQuests.erase(quest)
