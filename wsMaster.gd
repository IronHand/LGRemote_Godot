extends Node

export var tvIP = ""
export var websocket_url = "ws://:3000"
var clientKey = ""
var currentChannel = 0
var currentChannelData = {}
var currentChannelProgrammList = []
var currentVolume = 0
var currentMute = false
var appInForground = ""

var dataRes = ""

var inputStringData = ""
var multiInputNext = ""
var multiInputDelay = 0.2

# Our WebSocketClient instance
var wsc = WebSocketClient.new()
var wsPointer = WebSocketClient.new()
var pointerSocket_url = ""

#handshake without client key, for first connection
var hs = "{\"type\":\"register\",\"id\":\"register_0\",\"payload\":{\"forcePairing\":false,\"pairingType\":\"PROMPT\",\"manifest\":{\"manifestVersion\":1,\"appVersion\":\"1.1\",\"signed\":{\"created\":\"20140509\",\"appId\":\"com.lge.test\",\"vendorId\":\"com.lge\",\"localizedAppNames\":{\"\":\"LG Remote App\",\"ko-KR\":\"리모컨 앱\",\"zxx-XX\":\"ЛГ Rэмotэ AПП\"},\"localizedVendorNames\":{\"\":\"LG Electronics\"},\"permissions\":[\"TEST_SECURE\",\"CONTROL_INPUT_TEXT\",\"CONTROL_MOUSE_AND_KEYBOARD\",\"READ_INSTALLED_APPS\",\"READ_LGE_SDX\",\"READ_NOTIFICATIONS\",\"SEARCH\",\"WRITE_SETTINGS\",\"WRITE_NOTIFICATION_ALERT\",\"CONTROL_POWER\",\"READ_CURRENT_CHANNEL\",\"READ_RUNNING_APPS\",\"READ_UPDATE_INFO\",\"UPDATE_FROM_REMOTE_APP\",\"READ_LGE_TV_INPUT_EVENTS\",\"READ_TV_CURRENT_TIME\"],\"serial\":\"2f930e2d2cfe083771f68e4fe7bb07\"},\"permissions\":[\"LAUNCH\",\"LAUNCH_WEBAPP\",\"APP_TO_APP\",\"CLOSE\",\"TEST_OPEN\",\"TEST_PROTECTED\",\"CONTROL_AUDIO\",\"CONTROL_DISPLAY\",\"CONTROL_INPUT_JOYSTICK\",\"CONTROL_INPUT_MEDIA_RECORDING\",\"CONTROL_INPUT_MEDIA_PLAYBACK\",\"CONTROL_INPUT_TV\",\"CONTROL_POWER\",\"READ_APP_STATUS\",\"READ_CURRENT_CHANNEL\",\"READ_INPUT_DEVICE_LIST\",\"READ_NETWORK_STATE\",\"READ_RUNNING_APPS\",\"READ_TV_CHANNEL_LIST\",\"WRITE_NOTIFICATION_TOAST\",\"READ_POWER_STATE\",\"READ_COUNTRY_INFO\"],\"signatures\":[{\"signatureVersion\":1,\"signature\":\"eyJhbGdvcml0aG0iOiJSU0EtU0hBMjU2Iiwia2V5SWQiOiJ0ZXN0LXNpZ25pbmctY2VydCIsInNpZ25hdHVyZVZlcnNpb24iOjF9.hrVRgjCwXVvE2OOSpDZ58hR+59aFNwYDyjQgKk3auukd7pcegmE2CzPCa0bJ0ZsRAcKkCTJrWo5iDzNhMBWRyaMOv5zWSrthlf7G128qvIlpMT0YNY+n/FaOHE73uLrS/g7swl3/qH/BGFG2Hu4RlL48eb3lLKqTt2xKHdCs6Cd4RMfJPYnzgvI4BNrFUKsjkcu+WD4OO2A27Pq1n50cMchmcaXadJhGrOqH5YmHdOCj5NSHzJYrsW0HPlpuAx/ECMeIZYDh6RMqaFM2DXzdKX9NmmyqzJ3o/0lkk/N97gfVRLW5hA29yeAwaCViZNCP8iC9aO0q9fQojoa7NQnAtw==\"}]}}}"
var hs_w_key = "{\"type\":\"register\",\"id\":\"register_0\",\"payload\":{\"forcePairing\":false,\"pairingType\":\"PROMPT\",\"client-key\":\"CLIENTKEYGOESHERE\",\"manifest\":{\"manifestVersion\":1,\"appVersion\":\"1.1\",\"signed\":{\"created\":\"20140509\",\"appId\":\"com.lge.test\",\"vendorId\":\"com.lge\",\"localizedAppNames\":{\"\":\"LG Remote App\",\"ko-KR\":\"리모컨 앱\",\"zxx-XX\":\"ЛГ Rэмotэ AПП\"},\"localizedVendorNames\":{\"\":\"LG Electronics\"},\"permissions\":[\"TEST_SECURE\",\"CONTROL_INPUT_TEXT\",\"CONTROL_MOUSE_AND_KEYBOARD\",\"READ_INSTALLED_APPS\",\"READ_LGE_SDX\",\"READ_NOTIFICATIONS\",\"SEARCH\",\"WRITE_SETTINGS\",\"WRITE_NOTIFICATION_ALERT\",\"CONTROL_POWER\",\"READ_CURRENT_CHANNEL\",\"READ_RUNNING_APPS\",\"READ_UPDATE_INFO\",\"UPDATE_FROM_REMOTE_APP\",\"READ_LGE_TV_INPUT_EVENTS\",\"READ_TV_CURRENT_TIME\"],\"serial\":\"2f930e2d2cfe083771f68e4fe7bb07\"},\"permissions\":[\"LAUNCH\",\"LAUNCH_WEBAPP\",\"APP_TO_APP\",\"CLOSE\",\"TEST_OPEN\",\"TEST_PROTECTED\",\"CONTROL_AUDIO\",\"CONTROL_DISPLAY\",\"CONTROL_INPUT_JOYSTICK\",\"CONTROL_INPUT_MEDIA_RECORDING\",\"CONTROL_INPUT_MEDIA_PLAYBACK\",\"CONTROL_INPUT_TV\",\"CONTROL_POWER\",\"READ_APP_STATUS\",\"READ_CURRENT_CHANNEL\",\"READ_INPUT_DEVICE_LIST\",\"READ_NETWORK_STATE\",\"READ_RUNNING_APPS\",\"READ_TV_CHANNEL_LIST\",\"WRITE_NOTIFICATION_TOAST\",\"READ_POWER_STATE\",\"READ_COUNTRY_INFO\"],\"signatures\":[{\"signatureVersion\":1,\"signature\":\"eyJhbGdvcml0aG0iOiJSU0EtU0hBMjU2Iiwia2V5SWQiOiJ0ZXN0LXNpZ25pbmctY2VydCIsInNpZ25hdHVyZVZlcnNpb24iOjF9.hrVRgjCwXVvE2OOSpDZ58hR+59aFNwYDyjQgKk3auukd7pcegmE2CzPCa0bJ0ZsRAcKkCTJrWo5iDzNhMBWRyaMOv5zWSrthlf7G128qvIlpMT0YNY+n/FaOHE73uLrS/g7swl3/qH/BGFG2Hu4RlL48eb3lLKqTt2xKHdCs6Cd4RMfJPYnzgvI4BNrFUKsjkcu+WD4OO2A27Pq1n50cMchmcaXadJhGrOqH5YmHdOCj5NSHzJYrsW0HPlpuAx/ECMeIZYDh6RMqaFM2DXzdKX9NmmyqzJ3o/0lkk/N97gfVRLW5hA29yeAwaCViZNCP8iC9aO0q9fQojoa7NQnAtw==\"}]}}}"

