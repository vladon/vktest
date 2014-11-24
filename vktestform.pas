unit vktestform;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, IPPeerClient, REST.Client,
  REST.Authenticator.OAuth, Data.Bind.Components, Data.Bind.ObjectScope,
  browserform, VkApi;

type
  TMainForm = class(TForm)
    btLogin: TButton;
    eAppId: TEdit;
    eSecretKey: TEdit;
    eAccessToken: TEdit;
    btSetOffline: TButton;
    eGroupId: TEdit;
    Label1: TLabel;
    ePostText: TEdit;
    Label2: TLabel;
    bPostTextToGroup: TButton;
    Memo1: TMemo;
    Button1: TButton;
    bGetWallUploadServer: TButton;
    procedure FormCreate(Sender: TObject);
    procedure btLoginClick(Sender: TObject);
    procedure btSetOfflineClick(Sender: TObject);
    procedure bPostTextToGroupClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure bGetWallUploadServerClick(Sender: TObject);
  private
    { Private declarations }
    AppId: string;
    SecretKey: string;
    AccessToken: string;

    FVKApi: TVkApi;
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
  vkDefaultScope = 'notify,friends,photos,audio,video,docs,notes,pages,status,' +
  'wall,groups,messages,notifications,stats,ads,offline';
  vkDefaultDisplay = TVkDisplayType.dtPopup;
  vkDefaultVersion: TVkApiVersion = TVkApiVersion.av5_26;

procedure TMainForm.bGetWallUploadServerClick(Sender: TObject);
var
  wus: TVkPhotosGetWallUploadServerResponse;
begin
  wus := FVKApi.PhotosGetWallUploadServer(StrToInt(
     eGroupId.Text));

  Memo1.Lines.Add(wus.UploadUrl);
  Memo1.Lines.Add(IntToStr(wus.AlbumId));
  Memo1.Lines.Add(IntToStr(wus.UserId));


end;

procedure TMainForm.bPostTextToGroupClick(Sender: TObject);
begin
  Memo1.Lines.Add(FVKApi.WallPost(StrToInt(eGroupId.Text), ePostText.Text));
end;

procedure TMainForm.btLoginClick(Sender: TObject);
var
  vkReturnUrl: string;
  accessToken: string;
  indexOfAccessToken: Integer;
  indexOfExpiresIn: Integer;

  KeysIniFile: TIniFile;

begin
  FVKApi.Scope := vkDefaultScope;
  FVKApi.Display := vkDefaultDisplay;
  FVKApi.ApiVersion := vkDefaultVersion;

  WebBrowserForm.WebBrowser1.Navigate2(FVkApi.AuthorizationRequestURI);
  WebBrowserForm.ShowModal;

  vkReturnUrl := WebBrowserForm.WebBrowser1.LocationURL;

  indexOfAccessToken := vkReturnUrl.IndexOf('access_token=') + Length('access_token=');
  indexOfExpiresIn := vkReturnUrl.IndexOf('&expires_in');
  accessToken := vkReturnUrl.Substring(indexOfAccessToken, indexOfExpiresIn -
     indexOfAccessToken);

  Self.eAccessToken.Text := accessToken;
  Self.AccessToken := accessToken;

  FVKApi.AccessToken := accessToken;

  KeysIniFile := TIniFile.Create(ExtractFilePath(Application.ExeName) +
     KeysIniFileName);
  try
    KeysIniFile.WriteString(KeysSection, KeysAccessToken, FVKApi.AccessToken);
  finally
    KeysIniFile.Free;
  end;
end;

procedure TMainForm.btSetOfflineClick(Sender: TObject);
begin
//  RESTRequest1.Resource := 'account.setOffline';
end;

procedure TMainForm.Button1Click(Sender: TObject);
begin
  Memo1.Lines.Add(IntToStr(FVKApi.AccountGetAppPermissions()));
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

    FVKApi := TVkApi.Create(Self.AppId, Self.SecretKey, Self.AccessToken);
  finally
    KeysIniFile.Free;
  end;
end;

end.
