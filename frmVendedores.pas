unit frmVendedores;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, DBGrids, StdCtrls, DB, ZAbstractRODataset, ZAbstractDataset,
  ZDataset, base, Gauges;

type
  TfVendedores = class(TForm)
    Label1: TLabel;
    txtNomeVendedor: TEdit;
    btnNovo: TButton;
    btnEditar: TButton;
    btnExcluir: TButton;
    txtSenha: TEdit;
    gVendedores: TDBGrid;
    btnCancelar: TButton;
    btnGravar: TButton;
    Label5: TLabel;
    Label4: TLabel;
    Label3: TLabel;
    txtUsuario: TEdit;
    Gauge1: TGauge;
    lblRecount: TLabel;
    procedure btnNovoClick(Sender: TObject);
    procedure btnEditarClick(Sender: TObject);
    procedure btnExcluirClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
    procedure btnGravarClick(Sender: TObject);

    procedure crearTabele();
  private
    { Private declarations }
  public
    { Public declarations }
    acao: integer;
  end;

var
  fVendedores: TfVendedores;

implementation

uses frmPrincipal, frmDM;

{$R *.dfm}

procedure TfVendedores.btnCancelarClick(Sender: TObject);
var
  Registro: TBookmark;
begin

    Registro := DM.carregarLogin.GetBookmark;
    if acao = 1 then begin //a�ao para o botao novo
       btnGravar.Enabled := false;
       btnCancelar.Enabled := true;
       btnEditar.Enabled := true;
    end else begin // a�ao para o botao editar
       btnEditar.Enabled := true;
       btnGravar.Enabled := false;
       btnCancelar.Enabled := true;
    end;
    txtNomeVendedor.Enabled := false;
    btnNovo.Enabled := true;
    btnExcluir.Enabled := true;
    btnCancelar.Enabled := false;
    gVendedores.Enabled := true;
    DM.carregarLogin.GotoBookmark(Registro);

end;

procedure TfVendedores.btnEditarClick(Sender: TObject);
begin
   txtNomeVendedor.Enabled := true;
    txtUsuario.Enabled := true;
    txtSenha.Enabled := true;
    btnGravar.Enabled := true;
    btnCancelar.Enabled := true;
    btnNovo.Enabled := false;
    gVendedores.Enabled := false;
    btnCancelar.Enabled := true;
    btnExcluir.Enabled := false;
    acao := 2; // 1 = INSERT 2 = UPDATE
end;

procedure TfVendedores.btnExcluirClick(Sender: TObject);
var
excluirDados, updateDados: TZQuery;
begin
  excluirDados := TZQuery.Create(nil);
  updateDados := TZQuery.Create(nil);
  if MessageDlg( 'Voc� realmente deseja excluir este vendedor?', mtInformation, [mbNo,mbYes], 0 ) <> mrYes then begin
      Abort;
  end;

  ExcultSQL('DROP TABLE '+DM.carregarLogin.FieldByName('TABELA').AsString);
  ExcultSQL('DROP TABLE '+DM.carregarLogin.FieldByName('TABELA').AsString+'_controle');
  excluirDados.SQL.Clear;
  excluirDados.Close;
  excluirDados.Connection := DM.conexao;
  excluirDados.SQL.Add('DELETE FROM login WHERE IDLOGIN = "'+DM.carregarLogin.FieldByName('IDLOGIN').AsString+'"');
  excluirDados.ExecSQL;

  DM.carregarLogin.Active := True;
  DM.carregarLogin.Refresh;


  Application.MessageBox('Dados Excluido com sucesso!', 'SKY PAINEL',MB_OK + MB_ICONWARNING);

end;

procedure TfVendedores.btnGravarClick(Sender: TObject);
var
criarTabela, inserirDados: TZQuery;
begin

    if (txtNomeVendedor.Text = '') then begin
        Application.MessageBox('Informe o Nome do vendedor', 'SKY PAINEL',MB_OK + MB_ICONWARNING);
        txtNomeVendedor.SetFocus;
        abort;
    end;

      DM.qrValidar.SQL.Clear;
      DM.qrValidar.Close;
      DM.qrValidar.SQL.Add('SELECT * FROM login WHERE LOGIN = :login');
      DM.qrValidar.ParamByName('login').AsString := txtUsuario.Text;
      DM.qrValidar.Open;

    inserirDados := TZQuery.Create(nil);

    if acao = 1 then begin //a�ao para o botao novo
        //barra se existir o usuario cadastrado
        if (DM.qrValidar.RecordCount > 0) then begin
            Application.MessageBox('Este Vendedor j� existe!','SKY PAINEL', MB_OK + MB_ICONWARNING);
            txtNomeVendedor.Text := '';
            txtNomeVendedor.SetFocus;
            Abort;
        end;

        inserirDados.SQL.Clear;
        inserirDados.Close;
        inserirDados.Connection := DM.conexao;
        inserirDados.Connection.Connect;
        inserirDados.SQL.Add('INSERT INTO login (nome,login,senha,tabela)VALUES(:nome,:login,:senha,:tabela)');
        inserirDados.ParamByName('nome').AsString := txtNomeVendedor.Text;
        inserirDados.ParamByName('login').AsString := RemoverCaracteresEspeciais(txtUsuario.Text);
        inserirDados.ParamByName('senha').AsString := txtSenha.Text;
        inserirDados.ParamByName('tabela').AsString := RemoverCaracteresEspeciais(txtUsuario.Text);
        inserirDados.ExecSQL;

        crearTabele;
    end else begin // a�ao para o botao editar

        // Verifica se o nome Atual e igual o nome Antigo
        if (txtUsuario.Text <> DM.carregarLogin.FieldByName('login').AsString) then begin
            if (DM.qrValidar.RecordCount > 0) then begin
              Application.MessageBox('Este usuario j� esta cadastro!','SKY PAINEL', MB_OK + MB_ICONWARNING);
              txtNomeVendedor.Text := '';
              Abort;
            end;
        end;


        inserirDados.SQL.Clear;
        inserirDados.Close;
        inserirDados.Connection := DM.conexao;
        inserirDados.Connection.Connect;
        inserirDados.SQL.Add('UPDATE login SET login = :login, senha = :senha  WHERE IDLOGIN = :id');
        inserirDados.ParamByName('login').AsString := RemoverCaracteresEspeciais(txtUsuario.Text);
        inserirDados.ParamByName('senha').AsString := txtSenha.Text;
        inserirDados.ParamByName('id').AsString := DM.carregarLogin.FieldByName('IDLOGIN').AsString;
        inserirDados.ExecSQL;
    end;
    btnGravar.Enabled := false;
    btnNovo.Enabled := true;
    btnEditar.Enabled := true;
    btnExcluir.Enabled := true;
    btnCancelar.Enabled := false;
    txtNomeVendedor.Enabled := false;
    gVendedores.Enabled := true;

    DM.carregarLogin.Active := True;
    DM.carregarLogin.Refresh;

    lblRecount.Caption := 'Dados importado com sucesso!';
    Gauge1.MaxValue := 0;

    Application.MessageBox('Dados registrados com sucesso!','SKY PAINEL', MB_OK + MB_ICONINFORMATION);

