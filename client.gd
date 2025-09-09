extends Control

func _ready():
	# Connect signal when ready
	multiplayer.connected_to_server.connect(_on_connected)

func _on_connected():
	# Now it's safe to call RPC
	rpc_id(1, "name_adding", Global.player_name)