# Called when the node enters the scene tree for the first time.
func _ready():
	#wsc.set_write_mode(WebSocketPeer.WRITE_MODE_TEXT)
	# Connect base signals to get notified of connection open, close, and errors.
	wsc.connect("connection_closed", self, "_closed")
	wsc.connect("connection_error", self, "_closed")
	wsc.connect("connection_established", self, "_connected")
	# This signal is emitted when not using the Multiplayer API every time
	# a full packet is received.
	# Alternatively, you could check get_peer(1).get_available_packets() in a loop.
	wsc.connect("data_received", self, "_on_data")
	
	
	wsPointer.connect("connection_closed", self, "_closed_Input")
	wsPointer.connect("connection_established", self, "_connected_input")
	
	wsPointer.connect("data_received", self, "_on_input_data")
	
	if loadKey() == -1:
		return
	else:
		connectToTV()
	
func setURL(ip):
	tvIP = ip
	websocket_url = "ws://" + tvIP + ":3000"

func closeClient():
	wsc.disconnect_from_host(1000,"Connection closed by User")
	wsc.get_peer(1).close(1000,"Connection closed by User")
	
	wsPointer.disconnect_from_host(1000,"Connection closed by User")
	wsPointer.get_peer(1).close(1000,"Connection closed by User")

