program vktest;

uses
  Vcl.Forms,
  vktestform in 'vktestform.pas' {MainForm},
  browserform in 'browserform.pas' {WebBrowserForm};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TWebBrowserForm, WebBrowserForm);
  Application.Run;
end.
