extends Control
@onready var grid_container:GridContainer=$GridContainer
@onready var start_button:Button=$Button

var is_host = Global.is_host
func _ready() -> void:
	start_button.hide()
	Global.lobby= self
	if is_host:
		Global.add_player(Global.player_name)
		update_lobby()
	else:
		multiplayer.connected_to_server.connect(client_connected)
	
func client_connected():
	Global.update_using_host()
	await  get_tree().create_timer(Global.latency).timeout
	Global.add_player.rpc(Global.player_name)
	
func update_lobby():
	grid_container.hide()
	for child in grid_container.get_children():
		child.queue_free()
	for i in range(Global.player_names.size()):
		var player_name = Global.player_names[i]
		var player_icon = preload("res://scenes/player_icon.tscn").instantiate()
		player_icon.set_info(i,player_name)
		grid_container.add_child(player_icon)
	grid_container.show()
	if is_host and Global.player_names.size()==4:
		start_button.show()
