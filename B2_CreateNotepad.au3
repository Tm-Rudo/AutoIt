#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.16.1
 Author:         myName

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here

; thêm & trước chữ cái để nó gạch dưới chữ cái đầu ở mấy cái menu

; khoá cái điều khiển: chọn nó -> control->lock để k bị thay đổi
; ấn vô form, lưu 2 thuộc tính clientHeight, clientwidth
; điền vô width height của form 2 gtri của 2 client vừa lưu, top left cho = 0
; kí tự &: tạo ra phím tắt cho menu
; ấn vô form -> style
; ấn vô edit -> resizing -> dockauto = true -> thay đổi kích cỡ theo form
; tên &@Tab & tổ hợp phím

#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include<File.au3>
#Region ### START Koda GUI section ### Form=
Global $Form1 = GUICreate("Untitled - Notepad", 582, 404, -1, -1, BitOR($GUI_SS_DEFAULT_GUI,$WS_MAXIMIZEBOX,$WS_SIZEBOX,$WS_THICKFRAME,$WS_TABSTOP))
Global $MenuItem1 = GUICtrlCreateMenu("&File")
Global $MenuItem2 = GUICtrlCreateMenuItem("New"&@TAB&"Ctrl+N", $MenuItem1)
Global $MenuItem3 = GUICtrlCreateMenuItem("Open"&@TAB&"Ctrl+O", $MenuItem1)
Global $MenuItem4 = GUICtrlCreateMenuItem("Save"&@TAB&"Ctrl+S", $MenuItem1)
Global $MenuItem5 = GUICtrlCreateMenuItem("", $MenuItem1)
Global $MenuItem6 = GUICtrlCreateMenuItem("Exit", $MenuItem1)
Global $MenuItem8 = GUICtrlCreateMenu("&Help")
Global $MenuItem9 = GUICtrlCreateMenuItem("About Notepad"&@TAB&"Shift+Alt+Space", $MenuItem8)
GUISetFont(12, 400, 0, "MS Sans Serif")
Global $Edit1 = GUICtrlCreateEdit("", 0, 0, 614, 416)
;GUICtrlSetData(-1, "Edit1")
GUICtrlSetResizing(-1, $GUI_DOCKAUTO)
Global $Form1_AccelTable[3][2] = [["!4", $MenuItem2],["!{F21}", $MenuItem6],["!+{SPACE}", $MenuItem9]]
GUISetAccelerators($Form1_AccelTable)
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit

		;Case $MenuItem1 file k cần thiết

		Case $MenuItem2 ;new
			#cs
			; nếu có nội dung thì sẽ hỏi muốn lưu k
			; kh có nd thì k gì xảy ra
			Local $content = GUICtrlRead($Edit1) ;tạo biênss lưu dl người dùng nhập
			If $content Then
				; sd hàm dựng sẵn fsd(tiêu đề, thưu mục mặc định hiển thị, filter)
				Local $fp = FileSaveDialog('Save', @ScriptDir,  "Text files (*.txt)|All (*.*)" , 2+16,'', $Form1)

				If $fp Then
					;MsgBox(0,0,'ok')
					;filewrite: ghi dữ liệu (đường dẫn tới file, dữ liệu)
					FileWrite ( $fp, $content)
					FileClose($fp)
					;MsgBox(0,0,'Saved')
					GUICtrlSetData($Edit1, '')
				EndIf
			EndIf
			#ce
			saveFile(True)

		Case $MenuItem3 ;open
			;hỏi đường dẫn đến tệp tin
			;đọc nd file
			Local $fp = FileOpenDialog('Open', @ScriptDir,  "Text files (*.txt)|All (*.*)" ,1,'', $Form1)
			If $fp Then
			    Local $fp2 = FileOpen($fp, 128) ;128: utft , đọc trong help
				Local $data = FileRead($fp2)
				;đóng file
				FileClose($fp2)
				GUICtrlSetData($Edit1, $data)

				updateTitle($fp)
#cs
				;đổi tiêu đề form
				Local $driver, $dir, $fileName, $ext

				Local $arr = _PathSplit($fp,$driver, $dir, $fileName, $ext)

				;thay đổi tiêu đề form khi mở file mới
				WinSetTitle($Form1,'',$fileName & $ext & ' - Notepad')
#ce
			EndIf
		Case $MenuItem4 ;save
			;kiểm tra nhập gì chưa
			;có thì lưu
			Local $fp = saveFile()
			updateTitle($fp)

		Case $MenuItem6
			Exit
	;	Case $MenuItem8
		Case $MenuItem9 ;about
			MsgBox(64 + 262144, 'About', 'Test')
		Case $Edit1
	EndSwitch
WEnd
;tạo hàm lưu file vì giống cái new
Func saveFile($resetForm = False) ;;tạo hàm xem phải xoá dl trong trình soạn thảo k
	Local $content = GUICtrlRead($Edit1) ;tạo biênss lưu dl người dùng nhập
	If $content Then
		; sd hàm dựng sẵn fsd(tiêu đề, thưu mục mặc định hiển thị, filter)
		Local $fp = FileSaveDialog('Save', @ScriptDir,  "Text files (*.txt)|All (*.*)" , 2+16,'', $Form1)
;shift tab
		If $fp Then
			;filewrite: ghi dữ liệu (đường dẫn tới file, dữ liệu)
			;FileWrite ( $fp, $content)
			;FileClose($fp)

			$op = FileOpen($fp, 2)
			FileWrite ( $op, $content)
			FileClose($op)

			If $resetForm Then
			GUICtrlSetData($Edit1, '')
			EndIf
			Return $fp
		EndIf
	EndIf
EndFunc

;fp: file path
Func updateTitle($fp)
	Local $driver, $dir, $fileName, $ext

	Local $arr = _PathSplit($fp,$driver, $dir, $fileName, $ext)

	;thay đổi tiêu đề form khi mở file mới
	WinSetTitle($Form1,'',$fileName & $ext & ' - Notepad')

EndFunc
