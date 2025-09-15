# Global.gd
extends Node
var lobby
var game
var player_name: String = ""
var actual_roles: Array[String] = ["king","queen","bishop","thief"]

var player_names: Array[String] = []
var is_host: bool = false
var player_role : String
var latency:float = 0.5
var lobby_image_list = ["res://assets/fox.jpg","res://assets/rabbit.jpg","res://assets/lion.jpg","res://assets/horse.jpg"]
var lobby_color_list=["#006b3722", "#f6cf4941","#ff00004a","#a764db4a"]

func update_using_host():
	print(player_name," wants to update")
	update_player_list.rpc_id(1)
	
@rpc("any_peer","reliable","call_local")
func add_player(p_name:String):
	print(player_name," added ",p_name)
	player_names.append(p_name)
	lobby.update_lobby()
	
@rpc("any_peer","reliable")
func update_player_list():
	print(player_name," tries to update")
	set_player_list.rpc(player_names)
	
@rpc("authority","reliable")
func set_player_list(updated_player_names:Array):
	print(player_name," updated player_names to : ",updated_player_names)
	player_names=updated_player_names
	lobby.update_lobby()
