object fMain: TfMain
  Left = 0
  Top = 0
  Caption = #25480#26435#31649#29702#31995#32479
  ClientHeight = 762
  ClientWidth = 784
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 784
    Height = 36
    Align = alTop
    TabOrder = 0
    object btnBrush: TBitBtn
      Left = 4
      Top = 4
      Width = 75
      Height = 25
      Caption = #21047#26032
      TabOrder = 0
      OnClick = btnBrushClick
    end
    object btnCreateCode: TBitBtn
      Left = 89
      Top = 4
      Width = 75
      Height = 25
      Caption = #25480#26435#30721
      TabOrder = 1
      OnClick = btnCreateCodeClick
    end
  end
  object Bar1: TStatusBar
    Left = 0
    Top = 743
    Width = 784
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
  object Grid1: TDBGrid
    Left = 0
    Top = 36
    Width = 784
    Height = 707
    Align = alClient
    DataSource = DM.ds1
    TabOrder = 2
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
  end
end