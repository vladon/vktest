unit VkApi;

interface

uses
  System.SysUtils, REST.Authenticator.OAuth, REST.Client, REST.Types, REST.Utils, System.Math;

// VK API constants
const
  VKAPI_BASE_URL = 'https://api.vk.com/method';
  VKAPI_ACCESS_TOKEN_PARAM_NAME = 'access_token';
  VKAPI_RESPONSE_TYPE = TOAuth2ResponseType.rtTOKEN;
  VKAPI_TOKEN_TYPE = TOAuth2TokenType.ttNONE;
  VKAPI_ACCEPT = 'text/html,application/xhtml+xml,application/' +
    'xml;q=0.9,*/*;q=0.8';
  VKAPI_FALLBACK_CHARSET_ENCODING = 'UTF-8';
  VKAPI_USERAGENT = 'Embarcadero RESTClient/1.0';
  VKAPI_ACCEPT_CHARSET = 'UTF-8, *;q=0.8';
  VKAPI_TIMEOUT = 30000;
  VKAPI_AUTHORIZATION_ENDPOINT = 'https://oauth.vk.com/authorize';
  VKAPI_REDIRECTION_ENDPOINT = 'https://oauth.vk.com/blank.html';

{ display parameter }
type
  TVkDisplayType = (dtPage, dtPopup, dtMobile);

function VkDisplayTypeToString(const ADisplayType: TVkDisplayType): string;

{ versions }
type
  TVkApiVersion = (av4_0, av4_1, av4_2, av4_3, av4_4, av4_5, av4_6, av4_7,
     av4_8, av4_9, av4_91, av4_92, av4_93, av4_94, av4_95, av4_96, av4_97,
     av4_98, av4_99, av4_100, av4_101, av4_102, av4_103, av4_104, av5_0, av5_1,
     av5_2, av5_3, av5_4, av5_5, av5_6, av5_7, av5_8, av5_9, av5_10, av5_11,
     av5_12, av5_13, av5_14, av5_15, av5_16, av5_17, av5_18, av5_19, av5_20,
     av5_21, av5_22, av5_23, av5_24, av5_25, av5_26);

const
  VKAPI_LAST_API_VERSION: TVkApiVersion = TVkApiVersion.av5_26;

const
  VKAPI_DEFAULT_API_VERSION: TVkApiVersion = TVkApiVersion.av5_26;

function VkApiVersionToString(const AApiVersion: TVkApiVersion): string;

type
  TVkAuthenticator = class(TOAuth2Authenticator)
    private
      FDisplay: TVkDisplayType;
      FApiVersion: TVkApiVersion;

      procedure SetDisplay(const Value: TVkDisplayType);
      procedure SetApiVersion(const Value: TVkApiVersion);
    public
      property Display: TVkDisplayType read FDisplay write SetDisplay;
      property ApiVersion: TVkApiVersion read FApiVersion write SetApiVersion;

      function AuthorizationRequestURI: string;
  end;

type
  TVkApi = class
    private
      FAppId: string;
      FSecretKey: string;
      FAccessToken: string;
      FVkAuthenticator: TVkAuthenticator;
      FRESTClient: TRESTClient;
      FRESTRequest: TRESTRequest;
      FRESTResponse: TRESTResponse;

      function GetScope: string;
      procedure SetScope(const Value: string);

      function GetDisplay: TVkDisplayType;
      procedure SetDisplay(const Value: TVkDisplayType);

      function GetApiVersion: TVkApiVersion;
      procedure SetApiVersion(const Value: TVkApiVersion);

      function GetAuthorizationRequestURI: string;

      procedure SetAccessToken(const Value: string);
    public
      property Scope: string read GetScope write SetScope;
      property Display: TVkDisplayType read GetDisplay write SetDisplay;
      property ApiVersion: TVkApiVersion read GetApiVersion write SetApiVersion;
      property AuthorizationRequestURI: string read GetAuthorizationRequestURI;
      property AccessToken: string read FAccessToken write SetAccessToken;

      constructor Create(const AAppId: string; const ASecretKey: string;
         const AAccessToken: string);
      destructor Destroy; override;

      function WallPost(const AOwnerId: Integer; const AMessage: string):
        Integer;

  end;

