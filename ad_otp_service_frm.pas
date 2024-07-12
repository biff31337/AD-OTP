unit ad_otp_service_frm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.SvcMgr, Vcl.Dialogs,
  Vcl.ExtCtrls, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error,
  FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool,
  FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.SQLite, FireDAC.Phys.SQLiteDef,
  FireDAC.Stan.ExprFuncs, FireDAC.Phys.SQLiteWrapper.Stat, FireDAC.VCLUI.Wait,
  Data.DB, FireDAC.Comp.Client, System.IOUtils, FireDAC.Stan.Param,
  FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt, FireDAC.Comp.DataSet,
  DateUtils, Math, GoogleOTP, FireDAC.Phys.SQLiteWrapper.FDEStat;

type
  NetAPIStatus = Integer;
  TUserInfo_1003 = Packed Record
    Password : PWideChar;
  end;
  TADOTPService = class(TService)
    Timer1: TTimer;
    FDConnection1: TFDConnection;
    FDQuery1: TFDQuery;
    GLOBAL: TFDQuery;
    FDPhysSQLiteDriverLink1: TFDPhysSQLiteDriverLink;
    procedure ServiceStart(Sender: TService; var Started: Boolean);
    procedure Timer1Timer(Sender: TObject);
    procedure ServiceBeforeInstall(Sender: TService);
  private
  public
    function GetServiceController: TServiceController; override;
  end;

var
  ADOTPService: TADOTPService;
  Param_Err : DWORD;
  Function NetUserSetInfo(ServerName, UserName : PWideChar; Level : Integer; Const Buf : Pointer; Var Parm_Err : DWORD) : NetAPIStatus; StdCall; External 'NETAPI32.DLL';


implementation

{$R *.dfm}

function WriteLog(LogString: String): Integer;
var
  f: TextFile;
begin
{$IOChecks OFF}
  AssignFile(f, TPath.GetPublicPath()+'\ad_otp\ao_otp.log');
  if FileExists(TPath.GetPublicPath()+'\ad_otp\ao_otp.log') then
    Append(f)
  else
    Rewrite(f);
  Writeln(f, LogString);
  CloseFile(f);
  result := GetLastError();
{$IOCHECKS ON}
end;

function RoundToNearest(TheDateTime,TheRoundStep:TDateTime):TdateTime;
begin
  if 0=TheRoundStep then begin
    RoundToNearest:=TheDateTime;
  end else begin
    RoundToNearest:=Ceil(TheDateTime/TheRoundStep)*TheRoundStep;
  end;
end;

procedure ServiceController(CtrlCode: DWord); stdcall;
begin
  ADOTPService.Controller(CtrlCode);
end;

function TADOTPService.GetServiceController: TServiceController;
begin
  Result := ServiceController;
end;

procedure TADOTPService.ServiceBeforeInstall(Sender: TService);
begin
  self.ServiceStartName:=paramstr(2);
  self.Password:=paramstr(3);
end;

procedure TADOTPService.ServiceStart(Sender: TService; var Started: Boolean);
begin
  if FileExists(TPath.GetPublicPath()+'\ad_otp\ao_otp.log') then DeleteFile(TPath.GetPublicPath()+'\ad_otp\ao_otp.log');
  WriteLog(FormatDateTime('hh:nn:ss.zzz',now)+' Start.');
  FDConnection1.Params.Values['database'] := TPath.GetPublicPath()+'\ad_otp\ad_otp.sdb';
  Timer1.Interval:=1;
  Timer1.Enabled:=true;
end;

procedure TADOTPService.Timer1Timer(Sender: TObject);
var res:integer;
    UI1003:TUserInfo_1003;
    BufPassword:Array[0..255] Of WideChar;
begin
  Timer1.Enabled:=false;
  try
    FDConnection1.Connected:=true;
    FDQuery1.Open();
    GLOBAL.Open();
    while FDQuery1.eof=false do begin
      StringToWideChar(FDQuery1.FindField('Password').AsString+FormatFloat('000000',CalculateOTP(FDQuery1.findfield('Secret').asstring)),BufPassword,Length(BufPassword));
      UI1003.Password:=@BufPassword;
      Res:=NetUserSetInfo(PWideChar(WideString(GLOBAL.FindField('Server').AsString)),PWideChar(WideString(FDQuery1.FindField('Login').AsString)),1003,@UI1003,Param_Err);
      if res<>0 then WriteLog(FormatDateTime('hh:nn:ss.zzz',now)+' '+SysErrorMessage(res));
      FDQuery1.Next;
    end;
    FDConnection1.Connected:=false;
  except
    on E: Exception do begin
      WriteLog(FormatDateTime('hh:nn:ss.zzz',now)+' '+E.ClassName+': '+E.Message);
    end;
  end;
  Timer1.Interval:=100+MilliSecondsBetween(now,RoundToNearest(now,EncodeTime(0,0,30,00)));
  Timer1.Enabled:=true;
end;

end.
