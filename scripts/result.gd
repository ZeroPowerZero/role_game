extends Control

@onready var table = $GridContainer
@onready var message_box = $Message
@onready var winner_box = $WinnerBox
func show_message(message:String):
	message_box.text= message
func get_winner(scores:Dictionary)->String:
	var winner_id = 0
	for key in scores.keys():
		if(scores[key]>scores[winner_id]):
			winner_id=key
	return Global.player_names[winner_id] if winner_id != Global.player_id else "You"	

func show_scores(scores:Dictionary,is_end:bool=true):
	#Setting the Name : Score
	$PlayerIcon.set_info(Global.player_id, Global.player_name + " : " + str(Global.score))
	#Finding the Winner
	var winner_player=get_winner(scores)
	#Hiding back button for general Score
	if  is_end :
		winner_box.text= winner_player + " won this game."
		$BackButton.show()
	else:
		$BackButton.hide()
	print(scores)

	#Clear the table  before adding new scores 
	for element in table.get_children():
		table.remove_child(element)
		element.queue_free()
		
	#Printing out the table
	var label = Label.new()
	label.text = "ID"
	table.add_child(label)
	for key in scores.keys():
		var player = Label.new()
		player.text=str(key)
		table.add_child(player)
	
	label = Label.new()
	label.text = "Name"
	table.add_child(label)
	for val in Global.player_names:
		var name_label = Label.new()
		name_label.text = val
		table.add_child(name_label)
	
	label = Label.new()
	label.text = "Score"
	table.add_child(label)
	for value in scores.values():
		var score = Label.new()
		score.text = str(value)
		table.add_child(score)


func _on_button_pressed() -> void:
	multiplayer.multiplayer_peer.close();
	multiplayer.multiplayer_peer=null;
	Global.reset()
	get_tree().change_scene_to_file("res://control.tscn")
