unit frmClientes;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, ZAbstractRODataset, ZAbstractDataset, ZDataset, StdCtrls, Grids,
  DBGrids;

type
  TfClientes = class(TForm)
    cbVendedores: TComboBox;
    Label2: TLabel;
    Label8: TLabel;
    Label6: TLabel;
    txtCliente: TEdit;
    btnExcluirCliente: TButton;
    btnEditaCliente: TButton;
    btnNovoCliente: TButton;
    Label7: TLabel;
    txtTotalMilhar: TEdit;
    btnCancelarCliente: TButton;
    btnSalvaCliente: TButton;
    gClientes: TDBGrid;
    carregarLoginCB: TZQuery;
    procedure FormActivate(Sender: TObject);
    procedure btnEditaClienteClick(Sender: TObject);
    procedure btnExcluirClienteClick(Sender: TObject);
    procedure btnNovoClienteClick(Sender: TObject);
    procedure btnSalvaClienteClick(Sender: TObject);
    procedure dsClientesDataChange(Sender: TObject; Field: TField);

    procedure updateClientes();
    procedure insertClientes();
    procedure btnCancelarClienteClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    acao: integer;
  end;

var
  fClientes: TfClientes;

implementation

uses frmPrincipal, frmDM;

{$R *.dfm}

procedure TfClientes.btnCancelarClienteClick(Sender: TObject);
var
  Registro: TBookmark;
begin

    Registro := DM.carregarClientes.GetBookmark;
    if acao = 1 then begin //a�ao para o botao novo
       btnSalvaCliente.Enabled := false;
       btnCancelarCliente.Enabled := true;
       btnEditaCliente.Enabled := true;
    end else begin // a�ao para o botao editar
       btnEditaCliente.Enabled := true;
       btnSalvaCliente.Enabled := false;
       btnCancelarCliente.Enabled := true;
    end;
    txtCliente.Enabled := false;
    btnNovoCliente.Enabled := true;
    btnExcluirCliente.Enabled := true;
    btnCancelarCliente.Enabled := false;
    gClientes.Enabled := true;
    DM.carregarClientes.GotoBookmark(Registro);

end;

procedure TfClientes.btnEditaClienteClick(Sender: TObject);
begin

    btnSalvaCliente.Enabled := true;
    btnCancelarCliente.Enabled := true;
    btnNovoCliente.Enabled := false;
    gClientes.Enabled := false;
    btnExcluirCliente.Enabled := false;
    cbVendedores.Enabled := true;

    txtCliente.Enabled := true;
    txtTotalMilhar.Enabled := true;
    txtCliente.SetFocus;
    acao := 2; // 1 = INSERT 2 = UPDATE
end;

procedure TfClientes.btnExcluirClienteClick(Sender: TObject);
var
excluirDados, updateDados: TZQuery;
begin
    excluirDados := TZQuery.Create(nil);
    updateDados := TZQuery.Create(nil);
  if MessageDlg( 'Voc� realmente deseja excluir este cliente?', mtInformation, [mbNo,mbYes], 0 ) <> mrYes then begin
      Abort;
  end;

  updateDados.SQL.Clear;
  updateDados.Close;
  updateDados.Connection :=  DM.conexao;
  updateDados.SQL.Add('UPDATE '+DM.carregarClientes.FieldByName('TABELA').AsString+' SET CLIENTEID = "0" WHERE CLIENTEID = "'+DM.carregarClientes.FieldByName('IDCLIENTE').AsString+'"');
  updateDados.ExecSQL;

  excluirDados.SQL.Clear;
  excluirDados.Close;
  excluirDados.Connection := DM.conexao;
  excluirDados.SQL.Add('DELETE FROM clientes WHERE IDCLIENTE = "'+DM.carregarClientes.FieldByName('IDCLIENTE').AsString+'"');
  excluirDados.ExecSQL;

  DM.carregarClientes.Active := True;
  DM.carregarClientes.Refresh;

  Application.MessageBox('Dados Excluido com sucesso!', 'SKY PAINEL',MB_OK + MB_ICONWARNING);

end;

procedure TfClientes.btnNovoClienteClick(Sender: TObject);
begin
    gClientes.Enabled := false;
    btnSalvaCliente.Enabled := true;
    btnNovoCliente.Enabled := false;
    gClientes.Enabled := false;
    btnCancelarCliente.Enabled := true;
    btnExcluirCliente.Enabled := false;
    btnEditaCliente.Enabled := false;
    cbVendedores.ItemIndex := cbVendedores.Items.IndexOf('');
    cbVendedores.Enabled := true;

    txtCliente.Enabled := true;
    txtTotalMilhar.Enabled := true;
    txtCliente.SetFocus;
    txtCliente.Text := '';
    txtTotalMilhar.Text := '';

    acao := 1; // 1 = INSERT 2 = UPDATE
end;

