extends Control

@onready var name_input = $VBoxContainer/NameInput
@onready var ip_input = $VBoxContainer/IPInput
@onready var rounds_input =$VBoxContainer/RoundsInput
@onready var info_label = $VBoxContainer/InfoLabel 

var PORT = Global.PORT
var client_UDP:PacketPeerUDP = PacketPeerUDP.new()
var found=false
const MAX_CONNECTIONS = 4
func _ready():
	$VBoxContainer/YourIp.text ="Your IP : " + get_ip_string()
	info_label.text = ""
func _process(_delta: float) -> void:
	if not found and client_UDP.get_available_packet_count()>0:
		var packet = client_UDP.get_packet()
		ip_input.text = client_UDP.get_packet_ip()
		info_label.text="Found "+packet.get_string_from_ascii() +"'s game "
		found = true
	
func _on_host_button_pressed() -> void:
	
	Global.player_name = name_input.text.strip_edges().to_upper()
	if(Global.player_name.length()==0):
		info_label.text="Please Enter a name !"
		return
	
	Global.is_host = true
	Global.round_count = int(rounds_input.value)
	
	var peer = ENetMultiplayerPeer.new()
	if peer.create_server(PORT,MAX_CONNECTIONS) != OK:
		info_label.text = "Failed to start server!"
		return
	multiplayer.multiplayer_peer = peer
	get_tree().change_scene_to_file("res://scenes/lobby.tscn")

func _on_join_button_pressed() -> void:

	Global.player_name = name_input.text.strip_edges().to_upper() 

	if(Global.player_name.length()==0):
		info_label.text="Please Enter a name !"
		return
	Global.is_host = false
	
	var ip = ip_input.text.strip_edges()
	if ip == "":
		ip = "127.0.0.1";

	var peer = ENetMultiplayerPeer.new()
	if peer.create_client(ip, PORT) != OK:
		info_label.text = "Failed to connect to host!"
		return

	multiplayer.multiplayer_peer = peer
	get_tree().change_scene_to_file("res://scenes/lobby.tscn")


func _on_button_2_pressed() -> void:
	get_tree().quit()

func  get_ip_string()->String:
	for ip in IP.get_local_addresses():
		if ip.substr(0,2) in ["19","17","10"]:
			return ip
	return "Network Error"

func get_ip_stater()->String:
	var ip= get_ip_string()
	var l =0
	for i in range(len(ip)-1,0,-1):
		if ip[i] =='.':
			l = i 
			break
	return ip.substr(0,l+1)
func _on_find_game_pressed() -> void:
	found=false
	var address_starter =get_ip_stater()
	for i in range(254):
		client_UDP.set_dest_address(address_starter+str(i),Global.UDP_PORT)
		var msg=get_ip_string()
		client_UDP.put_packet(msg.to_ascii_buffer())
