extends Control
@onready var grid_container:GridContainer=$GridContainer
@onready var start_button:Button=$Button

var server_UDP :UDPServer = UDPServer.new()
var is_host = Global.is_host
func _ready() -> void:
	Global.lobby= self
	if is_host:
		server_UDP.listen(Global.UDP_PORT)
		Global.player_id=0 # BTW this line took 2 hours of debugging to add (Fixed a major Bug with Multiple Players with the same id )
		Global.add_player(Global.player_name)
		update_lobby()
		print(server_UDP.is_listening())
	else:
		multiplayer.connected_to_server.connect(client_connected)
func _process(_delta: float) -> void:
	if not is_host:
		return
	server_UDP.poll()
	if server_UDP.is_connection_available():
		var packet =Global.player_name.to_ascii_buffer()
		var client = server_UDP.take_connection()
		client.get_packet()
		print_debug("Server was hit by " , client.get_packet_ip())
		client.put_packet(packet) #send the ip 
		
func client_connected():
	Global.update_using_host()
	await  get_tree().create_timer(Global.latency).timeout
	Global.player_id=Global.player_names.size()
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

@rpc('call_local')
func change_scene():
	get_tree().change_scene_to_file("res://scenes/game.tscn")
	
func _on_button_pressed() -> void:
	change_scene.rpc()


func _on_back_home_pressed() -> void:
	multiplayer.multiplayer_peer.close();
	multiplayer.multiplayer_peer=null;
	Global.reset()
	get_tree().change_scene_to_file("res://control.tscn")


	
		
	