implementation

{ TVkApi }

constructor TVkApi.Create(const AAppId: string; const ASecretKey: string;
   const AAccessToken: string);
begin
  inherited Create;

  FAppId := AAppId;
  FSecretKey := ASecretKey;
  FAccessToken := AAccessToken;

  FVkAuthenticator := TVkAuthenticator.Create(nil);
  FRESTClient := TRESTClient.Create(VKAPI_BASE_URL);
  FRESTRequest := TRESTRequest.Create(nil);
  FRESTResponse := TRESTResponse.Create(nil);

  // Pre-init objects

  FVkAuthenticator.AccessTokenParamName := VKAPI_ACCESS_TOKEN_PARAM_NAME;
  FVkAuthenticator.ResponseType := VKAPI_RESPONSE_TYPE;
  FVkAuthenticator.TokenType := VKAPI_TOKEN_TYPE;
  FVkAuthenticator.AuthorizationEndpoint := VKAPI_AUTHORIZATION_ENDPOINT;
  FVkAuthenticator.RedirectionEndpoint := VKAPI_REDIRECTION_ENDPOINT;
  FVkAuthenticator.ClientID := FAppId;
  FVkAuthenticator.ClientSecret := FSecretKey;
  FVkAuthenticator.AccessToken := FAccessToken;

  FRESTClient.Accept := VKAPI_ACCEPT;
  FRESTClient.AllowCookies := True;
  FRESTClient.Authenticator := FVkAuthenticator;
  FRESTClient.FallbackCharsetEncoding := VKAPI_FALLBACK_CHARSET_ENCODING;
  FRESTClient.AutoCreateParams := True;
  FRESTClient.HandleRedirects := True;

  FRESTRequest.Accept := VKAPI_ACCEPT;
  FRESTRequest.AcceptCharset := VKAPI_ACCEPT_CHARSET;
  FRESTRequest.AutoCreateParams := True;
  FRESTRequest.Client := FRESTClient;
  FRESTRequest.HandleRedirects := True;
  FRESTRequest.Response := FRESTResponse;
  FRESTRequest.Timeout := VKAPI_TIMEOUT;
end;

destructor TVkApi.Destroy;
begin
  FRESTResponse.Free;
  FRESTRequest.Free;
  FRESTClient.Free;

  inherited Destroy;
end;

function TVkApi.GetApiVersion: TVkApiVersion;
begin
  Result := FVkAuthenticator.ApiVersion;
end;

function TVkApi.GetAuthorizationRequestURI: string;
begin
  if FVkAuthenticator <> nil then
    Result := FVkAuthenticator.AuthorizationRequestURI
  else
    Result := '';
end;

function TVkApi.GetDisplay: TVkDisplayType;
begin
  Result := FVkAuthenticator.Display;
end;

function TVkApi.GetScope: string;
begin
  if FVkAuthenticator <> nil then
    Result := FVkAuthenticator.Scope
  else
    Result := '';
end;

procedure TVkApi.SetAccessToken(const Value: string);
begin
  FAccessToken := Value;
  if FVkAuthenticator <> nil then
    FVkAuthenticator.AccessToken := Value;
end;

procedure TVkApi.SetApiVersion(const Value: TVkApiVersion);
begin
  if (Value <> FVkAuthenticator.ApiVersion) then
    FVkAuthenticator.ApiVersion := Value;
end;

procedure TVkApi.SetDisplay(const Value: TVkDisplayType);
begin
  if (Value <> FVkAuthenticator.Display) then
    FVkAuthenticator.Display := Value;
end;

procedure TVkApi.SetScope(const Value: string);
begin
  if FVkAuthenticator <> nil then
    FVkAuthenticator.Scope := Value;
