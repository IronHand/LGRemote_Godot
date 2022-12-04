extends Node2D

var outData = ""
var inputMode = "channel"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _on_Button2_pressed():
	WsMaster.closeClient()

func _on_Button3_pressed():
	#WsMaster.show_toast("Hallo Ballo")
	WsMaster.send_EnterKey()

func _on_PowerButton_pressed():
	#WsMaster.screen_OnOff()
	#WsMaster.closeClient()
	$ShutdownTimer.stop()
	shutdownDownButtonTimer = 0
	get_tree().notification(MainLoop.NOTIFICATION_WM_QUIT_REQUEST)
	
func _on_PowerButton_button_down():
	$ShutdownTimer.start()

var shutdownDownButtonTimer = 0
func _on_ShutdownTimer_timeout():
	shutdownDownButtonTimer += 1
	if shutdownDownButtonTimer > 1:
		WsMaster.screen_OnOff()
		WsMaster.closeClient()
		get_tree().notification(MainLoop.NOTIFICATION_WM_QUIT_REQUEST)

func _on_Ch_pressed(extra_arg_0):
	if inputMode == "channel":
		$OutTimer.stop()
		outData += str(extra_arg_0)
		$Keys/OutputLabel.text = outData
		$OutTimer.start()

func _on_OutTimer_timeout():
	$OutTimer.stop()
	WsMaster.set_ChannelByNbr(outData)

	outData = ""
	$Keys/OutputLabel.text = outData

func _on_Ch_Up_pressed():
	WsMaster.set_ChannelUp()

func _on_Ch_Down_pressed():
	WsMaster.set_ChannelDown()

func _on_B_Info_pressed():
	WsMaster.get_ChannelProgramInfo()

func _on_B_VUp_pressed():
	WsMaster.set_input_VolumeUp()

func _on_B_VDown_pressed():
	WsMaster.set_input_VolumeDown()
	
func _on_B_VMute_pressed():
	WsMaster.set_input_Mute()
	#WsMaster.set_volumeMute(!WsMaster.currentMute)
	#if WsMaster.currentMute == false:
	#	$Keys/B_VMute.texture_normal = load("res://img/button_Mute.png")
	#else:
	#	$Keys/B_VMute.texture_normal = load("res://img/button_Mute_on.png")

func _on_Ch_Enter_pressed():
	WsMaster.set_input_Click()
	#WsMaster.send_EnterKey()
	
func _on_Ch_Back_pressed():
	WsMaster.send_DelChar(1)
	
func _on_B_Play_pressed():
	WsMaster.set_play()

func _on_B_Pause_pressed():
	WsMaster.set_pause()

func _on_B_Stop_pressed():
	WsMaster.set_stop()

func _on_B_Next_pressed():
	WsMaster.set_next()

func _on_B_Prev_pressed():
	WsMaster.set_prev()
	
func _on_B_OK_pressed():
	WsMaster.set_input_Click()
	
func _on_B_Back_pressed():
	WsMaster.set_input_Back()
	
func _on_B_Home_pressed():
	WsMaster.set_input_Home()

func _on_B_Right_pressed():
	WsMaster.set_input_right()
	
func _on_B_Left_pressed():
	WsMaster.set_input_left()
	
func _on_B_MDown_pressed():
	WsMaster.set_input_down()
	
func _on_B_MUp_pressed():
	WsMaster.set_input_up()

func _on_B_Netflix_pressed():
	WsMaster.launch_App("netflix")
	
func _on_B_Prime_pressed():
	WsMaster.launch_App("amazon")
	
func _on_B_InputText_pressed():
	$TextInput.visible = true

func _on_Ch_Del_pressed():
	#WsMaster.send_DelChar(1)
	WsMaster.launch_App("com.webos.app.livetv")
	
func _on_CloseInputButton_pressed():
	$TextInput.visible = false

