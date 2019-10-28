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
    //function createUniqueCode():string;
  public
    { Public declarations }
  end;

var
  fauthCode: TfauthCode;
  //function createRandomNum():integer;
  //function createCode():string;
implementation

{$R *.dfm}


procedure TfauthCode.btnCreateCodeClick(Sender: TObject);
var
  count:integer;
  appID,authLength:string;
  ss:tstrings;
begin
  memCode.Clear;
  count:=strtoint(trim(edtcount.Text));
  appID:=trim(edtAppID.Text);
  authLength:=trim(edtLength.Text);
  ss:=tstringlist.Create;
  dm.GenerateCode(appId,authLength,count,ss);
  memCode.Lines:=ss;
  ss.Free;
end;


end.
