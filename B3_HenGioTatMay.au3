#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.16.1
 Author:         myName

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here
#Region
#AutoIt3Wrapper_Icon = shutdown.ico
#EndRegion

#include <ButtonConstants.au3>
#include <ComboConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <DateTimeConstants.au3>
#include<Date.au3> ;thư viện thời gian

; này k bị trùng giữ lại, form time picker


;ấn vô từng file, ktra cái nào có r thì xoá đi

#Region ### START Koda GUI section ### Form=
Global $FormMain = GUICreate("Auto Shutdown", 563, 467, -1, -1)
GUISetFont(13, 400, 0, "MS Sans Serif")
Global $Label1 = GUICtrlCreateLabel("Select action", 48, 24, 96, 24)
Global $Combobox = GUICtrlCreateCombo("", 48, 56, 209, 25, BitOR($GUI_SS_DEFAULT_COMBO,$CBS_SIMPLE))
GUICtrlSetData(-1, "Shutdown|Restart",'Shutdown')
Global $CheckboxForce = GUICtrlCreateCheckbox("Force running applications to close", 48, 112, 321, 25)
Global $checkboxSetTimeOut = GUICtrlCreateCheckbox("Set the time-out period before shutdown", 48, 152, 321, 33)
GUICtrlSetState(-1, $GUI_CHECKED)
Global $lbTimeOut = GUICtrlCreateLabel("Time-out", 48, 200, 66, 24)
Global $InputTimeOut = GUICtrlCreateInput("30", 120, 200, 113, 28, BitOR($GUI_SS_DEFAULT_INPUT,$ES_CENTER,$ES_NUMBER))
Global $lbSecond = GUICtrlCreateLabel("Seconds", 256, 200, 67, 24)
Global $ButtonTimePicker = GUICtrlCreateButton("Time Picker", 384, 192, 129, 33)
Global $Label4 = GUICtrlCreateLabel("Comment:", 48, 248, 81, 24)
Global $Edit = GUICtrlCreateEdit("", 48, 280, 465, 105)
Global $ButtonStart = GUICtrlCreateButton("Start", 56, 408, 121, 41, $BS_DEFPUSHBUTTON)
Global $ButtonAbort = GUICtrlCreateButton("Abort", 368, 408, 113, 41)
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

;combobox tích dropdownlist

;tạo thêm giao diện cho picker
;điền ParentForm là formMain để gọi form picker
;sang tab win32
;chọn win 32, cái date picker rồi style, tích ô đầu với ô timeformat
; copy cái phía trên vòng lặp while thôi
; cho include lên trên

#Region ### START Koda GUI section ### Form=
Global $FormTimePicker = GUICreate("Select Time", 375, 214, -1, -1, -1, -1, $FormMain)
GUISetFont(13, 400, 0, "MS Sans Serif")
Global $Date1 = GUICtrlCreateDate("", 32, 48, 297, 36, BitOR($DTS_UPDOWN,$DTS_TIMEFORMAT)) ;xoá thời gian mặc định
;sửa thời gian
Local $sStyle = "yyyy/MM/dd HH:mm:ss"
GUICtrlSendMsg($Date1, $DTM_SETFORMATW, 0, $sStyle)

Global $ButtonOK = GUICtrlCreateButton("OK", 96, 112, 153, 49)
;GUISetState(@SW_SHOW) ;xoá cái này để cài, nào ấn thì mới hiện chứ k hiện ngay
#EndRegion ### END Koda GUI section ###

