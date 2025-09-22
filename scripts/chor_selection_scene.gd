extends Control
@onready var choice1 = $HBoxContainer/BoxContainer/PlayerIcon
@onready var choice2 = $HBoxContainer/BoxContainer2/PlayerIcon

var l_choices :Array
func set_options(choices):
	l_choices=choices
	var c1 = choices[0]
	var c2 = choices[1]
	print("The options are : " , c1["player_name"],c2["player_name"])
	choice1.set_info(c1["id"],c1["player_name"])
	choice2.set_info(c2["id"],c2["player_name"])

func selected_player(index:int):
	var s_player = 	l_choices[index]
	if Global.chit_list[s_player["id"]]==Global.CHOR:
		print("GG")
		get_parent().set_result(true)
	else:
		print("You suck!!!")
		get_parent().set_result(false)
