program GetKeys;

uses
  Vcl.Forms,
  GetKeysForm in 'GetKeysForm.pas' {fGetKeys},
  browserform in 'browserform.pas' {WebBrowserForm};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfGetKeys, fGetKeys);
  Application.CreateForm(TWebBrowserForm, WebBrowserForm);
  Application.Run;
end.
