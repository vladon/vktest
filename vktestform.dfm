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
    Width = 448
    Height = 21
    TabOrder = 3
  end
end
