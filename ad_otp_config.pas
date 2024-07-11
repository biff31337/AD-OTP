unit ad_otp_config;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, Data.DB,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.StdCtrls, Vcl.Mask,
  Vcl.ExtCtrls, Vcl.DBCtrls, IOUtils;

type
  TForm2 = class(TForm)
    FDQuery1: TFDQuery;
    DataSource1: TDataSource;
    DBLabeledEdit1: TDBLabeledEdit;
    Panel1: TPanel;
    Button1: TButton;
    DBLabeledEdit2: TDBLabeledEdit;
    DBLabeledEdit3: TDBLabeledEdit;
    Button2: TButton;
    Button3: TButton;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure Button3Click(Sender: TObject);
  private
  public
  end;

var
  Form2: TForm2;

implementation

{$R *.dfm}

procedure ExecuteAndWait(const aCommando: string);
var
  tmpStartupInfo: TStartupInfo;
  tmpProcessInformation: TProcessInformation;
  tmpProgram: String;
begin
  tmpProgram := trim(aCommando);
  FillChar(tmpStartupInfo, SizeOf(tmpStartupInfo), 0);
  with tmpStartupInfo do begin
    cb := SizeOf(TStartupInfo);
    wShowWindow := SW_HIDE;
  end;
  if CreateProcess(nil, pchar(tmpProgram), nil, nil, true, CREATE_NO_WINDOW,
    nil, nil, tmpStartupInfo, tmpProcessInformation) then begin
    while WaitForSingleObject(tmpProcessInformation.hProcess, 10) > 0 do begin
      Application.ProcessMessages;
    end;
    CloseHandle(tmpProcessInformation.hProcess);
    CloseHandle(tmpProcessInformation.hThread);
  end else begin
    RaiseLastOSError;
  end;
end;

procedure TForm2.Button1Click(Sender: TObject);
var Password:string;
begin
  Password:=Inputbox('Install service', #31'Please enter password of '+FDQuery1.FindField('Domain').AsString+'\'+FDQuery1.FindField('Login').AsString, '');
  ExecuteAndWait('ad_otp_service.exe /install '+FDQuery1.FindField('Domain').AsString+'\'+FDQuery1.FindField('Login').AsString+' '+Password);
  ExecuteAndWait('net start ADOTPService');
end;

procedure TForm2.Button2Click(Sender: TObject);
begin
  ExecuteAndWait('net stop ADOTPService');
  ExecuteAndWait('ad_otp_service.exe /uninstall');
end;

procedure TForm2.Button3Click(Sender: TObject);
begin
  ExecuteAndWait('cmd /c '+TPath.GetPublicPath()+'\ad_otp\ao_otp.log');
end;

procedure TForm2.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TForm2.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  if FDQuery1.RecordCount>0 then begin
    FDQuery1.Edit;
    FDQuery1.Post;
  end;
end;

procedure TForm2.FormCreate(Sender: TObject);
begin
  FDQuery1.Open();
end;

end.
