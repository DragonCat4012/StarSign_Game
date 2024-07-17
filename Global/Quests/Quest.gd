extends Node
class_name Quest

var title := "Quest Title"
var description := "Quest Description"
var saveKey := "xox"

func _init(questTitle, questDescription, questKey):
	title = questTitle
	description = questDescription
	saveKey = questKey
	