end;

function TVkApi.WallPost(const AOwnerId: Integer;
  const AMessage: string): Integer;
begin
  FRESTRequest.Resource := 'wall.post';
  FRESTRequest.Method := TRESTRequestMethod.rmGET;
  FRESTRequest.Params.Clear;
  FRESTRequest.Params.AddItem('owner_id', IntToStr(AOwnerId));
  FRESTRequest.Params.AddItem('friends_only', '0');
  FRESTRequest.Params.AddItem('from_group', '1');
  FRESTRequest.Params.AddItem('message', AMessage);
  FRESTRequest.Execute;

  Result := 0;
end;

{ TVkAuthenticator }

function TVkAuthenticator.AuthorizationRequestURI: string;
begin
  Result := inherited AuthorizationRequestURI;

  Result := Result + '&display=' + URIEncode(VkDisplayTypeToString(
     FDisplay));

  Result := Result + '&v=' + URIEncode(VkApiVersionToString(FApiVersion));
end;

procedure TVkAuthenticator.SetApiVersion(const Value: TVkApiVersion);
begin
  if (Value <> FApiVersion) then
  begin
    FApiVersion := Value;
    PropertyValueChanged;
  end;
end;

procedure TVkAuthenticator.SetDisplay(const Value: TVkDisplayType);
begin
  if (Value <> FDisplay) then
  begin
    FDisplay := Value;
    PropertyValueChanged;
  end;
end;

{ functions }

function VkDisplayTypeToString(const ADisplayType: TVkDisplayType): string;
begin
  case ADisplayType of
    dtPage:
      Result := 'page'; // do not localize
    dtPopup:
      Result := 'popup'; // do not localize
    dtMobile:
      Result := 'mobile'; // do not localize
  else
    Result := ''; // do not localize
  end;
end;

function VkApiVersionToString(const AApiVersion: TVkApiVersion): string;
begin
  case AApiVersion of
    av4_0: Result := '4.0';
    av4_1: Result := '4.1';
    av4_2: Result := '4.2';
    av4_3: Result := '4.3';
    av4_4: Result := '4.4';
    av4_5: Result := '4.5';
    av4_6: Result := '4.6';
    av4_7: Result := '4.7';
    av4_8: Result := '4.8';
    av4_9: Result := '4.9';
    av4_91: Result := '4.91';
    av4_92: Result := '4.92';
    av4_93: Result := '4.93';
    av4_94: Result := '4.94';
    av4_95: Result := '4.95';
    av4_96: Result := '4.96';
    av4_97: Result := '4.97';
    av4_98: Result := '4.98';
    av4_99: Result := '4.99';
    av4_100: Result := '4.100';
    av4_101: Result := '4.101';
    av4_102: Result := '4.102';
    av4_103: Result := '4.103';
    av4_104: Result := '4.104';
    av5_0: Result := '5.0';
    av5_1: Result := '5.1';
    av5_2: Result := '5.2';
    av5_3: Result := '5.3';
    av5_4: Result := '5.4';
    av5_5: Result := '5.5';
    av5_6: Result := '5.6';
    av5_7: Result := '5.7';
    av5_8: Result := '5.8';
    av5_9: Result := '5.9';
    av5_10: Result := '5.10';
    av5_11: Result := '5.11';
    av5_12: Result := '5.12';
    av5_13: Result := '5.13';
    av5_14: Result := '5.14';
    av5_15: Result := '5.15';
    av5_16: Result := '5.16';
    av5_17: Result := '5.17';
    av5_18: Result := '5.18';
    av5_19: Result := '5.19';
    av5_20: Result := '5.20';
    av5_21: Result := '5.21';
    av5_22: Result := '5.22';
    av5_23: Result := '5.23';
    av5_24: Result := '5.24';
    av5_25: Result := '5.25';
    av5_26: Result := '5.26';
  else
    Result := '';
  end;
end;

end.