func handshake():
	if clientKey != "":
		return hs_w_key.replace("CLIENTKEYGOESHERE", clientKey)
	else:
		return hs

func _closed(was_clean = false):
	# was_clean will tell you if the disconnection was correctly notified
	# by the remote peer before closing the socket.
	print("Closed, clean: ", was_clean)
	get_tree().get_nodes_in_group("Main")[0].wsDataResc("Disconnect")
	set_process(false)
	
func _closed_Input(was_clean = false):
	# was_clean will tell you if the disconnection was correctly notified
	# by the remote peer before closing the socket.
	print("Closed Input, clean: ", was_clean)
	#set_process(false)

func _connected(proto = ""):
	# This is called on connection, "proto" will be the selected WebSocket
	# sub-protocol (which is optional)
	print("Connected with protocol: ", proto)
	# You MUST always use get_peer(1).put_packet to send data to server,
	# and not put_packet directly when not using the MultiplayerAPI.
	wsc.get_peer(1).set_write_mode(WebSocketPeer.WRITE_MODE_TEXT)
	wsc.get_peer(1).put_packet(handshake().to_utf8())
	
func _connected_input(proto = ""):
	# This is called on connection, "proto" will be the selected WebSocket
	# sub-protocol (which is optional)
	print("Connected Input with protocol: ", proto)
	#print(wsPointer.get_connected_host())
	# You MUST always use get_peer(1).put_packet to send data to server,
	# and not put_packet directly when not using the MultiplayerAPI.
	wsPointer.get_peer(1).set_write_mode(WebSocketPeer.WRITE_MODE_TEXT)
	#wsPointer.get_peer(1).put_packet(handshake().to_utf8())

func _on_data():
	# Print the received packet, you MUST always use get_peer(1).get_packet
	# to receive data from server, and not get_packet directly when not
	# using the MultiplayerAPI.
	var resc = wsc.get_peer(1).get_packet().get_string_from_utf8()
	#print("Got data from server: ", resc)
	interpreteIncomming(resc)
	
func _on_input_data():
	# Print the received packet, you MUST always use get_peer(1).get_packet
	# to receive data from server, and not get_packet directly when not
	# using the MultiplayerAPI.
	var resc = wsPointer.get_peer(1).get_packet().get_string_from_utf8()
	print("Input Resp: ", resc)

func _process(delta):
	# Call this in _process or _physics_process. Data transfer, and signals
	# emission will only happen when calling this function.
	wsc.poll()
	wsPointer.poll()
	
# Steuerfunktionen
#------------------------------------------------------------------------------
func show_toast(text):
	send_data( jsonMSG("","request","ssap://system.notifications/createToast", "{\"message\":\"" + text + "\"}" ) )

#Channel Control - TV Service
func set_ChannelByID(chanelID):
	send_data( jsonMSG("channels_","request","ssap://tv/openChannel", "{\"channelId\":\"" + str(chanelID) + "\"}" ) )

#JSON data from server: {id:channels_, payload:{returnValue:True}, type:response}
#JSON data from server: {id:channels_, payload:{returnValue:True}, type:response}
func set_ChannelByNbr(chanelNr):
	send_data( jsonMSG("channels_","request","ssap://tv/openChannel", "{\"channelNumber\":\"" + str(chanelNr) + "\"}" ) )

#Aktueller Kanal
#JSON data from server: {id:channels_, payload:{channelId:7_86_3_3_1089_12003_1,
#channelModeId:2, channelModeName:Satellite, channelName:RTL Television, channelNumber:3,
#channelTypeId:6, channelTypeName:Satellite Digital TV, dualChannel:{dualChannelId:Null,
#dualChannelNumber:Null, dualChannelTypeId:Null, dualChannelTypeName:Null}, favoriteGroup:Null, 
#hybridtvType:HBBTV, isChannelChanged:False, isDescrambled:False, isFineTuned:False, isHEVCChannel:False, 
#isInvisible:False, isLocked:False, isScrambled:False, isSkipped:False, physicalNumber:86, returnValue:True, 
#signalChannelId:1089_12003_1}, type:response}
func get_CurrentChannel():
	send_data( jsonMSG("channels_","request","ssap://tv/getCurrentChannel", "" ) )

