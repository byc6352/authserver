object fauthCode: TfauthCode
  Left = 0
  Top = 0
  Caption = 'fauthCode'
  ClientHeight = 634
  ClientWidth = 635
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object memCode: TMemo
    Left = 0
    Top = 29
    Width = 635
    Height = 586
    Align = alClient
    TabOrder = 0
  end
  object ToolBar1: TToolBar
    Left = 0
    Top = 0
    Width = 635
    Height = 29
    ButtonHeight = 24
    Caption = 'ToolBar1'
    TabOrder = 1
    object Label1: TLabel
      Left = 0
      Top = 0
      Width = 36
      Height = 24
      Caption = #26631#35782#65306
    end
    object edtAppID: TEdit
      Left = 36
      Top = 0
      Width = 60
      Height = 24
      TabOrder = 0
      Text = 'ca'
    end
    object Label2: TLabel
      Left = 96
      Top = 0
      Width = 68
      Height = 24
      Caption = #26102#38271'('#23567#26102')'#65306
    end
    object edtLength: TEdit
      Left = 164
      Top = 0
      Width = 60
      Height = 24
      TabOrder = 1
      Text = '720'
    end
    object Label3: TLabel
      Left = 224
      Top = 0
      Width = 36
      Height = 24
      Caption = #25968#37327#65306
    end
    object edtCount: TEdit
      Left = 260
      Top = 0
      Width = 60
      Height = 24
      TabOrder = 2
      Text = '10'
    end
    object btnCreateCode: TBitBtn
      Left = 320
      Top = 0
      Width = 75
      Height = 24
      Caption = #29983#25104
      TabOrder = 3
      OnClick = btnCreateCodeClick
    end
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 615
    Width = 635
    Height = 19
    Panels = <
      item
        Width = 200
      end
      item
        Width = 200
      end
      item
        Width = 50
      end>
  end
end