end;

procedure TfVendedores.btnNovoClick(Sender: TObject);
begin
    txtNomeVendedor.Text := '';
    txtUsuario.Text := '';
    txtSenha.Text := '';
    txtNomeVendedor.Enabled := true;
    txtUsuario.Enabled := true;
    txtSenha.Enabled := true;
    btnGravar.Enabled := true;
    btnCancelar.Enabled := true;
    btnNovo.Enabled := false;
    gVendedores.Enabled := false;
    btnCancelar.Enabled := true;
    btnExcluir.Enabled := false;
    btnEditar.Enabled := false;
    txtNomeVendedor.SetFocus;
    acao := 1; // 1 = INSERT 2 = UPDATE
end;

procedure TfVendedores.FormActivate(Sender: TObject);
begin
  acao := 0;
end;

procedure TfVendedores.crearTabele;
var
criarTabela, comparacao, inserir: TZQuery;
nomeTabela:string;
i,tTotalRegistro:integer;
begin

     criarTabela := TZQuery.Create(nil);
     comparacao := TZQuery.Create(nil);
     inserir := TZQuery.Create(nil);
    nomeTabela := RemoverCaracteresEspeciais(txtUsuario.Text);
    with criarTabela do begin
      Connection := DM.conexao;
      Connection.Connect;
      SQL.Clear;
      Close;
      ExcultSQL('DROP TABLE IF EXISTS '+nomeTabela);
      ExcultSQL('CREATE TABLE `'+nomeTabela+'` ( '
                  +'`ID` int(11) NOT NULL AUTO_INCREMENT,'
                  +'`MILHAR` int(4) NOT NULL,'
                  +'`CLIENTEID` int(11) DEFAULT NULL,'
                  +'PRIMARY KEY (`ID`) USING BTREE'
                  +') ENGINE=InnoDB AUTO_INCREMENT=0 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;');

      Close;
    end;

    with comparacao do begin
      Connection := DM.conexao;
      Connection.Connect;
      SQL.Clear;
      Close;
      SQL.Add('SELECT MILHAR FROM misturada');
      open;
    end;

    lblRecount.Visible := True;
    tTotalRegistro := comparacao.RecordCount;
    Gauge1.MaxValue := tTotalRegistro;
    i := 1;
    while not comparacao.Eof do begin
        with inserir do begin
              Connection := DM.conexao;
              Connection.Connect;
              SQL.Clear;
              Close;
              SQL.Add('INSERT INTO '+nomeTabela+' (MILHAR,CLIENTEID)VALUE(:MI,:CLIENTEID)');
              ParamByName('MI').AsString := comparacao.FieldByName('MILHAR').AsString;
              ParamByName('CLIENTEID').AsInteger := 1;
              ExecSQL;
         end;
         comparacao.Next;
         Gauge1.Progress := Gauge1.Progress + 1;
         lblRecount.Caption := 'Aguarde, Importando milhar para o vendedor ('+txtNomeVendedor.Text+'): ' + IntToStr(i) + ' de ' + IntToStr(tTotalRegistro) + ' registros';
         lblRecount.Update;
         i := i + 1;
      end;

//     with criarTabela do begin
//      Connection := fPrincipal.conexao;
//      Connection.Connect;
//      SQL.Clear;
//      Close;
//      ExcultSQL('DROP TABLE IF EXISTS '+RemoverCaracteresEspeciais(txtUsuario.Text)+'_controle');
//      ExcultSQL('CREATE TABLE `'+RemoverCaracteresEspeciais(txtUsuario.Text)+'_controle` ( '
//                  +'`ID` int(11) NOT NULL AUTO_INCREMENT,'
//                  +'`NC_INICIAL` int(11) NOT NULL,'
//                  +'`NC_FINAL` int(11) DEFAULT NULL,'
//                  +'`TOTAL_MILHAR` int(11) DEFAULT NULL,'
//                  +'`ID_VENDEDOR` int(11) DEFAULT NULL,'
//                  +'PRIMARY KEY (`ID`) USING BTREE'
//                  +') ENGINE=InnoDB AUTO_INCREMENT=0 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;');
//
//      Close;
//    end;
end;

end.
