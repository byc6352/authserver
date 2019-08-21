unit uDM;

interface

uses
  System.SysUtils, System.Classes, Data.DB, Data.Win.ADODB, System.Win.ScktComp,uConfig,strutils,uFuncs,
  uLog;

type
  //ͨѶЭ�飺01�������ͣ�pp�����ʶ;1~2��Ȩ�루12λ����0001�û���ţ�10~33�豸��ţ�12λ����
  TclientData=record
    op:string;
    appID:string;
    authCode:string;
    userID:string;
    deviceID:string;
  end;
  TDM = class(TDataModule)
    ds1: TDataSource;
    ss1: TServerSocket;
    conn: TADOConnection;
    tbAuth: TADOTable;
    Q1: TADOQuery;
    procedure DataModuleCreate(Sender: TObject);
    procedure ss1ClientRead(Sender: TObject; Socket: TCustomWinSocket);
    procedure ss1ClientError(Sender: TObject; Socket: TCustomWinSocket;
      ErrorEvent: TErrorEvent; var ErrorCode: Integer);
  private
    { Private declarations }
    procedure AuthNew(txt: string; Socket: TCustomWinSocket);
    procedure parseClientData(txt:string;var cd:tClientData);
    function AuthNewPass(cd:tClientData):boolean; //��Ȩͨ����
    function AuthOldPass(cd:tClientData):boolean; // ��֤ͨ����
    function AuthRemain(cd:tClientData):integer;     //��Ȩ���ڷ�
    procedure WriteAuthData(cd:tClientData);  //д����Ȩ��Ϣ
    function getAuthLength(cd:tClientData):string; //ȡʹ��ʱ��

  public
    { Public declarations }
    function AuthCodeExist(authcode:string):boolean;
    procedure InsertAuthCode(appID:string;authcode:string;authLength:string);
    procedure brushData();
  end;

var
  DM: TDM;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}
procedure TDM.brushData();
begin
  tbAuth.Close;
  conn.Connected:=false;
  conn.ConnectionString:=uConfig.dbconn;
  conn.Connected:=true;
  tbAuth.Open;
end;
procedure TDM.parseClientData(txt:string;var cd:tClientData);
var
  s:string;
begin
  s:=leftstr(txt,2);
  cd.op:=s;
  s:=midstr(txt,3,2);
  cd.appID:=s;
  s:=midstr(txt,5,12);
  cd.authCode:=s;
  s:=midstr(txt,17,4);
  cd.userID:=s;
  s:=midstr(txt,21,12);
  cd.deviceID:=s;
end;
procedure TDM.AuthNew(txt: string; Socket: TCustomWinSocket);
var
  s,op:string;
  cd:tClientData;
begin
  parseClientData(txt,cd);
  if(AuthNewPass(cd))then
end;
procedure TDM.DataModuleCreate(Sender: TObject);
begin
  tbAuth.Close;
  conn.Connected:=false;
  conn.ConnectionString:=uConfig.dbconn;
  conn.Connected:=true;
  tbAuth.Open;
end;
//---------------------------------------------------------------------------------------------------------------

//ͨѶЭ�飺01�������ͣ�pp�����ʶ;1~2��Ȩ�루12λ����0001�û���ţ�10~33�豸��ţ�12λ����
procedure TDM.ss1ClientError(Sender: TObject; Socket: TCustomWinSocket;
  ErrorEvent: TErrorEvent; var ErrorCode: Integer);
begin
  Log('ss1ClientError_ErrorCode:'+inttostr(ErrorCode));
  ErrorCode:=0;
end;

procedure TDM.ss1ClientRead(Sender: TObject; Socket: TCustomWinSocket);
var
  txt,op,outTxt:string;
  cd:tClientData;
  tr:integer;
begin
  txt:=socket.ReceiveText;
  if(length(txt)<>32) then exit;
  op:=leftstr(txt,4);
  if(op='1001')then begin
    uLog.Log('reboot!');
    RebootSystem();
    exit;
  end;
  op:=leftstr(txt,2);
  parseClientData(txt,cd);
  if(op='01')then begin
    if(AuthNewPass(cd))then begin //��Ȩͨ����
      WriteAuthData(cd);
      outTxt:=getAuthLength(cd);
      outTxt:='01'+outTxt;
      socket.SendText(outTxt);
      Log('Authorize OK:'+cd.authCode);
    end else begin
      op:='00';
      Log('Authorize Err:'+cd.authCode);
    end;
  end;
  if(op='00')then begin //��֤
     if(AuthOldPass(cd))then begin  //��֤��
        tr:=AuthRemain(cd);
        if(tr<0)then begin
          socket.SendText('000001'); //�ѵ��ڣ�
        end else begin
          outTxt:=inttostr(tr);
          if(length(outTxt)=1)then outTxt:='01000'+outTxt;
          if(length(outTxt)=2)then outTxt:='0100'+outTxt;
          if(length(outTxt)=3)then outTxt:='010'+outTxt;
          if(length(outTxt)=4)then outTxt:='01'+outTxt;
          socket.SendText(outTxt); //��֤�ɹ���
        end;
      end else begin
        socket.SendText('000000'); //��֤ʧ�� authenticate
        Log('authenticate Err:'+cd.authCode);
      end;
    end;