#Infos zum aktuellen Kanal - Noch mehr Informationen
func get_ChannelProgramInfo():
	send_data( jsonMSG("channels_","request","ssap://tv/getChannelProgramInfo", "" ) )

#Geht nicht ???
func get_ChannelList():
	send_data( jsonMSG("channels_","request","ssap://tv/getChannelList", "" ) )
	
func set_ChannelUp():
	send_data( jsonMSG("channels_","request","ssap://tv/channelUp", "" ) )

func set_ChannelDown():
	send_data( jsonMSG("channels_","request","ssap://tv/channelDown", "" ) )

#----

#HDMI usw.
func get_InputList():
	send_data( jsonMSG("input_","request","ssap://tv/getExternalInputList", "" ) )

#JSON data from server: {id:services_, payload:{returnValue:True, services:[{name:api, version:1}, 
#{name:audio, version:1}, {name:config, version:1}, {name:media.controls, version:1}, 
#{name:media.viewer, version:1}, {name:pairing, version:1}, {name:settings, version:1},
#{name:system, version:1}, {name:system.launcher, version:1}, {name:system.notifications, version:1},
#{name:timer, version:1}, {name:tv, version:1}, {name:user, version:1}, {name:webapp, version:2}]}, type:response}
func get_ServiceList():
	send_data( jsonMSG("services_","request","ssap://api/getServiceList", "" ) )

#JSON data from server: {id:sw_info_, payload:{auth_flag:N, config_key:00, 
#country:DE, country_group:EU, device_id:38:8c:50:01:0b:b2, eco_info:01, 
#ignore_disable:N, language_code:de-DE, major_ver:06, minor_ver:00.25, model_name:HE_DTV_W17H_AFADABAA, 
#product_name:webOSTV 3.5, returnValue:True, sw_type:FIRMWARE}, type:response}
func get_ServiceInfo():
	send_data( jsonMSG("sw_info_","request","ssap://com.webos.service.update/getCurrentSWInformation", "" ) )
	
#Applikationskacheln beim Home Button
func get_LauchPointList():
	send_data( jsonMSG("launcher_","request","ssap://com.webos.applicationManager/listLaunchPoints", "" ) )

#Starte eine App
func launch_App(appID):
	send_data( jsonMSG("","request","ssap://system.launcher/launch", "{\"id\":\"" + str(appID) + "\"}" ) )

#Launcher Close
func close_App(appID):
	send_data( jsonMSG("","request","ssap://system.launcher/close", "{\"id\":\"" + str(appID) + "\"}" ) )

#App State - Nur wenn App geöffnet ist
func app_State(appID):
	send_data( jsonMSG("","request","ssap://system.launcher/getAppState", "{\"id\":\"" + str(appID) + "\"}" ) )
	
#Infos über die App im Vordergrund
func app_Info():
	send_data( jsonMSG("appForgroundInfo","request","ssap://com.webos.applicationManager/getForegroundAppInfo", "" ) )
#----

#JSON data from server: {id:, payload:{returnValue:True, state:Active}, type:response}
func get_PowerState():
	send_data( jsonMSG("","request","ssap://com.webos.service.tvpower/power/getPowerState", "" ) )

#JSON data from server: {id:, payload:{features:{3d:False, dvr:True}, modelName:55SJ8109-ZA, receiverType:dvb, returnValue:True}, type:response}
func get_SystemInfo():
	send_data( jsonMSG("","request","ssap://system/getSystemInfo", "" ) )

#---
#Input Service-------------------------
func send_EnterKey():
	send_data( jsonMSG("","request","ssap://com.webos.service.ime/sendEnterKey", "" ) )

func send_InsertText(text):
	send_data( jsonMSG("textInput_","request","ssap://com.webos.service.ime/insertText", "{\"text\":\"" + text + "\"}" ) )
	
