object fMain: TfMain
  Left = 0
  Top = 0
  Caption = #25480#26435#31649#29702#31995#32479
  ClientHeight = 762
  ClientWidth = 1078
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
    Width = 1078
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
    Width = 1078
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
  object Page1: TPageControl
    Left = 0
    Top = 36
    Width = 1078
    Height = 707
    ActivePage = tsAuthEdit
    Align = alClient
    TabOrder = 2
    object tsAuth: TTabSheet
      Caption = #25480#26435#26597#35810
      object Grid1: TDBGrid
        Left = 0
        Top = 0
        Width = 1070
        Height = 679
        Align = alClient
        DataSource = DM.ds1
        TabOrder = 0
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'Tahoma'
        TitleFont.Style = []
      end
    end
    object tsService: TTabSheet
      Caption = #26381#21153#31649#29702
      ImageIndex = 1
      object lbState: TLabel
        Left = 24
        Top = 80
        Width = 29
        Height = 13
        Caption = 'state:'
      end
      object btnReboot: TBitBtn
        Left = 12
        Top = 12
        Width = 75
        Height = 25
        Caption = #37325#21551#30005#33041
        TabOrder = 0
        OnClick = btnRebootClick
      end
      object btnStartService: TBitBtn
        Left = 96
        Top = 12
        Width = 75
        Height = 25
        Caption = #21551#21160#26381#21153
        TabOrder = 1
        OnClick = btnStartServiceClick
      end
      object btnStopService: TBitBtn
        Left = 177
        Top = 12
        Width = 75
        Height = 25
        Caption = #20572#27490#26381#21153
        TabOrder = 2
        OnClick = btnStopServiceClick
      end
      object btnRestartService: TBitBtn
        Left = 262
        Top = 12
        Width = 75
        Height = 25
        Caption = #37325#21551#26381#21153
        TabOrder = 3
        OnClick = btnRestartServiceClick
      end
      object btnStartDUmeter: TBitBtn
        Left = 450
        Top = 12
        Width = 100
        Height = 25
        Caption = #21551#21160#27969#37327#30417#35270#22120
        TabOrder = 4
        OnClick = btnStartDUmeterClick
      end
      object btnStartPerfmon: TBitBtn
        Left = 342
        Top = 12
        Width = 100
        Height = 25
        Caption = #21551#21160#24615#33021#30417#35270#22120
        TabOrder = 5
        OnClick = btnStartPerfmonClick
      end
      object btnStartTaskmgr: TBitBtn
        Left = 554
        Top = 12
        Width = 100
        Height = 25
        Caption = #21551#21160#20219#21153#31649#29702#22120
        TabOrder = 6
        OnClick = btnStartTaskmgrClick
      end
      object btnQueryService: TBitBtn
        Left = 659
        Top = 12
        Width = 100
        Height = 25
        Caption = #26597#35810#26381#21153#29366#24577
        TabOrder = 7
        OnClick = btnQueryServiceClick
      end
    end
    object tsApp: TTabSheet
      Caption = 'APP'#31649#29702
      ImageIndex = 2
      object DBGrid1: TDBGrid
        Left = 0
        Top = 0
        Width = 1070
        Height = 679
        Align = alClient
        DataSource = DM.dsApp
        TabOrder = 0
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'Tahoma'
        TitleFont.Style = []
      end
    end
    object tsAuthEdit: TTabSheet
      Caption = #25480#26435#31649#29702
      ImageIndex = 3
      object DBGrid2: TDBGrid
        Left = 0
        Top = 0
        Width = 1070
        Height = 679
        Align = alClient
        DataSource = DM.dsAuthEdit
        TabOrder = 0
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'Tahoma'
        TitleFont.Style = []
      end
    end
  end
end
