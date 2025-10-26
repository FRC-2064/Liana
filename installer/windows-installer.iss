; installer/windows-installer.iss

[Setup]
AppName=Liana

AppVersion={#APP_VERSION}
AppPublisher=2064
AppPublisherURL=https://github.com/frc-2064/liana
AppSupportURL=https://github.com/FRC-2064/Liana/issues
AppId=4ff1e924-d188-41ae-966c-1e21cde85d2a

; Installation settings
DefaultDirName={autopf}\Liana
DefaultGroupName=Liana
DisableDirPage=auto
DisableProgramGroupPage=auto

; Uninstall settings
UninstallDisplayName=Liana
UninstallDisplayIcon={app}\liana.exe

; Output settings
SetupIconFile=..\windows\runner\resources\app_icon.ico
OutputBaseFilename=Liana-Installer-v{AppVersion}
Compression=lzma2
SolidCompression=yes
OutputDir=Output

; Update settings
CloseApplications=yes
RestartApplications=yes
AllowCancelDuringInstall=no

[Files]
Source: "..\build\windows\x64\runner\Release\*"; DestDir: "{app}"; Flags: recursesubdirs createallsubdirs ignoreversion

[Icons]
Name: "{group}\Liana"; Filename: "{app}\liana.exe"
Name: "{autodesktop}\Liana"; Filename: "{app}\liana.exe"; Tasks: desktopicon

[Run]
Filename: "{app}\liana.exe"; Description: "{cm:LaunchProgram,Liana}"; Flags: nowait postinstall skipifsilent

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}";

[Code]
function InitializeSetup(): Boolean;
var
  ResultCode: Integer;
  UninstallString: String;
begin
  Result := True;

  if CheckForMutexes('LianaAppMutex') then
  begin
    if MsgBox('Liana is currently running. The installer will close it to continue. Continue?',
              mbConfirmation, MB_YESNO) = IDYES then
    begin
      Result := True;
    end
    else
      Result := False;
  end;
end;

procedure CurStepChanged(CurStep: TSetupStep);
begin
  if CurStep = ssPostInstall then
  begin
    DeleteFile(ExpandConstant('{app}\old_file.dll'));
  end;
end;
