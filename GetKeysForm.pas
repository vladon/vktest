unit GetKeysForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, browserform;

type
  TfGetKeys = class(TForm)
    eAppId: TEdit;
    Label1: TLabel;
    eSecretKey: TEdit;
    Label2: TLabel;
    bLogin: TButton;
    eAccessToken: TEdit;
    eScope: TEdit;
    Label3: TLabel;
    mKeys: TMemo;
    procedure bLoginClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fGetKeys: TfGetKeys;

implementation

uses
  VkApi, VkApi.Types;

{$R *.dfm}

const
  vkDefaultScope = 'notify,friends,photos,audio,video,docs,notes,pages,status,' +
  'wall,groups,messages,notifications,stats,ads,offline';

procedure TfGetKeys.bLoginClick(Sender: TObject);
var
  VkApi: TVkApi;
  vkReturnUrl: string;
  indexOfAccessToken, indexOfExpiresIn: Integer;
  accessToken: string;
begin
  VkApi := TVkApi.Create(eAppId.Text, eSecretKey.Text, eAccessToken.Text);

  if eScope.Text = EmptyStr then
    eScope.Text := vkDefaultScope;

  VkApi.Scope := eScope.Text;
  VkApi.Display := TVkDisplayType.dtPopup;
  VkApi.ApiVersion := TVkApiVersion.av5_27;

  WebBrowserForm.WebBrowser1.Navigate2(VkApi.AuthorizationRequestURI);
  WebBrowserForm.ShowModal;

  vkReturnUrl := WebBrowserForm.WebBrowser1.LocationURL;

  indexOfAccessToken := vkReturnUrl.IndexOf('access_token=') + Length('access_token=');
  indexOfExpiresIn := vkReturnUrl.IndexOf('&expires_in');
  accessToken := vkReturnUrl.Substring(indexOfAccessToken, indexOfExpiresIn -
     indexOfAccessToken);

  eAccessToken.Text := accessToken;
  VkApi.AccessToken := accessToken;

  mKeys.Lines.Clear;
  mKeys.Lines.Add('[Keys]');
  mKeys.Lines.Add('app_id=' + eAppId.Text);
  mKeys.Lines.Add('secret_key=' + eSecretKey.Text);
  mKeys.Lines.Add('access_token=' + eAccessToken.Text);
end;

end.
