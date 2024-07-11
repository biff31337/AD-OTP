object Form2: TForm2
  Left = 0
  Top = 0
  Caption = 'Global Settings'
  ClientHeight = 158
  ClientWidth = 520
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  FormStyle = fsMDIChild
  Position = poMainFormCenter
  Visible = True
  OnClose = FormClose
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  TextHeight = 15
  object DBLabeledEdit1: TDBLabeledEdit
    Left = 16
    Top = 24
    Width = 305
    Height = 23
    DataField = 'Server'
    DataSource = DataSource1
    TabOrder = 0
    EditLabel.Width = 78
    EditLabel.Height = 15
    EditLabel.Caption = 'AD Server or IP'
  end
  object Panel1: TPanel
    Left = 425
    Top = 0
    Width = 95
    Height = 158
    Align = alRight
    BevelOuter = bvNone
    TabOrder = 3
    ExplicitLeft = 858
    ExplicitHeight = 632
    object Button1: TButton
      Left = 0
      Top = 3
      Width = 89
      Height = 25
      Caption = 'Install Service'
      TabOrder = 0
      OnClick = Button1Click
    end
    object Button2: TButton
      Left = 0
      Top = 34
      Width = 89
      Height = 25
      Caption = 'Remove Service'
      TabOrder = 1
      OnClick = Button2Click
    end
    object Button3: TButton
      Left = 0
      Top = 65
      Width = 89
      Height = 25
      Caption = 'Show log'
      TabOrder = 2
      OnClick = Button3Click
    end
  end
  object DBLabeledEdit2: TDBLabeledEdit
    Left = 16
    Top = 72
    Width = 305
    Height = 23
    DataField = 'Domain'
    DataSource = DataSource1
    TabOrder = 1
    EditLabel.Width = 42
    EditLabel.Height = 15
    EditLabel.Caption = 'Domain'
  end
  object DBLabeledEdit3: TDBLabeledEdit
    Left = 16
    Top = 120
    Width = 305
    Height = 23
    DataField = 'Login'
    DataSource = DataSource1
    TabOrder = 2
    EditLabel.Width = 83
    EditLabel.Height = 15
    EditLabel.Caption = 'Login of service'
  end
  object FDQuery1: TFDQuery
    Connection = Form1.FDConnection1
    UpdateOptions.AssignedValues = [uvEInsert]
    UpdateOptions.EnableInsert = False
    UpdateOptions.KeyFields = 'ID'
    SQL.Strings = (
      'Select * from GLOBAL')
    Left = 584
    Top = 16
  end
  object DataSource1: TDataSource
    DataSet = FDQuery1
    Left = 656
    Top = 16
  end
end
