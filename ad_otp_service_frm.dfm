object ADOTPService: TADOTPService
  DisplayName = 'AD OTP Service'
  BeforeInstall = ServiceBeforeInstall
  OnStart = ServiceStart
  Height = 600
  Width = 800
  PixelsPerInch = 120
  object Timer1: TTimer
    Enabled = False
    OnTimer = Timer1Timer
    Left = 30
    Top = 20
  end
  object FDConnection1: TFDConnection
    Params.Strings = (
      'LockingMode=Normal'
      'Password=ad_otp'
      'Encrypt=aes-256'
      'DriverID=SQLite')
    UpdateOptions.AssignedValues = [uvAutoCommitUpdates]
    UpdateOptions.AutoCommitUpdates = True
    LoginPrompt = False
    Left = 30
    Top = 90
  end
  object FDQuery1: TFDQuery
    Connection = FDConnection1
    SQL.Strings = (
      'Select * from USERS where flagEnabled=1')
    Left = 30
    Top = 160
  end
  object GLOBAL: TFDQuery
    Connection = FDConnection1
    SQL.Strings = (
      'Select * from GLOBAL')
    Left = 30
    Top = 230
  end
  object FDPhysSQLiteDriverLink1: TFDPhysSQLiteDriverLink
    EngineLinkage = slFDEStatic
    Left = 180
    Top = 90
  end
end
