program authserver;

uses
  Vcl.Forms,
  uMain in 'uMain.pas' {fMain},
  uDM in 'uDM.pas' {DM: TDataModule},
  uAuthCode in 'uAuthCode.pas' {fauthCode},
  uConfig in 'uConfig.pas',
  uFuncs in 'uFuncs.pas',
  uLog in 'uLog.pas',
  uStartServices in 'uStartServices.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfMain, fMain);
  Application.CreateForm(TDM, DM);
  Application.CreateForm(TfauthCode, fauthCode);
  Application.Run;
end.
