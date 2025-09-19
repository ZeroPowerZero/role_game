extends Control

@onready var choice1 = $HBoxContainer/BoxContainer/PlayerIcon
@onready var choice2 = $HBoxContainer/BoxContainer2/PlayerIcon
var l_choices :Array
func set_options(choices):
	l_choices=choices
	var c1 = choices[0]
	var c2 = choices[1]
	print(c1[1],c2[1])
	choice1.set_info(c1[0],c1[1])
	choice2.set_info(c2[0],c2[1])

func selected_player(index:int):
	var s_player = 	l_choices[index]
	if Global.chit_list[s_player[0]]==Global.CHOR:
		print("GG")
		get_parent().set_result(true)
	else:
		print("you suck!!!")
		get_parent().set_result(false)