procedure TfClientes.btnSalvaClienteClick(Sender: TObject);
var
inserirDados: TZQuery;
id_vendedor:integer;
begin

    if (txtCliente.Text = '') then begin
        Application.MessageBox('Informe o Nome do cliente', 'SKY PAINEL',MB_OK + MB_ICONWARNING);
        txtCliente.SetFocus;
        abort;
    end;

    if (txtTotalMilhar.Text = '') then begin
        Application.MessageBox('Informe quantidade milhar', 'SKY PAINEL',MB_OK + MB_ICONWARNING);
        txtTotalMilhar.SetFocus;
        abort;
    end;

    id_vendedor := Integer( cbVendedores.Items.Objects[cbVendedores.ItemIndex ] );  //Pega o id do registro selecionado no combox

    DM.qrValidar.SQL.Clear;
    DM.qrValidar.Close;
    DM.qrValidar.SQL.Add('SELECT * FROM clientes WHERE NOME_CLIENTE = :n and VENDEDORID = :idc');
    DM.qrValidar.ParamByName('n').AsString := txtCliente.Text;
    DM.qrValidar.ParamByName('idc').AsInteger := id_vendedor;
    DM.qrValidar.Open;

    if acao = 1 then begin //a�ao para o botao novo
        insertClientes;
    end else begin // a�ao para o botao editar
        updateClientes;
    end;

    btnSalvaCliente.Enabled := false;
    btnNovoCliente.Enabled := true;
    btnEditaCliente.Enabled := true;
    btnExcluirCliente.Enabled := true;
    btnCancelarCliente.Enabled := false;
    txtCliente.Enabled := false;
    gClientes.Enabled := true;
    txtCliente.Enabled := false;
    DM.carregarClientes.Active := True;
    DM.carregarClientes.Refresh;

    Application.MessageBox('Dados cadastrado com sucesso!','SKY PAINEL', MB_OK + MB_ICONINFORMATION);

end;

procedure TfClientes.dsClientesDataChange(Sender: TObject; Field: TField);
begin

    txtCliente.Text := DM.carregarClientes.FieldByName('NOME_CLIENTE').AsString;
    txtTotalMilhar.Text := DM.carregarClientes.FieldByName('TOTAL_MILHAR').AsString;
    cbVendedores.ItemIndex := cbVendedores.Items.IndexOf(DM.carregarClientes.FieldByName('idlogin').AsString+' - '+DM.carregarClientes.FieldByName('nome').AsString);

  if (acao = 1) then begin
      txtCliente.Text := '';
  end;
end;

procedure TfClientes.FormActivate(Sender: TObject);
var
item_combo:string;
begin
  with carregarLoginCB do
  begin
    Open;
    while not Eof do
    begin
        item_combo := FieldByName('idlogin').AsString + ' - ' + FieldByName('nome').AsString;
        cbVendedores.Items.AddObject(item_combo, TObject(FieldByName('idlogin').AsInteger));
      Next;
    end;
  end;
  DM.carregarClientes.Active := True;
  acao := 0;
end;

procedure TfClientes.insertClientes;
var
inserirDados: TZQuery;
id_vendedor: integer;
begin
    id_vendedor := integer(cbVendedores.Items.Objects[cbVendedores.ItemIndex]);
    // Pega o id do registro selecionado no combox
    inserirDados := TZQuery.Create(nil);
    // barra se existir o usuario cadastrado
    if (DM.qrValidar.RecordCount > 0) then
    begin
      Application.MessageBox('Este cliente j� existe para esse vendedor!',
        'SKY PAINEL', MB_OK + MB_ICONWARNING);
      txtCliente.Text := '';
      txtCliente.SetFocus;
      Abort;
    end;

    inserirDados.SQL.Clear;
    inserirDados.Close;
    inserirDados.Connection :=  DM.conexao;
    inserirDados.Connection.Connect;
    inserirDados.SQL.Add('INSERT INTO clientes (NOME_CLIENTE,VENDEDORID,TOTAL_MILHAR)VALUES(:nome,:id,:TM)');
    inserirDados.ParamByName('nome').AsString := txtCliente.Text;
    inserirDados.ParamByName('ID').AsInteger := id_vendedor;
    inserirDados.ParamByName('TM').AsString := txtTotalMilhar.Text;
    inserirDados.ExecSQL;
end;

procedure TfClientes.updateClientes;
var
inserirDados: TZQuery;
id_vendedor: integer;
begin
    id_vendedor := integer(cbVendedores.Items.Objects[cbVendedores.ItemIndex]);
    inserirDados := TZQuery.Create(nil);
    inserirDados.SQL.Clear;
    inserirDados.Close;
    inserirDados.SQL.Add('UPDATE clientes SET NOME_CLIENTE = :nome, VENDEDORID = :vid, TOTAL_MILHAR = :TM WHERE IDCLIENTE = :idc');
    inserirDados.Connection := DM.conexao;
    inserirDados.Connection.Connect;
    // Verifico se o nome Atual e igual o nome Antigo
    if (txtCliente.Text <> DM.carregarClientes.FieldByName('NOME_CLIENTE').AsString) then
    begin
      if (DM.qrValidar.RecordCount > 0) then begin
        Application.MessageBox('Este cliente j� existe para esse vendedor!','SKY PAINEL', MB_OK + MB_ICONWARNING);
        txtCliente.Text := '';
        Abort;
      end;
    end;

    inserirDados.ParamByName('nome').AsString := txtCliente.Text;
    inserirDados.ParamByName('idc').AsString := DM.carregarClientes.FieldByName('IDCLIENTE').AsString;
    inserirDados.ParamByName('vid').AsInteger := id_vendedor;
    inserirDados.ParamByName('TM').AsString := txtTotalMilhar.Text;
    inserirDados.ExecSQL;
end;
end.
