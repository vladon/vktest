object MainForm: TMainForm
  Left = 0
  Top = 0
  Caption = 'Main Form'
  ClientHeight = 552
  ClientWidth = 1050
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
    Text = '81144272'
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
    OnClick = bPostTextToGroupClick
  end
  object Memo1: TMemo
    Left = 187
    Top = 181
    Width = 318
    Height = 348
    TabOrder = 8
  end
  object Button1: TButton
    Left = 8
    Top = 266
    Width = 173
    Height = 25
    Caption = 'Button1'
    TabOrder = 9
    OnClick = Button1Click
  end
  object bGetWallUploadServer: TButton
    Left = 511
    Top = 179
    Width = 290
    Height = 25
    Caption = 'bGetWallUploadServer'
    TabOrder = 10
    OnClick = bGetWallUploadServerClick
  end
  object bUploadFile: TButton
    Left = 511
    Top = 264
    Width = 290
    Height = 25
    Caption = 'bUploadFile'
    TabOrder = 11
    OnClick = bUploadFileClick
  end
  object eUploadUrl: TEdit
    Left = 511
    Top = 210
    Width = 290
    Height = 21
    TabOrder = 12
    Text = 'eUploadUrl'
  end
  object eFilename: TEdit
    Left = 511
    Top = 237
    Width = 290
    Height = 21
    TabOrder = 13
    Text = 'testimage.jpg'
  end
  object bSaveWallPhoto: TButton
    Left = 511
    Top = 428
    Width = 290
    Height = 25
    Caption = 'bSaveWallPhoto'
    TabOrder = 14
    OnClick = bSaveWallPhotoClick
  end
  object eUserId: TEdit
    Left = 511
    Top = 320
    Width = 121
    Height = 21
    TabOrder = 15
    Text = 'eUserId'
  end
  object ePhoto: TEdit
    Left = 511
    Top = 347
    Width = 121
    Height = 21
    TabOrder = 16
    Text = 'ePhoto'
  end
  object eServer: TEdit
    Left = 511
    Top = 374
    Width = 121
    Height = 21
    TabOrder = 17
    Text = 'eServer'
  end
  object eHash: TEdit
    Left = 511
    Top = 401
    Width = 121
    Height = 21
    TabOrder = 18
    Text = 'eHash'
  end
  object eAlbumId: TEdit
    Left = 511
    Top = 293
    Width = 121
    Height = 21
    TabOrder = 19
    Text = 'eAlbumId'
  end
  object eMessage: TEdit
    Left = 839
    Top = 401
    Width = 121
    Height = 21
    TabOrder = 20
    Text = 'eMessage'
  end
  object bWallPost: TButton
    Left = 839
    Top = 428
    Width = 130
    Height = 25
    Caption = 'bWallPost'
    TabOrder = 21
    OnClick = bWallPostClick
  end
  object ePhotoId: TEdit
    Left = 839
    Top = 374
    Width = 121
    Height = 21
    TabOrder = 22
    Text = 'ePhotoId'
  end
  object eOwnerId: TEdit
    Left = 839
    Top = 347
    Width = 121
    Height = 21
    TabOrder = 23
    Text = 'eOwnerId'
  end
end
