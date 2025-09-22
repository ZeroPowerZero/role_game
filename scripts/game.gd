extends Control

#Different Nodes ...
@onready var message_box = $MessageBox
@onready var player_info = $Label
@onready var throw_chit_button = $ChitButton
@onready var card_select_scene = $Select
@onready var your_card_scene = $YourCard
@onready var chor_selection_scene= $ChorSelectionScene
@onready var score_label= $Score
@onready var result_scene=$Result
@onready var throw_chit_button2 =$ChitButton2
func _ready() -> void:
	Global.game=self
	player_info.text = " Name :  " + Global.player_name + " - "+str(Global.player_id)
	#if this instance is the host show him the throw button
	if Global.is_host:
		throw_chit_button.show()
	#else tell them to Wait
	else:
		message_box.show()
		
#hides all controls
func hide_all():
	message_box.hide()
	throw_chit_button.hide()
	card_select_scene.hide()
	your_card_scene.hide()
	chor_selection_scene.hide()
	throw_chit_button2.hide()
	result_scene.hide()
	
@rpc("any_peer","call_local")
func goto_initial_stage():
	hide_all()
	if Global.is_host:
		throw_chit_button.show()
	else:
		message_box.show()
		
		
#Fills the G.chit_list with random roles from G.roles array 
func fill_chits_array():
	Global.chit_list.clear()
	#Randomize the roles
	Global.roles.shuffle()
	#Assign them in to G.chit_list
	for role in Global.roles:
		Global.chit_list.append(role)
	print("chit_list :",Global.chit_list)
# When host clicks the Throw Chit Button	
func _on_chit_button_pressed() -> void:
	#fill the chit_list
	fill_chits_array()
	#Send them to client to update there list 
	Global.update_chit_list.rpc(Global.chit_list)
	#Wait a bit to let the update happen
	await get_tree().create_timer(Global.latency).timeout
	#Ask the client to render the Select Scene
	show_select_node.rpc()

#Shows the Select Node and and hides other components 
@rpc("call_local")
func show_select_node():
	hide_all()
	card_select_scene.show()
	

#Called when the a card in selected in the select scene
func selected_card():
	#Hide the select Scene
	card_select_scene.hide()
	#getting the role from the G.chit_list using the index / player id ...
	Global.player_role =Global.chit_list[Global.player_id]
	#and setting it in the your_card scene
	print("name ",Global.player_id , "role : ",Global.player_role)
	your_card_scene.set_role(Global.player_role)
	#Now show the card
	your_card_scene.show()
	
	# Notify host that this player has drawn
	Global.drawn_chits_no.rpc()
	print(Global.done)

#To let the Wazir know King is calling it
@rpc("any_peer")
func call_the_wazir(king_id:int):
	#Show the wazir the Selection Menu
	if Global.player_role==Global.WAZIR:
		your_card_scene.hide()
		var choices =[]
		var i = 0
		for p in Global.player_names:
			#Giving the choice between chor and sipahi  
			if i != Global.player_id and i != king_id:
				choices.append({"id":i,"player_name":p})
			i+=1
		chor_selection_scene.set_options(choices)
		chor_selection_scene.show()

#Called by the Chor_Selection_Scene
#Once the Wazir had made the choice
func set_result(won:bool):
	update_result.rpc_id(1,won)
		
#Updates the result in all the Clients 
@rpc("any_peer","call_local")
func update_result(wazir_won:bool):
	var result = calculate_result(wazir_won)
	print("result : ",result)
	
	#Updates the results on each client
	Global.update_results.rpc(result)
	await get_tree().create_timer(Global.latency).timeout
	
	#Then show the result on each client 
	#if its not the last round:
	print("ROUNDS : ", Global.round_count," : ",Global.current_round)
	if not (Global.round_count==Global.current_round):
		show_result.rpc(wazir_won)
	else:
		end_game.rpc(wazir_won)
	
#Host calculates the result for the current round here
func calculate_result(wazir_won:bool):
	var result={};
	var i =0
	
	# If the wazir has won the score_per_role is the valid result
	if wazir_won:
		for role in Global.chit_list:
			result[i]=Global.score_per_role[role]
			i+=1
			
	#If not , give wazir a zero and chor a set constant score. 
	#King and Sipahi gets the same 
	else:
		for role in Global.chit_list:
			if(role == Global.WAZIR):
				result[i]=0
			elif(role == Global.CHOR):
				result[i]=Global.CHOR_WIN_SCORE
			else:
				result[i]=Global.score_per_role[role]
			i+=1
	return result

#
@rpc("call_local")
func show_result(wazir_won:bool):
	hide_all()
	result_scene.show_message(Global.get_message(wazir_won))
	result_scene.show_scores(Global.results,false)
	result_scene.show()
	if Global.is_host:
		throw_chit_button2.show()

func _on_raja_button_pressed() -> void:
	call_the_wazir.rpc(Global.player_id) 
	$RajaButton.hide()

func show_raja_button():
	if Global.player_role == Global.RAJA:
		$RajaButton.show()

#Ends the Game by Showing the end screen
@rpc("any_peer","call_local")
func end_game(wazir_won:bool):
	hide_all()
	result_scene.show_message(Global.get_message(wazir_won))
	result_scene.show_scores(Global.results)
	result_scene.show()
	
