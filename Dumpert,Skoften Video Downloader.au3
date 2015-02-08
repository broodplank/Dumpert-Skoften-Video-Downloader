#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=dumpertskoften.ico
#AutoIt3Wrapper_Outfile=DumpertSkoftenVideoDownloader.exe
#AutoIt3Wrapper_Res_Fileversion=1.0
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include <Process.au3>
#include <WindowsConstants.au3>
#include <GUIConstants.au3>
#include <GUIConstantsEx.au3>
#include <String.au3>
#include <InetConstants.au3>
#include <StaticConstants.au3>

;Dumpert.nl/Skoften.net Video Downloader v1.0
;Copyright 2015 broodplank.net

GUICreate("Dumpert/Skoften Video Downloader", 300, 243)

GUICtrlCreateLabel("Genereer directe links naar videos op Dumpert en Skoften" & @CRLF & @CRLF & "Link naar video:", 5, 10)
$link = GUICtrlCreateInput("", 5, 55, 285, 20)
$getlink = GUICtrlCreateButton("Directe link genereren", 5, 82, 285, 30)

GUICtrlCreateGroup("Directe links naar video:", 5, 120, 285, 100)
$mp4result = GUICtrlCreateButton("Download MP4", 15, 140, 130, 20)
GUICtrlSetState($mp4result, $GUI_DISABLE)
$mp4open = GUICtrlCreateButton("Open MP4", 155, 140, 130, 20)
GUICtrlSetState($mp4open, $GUI_DISABLE)
$webmresult = GUICtrlCreateButton("Download WebM", 15, 165, 130, 20)
GUICtrlSetState($webmresult, $GUI_DISABLE)
$webmopen = GUICtrlCreateButton("Open WebM", 155, 165, 130, 20)
GUICtrlSetState($webmopen, $GUI_DISABLE)
$flvresult = GUICtrlCreateButton("Download FLV", 15, 190, 130, 20)
GUICtrlSetState($flvresult, $GUI_DISABLE)
$flvopen = GUICtrlCreateButton("Open FLV", 155, 190, 130, 20)
GUICtrlSetState($flvopen, $GUI_DISABLE)
$copy = GUICtrlCreateLabel("Copyright 2015 broodplank.net", 5, 225)
GUICtrlSetStyle($copy, $WS_DISABLED)

GUISetState()

