unit vktestform;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TMainForm = class(TForm)
    btLogin: TButton;
    eAppId: TEdit;
    eSecretKey: TEdit;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    AppId: string;
    SecretKey: string;
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

uses
  System.IniFiles;

const
  KeysIniFileName = 'keys.ini';
  KeysSection = 'Keys';
  KeysAppId = 'app_id';
  KeysSecretKey = 'secret_key';

procedure TMainForm.FormCreate(Sender: TObject);
var
  KeysIniFile: TIniFile;
begin
  KeysIniFile := TIniFile.Create(ExtractFilePath(ParamStr(0)) + KeysIniFileName);

  try
    Self.AppId := KeysIniFile.ReadString(KeysSection, KeysAppId, '');
    Self.SecretKey := KeysIniFile.ReadString(KeysSection, KeysSecretKey, '');

    Self.eAppId.Text := Self.AppId;
    Self.eSecretKey.Text := Self.SecretKey;
  finally
    KeysIniFile.Free;
  end;
end;

end.
