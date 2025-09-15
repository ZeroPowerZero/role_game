extends Control

@onready var name_list_label = $PlayerNameLabel  # Make this a Label or VBoxContainer
@onready var message_box = $MessageBox
var game
func _ready() :
	game = get_parent()
	add_player(Global.player_name)

func add_player(name):
	Global.player_names.append(name)
	var message = name + " just entered the game"
	print(message)
	message_box.text += message +"\n"
func _on_button_pressed() -> void:
	var result : String ="water"
	game.broadcast_message.rpc(result)
	#for item in Global.player_names :
		#result +=item + "\n"
	#
	#name_list_label.text = result
	#
	#if not multiplayer.is_server():
		#rpc_id(1,"name_adding",Global.player_name)
		##print(get_tree().get_network_unique_id())
	
