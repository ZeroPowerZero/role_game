extends Control
var game
@onready var label = $Label
func _ready():
	game = get_parent()
	# Connect signal when ready
	multiplayer.connected_to_server.connect(_on_connected)

func _on_connected():
	# Now it's safe to call RPC
	game.add_player.rpc(Global.player_name)
	label.text = Global.player_name
func show_message(message:String):
	label.text	= message
