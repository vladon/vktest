unit vktestform;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, IPPeerClient, REST.Client,
  REST.Authenticator.OAuth, Data.Bind.Components, Data.Bind.ObjectScope,
  browserform, VkApi, VkApi.Photo, VkApi.Authenticator, VkApi.Constants,
  VkApi.Types, VkApi.Utils;

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
    bUploadFile: TButton;
    eUploadUrl: TEdit;
    eFilename: TEdit;
    bSaveWallPhoto: TButton;
    eUserId: TEdit;
    ePhoto: TEdit;
    eServer: TEdit;
    eHash: TEdit;
    eAlbumId: TEdit;
    eMessage: TEdit;
    bWallPost: TButton;
    ePhotoId: TEdit;
    eOwnerId: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure btLoginClick(Sender: TObject);
    procedure btSetOfflineClick(Sender: TObject);
    procedure bPostTextToGroupClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure bGetWallUploadServerClick(Sender: TObject);
    procedure bUploadFileClick(Sender: TObject);
    procedure bSaveWallPhotoClick(Sender: TObject);
    procedure bWallPostClick(Sender: TObject);
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
  System.IniFiles, System.DateUtils, Vcl.Clipbrd, IdHTTP, IdMultipartFormData,
  SynCommons, IdSSLOpenSSL, superobject;

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

  eUploadUrl.Text := wus.UploadUrl;
  eUserId.Text := IntToStr(wus.UserId);
  eAlbumId.Text := IntToStr(wus.AlbumId);
end;

procedure TMainForm.bPostTextToGroupClick(Sender: TObject);
begin
  Memo1.Lines.Add(FVKApi.WallPost(StrToInt(eGroupId.Text), ePostText.Text));
end;

procedure TMainForm.bSaveWallPhotoClick(Sender: TObject);
var
  swpp: TVkSaveWallPhotoParams;
  p: TVkPhoto;
begin
  swpp.UserId := -1;
  swpp.GroupId := StrToInt(eGroupId.Text);
  swpp.Photo := ePhoto.Text;
  swpp.Server := StrToInt(eServer.Text);
  swpp.Hash := eHash.Text;

  p := FVKApi.PhotosSaveWallPhoto(swpp);
  Memo1.Lines.Add(p.Text);

  eOwnerId.Text := IntToStr(p.OwnerId);
  ePhotoId.Text := IntToStr(p.Id);
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

procedure TMainForm.bUploadFileClick(Sender: TObject);
var
  IdHTTP: TIdHTTP;
  IdSSL: TIdSSLIOHandlerSocketOpenSSL;
  SSL: Boolean;
  IdMFD: TIdMultiPartFormDataStream;
  Response: string;
  v: Variant;
begin
  IdHTTP := TIdHTTP.Create();

  IdSSL := nil;
  SSL := False;

  try
    try
      IdMFD := TIdMultiPartFormDataStream.Create;
      IdMFD.AddFile('photo', ExtractFilePath(Application.ExeName) +
         eFilename.Text);

      if string(eUploadUrl.Text).Contains('https://') then
      begin
        IdSSL := TIdSSLIOHandlerSocketOpenSSL.Create();
        IdHTTP.IOHandler := IdSSL;
        SSL := True;
      end;

      Response := IdHTTP.Post(eUploadUrl.Text, IdMFD);
      Memo1.Lines.Add('Response:');
      Memo1.Lines.Add(Response);

      v := _JsonFast(RawUTF8(Response));

      Memo1.Lines.Add('1');
      eServer.Text := v.server;
      Memo1.Lines.Add('2');
      ePhoto.Text := v.photo;
      Memo1.Lines.Add('3');
      eHash.Text := v.hash;
      Memo1.Lines.Add('4');

    except
      on E: Exception do
      begin
        Memo1.Lines.Add(E.ClassName);
        Memo1.Lines.Add(E.Message);
      end;
    end;
  finally
    if SSL then
    begin
      IdSSL.Free;
    end;
    IdHTTP.Free;
  end;
end;

procedure TMainForm.Button1Click(Sender: TObject);
begin
  Memo1.Lines.Add(IntToStr(FVKApi.AccountGetAppPermissions()));
end;

procedure TMainForm.bWallPostClick(Sender: TObject);
begin
  FVKApi.WallPostPhoto(GroupIdToOwnerId(StrToInt(eGroupId.Text)), 'photo' +
     eOwnerId.Text + '_' + ePhotoId.Text, eMessage.Text);
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
