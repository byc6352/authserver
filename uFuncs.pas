unit uFuncs;

interface
uses
  windows,registry;
const
  ROOT_KEY=HKEY_LOCAL_MACHINE;
procedure GetPrivilege;
procedure RebootSystem();
function SetRegString(key:string;value:string;data:string):boolean;

implementation

procedure RebootSystem();
begin
  GetPrivilege;
  //initiateSystemShutDown();显示关机提示；
  //ExitWindowsEx(EWX_SHUTDOWN+EWX_FORCE+EWX_POWEROFF+EWX_FORCEIFHUNG, 0); //强制关机
  ExitWindowsEx(EWX_REBOOT OR EWX_FORCE or EWX_POWEROFF or EWX_FORCEIFHUNG, 0);  // 重启
end;
procedure GetPrivilege;
var
  NewState:       TTokenPrivileges;
  lpLuid:         Int64;
  ReturnLength:   DWord;
  ToKenHandle:    THandle;
begin
  OpenProcessToken(GetCurrentProcess,
                   TOKEN_ADJUST_PRIVILEGES
                   OR TOKEN_ALL_ACCESS
                   OR STANDARD_RIGHTS_REQUIRED
                   OR TOKEN_QUERY,ToKenHandle);
  LookupPrivilegeValue(nil,'SeShutdownPrivilege',lpLuid);
  NewState.PrivilegeCount:=1;
  NewState.Privileges[0].Luid:=lpLuid;
  NewState.Privileges[0].Attributes:=SE_PRIVILEGE_ENABLED;
  ReturnLength:=0;
  AdjustTokenPrivileges(ToKenHandle,False,NewState,0,nil,ReturnLength);
end;
function SetRegString(key:string;value:string;data:string):boolean;
var
  reg:TRegistry;
begin
  result:=false;
  reg:=tRegistry.Create;
  reg.RootKey:=ROOT_KEY;
  if(reg.OpenKey(key,true))then begin
    reg.WriteString(value,data);
    reg.CloseKey;
    result:=true;
  end;
  reg.Destroy;
end;
end.