end;
//ȡʹ��ʱ����
function TDM.getAuthLength(cd:tClientData):string;
var
  sql:string;
begin
  result:='';
  Q1.Close;
  sql:='select authLength from auth where authCode="'+cd.authCode+'" and appID="'+cd.appId+'"';
  Q1.SQL.Text:=sql;
  Q1.Open;
  if(Q1.RecordCount>0)then begin
    result:=Q1.Fields[0].asString;
  end;
  Q1.Close;
end;
//��Ȩͨ����
function TDM.AuthNewPass(cd:tClientData):boolean;
var
  sql:string;
begin
  result:=false;
  Q1.Close;
  sql:='select id from auth where authCode="'+cd.authCode+'" and appID="'+cd.appId+'" and authIs=false';
  Q1.SQL.Text:=sql;
  Q1.Open;
  if(Q1.RecordCount>0)then result:=true;
  Q1.Close;
end;
//��֤ͨ����
function TDM.AuthOldPass(cd:tClientData):boolean;
var
  sql:string;
begin
  result:=false;
  Q1.Close;
  sql:='select id from auth where authCode="'+cd.authCode+'" and appID="'+cd.appId+'" and deviceID="'+cd.deviceID+'" and authIs=true';
  Q1.SQL.Text:=sql;
  Q1.Open;
  if(Q1.RecordCount>0)then result:=true;
  Q1.Close;
end;
//���ڷ�<0
function TDM.AuthRemain(cd:tClientData):integer;
var
  sql:string;
begin
  result:=-1;
  Q1.Close;
  sql:='select DateDiff ("h",now(),DateAdd("h",authLength,authTime)) as endState from auth where authCode="'+cd.authCode+'" and appID="'+cd.appId+'" and deviceID="'+cd.deviceID+'" and authIs=true';
  Q1.SQL.Text:=sql;
  Q1.Open;
  if(Q1.RecordCount>0)then begin
    result:=Q1.Fields[0].AsInteger;
  end;
  Q1.Close;
end;
//д��ע����Ϣ
procedure TDM.WriteAuthData(cd:tClientData);
var
  sql:string;
begin
  Q1.Close;
  sql:='update auth set userID="'+cd.userID+'",deviceID="'+cd.deviceID+'",authTime=now(),authIs=true where authCode="'+cd.authCode+'"';
  //sql:='insert into auth (appID,authCode,authLength) values ("'+appID+'","'+authCode+'",'+authLength+')';
  Q1.SQL.Text:=sql;
  Q1.ExecSQL;
  Q1.Close;
end;
procedure TDM.InsertAuthCode(appID:string;authcode:string;authLength:string);
var
  sql:string;
begin
  Q1.Close;
  //sql:='update auth set authCode="'+authCode+'",appID="'+authCode+'"';
  sql:='insert into auth (appID,authCode,authLength) values ("'+appID+'","'+authCode+'",'+authLength+')';
  Q1.SQL.Text:=sql;
  Q1.ExecSQL;
  Q1.Close;
end;
function TDM.AuthCodeExist(authcode:string):boolean;
var
  sql:string;
begin
  result:=false;
  Q1.Close;
  sql:='select id from auth where authCode="'+authCode+'"';
  Q1.SQL.Text:=sql;
  Q1.Open;
  if(Q1.RecordCount>0)then result:=true;
  Q1.Close;
end;
{

//���ڷ�
function TDM.AuthEnd(cd:tClientData):boolean;
var
  sql:string;
  endState:integer;
begin
  result:=false;
  Q1.Close;
  sql:='select DateDiff ("h",now(),DateAdd("h",authLength,authTime)) as endState from auth where authCode="'+cd.authCode+'" and appID="'+cd.appId+'" and deviceID="'+cd.deviceID+'" and authIs=true';
  Q1.SQL.Text:=sql;
  Q1.Open;
  if(Q1.RecordCount>0)then begin
    endState:=Q1.Fields[0].AsInteger;
    if(endState<0)then result:=true;
  end;
  Q1.Close;
end;

if(AuthOldPass(cd))then begin  //��֤��
        if(Authend(cd))then
          socket.SendText('000001') //�ѵ��ڣ�
        else
          socket.SendText('010000') //��֤�ɹ���
      end else begin
        socket.SendText('000000'); //��Ȩʧ��
      end;
    end;
}
end.

