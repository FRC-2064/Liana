; installer/windows-installer.iss

[Setup]
AppName=Liana
#define AppVersion GetEnv("APP_VERSION")

AppVersion=1.0.0
AppPublisher=2064
AppPublisherURL=https://github.com/frc-2064/liana
AppSupportURL=https://github.com/FRC-2064/Liana/issues

DefaultDirName={autopf}\Liana
DefaultGroupName=Liana
SetupIconFile=..\windows\runner\resources\app_icon.ico
OutputBaseFilename=Liana-Installer-v{#AppVersion}
Compression=lzma2
SolidCompression=yes
OutputDir=Output

[Files]
Source: "..\build\windows\x64\runner\Release\*"; DestDir: "{app}"; Flags: recursesubdirs createallsubdirs

[Icons]
Name: "{group}\Liana"; Filename: "{app}\liana.exe"
Name: "{autodesktop}\Liana"; Filename: "{app}\liana.exe"; Tasks: desktopicon

[Run]
Filename: "{app}\liana.exe"; Description: "{cm:LaunchProgram,Liana}"; Flags: nowait postinstall skipifsilent

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}";
