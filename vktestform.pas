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
    eAccessToken: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure btLoginClick(Sender: TObject);
  private
    { Private declarations }
    AppId: string;
    SecretKey: string;
    AccessToken: string;
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

uses
  System.IniFiles, browserform, Vcl.Clipbrd;

const
  KeysIniFileName = 'keys.ini';
  KeysSection = 'Keys';
  KeysAppId = 'app_id';
  KeysSecretKey = 'secret_key';
  KeysAccessToken = 'access_token';

const
  vkAuthUrlTemplate = 'https://oauth.vk.com/authorize?client_id=%s&scope=' +
  '%s&redirect_uri=%s&display=%s&v=%s&response_type=token';

  vkDefaultScope = 'notify,wall,status,wall,messages,stats,offline';
  vkDefaultRedirectUri = 'https://oauth.vk.com/blank.html';
  vkDefaultDisplay = 'popup';
  vkDefaultVersion = '5.26';


procedure TMainForm.btLoginClick(Sender: TObject);
var
  vkAuthUrl: string;
  vkReturnUrl: string;
  accessToken: string;
  indexOfAccessToken: Integer;
  indexOfExpiresIn: Integer;

  KeysIniFile: TIniFile;
begin
  vkAuthUrl := Format(vkAuthUrlTemplate, [Self.AppId,
     vkDefaultScope, vkDefaultRedirectUri, vkDefaultDisplay,
     vkDefaultVersion]);

  WebBrowserForm.WebBrowser1.Navigate2(vkAuthUrl);
  WebBrowserForm.ShowModal;

  vkReturnUrl := WebBrowserForm.WebBrowser1.LocationURL;

  indexOfAccessToken := vkReturnUrl.IndexOf('access_token=') + Length('access_token=');
  indexOfExpiresIn := vkReturnUrl.IndexOf('&expires_in');
  accessToken := vkReturnUrl.Substring(indexOfAccessToken, indexOfExpiresIn -
     indexOfAccessToken);

  Self.eAccessToken.Text := accessToken;
  Self.AccessToken := accessToken;

  KeysIniFile := TIniFile.Create(ExtractFilePath(Application.ExeName) +
     KeysIniFileName);
  try
    KeysIniFile.WriteString(KeysSection, KeysAccessToken, accessToken);
  finally
    KeysIniFile.Free;
  end;
end;

procedure TMainForm.FormCreate(Sender: TObject);
var
  KeysIniFile: TIniFile;
begin
  KeysIniFile := TIniFile.Create(ExtractFilePath(Application.ExeName) + KeysIniFileName);

  try
    Self.AppId := KeysIniFile.ReadString(KeysSection, KeysAppId, '');
    Self.SecretKey := KeysIniFile.ReadString(KeysSection, KeysSecretKey, '');
    Self.AccessToken := KeysIniFile.ReadString(KeysSection, KeysAccessToken,
       '');

    Self.eAppId.Text := Self.AppId;
    Self.eSecretKey.Text := Self.SecretKey;
    Self.eAccessToken.Text := Self.AccessToken;
  finally
    KeysIniFile.Free;
  end;
end;

end.
