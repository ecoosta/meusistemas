program consulta;

uses
  Forms,
  frmConsulta in 'frmConsulta.pas' {fConsulta},
  frmConfiguracaoFTP in 'frmConfiguracaoFTP.pas' {fConfiguracoes};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfConsulta, fConsulta);
  Application.CreateForm(TfConfiguracoes, fConfiguracoes);
  Application.Run;
end.
