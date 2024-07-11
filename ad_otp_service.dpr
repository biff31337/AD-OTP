program ad_otp_service;

uses
  Vcl.SvcMgr,
  ad_otp_service_frm in 'ad_otp_service_frm.pas' {ADOTPService: TService};

{$R *.RES}

begin
  Application.DelayInitialize := True;
  if not Application.DelayInitialize or Application.Installing then
    Application.Initialize;
  Application.CreateForm(TADOTPService, ADOTPService);
  Application.Run;
end.
