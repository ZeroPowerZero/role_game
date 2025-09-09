extends Node2D
@onready var  Host  :Control = $Host
@onready var  Client :Control = $Client
var is_server:bool

func _ready():
	is_server=multiplayer.is_server()
	if(is_server):
		Client.hide()
		Client.queue_free()
	else:
		Host.hide()
		Host.queue_free()
		
@rpc("any_peer","reliable")
func add_player(player_name):
	if(not is_server):return
	Host.add_player(player_name)

@rpc("authority")
func broadcast_message(message:String):
	if(is_server) : return
	Client.show_message(message)
