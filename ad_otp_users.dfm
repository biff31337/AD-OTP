object Form3: TForm3
  Left = 0
  Top = 0
  Caption = 'User configuration'
  ClientHeight = 632
  ClientWidth = 1041
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
  DesignSize = (
    1041
    632)
  TextHeight = 15
  object PaintBox1: TPaintBox
    Left = 272
    Top = 122
    Width = 232
    Height = 250
    Anchors = [akLeft, akTop, akRight, akBottom]
    OnPaint = PaintBox1Paint
  end
  object DBGrid1: TDBGrid
    AlignWithMargins = True
    Left = 3
    Top = 3
    Width = 254
    Height = 626
    Align = alLeft
    DataSource = DataSource1
    TabOrder = 3
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -12
    TitleFont.Name = 'Segoe UI'
    TitleFont.Style = []
    Columns = <
      item
        Expanded = False
        FieldName = 'Login'
        Width = 164
        Visible = True
      end>
  end
  object Panel1: TPanel
    Left = 946
    Top = 0
    Width = 95
    Height = 632
    Align = alRight
    BevelOuter = bvNone
    TabOrder = 4
    object Button1: TButton
      Left = 0
      Top = 3
      Width = 89
      Height = 25
      Caption = 'Create'
      TabOrder = 0
      OnClick = Button1Click
    end
    object Button2: TButton
      Left = 0
      Top = 34
      Width = 89
      Height = 25
      Caption = 'Delete'
      TabOrder = 1
      OnClick = Button2Click
    end
    object Button4: TButton
      Left = 0
      Top = 65
      Width = 89
      Height = 25
      Caption = 'Set Password'
      TabOrder = 2
      OnClick = Button4Click
    end
  end
  object DBCheckBox1: TDBCheckBox
    Left = 272
    Top = 99
    Width = 97
    Height = 17
    Caption = 'Activated'
    DataField = 'flagEnabled'
    DataSource = DataSource1
    TabOrder = 2
  end
  object DBLabeledEdit1: TDBLabeledEdit
    Left = 272
    Top = 24
    Width = 305
    Height = 23
    DataField = 'Login'
    DataSource = DataSource1
    TabOrder = 0
    EditLabel.Width = 53
    EditLabel.Height = 15
    EditLabel.Caption = 'Username'
  end
  object DBLabeledEdit2: TDBLabeledEdit
    Left = 272
    Top = 70
    Width = 305
    Height = 23
    DataField = 'Password'
    DataSource = DataSource1
    PasswordChar = '*'
    TabOrder = 1
    EditLabel.Width = 50
    EditLabel.Height = 15
    EditLabel.Caption = 'Password'
  end
  object DataSource1: TDataSource
    DataSet = FDQuery1
    Left = 96
    Top = 56
  end
  object FDQuery1: TFDQuery
    AfterScroll = FDQuery1AfterScroll
    Connection = Form1.FDConnection1
    UpdateOptions.AssignedValues = [uvEInsert]
    UpdateOptions.EnableInsert = False
    UpdateOptions.KeyFields = 'ID'
    SQL.Strings = (
      'Select * from USERS')
    Left = 24
    Top = 56
  end
  object FDQuery2: TFDQuery
    Connection = Form1.FDConnection1
    UpdateOptions.KeyFields = 'ID'
    SQL.Strings = (
      'Select * from USERS')
    Left = 24
    Top = 112
  end
end
