extends Control

@onready var name_list_label = $PlayerNameLabel  # Make this a Label or VBoxContainer

func _ready() :
	Global.player_names.append(Global.player_name)

@rpc("any_peer","reliable")
func name_adding(players_names):
	Global.player_names.append(players_names)


func _on_button_pressed() -> void:
	var result : String =""
	for item in Global.player_names :
		result +=item + "\n"
	
	name_list_label.text = result
	
	if not multiplayer.is_server():
		rpc_id(1,"name_adding",Global.player_name)
		#print(get_tree().get_network_unique_id())
	
