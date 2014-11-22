unit VkApi;

interface

uses
  REST.Authenticator.OAuth, REST.Client, REST.Types;

// VK API constants
const
  VKAPI_BASE_URL = 'https://api.vk.com/method';
  VKAPI_ACCESS_TOKEN_PARAM_NAME = 'access_token';
  VKAPI_RESPONSE_TYPE = TOAuth2ResponseType.rtCODE;
  VKAPI_TOKEN_TYPE = TOAuth2TokenType.ttNONE;
  VKAPI_ACCEPT = 'text/html,application/xhtml+xml,application/' +
    'xml;q=0.9,*/*;q=0.8';
  VKAPI_FALLBACK_CHARSET_ENCODING = 'UTF-8';
  VKAPI_USERAGENT = 'Embarcadero RESTClient/1.0';
  VKAPI_ACCEPT_CHARSET = 'UTF-8, *;q=0.8';
  VKAPI_TIMEOUT = 30000;


type
  TVkApi = class
    private
      FAppId: string;
      FSecretKey: string;
      FAccessToken: string;
      FOAuth2Authenticator: TOAuth2Authenticator;
      FRESTClient: TRESTClient;
      FRESTRequest: TRESTRequest;
      FRESTResponse: TRESTResponse;
    public
      constructor Create(const AAppId: string; ASecretKey: string;
         AAccessToken: string);
      destructor Destroy; override;
  end;

implementation

{ TVkApi }

constructor TVkApi.Create(const AAppId: string; ASecretKey,
  AAccessToken: string);
begin
  inherited Create;

  FAppId := AAppId;
  FSecretKey := ASecretKey;
  FAccessToken := AAccessToken;

  FOAuth2Authenticator := TOAuth2Authenticator.Create(nil);
  FRESTClient := TRESTClient.Create(VKAPI_BASE_URL);
  FRESTRequest := TRESTRequest.Create(nil);
  FRESTResponse := TRESTResponse.Create(nil);

  // Pre-init objects

  FOAuth2Authenticator.AccessTokenParamName := VKAPI_ACCESS_TOKEN_PARAM_NAME;
  FOAuth2Authenticator.ResponseType := VKAPI_RESPONSE_TYPE;
  FOAuth2Authenticator.TokenType := VKAPI_TOKEN_TYPE;

  FRESTClient.Accept := VKAPI_ACCEPT;
  FRESTClient.AllowCookies := True;
  FRESTClient.Authenticator := FOAuth2Authenticator;
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

end.
