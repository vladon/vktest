unit vktestform;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, IPPeerClient, REST.Client,
  REST.Authenticator.OAuth, Data.Bind.Components, Data.Bind.ObjectScope,
  browserform;

type
  TMainForm = class(TForm)
    btLogin: TButton;
    eAppId: TEdit;
    eSecretKey: TEdit;
    eAccessToken: TEdit;
    RESTClient1: TRESTClient;
    RESTRequest1: TRESTRequest;
    RESTResponse1: TRESTResponse;
    OAuth2Authenticator1: TOAuth2Authenticator;
    btSetOffline: TButton;
    procedure FormCreate(Sender: TObject);
    procedure btLoginClick(Sender: TObject);
    procedure btSetOfflineClick(Sender: TObject);
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
  System.IniFiles, System.DateUtils, Vcl.Clipbrd;

const
  KeysIniFileName = 'keys.ini';
  KeysSection = 'Keys';
  KeysAppId = 'app_id';
  KeysSecretKey = 'secret_key';
  KeysAccessToken = 'access_token';

const
  vkAuthUrlTemplate = 'https://oauth.vk.com/authorize?client_id=%s&scope=' +
  '%s&redirect_uri=%s&display=%s&v=%s&response_type=token';
  vkAuthEndpoint = 'https://oauth.vk.com/authorize';

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
  OAuth2Authenticator1.AccessToken := EmptyStr;
  OAuth2Authenticator1.ClientID := Self.AppId;
  OAuth2Authenticator1.ClientSecret := Self.SecretKey;
  OAuth2Authenticator1.ResponseType := TOAuth2ResponseType.rtTOKEN;
  OAuth2Authenticator1.Scope := vkDefaultScope;
  OAuth2Authenticator1.AuthorizationEndpoint := vkAuthEndpoint;
  OAuth2Authenticator1.RedirectionEndpoint := vkDefaultRedirectUri;

//  vkAuthUrl := Format(vkAuthUrlTemplate, [Self.AppId,
//     vkDefaultScope, vkDefaultRedirectUri, vkDefaultDisplay,
//     vkDefaultVersion]);

  Clipboard.AsText := OAuth2Authenticator1.AuthorizationRequestURI;

  WebBrowserForm.WebBrowser1.Navigate2(OAuth2Authenticator1.AuthorizationRequestURI);
  WebBrowserForm.ShowModal;

  vkReturnUrl := WebBrowserForm.WebBrowser1.LocationURL;

  indexOfAccessToken := vkReturnUrl.IndexOf('access_token=') + Length('access_token=');
  indexOfExpiresIn := vkReturnUrl.IndexOf('&expires_in');
  accessToken := vkReturnUrl.Substring(indexOfAccessToken, indexOfExpiresIn -
     indexOfAccessToken);

  Self.eAccessToken.Text := accessToken;
  Self.AccessToken := accessToken;

  OAuth2Authenticator1.AccessToken := accessToken;

  KeysIniFile := TIniFile.Create(ExtractFilePath(Application.ExeName) +
     KeysIniFileName);
  try
    KeysIniFile.WriteString(KeysSection, KeysAccessToken, accessToken);
  finally
    KeysIniFile.Free;
  end;
end;

procedure TMainForm.btSetOfflineClick(Sender: TObject);
begin
  RESTRequest1.Resource := 'account.setOffline';
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

    OAuth2Authenticator1.AccessToken := Self.AccessToken;
    OAuth2Authenticator1.ClientID := Self.AppId;
    OAuth2Authenticator1.ClientSecret := Self.SecretKey;
    OAuth2Authenticator1.ResponseType := TOAuth2ResponseType.rtTOKEN;
    OAuth2Authenticator1.AuthorizationEndpoint := vkAuthEndpoint;
  finally
    KeysIniFile.Free;
  end;
end;

end.
