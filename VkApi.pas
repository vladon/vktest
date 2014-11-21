unit VkApi;

interface

uses
  REST.Client;

type
  TVkApi = class
    private
      FAppId: string;
      FSecretKey: string;
      FAccessToken: string;
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
end;

destructor TVkApi.Destroy;
begin


  inherited Destroy;
end;

end.
