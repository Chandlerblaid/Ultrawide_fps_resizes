;-Includes
#include <MsgBoxConstants.au3>
#include <Array.au3>
#include <String.au3>
#include <WinAPI.au3>
#include <WindowsConstants.au3>
#include <FileConstants.au3>

$AlreadyRunning = MsgBox(4, "Game Status", "Is Cold War already running in Windowed mode?" & @CRLF & @CRLF & "If you click 'Yes', make sure the game is started already and running in windowed mode" & @CRLF & "If not, just click no to proceed with the Autolaunch")
$Title = "Call of Duty®: Black Ops Cold War" ;--Set Application-Title (Window Title)
If $AlreadyRunning = 4 Then
   WinWaitActive($Title) ;--Wait for Window to become active

   If Not WinExists($Title) Then ;-- If Window was Active, but does not exist anymore, give Error and Quit
	   MsgBox(0, "ERROR", "Cold War not launched") ;-Give Errormessage
	   Exit ;-End Program
	EndIf ;- End If Win Not Exist Check

   $hWnd = WinGetHandle($Title) ;-Get Handle Adress by Title of Window

   Local $iStyle = _WinAPI_GetWindowLong($hWnd, $GWL_STYLE) ;-Set Style of Window

   $iStyle = BitOR(BitXOR($iStyle, $WS_MINIMIZEBOX, $WS_MAXIMIZEBOX, $WS_CAPTION, $WS_BORDER, $WS_SIZEBOX), $WS_POPUP) ;- Change Windowstyle to Fullscreen, while removing Border, Options, set Window as Popup

   _WinAPI_SetWindowLong($hWnd, $GWL_STYLE, $iStyle) ;-Set WindowLong Style
   _WinAPI_SetWindowPos($hWnd, $HWND_TOP, @DesktopWidth/4, -1, @DesktopWidth/2, @DesktopHeight+2, $SWP_FRAMECHANGED) ;-Resize Window to -1 Pixel on X and Y Axis, to hide 1px white Bar around the Window, Overstretch by 2px each to hide white Bar around outer Edges
EndIf

;-Set Dims to check back if files do not exist
Dim $ClearLocation, $ArrayType, $CFG_File

;Check if the client is installed
$ClientDestination = RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\Classes\battlenet\DefaultIcon", "") ;Registrylocation for RiotClient
$ClearLocation = _StringBetween($ClientDestination, '"', '"') ;Give Direct Path by extracting String between quotations
$ArrayType = 1 ;Change ArrayType to indicate if Location is a String or Array ( 1 = Array; 0 = String)
If Not FileExists(_ArrayToString($ClearLocation)) Then ;--If Client does not exist, give Option to manually select it
   MsgBox(0, "ERROR", "Battle.net Client was not found!" & @CRLF & @CRLF & "Usually located at:" & @CRLF & "C:\Program Files (x86)\Battle.net\...") ;-Give Errormessage
   $sFileOpenDialog = FileOpenDialog("Select Battle.net.exe...", @HomeDrive & "\", "RiotGameServices.exe (*.exe)", $FD_FILEMUSTEXIST) ;-Open Dialog to manually select RiotGamesSerivces.exe
   $ClearLocation = $sFileOpenDialog ;-Set New Location instead of Registrydefault Location
   $ArrayType = 0 ;-Change Location Type from Array to String ( 1 = Array; 0 = String)
EndIf ;--End Check for Existence of RiotGamesServices.exe

;Check if Config exists
$CFG_File = @MyDocumentsDir & "\Call Of Duty Black Ops Cold War\player\config.ini" ;-Read UserID and Open Gamesettings from last logged in User
$CFG_File_Section = "Display" ;-Jump to Section in GameSettings
;$CFG_File_Section = "/Script/ShooterGame.ShooterGameUserSettings" ;-Jump to Section in GameSettings

If Not FileExists($CFG_File) Then ;If Config does not exists - give option to manually select it
   Msgbox(0, "ERROR", "Cold War Config not found!" & @CRLF & @CRLF &"It's usually located at:" & @CRLF & "%MyDocumentsDir%\Call Of Duty Black Ops Cold War\player\") ;-Give Errormessage
   $sFileOpenDir = FileOpenDialog("Select config.ini... - Usually: '%LocalAppData%\Call Of Duty Black Ops Cold War\player\'", @MyDocumentsDir, "config.ini (*.ini)", $FD_FILEMUSTEXIST) ;-Open Dialog to manually select RiotLocalMachine.ini
   $CFG_File = $sFileOpenDir ;-Set New Location for Riot Config

   IniWrite($CFG_File, $CFG_File_Section, "fullscreen_mode", "0") ;-Change Whatever Screenmode is selected to Windowed
   IniWrite($CFG_File, $CFG_File_Section, "window_x", ((@DesktopWidth/2)-2560/2)) ;-Set Windowposition on X-Axis to Middle of Screen
   IniWrite($CFG_File, $CFG_File_Section, "window_y", ((@DesktopHeight/2)-1440/2)) ;-Set Windowposition on Y-Axis to Middle of Screen
Else ;-- If Config was found by default, do the same
   IniWrite($CFG_File, $CFG_File_Section, "fullscreen_mode", "0") ;-Change Whatever Screenmode is selected to Windowed
   IniWrite($CFG_File, $CFG_File_Section, "window_x", ((@DesktopWidth/2)-5120/2)) ;-Set Windowposition on X-Axis to Middle of Screen
   IniWrite($CFG_File, $CFG_File_Section, "window_y", ((@DesktopHeight/2)-1440/2)) ;-Set Windowposition on Y-Axis to Middle of Screen
EndIf

;Launch Cold War
;$Parameters = "--launch-product=valorant --launch-patchline=live" ;--Set Launchparameters to Launch ValorantGame through RiotClient
$Parameters = "" ;--Set Launchparameters to Launch ValorantGame through RiotClient
If $ArrayType = 1 Then ;--If Gamelocation is an Array (Array = 1; String = 0) Launch using an Array
   ShellExecute(_ArrayToString($ClearLocation), $Parameters) ;-Launch Game by Array
Else ;--If Gamelocation is a String (Array = 1; String = 0) Launch using a String
   ShellExecute($ClearLocation, $Parameters) ;-Launch Game by String
EndIf ;- End of Launchprocess

WinWaitActive($Title) ;--Wait for Window to become active

If Not WinExists($Title) Then ;-- If Window was Active, but does not exist anymore, give Error and Quit
    MsgBox(0, "ERROR", "Cold War not launched") ;-Give Errormessage
    Exit ;-End Program
 EndIf ;- End If Win Not Exist Check

$hWnd = WinGetHandle($Title) ;-Get Handle Adress by Title of Window

Local $iStyle = _WinAPI_GetWindowLong($hWnd, $GWL_STYLE) ;-Set Style of Window

$iStyle = BitOR(BitXOR($iStyle, $WS_MINIMIZEBOX, $WS_MAXIMIZEBOX, $WS_CAPTION, $WS_BORDER, $WS_SIZEBOX), $WS_POPUP) ;- Change Windowstyle to Fullscreen, while removing Border, Options, set Window as Popup

_WinAPI_SetWindowLong($hWnd, $GWL_STYLE, $iStyle) ;-Set WindowLong Style
_WinAPI_SetWindowPos($hWnd, $HWND_TOP, @DesktopWidth/4, -1, @DesktopWidth/2, @DesktopHeight+2, $SWP_FRAMECHANGED) ;-Resize Window to -1 Pixel on X and Y Axis, to hide 1px white Bar around the Window, Overstretch by 2px each to hide white Bar around outer Edges