func send_DelChar(count):
	send_data( jsonMSG("","request","ssap://com.webos.service.ime/deleteCharacters", "{\"count\":" + str(count) + "}" ) )

#------------------------------------------------------------------------------
#System Settings
func get_PicSettings():
	var count = "[\"contrast\", \"backlight\", \"brightness\", \"color\"]"
	send_data( jsonMSG("","request","ssap://settings/getSystemSettings", "{\"category\": \"picture\"}" ) )

func screen_OnOff():
	send_data( jsonMSG("","request","ssap://system/turnOff", "" ) )
	
#------------------------------------------------------------------------------
#Audio
func get_audioState():
	send_data( jsonMSG("audiostatus_","request","ssap://audio/getVolume", "" ) )

func set_volumeUp():
	send_data( jsonMSG("volumeup_","request","ssap://audio/volumeUp", "" ) )

func set_volumeDown():
	send_data( jsonMSG("volumedown_","request","ssap://audio/volumeDown", "" ) )
	
func set_volumeMute(muteState):
	send_data( jsonMSG("mute_","request","ssap://audio/setMute", "{\"mute\":\"" + str(muteState) + "\"}") )
	
func set_ToggleMute():
	send_data( jsonMSG("volumedown_","request","ssap://audio/setMute", "{\"mute\":\"" + str(!currentMute) + "\"}") )
	
func set_volume(newVolume):
	send_data( jsonMSG("volumedown_","request","ssap://audio/setVolume", "{\"volume\":\"" + newVolume + "\"}") )

#Media Control-----------------------------------------------------------------
func set_play():
	send_data( jsonMSG("mediacontrol_play","request","ssap://media.controls/play", "" ) )
func set_stop():
	send_data( jsonMSG("mediacontrol_stop","request","ssap://media.controls/stop", "" ) )
func set_pause():
	send_data( jsonMSG("mediacontrol_pause","request","ssap://media.controls/pause", "" ) )
func set_next():
	send_data( jsonMSG("mediacontrol_next","request","ssap://media.controls/fastForward", "" ) )
func set_prev():
	send_data( jsonMSG("mediacontrol_prev","request","ssap://media.controls/rewind", "" ) )

#------------------------------------------------------------------------------
#Inputs
func get_InputSocket():
	send_data( jsonMSG("getInputSock_","request","ssap://com.webos.service.networkinput/getPointerInputSocket", "" ) )

func set_input_Click():
	send_Input_data("click","")
	
func set_input_Back():
	send_Input_data("button","BACK")
	
func set_input_Home():
	send_Input_data("button","HOME")
	
func set_input_left():
	send_Input_data("button","LEFT")
func set_input_right():
	send_Input_data("button","RIGHT")
func set_input_up():
	send_Input_data("button","UP")
func set_input_down():
	send_Input_data("button","DOWN")
	
func set_input_VolumeUp():
	send_Input_data("button","VOLUMEUP")
func set_input_VolumeDown():
	send_Input_data("button","VOLUMEDOWN")
func set_input_Mute():
	send_Input_data("button","MUTE")
	
func set_input_Red():
	send_Input_data("button","RED")
func set_input_Green():
	send_Input_data("button","GREEN")
func set_input_Yellow():
	send_Input_data("button","YELLOW")
func set_input_Blue():
	send_Input_data("button","BLUE")
	
func set_input_CC():
	send_Input_data("button","CC")
func set_input_Dash():
	send_Input_data("button","DASH")
func set_input_Info():
	send_Input_data("button","INFO")
func set_input_Asterisk():
	send_Input_data("button","ASTERISK")
func set_input_Exit():
	send_Input_data("button","EXIT")
	
func set_open_search():
	multiInput("search")
func set_go_search():
	multiInput("searchgo")
#------------------------------------------------------------------------------
func send_data(data):
	dataRes = ""
	wsc.get_peer(1).put_packet(data.to_utf8())
	
func send_Input_data(_type, _name):
	var msg = ""
	if _type == "button":
		msg = "type:" + _type + "\nname:" + _name + "\n\n"
	elif _type == "click":
		msg = "type:click\n\n"
	#print(wsPointer.get_connection_status())
	wsPointer.get_peer(1).put_packet(msg.to_utf8())
	
func connectToTV():
	# Initiate connection to the given URL.
	var err = wsc.connect_to_url(websocket_url)
	if err != OK:
		print("Unable to connect")
		set_process(false)
		
