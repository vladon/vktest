program vktest;

uses
  Vcl.Forms,
  vktestform in 'vktestform.pas' {MainForm},
  browserform in 'browserform.pas' {WebBrowserForm},
  VkApi in '..\vkapi\VkApi.pas',
  VkApi.Photo in '..\vkapi\VkApi.Photo.pas',
  VkApi.Utils in '..\vkapi\VkApi.Utils.pas',
  VkApi.Authenticator in '..\vkapi\VkApi.Authenticator.pas',
  VkApi.Types in '..\vkapi\VkApi.Types.pas',
  VkApi.Constants in '..\vkapi\VkApi.Constants.pas',
  VkApi.Exception in '..\vkapi\VkApi.Exception.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TWebBrowserForm, WebBrowserForm);
  Application.Run;
end.
