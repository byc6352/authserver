unit uStartServices;

interface

uses
Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
Dialogs, WinSVC, StdCtrls;
{
 if SERVICE_RUNNING = ServiceGetStatus('', '������') then
  StopServices('������', true);
StartServices('������', false);
}
//��ȡ����״̬
//������sMachine����������������ÿ��ַ�����ʾ��  sService����������
//����������״̬ SERVICE_RUNNING/SERVICE_STOPPED/SERVICE_PAUSED��
function ServiceGetStatus(sMachine, sService: string ): DWord;
//�������� Wait=true��ʾһֱ�ȴ�����������ֹͣ��ɺ���ܼ�����������
function StartServices(const SvrName: string; BWait: boolean): Boolean;
//ֹͣ����
function StopServices(const SvrName: string; BWait: boolean): Boolean;
//��������
function RestartServices(const SvrName: string; BWait: boolean): Boolean;
//�ȴ�����������ֹͣ
function WaitForService(ServiceHandle: Longword; AStatus: Longword): Boolean;

implementation


function StartServices(const SvrName: string; BWait: boolean): Boolean;
var
  SCH, SvcSCH: SC_HANDLE;
  arg: PChar;
  dwStartType: DWORD;
begin
  Result := False;
  SCH := OpenSCManager(nil, nil, SC_MANAGER_ALL_ACCESS);
  if SCH <= 0 then Exit;
  SvcSCH := OpenService(SCH, PChar(SvrName), SERVICE_ALL_ACCESS);
  if SvcSCH <= 0 then Exit;
  try
    Result := StartService(SvcSCH, 0, arg);
    if BWait then
      WaitForService(SvcSCH, SERVICE_RUNNING);
    finally
      CloseServiceHandle(SvcSCH);
      CloseServiceHandle(SCH);
    end;
end;

function RestartServices(const SvrName: string; BWait: boolean): Boolean;
var
  SCH, SvcSCH: SC_HANDLE;
  arg: PChar;
  dwStartType: DWORD;
  ServiceStatus: _SERVICE_STATUS;
  SS: TServiceStatus;
begin
  Result := False;
  SCH := OpenSCManager(nil, nil, SC_MANAGER_ALL_ACCESS);
  if SCH <= 0 then Exit;
  SvcSCH := OpenService(SCH, PChar(SvrName), SERVICE_ALL_ACCESS);
  if SvcSCH <= 0 then Exit;

  if not ControlService(SvcSCH, SERVICE_CONTROL_INTERROGATE, ServiceStatus) then exit;
  if ServiceStatus.dwCurrentState = SERVICE_RUNNING then    //����������У�����ֹͣ����
  begin
    ControlService(SvcSCH, SERVICE_CONTROL_STOP, SS);
    WaitForService(SvcSCH, SERVICE_STOPPED);
    //StopServices(SvrName, true);
  end;

  try
    Result := StartService(SvcSCH, 0, arg);
    if BWait then
      WaitForService(SvcSCH, SERVICE_RUNNING);
  finally
    CloseServiceHandle(SvcSCH);
    CloseServiceHandle(SCH);
  end;
end;

function StopServices(const SvrName: string; BWait: boolean): Boolean;
var
  SCH, SvcSCH: SC_HANDLE;
  SS: TServiceStatus;
begin
  Result := False;
  SCH := OpenSCManager(nil, nil, SC_MANAGER_ALL_ACCESS);
  if SCH <= 0 then Exit;
  SvcSCH := OpenService(SCH, PChar(SvrName), SERVICE_ALL_ACCESS);
  if SvcSCH <= 0 then Exit;
  try
    Result := ControlService(SvcSCH, SERVICE_CONTROL_STOP, SS);
    if BWait then
      WaitForService(SvcSCH, SERVICE_STOPPED);
  finally
    CloseServiceHandle(SCH);
    CloseServiceHandle(SvcSCH);
  end;
end;

function ServiceGetStatus(sMachine, sService: string ): DWord;
var
  schm,     //service control manager handle
  schs: SC_Handle;  //service handle
  ss: TServiceStatus;  //service status
  dwStat : DWord;   //current service status
begin
  dwStat := 0;
  schm := OpenSCManager(PChar(sMachine), Nil, SC_MANAGER_CONNECT);
  if(schm > 0)then
  begin
    //open a handle to the specified service
    schs := OpenService(schm, PChar(sService), SERVICE_QUERY_STATUS);
    if(schs > 0)then
    begin
      //retrieve the current status of the specified service
      if(QueryServiceStatus(schs, ss))then
      begin
        dwStat := ss.dwCurrentState;
      end;

      CloseServiceHandle(schs);  //close service handle
    end;

    CloseServiceHandle(schm);   // close service control manager handle
  end;

  Result := dwStat;
end;

function WaitForService(ServiceHandle: Longword; AStatus: Longword): Boolean;
var
  PendingStatus: Longword;
  ServiceStatus: _SERVICE_STATUS;
  Error: Integer;
begin
  Result := False;
  case AStatus of
    SERVICE_RUNNING: PendingStatus := SERVICE_START_PENDING;
    SERVICE_STOPPED: PendingStatus := SERVICE_STOP_PENDING;
  end;
  repeat
    if not ControlService(ServiceHandle, SERVICE_CONTROL_INTERROGATE, ServiceStatus) then
    begin

    end;
    if ServiceStatus.dwWin32ExitCode <> 0 then
      Break;
    Result := ServiceStatus.dwCurrentState = AStatus;
    if not Result and (ServiceStatus.dwCurrentState = PendingStatus) then
      Sleep(ServiceStatus.dwWaitHint)
    else
      Break;
  until Result;
end;

end.