func jsonMSG(_id,_type,_uri,_payload):
	var dataMsg = {"id":_id,"type":_type,"uri":_uri,"payload":_payload}
	var jsonStr = to_json(dataMsg)
	return jsonStr
	
func interpreteIncomming(rawInData):
	var inData = parse_json(rawInData)
	print("JSON data from server: ", inData)
	
	if "id" in inData:
		if inData["type"] == "registered":
			if clientKey == "":
				if "client-key" in inData["payload"]:
					saveKey(tvIP, inData["payload"]["client-key"])
			show_toast("Connected!")
			dataRes = "Connect"
		elif inData["type"] == "response":
			var inPayload = inData["payload"]
			if inData["id"] == "channels_":
				if "channel" in inPayload:
					dataRes = "ProgrammInfos"
					currentChannelData = inPayload["channel"]
					if "programList" in inPayload:
						currentChannelProgrammList = inPayload["programList"]
				elif "channelId" in inPayload:
					dataRes = "ChannelInfos"
					currentChannelData = inPayload
				elif "returnValue" in inPayload:
					if inPayload["returnValue"] == true:
						get_CurrentChannel()
			elif inData["id"] == "audiostatus_":
				dataRes = "AudioInfo"
				currentVolume = inPayload["volume"]
				currentMute = inPayload["muted"]
			elif inData["id"] == "getInputSock_":
				pointerSocket_url = inPayload["socketPath"]
				var err = wsPointer.connect_to_url(pointerSocket_url)
				if err != OK:
					print("Unable to connect Input")
			elif inData["id"] == "appForgroundInfo":
				pass
				#appInForground = inPayload[""]
	else:
		print("No MSG Data :" + rawInData)
		
	get_tree().get_nodes_in_group("Main")[0].wsDataResc(dataRes)
		
func saveKey(_ip,_key):
	var save_file = File.new()
	save_file.open("user://keyFile", File.WRITE)
	save_file.store_line(_ip + ":" + _key)
	save_file.close()
	
func loadKey():
	var save_file = File.new()
	
	if not save_file.file_exists("user://keyFile"):
		get_tree().get_nodes_in_group("Main")[0].get_node("IPInput").visible = true
		return -1
	
	save_file.open("user://keyFile", File.READ)
	var dataLine = save_file.get_line()
	var splitter = dataLine.split(":")
	if splitter[0] != "":
		tvIP = splitter[0]
	if splitter[1] != "":
		clientKey = splitter[1]
	save_file.close()
	
	setURL(tvIP)
	
func saveData(inData):
	var save_file = File.new()
	save_file.open("user://tempData", File.WRITE)
	save_file.store_line(inData)
	save_file.close()
#-------------------------------------------------------------------------------
func multiInput(next):
	multiInputNext = next
	if next == "search":
		send_Input_data("button","DASH")
		yield(get_tree().create_timer(multiInputDelay), "timeout")
		send_Input_data("button","RIGHT")
		yield(get_tree().create_timer(multiInputDelay), "timeout")
		send_Input_data("button","RIGHT")
		yield(get_tree().create_timer(multiInputDelay), "timeout")
		send_Input_data("button","RIGHT")
		yield(get_tree().create_timer(multiInputDelay), "timeout")
		send_Input_data("button","UP")
		yield(get_tree().create_timer(multiInputDelay), "timeout")
		send_Input_data("button","UP")
		yield(get_tree().create_timer(multiInputDelay), "timeout")
		send_Input_data("click","")
	if next == "searchgo":
		send_Input_data("button","RIGHT")
		yield(get_tree().create_timer(multiInputDelay), "timeout")
		send_Input_data("button","RIGHT")
		yield(get_tree().create_timer(multiInputDelay), "timeout")
		send_Input_data("button","RIGHT")
		yield(get_tree().create_timer(multiInputDelay), "timeout")
		send_Input_data("button","RIGHT")
		yield(get_tree().create_timer(multiInputDelay), "timeout")
		send_Input_data("button","RIGHT")
		yield(get_tree().create_timer(multiInputDelay), "timeout")
		send_Input_data("button","RIGHT")
		yield(get_tree().create_timer(multiInputDelay), "timeout")
		send_Input_data("click","")
