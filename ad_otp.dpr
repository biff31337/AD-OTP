program ad_otp;

uses
  Vcl.Forms,
  ad_otp_main in 'ad_otp_main.pas' {Form1},
  ad_otp_config in 'ad_otp_config.pas' {Form2},
  ad_otp_users in 'ad_otp_users.pas' {Form3};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
