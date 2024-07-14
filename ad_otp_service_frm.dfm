object ADOTPService: TADOTPService
  DisplayName = 'AD OTP Service'
  BeforeInstall = ServiceBeforeInstall
  OnStart = ServiceStart
  Height = 480
  Width = 640
  object Timer1: TTimer
    Enabled = False
    OnTimer = Timer1Timer
    Left = 24
    Top = 16
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
    Left = 24
    Top = 72
  end
  object FDQuery1: TFDQuery
    Connection = FDConnection1
    SQL.Strings = (
      'Select * from USERS where flagEnabled=1')
    Left = 24
    Top = 128
  end
  object GLOBAL: TFDQuery
    Connection = FDConnection1
    SQL.Strings = (
      'Select * from GLOBAL')
    Left = 24
    Top = 184
  end
  object FDPhysSQLiteDriverLink1: TFDPhysSQLiteDriverLink
    EngineLinkage = slFDEStatic
    Left = 144
    Top = 72
  end
end