;sửa vòng lặp cho xử lý 2 giao diện
While 1
	;0: chỉ trả về 1 sk
	;1: trả về 1 mảng chứa sk, thông tin mở rộng...
	$nMsg = GUIGetMsg(1) ;thêm số 1, F1 coi file help
	Switch $nMsg[0] ;almf mảng
		Case $GUI_EVENT_CLOSE
			If $nMsg[1] == $FormMain Then ;form nào
				Exit ;tắt toàn bộ ctrinh
			EndIf

			If $nMsg[1] == $FormTimePicker Then
				GUISetState(@SW_HIDE, $FormTimePicker) ;ẩn form đi
			EndIf

		Case $checkboxSetTimeOut
			;chỉ khi đc tích thì người dùng mới đc nhập
			If GUICtrlRead($checkboxSetTimeOut) == $GUI_CHECKED Then
				toggleTimeOut(True)
			Else
				toggleTimeOut(False)
			EndIf

		Case $ButtonTimePicker
			GUISetState(@SW_SHOW, $FormTimePicker) ;hiện form

		Case $ButtonStart
			;MsgBox(0,0,generateCommand())
			Run(generateCommand(),'',@SW_HIDE)
		Case $ButtonAbort
			Run('shutdown -a','',@SW_HIDE) ;lệnh huỷ
			MsgBox(64+ 262144,'Thông báo', 'Đã huỷ thành công')

		;cho nút ok
		Case $ButtonOK
			;quy đổi thời gian người dùng chọn sang đơn vị giây
			;sd hàm lấy ra số giây hiện tại
			Local $dateTime =GUICtrlRead($Date1) ;tính ra ngày hiện tại,;nối thêm giờ từ Input người dùng chọn

			$dateTime = StringReplace($dateTime, ' PM', '')
			$dateTime = StringReplace($dateTime, ' AM', '')

			Local $seconds = _DateDiff('s', _NowCalc(),$dateTime) ;hàm tính time ngày giờ htai, ngày giờ t2 rồi trừ đi quy đổi

			If $seconds <=0 Then
				MsgBox(16+ 262144,"Lỗi","Vui lòng chọn thời gian hợp lệ")
			Else
				GUICtrlSetData($InputTimeOut, $seconds) ;gán gtri vô input
				;đóng giao diện timepicker
				GUISetState(@SW_HIDE, $FormTimePicker)
			EndIf
	EndSwitch
WEnd

;
Func generateCommand()
;trả về kiểu chuỗi
	Local $cmd = 'shutdown'
;ktra các tuỳ chọn của người dùng
	;shutdow hay restart
	Local $action = GUICtrlRead($Combobox)
	$cmd &= ' ' & ($action =='Shutdown' ? '-s' : '-r')
	;có đóng toàn bộ ứng dụng khi tắt máy không: checkbox force
	If GUICtrlRead($CheckboxForce)==$GUI_CHECKED Then ;nếu có tích
		$cmd &= ' -f' ;chuỗi trên nối thêm gtri -f
	EndIf
	; có đặt thời gian chờ hay không?
	If GUICtrlRead($checkboxSetTimeOut) == $GUI_CHECKED Then
			Local $timeout = GUICtrlRead($InputTimeOut)
			;nếu người dùng k nhập gì trong input
			If Not $timeout Then
				$timeout = 30
				GUICtrlSetData($InputTimeOut, 30) ;set gtri cho input, phòng trường hợp k hợp lệ
			EndIf
			;ngược lại
			$cmd &= ' -t ' & $timeout

	EndIf

	;ktra comment xem có nhập gì k
	Local $cmt = GUICtrlRead($Edit)

	If $cmt Then
		$cmd &= ' -c "' & $cmt & '"'
	EndIf

	Return $cmd
EndFunc


;ktra tích checkbox
Func toggleTimeOut($enable)
	Local $value = $enable ? $GUI_ENABLE : $GUI_DISABLE
;ctrl+ D copy code
;ẩn sau cái checkbox nếu k đc tích
	GUICtrlSetState($lbTimeOut, $value)
	GUICtrlSetState($InputTimeOut, $value)
	GUICtrlSetState($lbSecond, $value)
	GUICtrlSetState($ButtonTimePicker, $value)
	;khi tích thì con trỏ sẽ ở ô nhập input
	If $value Then
		GUICtrlSetState($InputTimeOut, $GUI_FOCUS) ;
	EndIf
EndFunc