While 1
	$msg = GUIGetMsg()

	If $msg = $gui_event_close Then Exit

	If $msg = $getlink Then

		$readlink = GUICtrlRead($link)

		;Als het een dumpert link is
		If StringInStr($readlink, "dumpert.nl") = True Then

			;Download html
			InetGet($readlink, @ScriptDir & "\temp.html")
			$readfile = FileRead(@ScriptDir & "\temp.html")

			;Zoek 'videoplayer' in html pagina
			_RunDos("findstr " & Chr(34) & "videoplayer" & Chr(34) & " temp.html > temp1.html")

			;Verwijder whitespacing
			$getbase = StringStripWS(FileReadLine("temp1.html", 1), 8)
			FileWrite(@ScriptDir & "/base64.txt", $getbase)

			;Verwijder de eerste 70 tekens
			$trimleft = StringTrimLeft(FileReadLine(@ScriptDir & "/base64.txt", 1), 70)

			;Verwijder de laatste 36 tekens
			$base64hash = StringTrimRight($trimleft, 36)

			;Decode base64 hash
			$decodedmp4 = _Base64Decode($base64hash)

			;Maak output leesbaar
			$replace1 = StringReplace($decodedmp4, ",", @CRLF)
			$replace2 = StringReplace($replace1, "{", "")
			$replace3 = StringReplace($replace2, "}", "")
			$replace4 = StringReplace($replace3, Chr(34) & "flv" & Chr(34) & ":" & Chr(34), "")
			$replace5 = StringReplace($replace4, Chr(34) & "tablet" & Chr(34) & ":" & Chr(34), "")
			$replace6 = StringReplace($replace5, Chr(34) & "mobile" & Chr(34) & ":" & Chr(34), "")
			$replace7 = StringReplace($replace6, Chr(34), "")
			$replace8 = StringReplace($replace7, "\/\/", "//")
			$replace9 = StringReplace($replace8, "\/", "/")

			;Schrijf MP4 en FLV link naar links.txt
			FileWrite(@ScriptDir & "\links.txt", $replace9)
			$flvlink = FileReadLine(@ScriptDir & "\links.txt", 1)
			$mp4link = FileReadLine(@ScriptDir & "\links.txt", 2)

			;Pas GUI Button states aan voor dumpert.nl
			GUICtrlSetState($mp4result, $GUI_ENABLE)
			GUICtrlSetState($mp4open, $GUI_ENABLE)
			GUICtrlSetState($flvresult, $GUI_ENABLE)
			GUICtrlSetState($flvopen, $GUI_ENABLE)
			GUICtrlSetState($webmresult, $GUI_DISABLE)
			GUICtrlSetState($webmopen, $GUI_DISABLE)

		;Als het een skoften link is
		ElseIf StringInStr($readlink, "skoften.net") = True Then

			;Download html
			InetGet($readlink, @ScriptDir & "\temp.html")

			;Zoek 'sources' in html pagina
			_RunDos("findstr " & Chr(34) & "sources" & Chr(34) & " temp.html > temp1.html")

			;Verwijder whitespacing
			$stripmp4 = StringStripWS(FileReadLine("temp1.html", 2), 8)
			FileWrite(@ScriptDir & "/mp4link.txt", $stripmp4)

			;Verwijder eerste 27 tekens
			$trimleft = StringTrimLeft(FileReadLine(@ScriptDir & "/mp4link.txt", 1), 27)

			;Verwijder laatste 8 tekens
			$mp4link = StringTrimRight($trimleft, 8)

			;Verwijder whitespacing
			$stripwebm = StringStripWS(FileReadLine("temp1.html", 3), 8)
			FileWrite(@ScriptDir&"\webmlink.txt", $stripwebm)

			;Verwijder eerste 28 tekens
			$trimleft = StringTrimLeft(FileReadLine(@ScriptDir & "/webmlink.txt", 1), 28)

			;Verwijder laatste 8 tekens
			$webmlink = StringTrimRight($trimleft, 8)

			;Pas GUI Button states aan voor skoften.net
			GUICtrlSetState($mp4result, $GUI_ENABLE)
			GUICtrlSetState($mp4open, $GUI_ENABLE)
			GUICtrlSetState($flvresult, $GUI_DISABLE)
			GUICtrlSetState($flvopen, $GUI_DISABLE)
			GUICtrlSetState($webmresult, $GUI_ENABLE)
			GUICtrlSetState($webmopen, $GUI_ENABLE)

		Else

			MsgBox(64, "Dumpert/Skoften Video Downloader", "Alleen dumpert.nl en skoften.net links zijn toegestaan")

		EndIf

		;Cillit Bang
		FileDelete(@ScriptDir & "\result.txt")
		FileDelete(@ScriptDir & "\temp.html")
		FileDelete(@ScriptDir & "\temp1.html")
		FileDelete(@ScriptDir & "\mp4link.txt")
		FileDelete(@ScriptDir & "\webmlink.txt")
		FileDelete(@ScriptDir & "\base64.txt")
		FileDelete(@ScriptDir & "\links.txt")

	EndIf


	If $msg = $mp4open Then
		_RunDos("start " & $mp4link)
	EndIf

	If $msg = $mp4result Then
		$rand = Random(1, 2)
		$dir = FileSaveDialog("Dumpert/Skoften Video Downloader", @MyDocumentsDir, "MP4 Files (*.mp4)", 2, StringRight($rand, 7) & ".mp4")
		If $dir <> "" Then
			$get = InetGet($mp4link, $dir, 1, 1)

			Do
				Sleep(200)
			Until InetGetInfo($get, $INET_DOWNLOADCOMPLETE)

			TrayTip("Video is gedownload", $dir, 1)

		EndIf
	EndIf

	If $msg = $flvopen Then
		_RunDos("start " & $flvlink)
	EndIf

	If $msg = $flvresult Then
		$rand = Random(1, 2)
		$dir = FileSaveDialog("Dumpert/Skoften Video Downloader", @MyDocumentsDir, "FLV Files (*.flv)", 2, StringRight($rand, 7) & ".flv")
		If $dir <> "" Then
			$get = InetGet($flvlink, $dir, 1, 1)

			Do
				Sleep(200)
			Until InetGetInfo($get, $INET_DOWNLOADCOMPLETE)

			TrayTip("Video is gedownload", $dir, 1)

		EndIf
	EndIf

	If $msg = $webmopen Then
		_RunDos("start " & $webmlink)
	EndIf

	If $msg = $webmresult Then
		$rand = Random(1, 2)
		$dir = FileSaveDialog("Dumpert/Skoften Video Downloader", @MyDocumentsDir, "WebM Files (*.webm)", 2, StringRight($rand, 7) & ".webm")
		If $dir <> "" Then
			$get = InetGet($webmlink, $dir, 1, 1)

			Do
				Sleep(200)
			Until InetGetInfo($get, $INET_DOWNLOADCOMPLETE)

			TrayTip("Video is gedownload", $dir, 1)

		EndIf
	EndIf


WEnd

;Functie voor het decoden van Base64 strings
Func _Base64Decode($sData)
	Local $oXml = ObjCreate("Msxml2.DOMDocument")
	If Not IsObj($oXml) Then
		SetError(1, 1, 0)
	EndIf

	Local $oElement = $oXml.createElement("b64")
	If Not IsObj($oElement) Then
		SetError(2, 2, 0)
	EndIf

	$oElement.dataType = "bin.base64"
	$oElement.Text = $sData
	Local $sReturn = BinaryToString($oElement.nodeTypedValue, 4)

	If StringLen($sReturn) = 0 Then
		SetError(3, 3, 0)
	EndIf

	Return $sReturn
EndFunc   ;==>_Base64Decode
