unit uDM;

interface

uses
  System.SysUtils, System.Classes, Data.DB, Data.Win.ADODB, System.Win.ScktComp,uConfig,strutils,uFuncs,
  uLog;

type
  //通讯协议：01操作类型；pp软件标识;1~2授权码（12位）；0001用户编号；10~33设备编号（12位）；
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
    function AuthNewPass(cd:tClientData):boolean; //授权通过否
    function AuthOldPass(cd:tClientData):boolean; // 认证通过否
    function AuthRemain(cd:tClientData):integer;     //授权到期否
    procedure WriteAuthData(cd:tClientData);  //写入授权信息
    function getAuthLength(cd:tClientData):string; //取使用时间

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

//通讯协议：01操作类型；pp软件标识;1~2授权码（12位）；0001用户编号；10~33设备编号（12位）；
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
    if(AuthNewPass(cd))then begin //授权通过：
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
  if(op='00')then begin //认证
     if(AuthOldPass(cd))then begin  //认证：
        tr:=AuthRemain(cd);
        if(tr<0)then begin
          socket.SendText('000001'); //已到期；
        end else begin
          outTxt:=inttostr(tr);
          if(length(outTxt)=1)then outTxt:='01000'+outTxt;
          if(length(outTxt)=2)then outTxt:='0100'+outTxt;
          if(length(outTxt)=3)then outTxt:='010'+outTxt;
          if(length(outTxt)=4)then outTxt:='01'+outTxt;
          socket.SendText(outTxt); //认证成功；
        end;
      end else begin
        socket.SendText('000000'); //认证失败 authenticate
        Log('authenticate Err:'+cd.authCode);
      end;
    end;
end;
//取使用时长：
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
//授权通过否：
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
//认证通过否：
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
//到期否：<0
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
//写入注册信息
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

//到期否：
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

if(AuthOldPass(cd))then begin  //认证：
        if(Authend(cd))then
          socket.SendText('000001') //已到期；
        else
          socket.SendText('010000') //认证成功；
      end else begin
        socket.SendText('000000'); //授权失败
      end;
    end;
}
end.

