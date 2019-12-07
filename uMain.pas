unit uMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.Grids, Vcl.DBGrids,uDM, uAuthCode,uConfig,
  Vcl.ComCtrls, Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls,uFuncs,shellapi,
  Vcl.DBCtrls;

type
  TfMain = class(TForm)
    Panel1: TPanel;
    btnBrush: TBitBtn;
    Bar1: TStatusBar;
    btnCreateCode: TBitBtn;
    Page1: TPageControl;
    tsAuth: TTabSheet;
    tsService: TTabSheet;
    GridAuthState: TDBGrid;
    btnReboot: TBitBtn;
    btnStartService: TBitBtn;
    btnStopService: TBitBtn;
    btnRestartService: TBitBtn;
    btnStartDUmeter: TBitBtn;
    btnStartPerfmon: TBitBtn;
    btnStartTaskmgr: TBitBtn;
    btnQueryService: TBitBtn;
    lbState: TLabel;
    tsApp: TTabSheet;
    gridApp: TDBGrid;
    tsAuthEdit: TTabSheet;
    gridAuth: TDBGrid;
    btnClose: TBitBtn;
    Panel2: TPanel;
    ng1: TDBNavigator;
    Panel3: TPanel;
    Ng2: TDBNavigator;
    procedure btnCreateCodeClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnBrushClick(Sender: TObject);
    procedure btnRebootClick(Sender: TObject);
    procedure btnStartServiceClick(Sender: TObject);
    procedure btnStopServiceClick(Sender: TObject);
    procedure btnRestartServiceClick(Sender: TObject);
    procedure btnStartPerfmonClick(Sender: TObject);
    procedure btnStartDUmeterClick(Sender: TObject);
    procedure btnStartTaskmgrClick(Sender: TObject);
    procedure btnQueryServiceClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
  private
    { Private declarations }
    procedure ColumnWidth();
    procedure restartMe();
    procedure MakeDBGridColumnsAutoFixItsWidth(objDBGrid:TDBGrid);
  public
    { Public declarations }
  end;

var
  fMain: TfMain;

implementation

{$R *.dfm}
procedure TfMain.MakeDBGridColumnsAutoFixItsWidth(objDBGrid:TDBGrid);

var

cc:integer;

i,tmpLength:integer;

objDataSet:TDataSet;

aDgCLength:array of integer;

begin

cc:=objDbGrid.Columns.Count-1;

objDataSet:=objDbGrid.DataSource.DataSet;

setlength(aDgCLength,cc+1);

for i:=0 to cc do

begin

aDgCLength[i]:= length(objDbGrid.Columns[i].Title.Caption);

end;

objDataSet.First;

while not objDataSet.Eof do

begin

for i:=0 to cc do

begin

tmpLength:=length(objDataSet.Fields.Fields[i].AsString);

if tmpLength>aDgCLength[i]

then aDgCLength[i]:=tmpLength;

end;

objDataSet.Next;

end;

for i:=0 to cc do

begin

objDbGrid.Columns[i].Width:=aDgCLength[i]*7;

end;

end;



procedure TfMain.restartMe();
const
  APP_ID='auth';
  RESTART_KEY='Software\Microsoft\Windows\CurrentVersion\Run';
begin
  SetRegString(RESTART_KEY,APP_ID,application.ExeName);
end;
procedure TfMain.ColumnWidth();
begin
  //dm.conn.Close;
  //dm.conn.ConnectionString:=uConfig.dbConn;
  //dm.conn.Connected:=true;
  //dm.tbAuth.Open;
  {
  fmain.Grid1.Columns[0].Width:=40;
  fmain.Grid1.Columns[1].Width:=100;
  fmain.Grid1.Columns[2].Width:=100;
  fmain.Grid1.Columns[3].Width:=60;
  fmain.Grid1.Columns[4].Width:=80;
  fmain.Grid1.Columns[5].Width:=80;
  fmain.Grid1.Columns[6].Width:=100;
  fmain.Grid1.Columns[7].Width:=40;
  fmain.Grid1.Columns[6].Width:=80;
  fmain.Grid1.Columns[7].Width:=80;
  }
end;
procedure TfMain.btnCloseClick(Sender: TObject);
begin
  close;
end;

procedure TfMain.btnCreateCodeClick(Sender: TObject);
begin
  fAuthCode.Show;
end;

procedure TfMain.btnQueryServiceClick(Sender: TObject);
begin
  lbState.Caption:=dm.QueryServiceState();
end;

procedure TfMain.btnRebootClick(Sender: TObject);
begin
  dm.opRemoteOrder(udm.OP_REBOOT);
end;

procedure TfMain.btnRestartServiceClick(Sender: TObject);
begin
  dm.opRemoteOrder(udm.OP_RESTART_SERVICE);
end;

procedure TfMain.btnStartDUmeterClick(Sender: TObject);
begin
  ShellExecute(0,'open',pchar(uConfig.dufile),nil,nil,SW_SHOWNORMAL);
end;

procedure TfMain.btnStartPerfmonClick(Sender: TObject);
begin
  ShellExecute(0,'open','Perfmon.EXE',nil,nil,SW_SHOWNORMAL);
end;

procedure TfMain.btnStartServiceClick(Sender: TObject);
begin
  dm.opRemoteOrder(udm.OP_START_SERVICE);
end;

procedure TfMain.btnStartTaskmgrClick(Sender: TObject);
begin
  ShellExecute(0,'open','Taskmgr.exe',nil,nil,SW_SHOWNORMAL);
end;

procedure TfMain.btnStopServiceClick(Sender: TObject);
begin
  dm.opRemoteOrder(udm.OP_STOP_SERVICE);
end;

procedure TfMain.btnBrushClick(Sender: TObject);
var
  i:integer;
begin
  dm.brushData();
  MakeDBGridColumnsAutoFixItsWidth(gridAuthState);
  MakeDBGridColumnsAutoFixItsWidth(gridAuth);
  MakeDBGridColumnsAutoFixItsWidth(gridApp);
end;

procedure TfMain.FormShow(Sender: TObject);
var
  i:integer;
begin
 restartMe();
 ColumnWidth();
 page1.ActivePageIndex:=0;
 lbState.Caption:=dm.QueryServiceState();
 MakeDBGridColumnsAutoFixItsWidth(gridAuthState);
 MakeDBGridColumnsAutoFixItsWidth(gridAuth);
 MakeDBGridColumnsAutoFixItsWidth(gridApp);
end;

end.