func _on_SendInputButton_pressed():
	var inputVarText = $TextInput/InputText.text
	if "delay " in inputVarText:
		var commandSplitter = inputVarText.split(" ")
		WsMaster.multiInputDelay = float(commandSplitter[1])
	else:
		WsMaster.send_InsertText(inputVarText)
	$TextInput/InputText.text = ""

func _on_DelInputButton_pressed():
	WsMaster.send_DelChar(1)

func _on_B_Red_pressed():
	WsMaster.set_input_Red()

func _on_B_Green_pressed():
	WsMaster.set_input_Green()

func _on_B_Yellow_pressed():
	WsMaster.set_input_Yellow()

func _on_B_Blue_pressed():
	WsMaster.set_input_Blue()
	
func _on_CC_pressed():
	WsMaster.set_input_CC()

func _on_Dash_pressed():
	WsMaster.set_input_Dash()

func _on_Info_pressed():
	WsMaster.set_input_Info()

func _on_Asterisk_pressed():
	WsMaster.set_input_Asterisk()

func _on_Exit_pressed():
	WsMaster.set_input_Exit()
	
func _on_Custom_pressed():
	var inputVarText = $TextInput/InputText.text
	WsMaster.send_Input_data("button",inputVarText)
	
func _on_Search_pressed():
	WsMaster.set_open_search()

func _on_GoSearch_pressed():
	WsMaster.set_go_search()
#---

func _on_BackButton_pressed():
	$Programm.visible = false

#Es sind Daten vom Socket eingetroffen
func wsDataResc(dataType):
	if dataType == "Connect":
		WsMaster.get_CurrentChannel()
		WsMaster.get_audioState()
		WsMaster.get_InputSocket()
		$Connection.visible = true
	if dataType == "Disconnect":
		pass
	elif dataType == "ChannelInfos":
		$InfoLabel.text = ""
		$InfoLabel.text += WsMaster.currentChannelData["channelNumber"] + " - " + WsMaster.currentChannelData["channelName"]
	elif dataType == "ProgrammInfos":
		$InfoLabel.text = ""
		$InfoLabel.text += WsMaster.currentChannelData["channelNumber"] + " - " + WsMaster.currentChannelData["channelName"]
		
		$Programm/ProgrammLabel.bbcode_text = ""
		for prog in WsMaster.currentChannelProgrammList:
			var startTime = convertTime(prog["localStartTime"])
			$Programm/ProgrammLabel.bbcode_text += "[fill]" + startTime.hour + ":" + startTime.minute + " - " + prog["programName"] + "[/fill]" + "\r\n"
		$Programm.visible = true
	elif dataType == "AudioInfo":
		if WsMaster.currentMute == false:
			$Keys/B_VMute.texture_normal = load("res://img/button_Mute.png")
		else:
			$Keys/B_VMute.texture_normal = load("res://img/button_Mute_on.png")
		
func convertTime(strTime):
	var dateSplitter = strTime.split(",")
	var dateDic = {"day":dateSplitter[2], "dst":true, "hour":dateSplitter[3], "minute":dateSplitter[4], "month":dateSplitter[1], "second":dateSplitter[5], "weekday":0, "year":dateSplitter[0]}
	
	return dateDic
	#print(OS.get_datetime())

func _on_B_Shift_pressed():
	$Keys/B_Red.visible = $Keys/B_Shift.pressed
	$Keys/B_Green.visible = $Keys/B_Shift.pressed
	$Keys/B_Yellow.visible = $Keys/B_Shift.pressed
	$Keys/B_Blue.visible = $Keys/B_Shift.pressed
	$Keys/Info.visible = $Keys/B_Shift.pressed

func _on_Button_pressed():
	WsMaster.setURL($IPInput/IPEdit.text)
	WsMaster.loadKey()
	WsMaster.connectToTV()
	$IPInput.visible = false

func _on_ButtonIPClose_pressed():
	get_tree().notification(MainLoop.NOTIFICATION_WM_QUIT_REQUEST)
