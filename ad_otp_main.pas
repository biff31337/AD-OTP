unit ad_otp_main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Menus, Vcl.FormTabsBar,
  FireDAC.Stan.ExprFuncs, FireDAC.Phys.SQLiteWrapper.Stat, System.IOUtils,
  FireDAC.Phys.SQLiteDef, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.SQLite,
  FireDAC.VCLUI.Wait, Data.DB, FireDAC.Comp.Client, FireDAC.Stan.Param,
  FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt, FireDAC.Comp.DataSet,
  FireDAC.Phys.SQLiteWrapper.FDEStat, FireDAC.Phys.SQLiteWrapper;

type
  TForm1 = class(TForm)
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    File2: TMenuItem;
    Configuration1: TMenuItem;
    GlobalSettings1: TMenuItem;
    Info1: TMenuItem;
    FormTabsBar1: TFormTabsBar;
    Userconfiguration1: TMenuItem;
    FDConnection1: TFDConnection;
    FDCommand1: TFDCommand;
    GLOBAL: TFDQuery;
    FDPhysSQLiteDriverLink1: TFDPhysSQLiteDriverLink;
    procedure File2Click(Sender: TObject);
    procedure GlobalSettings1Click(Sender: TObject);
    procedure Userconfiguration1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Info1Click(Sender: TObject);
  private
    DBName:string;
  public
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

uses ad_otp_config, ad_otp_users;

procedure TForm1.File2Click(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  DBName:=TPath.GetPublicPath()+'\ad_otp\ad_otp.sdb';
  if not TDirectory.Exists(TPath.GetPublicPath()+'\ad_otp') then TDirectory.CreateDirectory(TPath.GetPublicPath()+'\ad_otp');
  //if FileExists(DBName) then DeleteFile(DBName);
  FDConnection1.Params.Values['database'] := DBName;
  if FileExists(DBName)=false then begin
    FDConnection1.Connected:= True;
    FDCommand1.Execute('CREATE TABLE USERS (ID INTEGER PRIMARY KEY,	Login VARCHAR(255), Secret VARCHAR(255), Password VARCHAR(255), flagEnabled BIT);');
    FDCommand1.Execute('CREATE TABLE GLOBAL (ID INTEGER PRIMARY KEY, Server VARCHAR(255), Domain VARCHAR(255), Login VARCHAR(255));');
    FDCommand1.Execute('INSERT INTO GLOBAL (Server,Domain,Login) VALUES (:s1,:s2,:s3);',['Server','Domain','Administrator']);
  end else
    FDConnection1.Connected:= True;
  GLOBAL.Open();
end;

procedure TForm1.GlobalSettings1Click(Sender: TObject);
begin
  Application.CreateForm(TForm2, Form2);
end;

procedure TForm1.Info1Click(Sender: TObject);
begin
  ShowMessage('AD OTP alpha 0.1 by Kakiarts Technologies (c) www.kakiarts.de')
end;

procedure TForm1.Userconfiguration1Click(Sender: TObject);
begin
  Application.CreateForm(TForm3, Form3);
end;

end.
