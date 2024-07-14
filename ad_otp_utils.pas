unit ad_otp_utils;

interface
uses
  Windows, Classes, SysUtils, math;

type
  NetAPIStatus = Integer;
  CREDENTIAL_ATTRIBUTE = packed record
    Keyword: LPTSTR;
    Flags: DWORD;
    ValueSize: DWORD;
    Value: LPBYTE;
  end;
  PCREDENTIAL_ATTRIBUTE = ^CREDENTIAL_ATTRIBUTE;

  CREDENTIALW = packed record
    Flags: DWORD;
    Type_: DWORD;
    TargetName: LPTSTR;
    Comment: LPTSTR;
    LastWritten: FILETIME;
    CredentialBlobSize: DWORD;
    CredentialBlob: LPBYTE;
    Persist: DWORD;
    AttributeCount: DWORD;
    Attributes: PCREDENTIAL_ATTRIBUTE;
    TargetAlias: LPTSTR;
    UserName: LPTSTR;
  end;
  PCREDENTIALW = ^CREDENTIALW;
  function CredReadGenericCredentials(const Target: UnicodeString; var Username, Password: UnicodeString): Boolean;
  function CredWriteGenericCredentials(const Target, Username, Password: UnicodeString): Boolean;
  Function NetUserSetInfo(ServerName, UserName : PWideChar; Level : Integer; Const Buf : Pointer; Var Parm_Err : DWORD) : NetAPIStatus; StdCall; External 'NETAPI32.DLL';
  function GeneratePassword(lengthx: Integer): String;

implementation
const
  CRED_TYPE_GENERIC                 = 1;
  CRED_TYPE_DOMAIN_PASSWORD         = 2;
  CRED_TYPE_DOMAIN_CERTIFICATE      = 3;
  CRED_TYPE_DOMAIN_VISIBLE_PASSWORD = 4;
  CRED_TYPE_MAXIMUM                 = 5;
  CRED_TYPE_MAXIMUM_EX              = CRED_TYPE_MAXIMUM + 1000;
  CRED_PERSIST_NONE: DWORD          = 0;
  CRED_PERSIST_SESSION: DWORD       = 1;
  CRED_PERSIST_LOCAL_MACHINE: DWORD = 2;
  CRED_PERSIST_ENTERPRISE: DWORD    = 3;

function CredWriteW( Credential:PCREDENTIALW;Flags:DWORD): BOOL; stdcall; external 'advapi32.dll';
function CredReadW(TargetName: LPCWSTR; Type_: DWORD; Flags: DWORD; var Credential: PCREDENTIALW): BOOL; stdcall; external 'advapi32.dll';
Procedure CredFree(Buffer:pointer); stdcall; external 'advapi32.dll';

function CredReadGenericCredentials(const Target: UnicodeString; var Username, Password: UnicodeString): Boolean;
var
    credential: PCREDENTIALW;
begin
    Result := False;
    credential := nil;
    if not CredReadW(PWideChar(Target), CRED_TYPE_GENERIC, 0, {var}credential) then
      Exit;
    try
        username := Credential.UserName;
        password := WideCharToString(PWideChar(Credential.CredentialBlob));
    finally
        CredFree(Credential);
    end;
    Result := True;
end;

function CredWriteGenericCredentials(const Target, Username, Password: UnicodeString): Boolean;
var
    Credentials: CREDENTIALW;
begin
    ZeroMemory(@Credentials, SizeOf(Credentials));
    Credentials.TargetName := PWideChar(Target);
    Credentials.Type_ := CRED_TYPE_GENERIC;
    Credentials.UserName := PWideChar(Username);
    Credentials.Persist := CRED_PERSIST_LOCAL_MACHINE;
    Credentials.CredentialBlob := PByte(Password);
    Credentials.CredentialBlobSize := 2*(Length(Password));
    Result := CredWriteW(@Credentials, 0);
end;

function GeneratePassword(lengthx: Integer): String;
const
  CharSet = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!@#$%^&*()-=_+';
var
  i: Integer;
begin
  Randomize;
  Result := '';
  for i := 1 to lengthx do
    Result := Result + CharSet[Random(Length(CharSet)) + 1];
end;

end.
