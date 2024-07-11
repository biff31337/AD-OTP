object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'AD OTP'
  ClientHeight = 868
  ClientWidth = 1457
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  FormStyle = fsMDIForm
  VisualManager = FormTabsBar1
  Menu = MainMenu1
  Position = poMainFormCenter
  OnCreate = FormCreate
  TextHeight = 15
  object FormTabsBar1: TFormTabsBar
    Left = 0
    Top = 0
    Width = 1457
    Height = 30
    ParentColor = False
    TabOptions.ShowFormSystemMenu = True
    TabOptions.ShowCloseButton = True
    TabOptions.ShowHintForTruncatedCaption = True
    TabMinWidth = 100
    TabMaxWidth = 250
    ShowTabsMenuButton = True
  end
  object MainMenu1: TMainMenu
    Left = 256
    Top = 8
    object File1: TMenuItem
      Caption = 'File'
      object File2: TMenuItem
        Caption = 'Quit'
        OnClick = File2Click
      end
    end
    object Configuration1: TMenuItem
      Caption = 'Configuration'
      object Userconfiguration1: TMenuItem
        Caption = 'User configuration'
        OnClick = Userconfiguration1Click
      end
      object GlobalSettings1: TMenuItem
        Caption = 'Global Settings'
        OnClick = GlobalSettings1Click
      end
    end
    object Info1: TMenuItem
      Caption = 'Info'
      OnClick = Info1Click
    end
  end
  object FDConnection1: TFDConnection
    Params.Strings = (
      'DriverID=SQLite'
      'LockingMode=Normal')
    UpdateOptions.AssignedValues = [uvAutoCommitUpdates]
    UpdateOptions.AutoCommitUpdates = True
    Connected = True
    LoginPrompt = False
    Left = 256
    Top = 88
  end
  object FDCommand1: TFDCommand
    Connection = FDConnection1
    Left = 348
    Top = 88
  end
  object GLOBAL: TFDQuery
    Connection = FDConnection1
    UpdateOptions.KeyFields = 'ID'
    SQL.Strings = (
      'Select * from GLOBAL')
    Left = 256
    Top = 144
  end
  object FDPhysSQLiteDriverLink1: TFDPhysSQLiteDriverLink
    EngineLinkage = slFDEStatic
    Left = 136
    Top = 88
  end
end
