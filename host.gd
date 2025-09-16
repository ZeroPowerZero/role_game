extends Control

@onready var name_list_label = $PlayerNameLabel  # Label or VBoxContainer

func _ready():
	if is_multiplayer_authority():
		Global.is_host = true
	
	Global.player_names.append(Global.player_name)
	
	await get_tree().create_timer(0.5).timeout

	if not multiplayer.is_server():
		Global.rpc_id(1, "name_adding", Global.player_name)

	Global.connect("player_names_updated", Callable(self, "_update_player_list"))

	rpc("_update_player_list")
	


@rpc("any_peer","call_local")
func _update_player_list() -> void:
	var result : String = ""
	for item in Global.player_names:
		result += "player joined are "+item+"with authority" + str(get_multiplayer_authority()) + "\n"
	name_list_label.text = result
	
	#await get_tree().create_timer(0.5).timeout
	if Global.player_names.size() == 4:
		if Global.is_host == true :
#			for now duplicate role is actual role with suffle will see later
			Global.duplicate_roles = Global.actual_roles
			Global.rpc("duplication_function",Global.duplicate_roles)
			
		#await get_tree().create_timer(0.5).timeout
		get_tree().change_scene_to_file("res://game.tscn")
