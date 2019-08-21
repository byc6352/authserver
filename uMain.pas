unit uMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.Grids, Vcl.DBGrids,uDM, uAuthCode,uConfig,
  Vcl.ComCtrls, Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls,uFuncs;

type
  TfMain = class(TForm)
    Panel1: TPanel;
    btnBrush: TBitBtn;
    Bar1: TStatusBar;
    Grid1: TDBGrid;
    btnCreateCode: TBitBtn;
    procedure btnCreateCodeClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnBrushClick(Sender: TObject);
  private
    { Private declarations }
    procedure ColumnWidth();
    procedure restartMe();
  public
    { Public declarations }
  end;

var
  fMain: TfMain;

implementation

{$R *.dfm}
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
end;
procedure TfMain.btnCreateCodeClick(Sender: TObject);
begin
  fAuthCode.Show;
end;

procedure TfMain.btnBrushClick(Sender: TObject);
var
  i:integer;
begin
  dm.brushData();

end;

procedure TfMain.FormShow(Sender: TObject);
var
  i:integer;
begin
 restartMe();
 ColumnWidth();


end;

end.