unit uConfig;

interface
uses
  Vcl.Forms,System.SysUtils;
const
  DB_DIR:string='database'; // 保存网页的子目录名
  DB_NAME:string='author.mdb';
  LOG_NAME:string='authLog.txt';
var
  workdir:string;//工作目录
  dbdir,dbfile,dbConn,logfile:string;// 数据库子目录,数据库
  isInit:boolean=false;
  procedure init();
implementation
procedure init();
var
    me:String;
begin
  isInit:=true;
    me:=application.ExeName;
    workdir:=extractfiledir(me);
    dbdir:=workdir+'\'+DB_DIR;
    if(not DirectoryExists(dbdir))then
      ForceDirectories(dbdir);
    dbfile:=dbdir+'\'+DB_NAME;
    logfile:=workdir+'\'+LOG_NAME;
    //D:\works\delphi\authserver\Win32\Debug\database\author.mdb
    dbConn := 'Provider = MicroSoft.jet.OLEDB.4.0;'+
                       'Persist Security Info = False;'+
                       'Data Source='+dbfile+';'+//数据库本地目录
                       'Mode = ReadWrite;'+
                       'Jet OLEDB:Database Password="";'// 加入密码
    //dbConn:='Provider=Microsoft.Jet.OLEDB.4.0;Password="";User ID=Admin;Data Source='+dbfile+
   // ';Mode=Share Deny None;Extended Properties="";Jet OLEDB:System database="";Jet OLEDB:Registry Path="";Jet OLEDB:Database Password="";'+
   // 'Jet OLEDB:Engine Type=5;Jet OLEDB:Database Locking Mode=1;Jet OLEDB:Global Partial Bulk Ops=2;Jet OLEDB:Global Bulk Transactions=1;'+
   // 'Jet OLEDB:New Database Password="";Jet OLEDB:Create System Database=False;Jet OLEDB:Encrypt Database=False;Jet OLEDB:Jet OLEDB:Compact Without Replica Repair=False;Jet OLEDB:SFP=False';
end;
begin
  init();
end.
