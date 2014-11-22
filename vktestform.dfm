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
  object Label1: TLabel
    Left = 8
    Top = 184
    Width = 46
    Height = 13
    Caption = 'Group Id:'
  end
  object Label2: TLabel
    Left = 8
    Top = 211
    Width = 50
    Height = 13
    Caption = 'Post Text:'
  end
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
    Top = 112
    Width = 75
    Height = 25
    Caption = 'Set Offline'
    TabOrder = 4
    OnClick = btSetOfflineClick
  end
  object eGroupId: TEdit
    Left = 60
    Top = 181
    Width = 121
    Height = 21
    TabOrder = 5
  end
  object ePostText: TEdit
    Left = 60
    Top = 208
    Width = 121
    Height = 21
    TabOrder = 6
  end
  object bPostTextToGroup: TButton
    Left = 8
    Top = 235
    Width = 173
    Height = 25
    Caption = 'Post Text To Group'
    TabOrder = 7
  end
end
