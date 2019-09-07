unit frmConfiguracaoFTP;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, IniFiles, Filectrl, IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient,
  IdExplicitTLSClientServerBase, IdFTP;

type
  TfConfiguracoes = class(TForm)
    Label2: TLabel;
    btnConnectar: TButton;
    txtServidor: TEdit;
    Button1: TButton;
    procedure btnConnectarClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    arConfig: TIniFile;
  end;

var
  fConfiguracoes: TfConfiguracoes;

implementation

{$R *.dfm}

procedure TfConfiguracoes.btnConnectarClick(Sender: TObject);
var
  Dir, porta: string;
begin
  Dir := ExtractFilePath(Application.ExeName);
  if (txtServidor.Text = '') then begin
     Application.MessageBox('Nao foi possivel analisar o endereco do servidor:'+#13+'Host nao especificiado, entre com um host.', 'SKY PAINEL - ERRO DE SINTAXE', MB_OK + 16);
     txtServidor.SetFocus;
     Abort;
  end;
  arConfig := TIniFile.Create(Dir + 'config.ini');
  try
    with arConfig do
    begin
      WriteString('CONFIG', 'VENDEDOR', txtServidor.Text);
      Free;
    end;
  except
    on E: Exception do
    begin
      Application.MessageBox('Erro na conex�o!', 'SKY PAINEL', MB_OK + 16);
      abort;
    end;
  end;
  Application.MessageBox('Dados salvos com sucesso', 'SKY PAINEL - NOTIFICACAO', MB_OK + 64);
end;

procedure TfConfiguracoes.Button1Click(Sender: TObject);
begin
  Application.Terminate;
end;

end.
