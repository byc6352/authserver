unit uAuthCode;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls,uDM,
  Vcl.ComCtrls, Vcl.ToolWin;

type
  TfauthCode = class(TForm)
    memCode: TMemo;
    ToolBar1: TToolBar;
    StatusBar1: TStatusBar;
    edtAppID: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    edtLength: TEdit;
    Label3: TLabel;
    edtCount: TEdit;
    btnCreateCode: TBitBtn;
    procedure btnCreateCodeClick(Sender: TObject);
  private
    { Private declarations }
    function createUniqueCode():string;
  public
    { Public declarations }
  end;

var
  fauthCode: TfauthCode;
  function createRandomNum():integer;
  function createCode():string;
implementation

{$R *.dfm}
function createCode():string;
var
  i:integer;
  n:string;
begin
  result:='';
  for I := 1 to 12 do
  begin
    n:=inttostr(createRandomNum());
    result:=result+n;
  end;
end;
function createRandomNum():integer;
begin
  Randomize;
  result:=random(9);
end;

procedure TfauthCode.btnCreateCodeClick(Sender: TObject);
var
  i,count:integer;
  aCode,appID,authLength:string;
begin
  memCode.Clear;
  count:=strtoint(trim(edtcount.Text));
  appID:=trim(edtAppID.Text);
  authLength:=trim(edtLength.Text);
  for i := 1 to count do
  begin
    aCode:=createUniqueCode();
    dm.InsertAuthCode(appId,aCode,authLength);
    memCode.Lines.Add(aCode);
  end;
end;

function TfauthCode.createUniqueCode():string;
var
  aCode:string;
begin
  aCode:=createCode();
  while dm.AuthCodeExist(aCode) do
     aCode:=createCode();
  result:=aCode;
end;
end.
