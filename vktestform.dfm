object MainForm: TMainForm
  Left = 0
  Top = 0
  Caption = 'Main Form'
  ClientHeight = 552
  ClientWidth = 835
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object btLogin: TButton
    Left = 8
    Top = 35
    Width = 75
    Height = 25
    Caption = 'Login'
    TabOrder = 0
    OnClick = btLoginClick
  end
  object eAppId: TEdit
    Left = 8
    Top = 8
    Width = 121
    Height = 21
    TabOrder = 1
  end
  object eSecretKey: TEdit
    Left = 135
    Top = 8
    Width = 321
    Height = 21
    TabOrder = 2
  end
  object eAccessToken: TEdit
    Left = 8
    Top = 66
    Width = 793
    Height = 21
    TabOrder = 3
  end
  object btSetOffline: TButton
    Left = 8
    Top = 136
    Width = 75
    Height = 25
    Caption = 'Set Offline'
    TabOrder = 4
    OnClick = btSetOfflineClick
  end
  object RESTClient1: TRESTClient
    Authenticator = OAuth2Authenticator1
    Accept = 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8'
    BaseURL = 'https://api.vk.com/method'
    Params = <>
    HandleRedirects = True
    Left = 368
    Top = 160
  end
  object RESTRequest1: TRESTRequest
    Client = RESTClient1
    Params = <>
    Response = RESTResponse1
    SynchronizedEvents = False
    Left = 376
    Top = 224
  end
  object RESTResponse1: TRESTResponse
    Left = 464
    Top = 224
  end
  object OAuth2Authenticator1: TOAuth2Authenticator
    Left = 368
    Top = 104
  end
end
