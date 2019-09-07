unit frmLogin;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, jpeg, pngimage, DB, ZAbstractRODataset,
  ZAbstractDataset, ZDataset, ZAbstractConnection, IniFiles, ZConnection, ZAbstractTable,
  Buttons;

type
  TfLogin = class(TForm)
    txtUsuario: TEdit;
    txtSenha: TEdit;
    pClique: TPanel;
    Button1: TButton;
    sbLogar: TSpeedButton;
    imgTelaLogin: TImage;
    procedure Image3Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure txtSenhaChange(Sender: TObject);
    procedure txtUsuarioKeyPress(Sender: TObject; var Key: Char);
    procedure Logar();
    procedure btnAcessaClick(Sender: TObject);
    procedure txtSenhaKeyPress(Sender: TObject; var Key: Char);
    procedure sbLogarClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
     tentativas: integer;
  public
    { Public declarations }
  end;

var
  fLogin: TfLogin;

implementation

uses frmPrincipal, frmDM;

{$R *.dfm}

procedure TfLogin.btnAcessaClick(Sender: TObject);
begin
  Logar();
end;

procedure TfLogin.Button1Click(Sender: TObject);
begin
  Logar;
end;

procedure TfLogin.FormCreate(Sender: TObject);
begin
  tentativas := 1;
end;

procedure TfLogin.Image3Click(Sender: TObject);
begin
Application.Terminate;
end;

procedure TfLogin.Logar;
begin
  dm.Acesso.SQL.Clear;
  DM.Acesso.Close;
  DM.Acesso.SQL.Add('SELECT * FROM acesso WHERE');
  DM.Acesso.SQL.Add('login = "' + txtUsuario.Text + '" AND senha = "' +txtsenha.Text + '"');
  DM.Acesso.Close;
  DM.Acesso.Open;

  if (DM.Acesso.RecordCount < 1) then begin
    ModalResult := mrNone;
    if (tentativas = 1) then begin
      Inc(tentativas);
      Application.MessageBox('Acesso não liberado, Você só tem mais (2) tentativa','SKY PAINEL', MB_OK + MB_ICONWARNING);
    end else if (tentativas = 2) then begin
      Inc(tentativas);
      Application.MessageBox('Acesso não liberado, Você tem mais (1) tentativa','SKY PAINEL', MB_OK + MB_ICONWARNING);
    end else begin
      Application.MessageBox('Acesso bloqueado!','SKY PAINEL', MB_OK + MB_ICONWARNING);
      Application.Terminate;
    end;
  end;
end;

procedure TfLogin.sbLogarClick(Sender: TObject);
begin
  Button1.Click;
end;

procedure TfLogin.txtSenhaChange(Sender: TObject);
begin
  if (Length(txtSenha.Text) > 4) then begin
    //btnAcessa.Enabled := true;
  end;
end;

procedure TfLogin.txtSenhaKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then begin
       Logar;
  end;
end;

procedure TfLogin.txtUsuarioKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then begin
       if (txtUsuario.Text = '') then begin
          Application.MessageBox('Informe o nome do usuario','SKY PAINEL', MB_OK + MB_ICONWARNING);
          abort;
       end;
       txtSenha.SetFocus;
  end;
end;

end.
