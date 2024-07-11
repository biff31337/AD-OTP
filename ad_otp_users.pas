unit ad_otp_users;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, Data.DB, Vcl.Grids,
  Vcl.DBGrids, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.StdCtrls,
  Vcl.ExtCtrls, Vcl.Mask, Vcl.DBCtrls, DelphiZXingQRCode, Math, DateUtils, GoogleOTP;

type
  NetAPIStatus = Integer;
  TUserInfo_1003 = Packed Record
    Password : PWideChar;
  end;
  TForm3 = class(TForm)
    DataSource1: TDataSource;
    DBGrid1: TDBGrid;
    Panel1: TPanel;
    Button1: TButton;
    Button2: TButton;
    DBCheckBox1: TDBCheckBox;
    DBLabeledEdit1: TDBLabeledEdit;
    PaintBox1: TPaintBox;
    DBLabeledEdit2: TDBLabeledEdit;
    FDQuery1: TFDQuery;
    FDQuery2: TFDQuery;
    Button4: TButton;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure PaintBox1Paint(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure FDQuery1AfterScroll(DataSet: TDataSet);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
    QRCodeBitmap: TBitmap;
  public
  end;

var
  Form3: TForm3;
  Param_Err : DWORD;
  Function NetUserSetInfo(ServerName, UserName : PWideChar; Level : Integer; Const Buf : Pointer; Var Parm_Err : DWORD) : NetAPIStatus; StdCall; External 'NETAPI32.DLL';

implementation

{$R *.dfm}

uses ad_otp_main;

function RoundToNearest(TheDateTime,TheRoundStep:TDateTime):TdateTime;
begin
  if 0=TheRoundStep then begin
    RoundToNearest:=TheDateTime;
  end else begin
    RoundToNearest:=Ceil(TheDateTime/TheRoundStep)*TheRoundStep;
  end;
end;

procedure TForm3.Button1Click(Sender: TObject);
begin
  FDQuery2.Open('Insert into USERS (Login,flagEnabled,Secret) Values (''*user*'',0,:s);SELECT last_insert_rowid() ID;',[GenerateOTPSecret()]);
  FDQuery1.Refresh;
  FDQuery1.Locate('ID',FDQuery2.FindField('ID').AsInteger,[]);
end;

procedure TForm3.Button2Click(Sender: TObject);
begin
  FDQuery1.Delete;
end;

procedure TForm3.Button4Click(Sender: TObject);
var res:integer;
    UI1003:TUserInfo_1003;
    BufPassword:Array[0..255] Of WideChar;
begin
  StringToWideChar(FDQuery1.FindField('Password').AsString,BufPassword,Length(BufPassword));
  UI1003.Password:=@BufPassword;
  Res:=NetUserSetInfo(PWideChar(WideString(Form1.GLOBAL.FindField('Server').AsString)),PWideChar(WideString(FDQuery1.FindField('Login').AsString)),1003,@UI1003,Param_Err);
  if res<>0 then ShowMessage(SysErrorMessage(res));
end;

procedure TForm3.FDQuery1AfterScroll(DataSet: TDataSet);
var QRCode: TDelphiZXingQRCode;
    Row, Column: Integer;
begin
  Form1.GLOBAL.Refresh;
  QRCode := TDelphiZXingQRCode.Create;
  try
    QRCode.Data := 'otpauth://totp/'+FDQuery1.findfield('Login').asstring+'@'+Form1.GLOBAL.FindField('Domain').AsString+'?secret='+FDQuery1.findfield('Secret').asstring+'&issuer=ADOTP';
    QRCode.Encoding := TQRCodeEncoding(0);
    QRCode.QuietZone := 4;
    QRCodeBitmap.SetSize(QRCode.Rows, QRCode.Columns);
    for Row := 0 to QRCode.Rows - 1 do begin
      for Column := 0 to QRCode.Columns - 1 do begin
        if (QRCode.IsBlack[Row, Column]) then begin
          QRCodeBitmap.Canvas.Pixels[Column, Row] := clBlack;
        end else begin
          QRCodeBitmap.Canvas.Pixels[Column, Row] := clWhite;
        end;
      end;
    end;
  finally
    QRCode.Free;
  end;
  PaintBox1.Repaint;
end;

procedure TForm3.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  FreeAndNil(QRCodeBitmap);
  Action := caFree;
end;

procedure TForm3.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  if FDQuery1.RecordCount>0 then begin
    FDQuery1.Edit;
    FDQuery1.Post;
  end;
end;

procedure TForm3.FormCreate(Sender: TObject);
begin
  QRCodeBitmap := TBitmap.Create;
  FDQuery1.active:=true;
end;

procedure TForm3.PaintBox1Paint(Sender: TObject);
var Scale: Double;
begin
  PaintBox1.Canvas.Brush.Color := clWhite;
  PaintBox1.Canvas.FillRect(Rect(0, 0, PaintBox1.Width, PaintBox1.Height));
  if ((QRCodeBitmap.Width > 0) and (QRCodeBitmap.Height > 0)) then begin
    if (PaintBox1.Width < PaintBox1.Height) then begin
      Scale := PaintBox1.Width / QRCodeBitmap.Width;
    end else begin
      Scale := PaintBox1.Height / QRCodeBitmap.Height;
    end;
    PaintBox1.Canvas.StretchDraw(Rect(0, 0, Trunc(Scale * QRCodeBitmap.Width), Trunc(Scale * QRCodeBitmap.Height)), QRCodeBitmap);
  end;
end;

end.
