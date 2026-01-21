!define Name "VRCTally"
!define DevName "Happyrobot33"
Name "${Name}"
Outfile "${Name} setup.exe"
RequestExecutionLevel admin ;Require admin rights on NT6+ (When UAC is turned on)
InstallDir "$ProgramFiles\${Name}"

!include LogicLib.nsh
!include MUI.nsh

Function .onInit
SetShellVarContext all
UserInfo::GetAccountType
pop $0
${If} $0 != "admin" ;Require admin rights on NT4+
    MessageBox mb_iconstop "Administrator rights required!"
    SetErrorLevel 740 ;ERROR_ELEVATION_REQUIRED
    Quit
${EndIf}
FunctionEnd

!define INSTDIR_DATA "$APPDATA\${Name}"

!insertmacro MUI_PAGE_WELCOME
!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_PAGE_FINISH
!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_INSTFILES
!insertmacro MUI_LANGUAGE "English"

Section "Install"
SetOutPath "$INSTDIR"
WriteUninstaller "$INSTDIR\Uninstall.exe"
WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${DevName}"   "DisplayName" "${Name}"
WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${DevName}"   "UninstallString" "$INSTDIR\Uninstall.exe"
;Grab all the files
File /r "..\..\artifacts\publish\VRCTallyApp\release_win-x64\*"
;Create the startup command, also passing in the config file location
CreateShortCut "$SMPROGRAMS\${Name}.lnk" "$INSTDIR\VRCTallyApp.exe" "$INSTDIR_DATA\config.tally"

SetOutPath "$INSTDIR_DATA"
;copy the config.tally file
File /oname=config.tally "..\..\artifacts\publish\VRCTallyApp\release_win-x64\config.tally"

SectionEnd

Section "Uninstall"
;TODO: Delete your files
Delete "$SMPROGRAMS\${Name}.lnk"
DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${DevName}"
Delete "$INSTDIR\Uninstall.exe"
RMDir /r "$INSTDIR"
RMDir /r "$INSTDIR_DATA"
SectionEnd
