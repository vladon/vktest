object fGetKeys: TfGetKeys
  Left = 0
  Top = 0
  Caption = 'Get Keys'
  ClientHeight = 359
  ClientWidth = 527
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 11
    Width = 33
    Height = 13
    Caption = 'AppId:'
  end
  object Label2: TLabel
    Left = 8
    Top = 38
    Width = 56
    Height = 13
    Caption = 'Secret Key:'
  end
  object Label3: TLabel
    Left = 8
    Top = 65
    Width = 33
    Height = 13
    Caption = 'Scope:'
  end
  object eAppId: TEdit
    Left = 70
    Top = 8
    Width = 449
    Height = 21
    TabOrder = 0
  end
  object eSecretKey: TEdit
    Left = 70
    Top = 35
    Width = 449
    Height = 21
    TabOrder = 1
  end
  object bLogin: TButton
    Left = 70
    Top = 89
    Width = 75
    Height = 25
    Caption = 'Login'
    TabOrder = 2
    OnClick = bLoginClick
  end
  object eAccessToken: TEdit
    Left = 70
    Top = 120
    Width = 449
    Height = 21
    ReadOnly = True
    TabOrder = 3
  end
  object eScope: TEdit
    Left = 70
    Top = 62
    Width = 449
    Height = 21
    TabOrder = 4
  end
  object mKeys: TMemo
    Left = 70
    Top = 147
    Width = 449
    Height = 204
    TabOrder = 5
  end
end
