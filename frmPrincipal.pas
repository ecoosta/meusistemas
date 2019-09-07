unit frmPrincipal;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, Menus, StdCtrls, DB, ZAbstractRODataset, ZAbstractDataset,
  ZDataset, Grids, DBGrids, ZAbstractConnection, ZConnection, base, Gauges;

type
  TfPrincipal = class(TForm)
    sbPrincipal: TStatusBar;
    gbprocesso: TGroupBox;
    Label16: TLabel;
    Label15: TLabel;
    btnProcessamento: TButton;
    cbVendedoresProcessamento: TComboBox;
    cbClientesPrecessamento: TComboBox;
    btnF1: TButton;
    menu: TMainMenu;
    Cadastros1: TMenuItem;
    mcVendedores: TMenuItem;
    mcClientes: TMenuItem;
    mcMilhar: TMenuItem;
    AreadeImpressao1: TMenuItem;
    btnOrganizaDados: TButton;
    txtTabela: TEdit;
    Button1: TButton;
    gTipo: TGroupBox;
    rEscolhido: TRadioButton;
    rTodos: TRadioButton;
    prg: TGauge;
    lblRecount: TLabel;
    Gauge1: TGauge;
    lblMsg: TLabel;
    Ajuda1: TMenuItem;
    Button2: TButton;
    Button3: TButton;
    ZQuery1: TZQuery;
    ZQuery2: TZQuery;
    rvazio: TLabel;
    rCapas: TRadioButton;
    Button4: TButton;
    btntran: TButton;
    Button5: TButton;
    GroupBox1: TGroupBox;
    lblQuebras: TLabel;
    lblEscolhidas: TLabel;
    lblAvulsos: TLabel;
    Consulta1: TMenuItem;
    Premios1: TMenuItem;
    procedure tabVendedoresShow(Sender: TObject);
    procedure btnExcluirClick(Sender: TObject);
    procedure TabSheet4Show(Sender: TObject);
    procedure mcVendedoresClick(Sender: TObject);
    procedure mcClientesClick(Sender: TObject);
    procedure mcMilharClick(Sender: TObject);
    procedure btnProcessamentoClick(Sender: TObject);
    procedure cbVendedoresProcessamentoChange(Sender: TObject);

    procedure organizatabela();
    procedure gerarTodos();
    procedure gerarEscolhido();
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure btnF1Click(Sender: TObject);
    procedure AreadeImpressao1Click(Sender: TObject);
    procedure btnOrganizaDadosClick(Sender: TObject);
    procedure cbClientesPrecessamentoChange(Sender: TObject);
    procedure cbVendedoresProcessamento2Change(Sender: TObject);

    procedure gerarCapasEscolhidas();
    procedure gerarCapas();
    procedure geraBackup();
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btntranClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure rEscolhidoClick(Sender: TObject);
    procedure rTodosClick(Sender: TObject);
    procedure Ajuda1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure conexaoAcess();
    procedure Button4Click(Sender: TObject);
    procedure rCapasClick(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Consulta1Click(Sender: TObject);
    procedure Premios1Click(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
    acao,nivel_acesso: integer;
    funcao: boolean;
  end;

var
  fPrincipal: TfPrincipal;

implementation

uses frmVendedores, frmClientes, frmMilhar, frmLogin, frmProcessamentoArquivo,
  frmDM, frmInfor, frmConsulta, frmPremios;

{$R *.dfm}


procedure TfPrincipal.Ajuda1Click(Sender: TObject);
begin
  Application.CreateForm(TfInfor, fInfor);
  fInfor.ShowModal;
  fInfor.Free;
end;

procedure TfPrincipal.AreadeImpressao1Click(Sender: TObject);
begin
   Application.CreateForm(TfProcessamentoArquivo, fProcessamentoArquivo);
  fProcessamentoArquivo.ShowModal;
  fProcessamentoArquivo.Free;
end;

procedure TfPrincipal.btnExcluirClick(Sender: TObject);
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

procedure TfPrincipal.btnF1Click(Sender: TObject);
var
listas: TStringList;
indice: integer;
begin
  if (gbprocesso.Visible = True) then begin
    gbprocesso.Visible := false;
    rEscolhido.Checked := false;
    rTodos.Checked := False;
  end else begin

  end;
    gbprocesso.Visible := True;
    btnF1.Enabled := false;

    cbClientesPrecessamento.Visible := False;
    Label15.Visible := False;
    cbClientesPrecessamento.ItemIndex := cbClientesPrecessamento.Items.IndexOf('');
    cbVendedoresProcessamento.ItemIndex := cbVendedoresProcessamento.Items.IndexOf('');
    gTipo.Visible := False;
end;

procedure TfPrincipal.btnProcessamentoClick(Sender: TObject);
begin

  if (rEscolhido.Checked = true) then begin

    if (cbClientesPrecessamento.Text = '') then begin
        Application.MessageBox('Informe um cliente primeiro para iniciar!','SKY PAINEL', MB_OK + MB_ICONWARNING);
        cbClientesPrecessamento.SetFocus;
        Abort;
    end;
    gerarEscolhido();
  end else if (rCapas.Checked = true) then begin
    gerarCapas();
  end else begin
    gerarTodos();
  end;

end;

procedure TfPrincipal.btntranClick(Sender: TObject);
var
qrMilhar, qrTransferencia,qrTruncate,criarTabela,qrSQL:TZQuery;
aTxt:textFile;
ttReg, i: integer;
begin

    qrMilhar := TZQuery.Create(nil);
    qrTransferencia := TZQuery.Create(nil);
    qrTruncate := TZQuery.Create(nil);
    criarTabela := TZQuery.Create(nil);

    qrSQL := TZQuery.Create(nil);
    if (TabExistsB('skypai19_eudomar', txtTabela.Text, qrSQL) = false ) then begin
      with criarTabela do begin
        Connection := DM.conexaoRemoto;
        Connection.Connect;
        SQL.Clear;
        Close;
        SQL.Add('CREATE TABLE `'+txtTabela.Text+'` ( '
                    +'`ID` int(11) NOT NULL AUTO_INCREMENT,'
                    +'`MILHAR` int(4) NOT NULL,'
                    +'`CLIENTEID` int(11) DEFAULT NULL,'
                    +'`NCONTROLE` VARCHAR(45) DEFAULT NULL,'
                    +'PRIMARY KEY (`ID`) USING BTREE'
                    +') ENGINE=InnoDB AUTO_INCREMENT=0 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;');

        ExecSQL;
      end;
    end;

    with qrMilhar do begin
        Connection := DM.conexao;
        Connection.Connect;
        Close;
        SQL.Add('SELECT * FROM '+txtTabela.Text);
        Open;
    end;

    ttReg := qrMilhar.RecordCount;

    Gauge1.MaxValue := ttReg;

    with qrTruncate do begin
        Connection := DM.conexaoRemoto;
        Connection.Connect;
        SQL.Add('TRUNCATE TABLE '+txtTabela.Text);
        ExecSQL;
    end;
    dm.mostrarMensageLabel('Aguarde, Limpando dados anteriores...', lblMsg);
    Sleep(6000);
    i := 1;
    while not qrMilhar.Eof do begin

        with qrTransferencia do begin
            Connection :=  DM.conexaoRemoto;
            Connection.Connect;
            SQL.Clear;
            SQL.Add('INSERT INTO '+txtTabela.Text+' (MILHAR, CLIENTEID, NCONTROLE)VALUES(:MILHAR, :IDV, :NCT)');
            ParamByName('MILHAR').AsString := qrMilhar.FieldByName('MILHAR').AsString;
            ParamByName('IDV').AsString := qrMilhar.FieldByName('CLIENTEID').AsString;
            ParamByName('NCT').AsString := qrMilhar.FieldByName('ID').AsString;
            ExecSQL;
        end;
         dm.mostrarMensageLabel('Aguarde, O processo de atualiza��o do banco online... ('+txtTabela.Text+')', lblMsg);
         dm.mostrarMensageLabel('Total de Registro: '+IntToStr(i)+' de '+IntToStr(ttReg), lblRecount);
         i := i + 1;

         Gauge1.Progress := Gauge1.Progress +1;
         qrMilhar.Next;
    end;
    ShowMessage(IntToStr(ttReg));
    Application.MessageBox('Algo nao encontrado','SKY PAINEL', MB_OK + MB_ICONWARNING);
end;

procedure TfPrincipal.Button1Click(Sender: TObject);
var
qrSQL:TZQuery;
begin
    qrSQL := TZQuery.Create(nil);
    if (TabExistsB('skypai19_eudomar', 'joao1', qrSQL) = false ) then begin
      ShowMessage('Tabela Existe');
     end else begin
      ShowMessage('Tabela n�o Existe');
    end;

end;

procedure TfPrincipal.Button2Click(Sender: TObject);
var
qrTBvendedor, qrTBMilhar,qrSQLTemp, qrSQL:TZQuery;
atxt:textfile;
i,j,id_clientes:integer;
tipoVendedor: string;
nTal, nPrf, nSomaNprf: LongInt;
begin
    lblRecount.Visible := true;
    DM.mostrarMensageLabel('Aguarde, Limpando tabela temporaria...', lblMsg);


    qrTBvendedor := TZQuery.Create(nil);
    qrTBMilhar := TZQuery.Create(nil);
    qrSQL := TZQuery.Create(nil);
    qrSQLTemp   := TZQuery.Create(nil);
    ExcultSQL('TRUNCATE TABLE t_temp3');


    DM.mostrarMensageLabel('Aguarde, obtendo os clientes do vendedor', lblMsg);

    //recuperar os vendedor do cleinte selecionado.
    with qrTBvendedor do begin
        Connection := DM.conexao;
        Connection.Connect;
        SQL.Clear;
        SQL.Add('SELECT * FROM t_temp order by LOTE,ID_TEMP ASC');
        Close;
        Open;
    end;

    prg.MaxValue := 100;
    DM.mostrarMensageLabel('Aguarde, Organizando dados na tabela...', lblMsg);
    prg.Progress := 25;
    //LOOP DE VENDEDORES
    while not qrTBvendedor.Eof do begin
      with qrSQL do begin
                  Connection := DM.conexao;
                  Connection.Connect;
                  SQL.Clear;
                  SQL.Add('INSERT INTO t_temp3 (ID_TEMP,MILHAR_TEMP,CLIENTE_TEMP,LOTE)VALUES(:ID_TEMP,:MILHAR_TEMP,:CLIENTE_TEMP,:LOTE)');
                  ParamByName('ID_TEMP').AsString := qrTBvendedor.FieldByName('ID_TEMP').AsString;
                  ParamByName('MILHAR_TEMP').AsString := qrTBvendedor.FieldByName('MILHAR_TEMP').AsString;
                  ParamByName('CLIENTE_TEMP').AsString := qrTBvendedor.FieldByName('CLIENTE_TEMP').AsString;
                  ParamByName('LOTE').AsString := qrTBvendedor.FieldByName('LOTE').AsString;
                  ExecSQL;
              end; // with qrSQL
              qrTBvendedor.Next;
    end; // loop vendedores
   Application.MessageBox('FIM DO PROCESSAMENTO!','SKY PAINEL', MB_OK + MB_ICONASTERISK);

end;

procedure TfPrincipal.Button3Click(Sender: TObject);
var
  tTotalRegistro, i: integer;
begin

  lblMsg.Visible := True;
  lblRecount.Visible := True;
  lblMsg.Caption := 'Aguarde, Processando comparacao...';

  ZQuery1.SQL.Clear;
  ZQuery1.Close;
  ZQuery1.SQL.Add('SELECT * FROM '+txtTabela.Text);
  ZQuery1.Open;

  tTotalRegistro := ZQuery1.RecordCount;
  prg.Visible := true;
  prg.MaxValue := tTotalRegistro;
  i := 1;

  while not ZQuery1.Eof do begin
    lblMsg.Update;
    ZQuery2.SQL.Clear;
    ZQuery2.Close;
    ZQuery2.SQL.Add('UPDATE comparacao SET status = "1" WHERE MILHAR = :MI');
    ZQuery2.ParamByName('MI').AsString := ZQuery1.FieldByName('MILHAR').AsString;
    ZQuery2.ExecSQL;
    ZQuery1.Next;
    prg.Progress := prg.Progress + 1;
    lblRecount.Caption := 'Comparando: ' + IntToStr(i) + ' de ' + IntToStr(tTotalRegistro) + ' registros';
    lblRecount.Update;
    i := i + 1;
  end;
  ZQuery1.Close;
  ZQuery2.Close;
  // pegamos o resto das milhar que nao temos e jogamos para a outra tabela
  prg.MaxValue := 0;

  ZQuery1.SQL.Clear;
  ZQuery1.Close;
  ZQuery1.SQL.Add('SELECT MILHAR, status FROM comparacao WHERE status = "0"');
  ZQuery1.Open;

  tTotalRegistro := ZQuery1.RecordCount;
  lblMsg.Caption := 'Aguarde, Processando registros...';
  prg.MaxValue := tTotalRegistro;

  while not ZQuery1.Eof do
  begin
    lblMsg.Update;
    ZQuery2.SQL.Clear;
    ZQuery2.Close;
    ZQuery2.SQL.Add('INSERT INTO '+txtTabela.Text+' (MILHAR)VALUES(:MI)');
    ZQuery2.ParamByName('MI').AsString := ZQuery1.FieldByName('MILHAR').AsString;
    ZQuery2.ExecSQL;
    ZQuery1.Next;

    prg.Progress := prg.Progress + 1;
    lblRecount.Caption := 'importando: ' + IntToStr(i) + ' de ' + IntToStr(tTotalRegistro) + ' registros';
    lblRecount.Update;
    i := i + 1;
  end;

  ShowMessage('FIM DO PROCESSO DE COMPARACAO');

end;

procedure TfPrincipal.Button4Click(Sender: TObject);
var
ListMilhar,tabelaVendedores:TZQuery;
id_vendedor:integer;
begin

   if (cbClientesPrecessamento.Text = '') then begin
      Application.MessageBox('Informe um cliente primeiro para iniciar!','SKY PAINEL', MB_OK + MB_ICONWARNING);
      Abort;
    end;

  conexaoAcess;
  try
  //deletando dados anteriores
    with DM.consultaSQL do begin
      Close;
      SQL.Clear;
      SQL.Add('DELETE FROM sorteio');
      ExecSQL;
      Close;
    end;

    id_vendedor := Integer( cbVendedoresProcessamento.Items.Objects[cbVendedoresProcessamento.ItemIndex ] );  //Pega o id do registro selecionado no combox
    //pego os cliente do vendedor
    tabelaVendedores := TZQuery.Create(nil);
    tabelaVendedores.Connection :=  DM.conexao;
    tabelaVendedores.SQL.Clear;
    tabelaVendedores.SQL.Add('SELECT * FROM login WHERE IDLOGIN = "' + IntToStr(id_vendedor)+ '"');
    tabelaVendedores.Close;
    tabelaVendedores.Open;

    ListMilhar := TZQuery.Create(nil);

    //importando dados para acess
    with ListMilhar do begin
      Connection :=  DM.conexao;
      Connection.Connect;
      SQL.Clear;
      Close;
      SQL.Add('SELECT * FROM ');
      SQL.Add(tabelaVendedores.FieldByName('tabela').AsString+' t');
      SQL.Add(' INNER JOIN clientes c ON c.idcliente = ');
      SQL.Add('t.CLIENTEID');
      Close;
      Open;
    end;
    prg.Visible := True;
    prg.MaxValue := ListMilhar.RecordCount;
    prg.Progress := 0;
    while not ListMilhar.eof do begin
      with DM.consultaSQL do begin
        Close;
        SQL.Clear;
        SQL.Add('INSERT INTO sorteio (IDCONTROLE,MILHAR,CLIENTE)VALUES(:ID,:MILHAR,:CLIENTE)');
        Parameters.ParamByName('ID').Value := ListMilhar.FieldByName('ID').AsString;
        Parameters.ParamByName('MILHAR').Value := ListMilhar.FieldByName('MILHAR').AsString;
        Parameters.ParamByName('CLIENTE').Value := ListMilhar.FieldByName('NOME_CLIENTE').AsString;
        ExecSQL;
      end;
      prg.Progress := prg.Progress + 1;
      ListMilhar.Next;
    end;

   except on e : exception do  begin
      rvazio.Visible := true;
      rvazio.Caption := 'Sem Conex�o de BANCO DE DADOS CONFIG: '+ e.message;
      abort;
    end;
  end;
  Application.MessageBox('Fim de Importa��o', 'SKY PAINEL',MB_OK + MB_ICONWARNING);
end;

procedure TfPrincipal.Button5Click(Sender: TObject);
begin
    gbprocesso.Visible := false;
    btnF1.Enabled := True;
    cbClientesPrecessamento.Visible := False;
    Label15.Visible := False;
    cbClientesPrecessamento.ItemIndex := cbClientesPrecessamento.Items.IndexOf('');
    cbVendedoresProcessamento.ItemIndex := cbVendedoresProcessamento.Items.IndexOf('');
    gTipo.Visible := False;
end;

procedure TfPrincipal.btnOrganizaDadosClick(Sender: TObject);
begin
    if (cbVendedoresProcessamento.Text = '') then begin
        Application.MessageBox('Informe um Vendedor primeiro para iniciar!', 'SKY PAINEL',MB_OK + MB_ICONWARNING);
        cbVendedoresProcessamento.SetFocus;
        abort;
    end;
    geraBackup();
    organizatabela();
end;

procedure TfPrincipal.cbClientesPrecessamentoChange(Sender: TObject);
begin
  btnProcessamento.Visible := True;
  btnProcessamento.Enabled := true;
end;

procedure TfPrincipal.cbVendedoresProcessamento2Change(Sender: TObject);
var
id_vendedor,tClientes:integer;
tabelaVendedores,tabelaClientes,qQuebra:TZQuery;
item_combo_cliente:string;
begin

  cbClientesPrecessamento.Clear;

  id_vendedor := Integer( cbVendedoresProcessamento.Items.Objects[cbVendedoresProcessamento.ItemIndex ] );  //Pega o id do registro selecionado no combox

  try
    tabelaVendedores := TZQuery.Create(nil);
    tabelaVendedores.Connection :=  DM.conexao;
    tabelaVendedores.SQL.Clear;
    tabelaVendedores.SQL.Add('SELECT * FROM login WHERE IDLOGIN = "' + IntToStr(id_vendedor)+ '"');
    tabelaVendedores.Close;
    tabelaVendedores.Open;
    txtTabela.Text := tabelaVendedores.FieldByName('tabela').AsString;

    btntran.Enabled := true;
   except on e : exception do  begin
      rvazio.Visible := true;
      rvazio.Left := 16;
      rvazio.Top := 74;
      rvazio.Caption := 'Sem Conex�o de BANCO DE DADOS CONFIG: '+ e.message;
      abort;
    end;
  end;
end;

procedure TfPrincipal.cbVendedoresProcessamentoChange(Sender: TObject);
var
id_vendedor,tClientes:integer;
tabelaVendedores,tabelaClientes,qQuebra,qAvulsos,qEscolhidas:TZQuery;
item_combo_cliente:string;
begin
  gTipo.Visible := false;
  cbClientesPrecessamento.Clear;

  id_vendedor := Integer( cbVendedoresProcessamento.Items.Objects[cbVendedoresProcessamento.ItemIndex ] );  //Pega o id do registro selecionado no combox

  tabelaVendedores := TZQuery.Create(nil);
  tabelaVendedores.Connection :=  DM.conexao;
  tabelaVendedores.SQL.Clear;
  tabelaVendedores.SQL.Add('SELECT * FROM login WHERE IDLOGIN = "' + IntToStr(id_vendedor)+ '"');
  tabelaVendedores.Close;
  tabelaVendedores.Open;
  txtTabela.Text := tabelaVendedores.FieldByName('tabela').AsString;


  if (tabelaVendedores.RecordCount > 0) then begin

    tabelaClientes := TZQuery.Create(nil);
    with tabelaClientes do begin
      Connection := DM.conexao;
      Connection.Connect;
      SQL.Clear;
      Close;
      SQL.Add('SELECT * FROM clientes c WHERE VENDEDORID IN (' + tabelaVendedores.FieldByName('IDLOGIN').AsString + ',0)');
      Close;
      Open;

      while not Eof do begin
          item_combo_cliente := FieldByName('idcliente').AsString + ' - ' + FieldByName('nome_cliente').AsString;
          cbClientesPrecessamento.Items.AddObject(item_combo_cliente, TObject(FieldByName('idcliente').AsInteger));
        Next;
      end;

       lblEscolhidas.Caption := 'Total Escolhida: '+ dm.querySQLCount('SELECT * FROM '+txtTabela.Text+' where clienteid <> 1 AND clienteid <> 6');
       lblQuebras.Caption := 'Total Quebra: '+ dm.querySQLCount('SELECT * FROM '+txtTabela.Text+' where clienteid = 6');
       lblAvulsos.Caption := 'Total Avulso: '+ dm.querySQLCount('SELECT * FROM '+txtTabela.Text+' where clienteid = 1');
    end;

    tClientes := tabelaClientes.RecordCount;

    //cbClientesPrecessamento.Enabled := True;
    btnOrganizaDados.Enabled := True;

    if MessageDlg( 'Voc� deseja Organizar os dados para esse Vendedor?', mtInformation, [mbNo,mbYes], 0 ) <> mrYes then begin
      gTipo.Visible := True;
    end else  begin
      btnOrganizaDados.Left := 17;
      btnOrganizaDados.Top := 76;
      btnOrganizaDados.Visible := True;
    end;

      lblEscolhidas.Visible := true;
      lblQuebras.Visible := true;
      lblAvulsos.Visible := true;
  end
  else
  begin
    cbClientesPrecessamento.TextHint := 'Cliente n�o encontrado.';
    cbClientesPrecessamento.ItemIndex := cbClientesPrecessamento.Items.IndexOf('');
    abort;
  end;
end;

procedure TfPrincipal.conexaoAcess;
var
cDir: string;
begin
    cDir := ExtractFilePath(Application.ExeName);
    with DM.conexaoAcess do begin
        ConnectionString :=
        'Provider=Microsoft.Jet.OLEDB.4.0;'
        +'User ID=Admin;'
        +'Data Source='+cDir+'\consulta.mdb;'
        +'Mode=Share Deny None;'
        +'Jet OLEDB:System database="";'
        +'Jet OLEDB:Registry Path="";'
        +'Jet OLEDB:Database Password="182689";'
        +'Jet OLEDB:Engine Type=5;'
        +'Jet OLEDB:Database Locking Mode=1;'
        +'Jet OLEDB:Global Partial Bulk Ops=2;'
        +'Jet OLEDB:Global Bulk Transactions=1;'
        +'Jet OLEDB:New Database Password="";'
        +'Jet OLEDB:Create System Database=False;'
        +'Jet OLEDB:Encrypt Database=False;'
        +'Jet OLEDB:Don'+chr(39)+'t Copy Locale on Compact=False;'
        +'Jet OLEDB:Compact Without Replica Repair=False;'
        +'Jet OLEDB:SFP=False';
    end;
end;

procedure TfPrincipal.Consulta1Click(Sender: TObject);
begin
  Application.CreateForm(TfConsulta, fConsulta);
  fConsulta.ShowModal;
  fConsulta.Free;
end;

procedure TfPrincipal.FormActivate(Sender: TObject);
var
item_combo,item_id_combo:string;
begin

  with DM.carregarLogin do
  begin
    Open;
    while not Eof do
    begin
        item_combo := FieldByName('idlogin').AsString + ' - ' + FieldByName('nome').AsString;
        item_id_combo := FieldByName('idlogin').AsString + ' - ' + FieldByName('nome').AsString;
        cbVendedoresProcessamento.Items.AddObject(item_combo, TObject(FieldByName('idlogin').AsInteger));
      Next;
    end;
  end;
  DM.carregarClientes.Active := True;

end;

procedure TfPrincipal.FormClose(Sender: TObject; var Action: TCloseAction);
var
ucesso:TZQuery;
begin
ucesso := TZQuery.Create(nil);
  with ucesso do
  begin
    Connection := dm.conexao;
    Connection.Connect;
    SQL.Clear;
    Close;
    SQL.Add('UPDATE acesso SET ultimoacesso = :uacesso where id = :id');
    ParamByName('uacesso').AsString := FormatDateTime('yyyy-mm-dd hh:mm:ss',now);
    ParamByName('id').AsInteger := DM.Acesso.FieldByName('id').AsInteger;
    ExecSQL;
  end;

end;

procedure TfPrincipal.FormCreate(Sender: TObject);
begin
//   flogin := Tflogin.Create(nil);
//   if (flogin.ShowModal = 1) then
//   begin
//   FreeAndNil(flogin);
//   end;
end;

procedure TfPrincipal.FormShow(Sender: TObject);
begin
    nivel_acesso := DM.acesso.FieldByName('nivel').AsInteger;
    if nivel_acesso = 0 then  begin
      AreadeImpressao1.Visible := true
    end else begin
      AreadeImpressao1.Visible := false
    end;

    sbPrincipal.Panels[0].Text := DM.acesso.FieldByName('nome').AsString;
    sbPrincipal.Panels[1].Text := 'Ultimo Acesso: '+FormatDateTime('dd-mm-yyyy hh:mm:ss',DM.acesso.FieldByName('ULTIMOACESSO').AsDateTime);
    sbPrincipal.Panels[3].Text := 'Version: 1.8.2';
end;

procedure TfPrincipal.geraBackup;
var
qrBackup:TZQuery;
txt: TextFile;
begin
    qrBackup := TZQuery.Create(nil);
    dm.mostrarMensageLabel('Aguarde, Execultando backup da tabela ('+txtTabela.Text+'), Isto pode demora!', lblMsg);
    Sleep(3000);
    // criar o diretorio para guarda o banco txt, se ja existe o caminho ele nao criar
    if not DirectoryExists('backups') then
    begin
      CreateDir('backups');
    end;

    AssignFile(txt, 'backups/'+txtTabela.Text+'_'+RemoverCaracteresEspeciais(FormatDateTime('ddmmyyyy_hhmmss',now))+'.txt');
    Rewrite(txt);

    with qrBackup do begin
      Connection := DM.conexao;
      Connection.Connect;
      SQL.Clear;
      SQL.Add('SELECT * FROM '+txtTabela.Text +' t INNER JOIN clientes c ON c.IDCLIENTE = t.CLIENTEID');
      Close;
      Open;
      Gauge1.MaxValue := RecordCount;
      while not Eof do begin
        Writeln(txt,
            FieldByName('ID').AsString+';'+
            FieldByName('MILHAR').AsString+';'+
            FieldByName('NOME_CLIENTE').AsString+';'
        );
        Gauge1.Progress := prg.Progress + 1;
        Next;
      end
    end;
    dm.mostrarMensageLabel('Fim de backup!', lblMsg);
    Sleep(3000);
    CloseFile(txt);
end;

procedure TfPrincipal.gerarTodos;
var
  id_cliente, id_vendedor: integer;
  txt: TextFile;
  qrSQL, tempSQL: TZQuery;
  caminhoArquivo:string;
begin
  lblMsg.Visible := true;
  Gauge1.Visible := true;
  if (cbVendedoresProcessamento.Text = '') then
  begin
    Application.MessageBox('Informe o codigo ou nome do vendedor','SKY PAINEL', MB_OK + MB_ICONWARNING);
    cbVendedoresProcessamento.SetFocus;
    abort;
  end;
  qrSQL := TZQuery.Create(nil);
  tempSQL := TZQuery.Create(nil);

  id_vendedor := Integer( cbVendedoresProcessamento.Items.Objects[cbVendedoresProcessamento.ItemIndex ] );  //Pega o id do registro selecionado no combox

    caminhoArquivo :=  'producao/'+txtTabela.Text+'/';

    if not DirectoryExists(caminhoArquivo) then
    begin
      CreateDir('producao');
      CreateDir(caminhoArquivo);
    end;

  with qrSQL do //capturo todos os cliente do vendedor escolhido
  begin
    Connection := DM.conexao;
    Connection.Connect;
    SQL.Clear;
    Close;
    SQL.Add('SELECT * FROM clientes c WHERE VENDEDORID IN (' +IntToStr(id_vendedor)+ ',0)');
    Open;
    prg.MaxValue := RecordCount;

    while not Eof do begin
    Gauge1.MaxValue := 0;
    DM.mostrarMensageLabel('Aguarde, Processando: '+FieldByName('nome_cliente').AsString, lblMsg);
    AssignFile(txt, caminhoArquivo+FieldByName('nome_cliente').AsString+'.txt');  // Nome do arquivo
    Rewrite(txt);
    with tempSQL do begin //capturo dados do cliente
      Connection := DM.conexao;
      Connection.Connect;
      SQL.Clear;
      Close;
      SQL.Add('SELECT * FROM ' + txtTabela.Text+' t INNER JOIN clientes c ON c.IDCLIENTE = t.CLIENTEID');
      SQL.Add('WHERE CLIENTEID = "' +qrSQL.FieldByName('idcliente').AsString+'"');
      Open;
      Gauge1.MaxValue := tempSQL.RecordCount;
      while not tempSQL.eof do begin
        Writeln(txt,
          tempSQL.FieldByName('ID').AsString+';'+
          tempSQL.FieldByName('MILHAR').AsString+';'+
          tempSQL.FieldByName('NOME_CLIENTE').AsString+';'
        );
      Next;
      Gauge1.Progress := prg.Progress + 1;
      end; // loop milhar
    end;
    Next;
    CloseFile(txt);
    prg.Progress := prg.Progress + 1;
    end; // loop clientes
  end;
  Application.MessageBox('FIM DO PROCESSAMENTO!','SKY PAINEL', MB_OK + MB_ICONASTERISK);
end;

procedure TfPrincipal.gerarCapas;
var
qrSQLTemp, qrCapas:TZQuery;
atxt:textfile;
i,j,id_clientes, nTot, cini, cfim,nReg,nSoma:integer;
caminhoArquivo:string;
begin
    Gauge1.Visible := True;
    Gauge1.MaxValue := 100;
    DM.mostrarMensageLabel('Aguarde, gerando arquivo de capa avulsas',lblMsg);
    Sleep(5000);
    qrSQLTemp   := TZQuery.Create(nil);
    if (cbVendedoresProcessamento.Text = '') then begin
        Application.MessageBox('Escolha um Vendedor!', 'SKY PAINEL',MB_OK + MB_ICONWARNING);
        cbVendedoresProcessamento.SetFocus;
        abort;
    end;

    // Pegamos apenas as sobras
    with qrSQLTemp do begin
      Connection := DM.conexao;
      Connection.Connect;
      SQL.Clear;
      SQL.Add('SELECT *, count(*) as tt FROM '+txtTabela.Text+' t INNER JOIN clientes c ON c.IDCLIENTE = t.CLIENTEID');
      SQL.Add('WHERE CLIENTEID = 1 GROUP BY CLIENTEID ORDER BY ID ASC');
      Close;
      Open;
    end;

    caminhoArquivo :=  'producao/'+txtTabela.Text+'/';
    if not DirectoryExists(caminhoArquivo) then begin
      CreateDir('producao');
      CreateDir(caminhoArquivo);
    end;
    Gauge1.Progress := 50;
    AssignFile(atxt, caminhoArquivo+'/capas_avulsas.txt');
    Rewrite(atxt);

    nTot := qrSQLTemp.FieldByName('tt').AsInteger;
    cini :=  qrSQLTemp.FieldByName('ID').AsInteger;
//    cfim := (i + cini) -1;

     nSoma := (nTot div 100);

    for i := 0 to Trunc(nSoma) - 1 do begin
        nReg := (i * 100) + cini; // nao mexa   0*100+400+1
         Writeln(atxt,
            IntToStr(nReg)+';'+
            IntToStr(nReg + 100 -1)+';Avulsos;'+
            IntToStr(100)+';'
        );
        Continue;
    end;
    CloseFile(atxt);
    qrSQLTemp.Close;

    DM.mostrarMensageLabel('Aguarde, gerando arquivo de capa escolhidas',lblMsg);
    Sleep(5000);
    AssignFile(atxt, caminhoArquivo+ '/capas_escolhidas.txt');
    Rewrite(atxt);
    Gauge1.Progress := Gauge1.Progress + 50;
    // Pegamos apenas as escolhidas
    with qrSQLTemp do begin
       Connection := DM.conexao;
       Connection.Connect;
       SQL.Clear;
       SQL.Add('SELECT *, count(*) as tt FROM '+txtTabela.Text+' t INNER JOIN clientes c ON c.IDCLIENTE = t.CLIENTEID');
       SQL.Add('WHERE CLIENTEID <> 1 GROUP BY CLIENTEID ORDER BY ID ASC');
       Close;
       Open;

       while not Eof do
       begin
         i := FieldByName('tt').AsInteger;
         cini := FieldByName('ID').AsInteger;
         cfim := (i + cini) - 1;
         Writeln(atxt, IntToStr(cini) + ';' + IntToStr(cfim) + ';' + FieldByName('NOME_CLIENTE').AsString + ';' + IntToStr(i) + ';');
         Next;
       end;
    end;
    CloseFile(atxt);
    DM.mostrarMensageLabel('Fim de processo!',lblMsg);
    Application.MessageBox('Processo finalizado com sucesso!', 'SKY PAINEL',MB_OK + MB_ICONWARNING);
end;

procedure TfPrincipal.gerarCapasEscolhidas;
var
qrSQLTemp, qrCapas:TZQuery;
atxt:textfile;
i,j,id_clientes, nTot, cini, cfim:integer;
caminhoArquivo:string;
begin

    qrSQLTemp   := TZQuery.Create(nil);

    if (cbVendedoresProcessamento.Text = '') then begin
        Application.MessageBox('Informe um Vendedor primeiro para iniciar!', 'SKY PAINEL',MB_OK + MB_ICONWARNING);
        cbVendedoresProcessamento.SetFocus;
        abort;
    end;

     caminhoArquivo := 'C:/Users/'+usuarioWindows+'/Documents/';

    // criar o diretorio para guarda o banco txt, se ja existe o caminho ele nao criar
    if not DirectoryExists(caminhoArquivo+'arquivoBingo\') then
    begin
      CreateDir(caminhoArquivo+'arquivoBingo/');
    end;

    if not DirectoryExists(caminhoArquivo+'arquivoBingo\' + txtTabela.Text + '\') then
    begin
      CreateDir(caminhoArquivo+'arquivoBingo/' + txtTabela.Text + '/');
    end;

    AssignFile(atxt, caminhoArquivo+'arquivoBingo/' + txtTabela.Text + '/capas_escolhidas.txt');
    Rewrite(atxt);

    // Pegamos apenas as escolhidas
    with qrSQLTemp do begin
       Connection := DM.conexao;
       Connection.Connect;
       SQL.Clear;
       SQL.Add('SELECT *, count(*) as tt FROM '+txtTabela.Text+' t INNER JOIN clientes c ON c.IDCLIENTE = t.CLIENTEID');
       SQL.Add('WHERE CLIENTEID <> 1 GROUP BY CLIENTEID ORDER BY ID ASC');
       Close;
       Open;

       while not Eof do
       begin
         i := FieldByName('tt').AsInteger;
         cini := FieldByName('ID').AsInteger;
         cfim := (i + cini) - 1;
         Writeln(atxt, IntToStr(cini) + ';' + IntToStr(cfim) + ';' + FieldByName
             ('NOME_CLIENTE').AsString + ';' + IntToStr(i) + ';');
         Next;
       end;
    end;
    CloseFile(atxt);

end;

procedure TfPrincipal.gerarEscolhido;
var
  id_cliente, id_vendedor: integer;
  txt: TextFile;
  qrSQL, tempSQL: TZQuery;
  caminhoArquivo:string;
begin

  lblMsg.Visible := true;
  qrSQL := TZQuery.Create(nil);
  tempSQL := TZQuery.Create(nil);

  id_vendedor := Integer( cbVendedoresProcessamento.Items.Objects[cbVendedoresProcessamento.ItemIndex ] );  //Pega o id do registro selecionado no combox
  id_cliente := Integer( cbClientesPrecessamento.Items.Objects[cbClientesPrecessamento.ItemIndex ] );  //Pega o id do registro selecionado no combox

  caminhoArquivo :=  'producao/'+txtTabela.Text+'/';

   if not DirectoryExists(caminhoArquivo) then begin
      CreateDir('producao');
      CreateDir(caminhoArquivo);
    end;

    with tempSQL do begin //capturo dados do cliente
      Connection := DM.conexao;
      Connection.Connect;
      SQL.Clear;
      Close;
      SQL.Add('SELECT * FROM ' + txtTabela.Text+' t INNER JOIN clientes c ON c.IDCLIENTE = t.CLIENTEID');
      SQL.Add('WHERE CLIENTEID = "' +IntToStr(id_cliente)+'"');
      Open;
      Gauge1.MaxValue := tempSQL.RecordCount;

      AssignFile(txt, caminhoArquivo+FieldByName('nome_cliente').AsString+'.txt');  // Nome do arquivo
      Rewrite(txt);

      while not tempSQL.eof do begin
        Writeln(txt,
          tempSQL.FieldByName('ID').AsString+';'+
          tempSQL.FieldByName('MILHAR').AsString+';'+
          tempSQL.FieldByName('NOME_CLIENTE').AsString+';'
        );
      Next;
      Gauge1.Progress := prg.Progress + 1;
      end; // loop milhar
       CloseFile(txt);
    end;
  Application.MessageBox('FIM DO PROCESSAMENTO!','SKY PAINEL', MB_OK + MB_ICONASTERISK);
end;

procedure TfPrincipal.mcClientesClick(Sender: TObject);
begin
  Application.CreateForm(TfClientes, fClientes);
  fClientes.ShowModal;
  fClientes.Free;
end;

procedure TfPrincipal.mcMilharClick(Sender: TObject);
begin
  Application.CreateForm(TfMilhar, fMilhar);
  fMilhar.ShowModal;
  fMilhar.Free;
end;

procedure TfPrincipal.mcVendedoresClick(Sender: TObject);
begin
  Application.CreateForm(TfVendedores, fVendedores);
  fVendedores.ShowModal;
  fVendedores.Free;
end;

procedure TfPrincipal.organizatabela;
var
qrTBvendedor, qrTBMilhar,qrSQLTemp, qrSQL:TZQuery;
atxt:textfile;
i,j,id_clientes:integer;
tipoVendedor: string;
nTal, nPrf, nSomaNprf: LongInt;
begin
    lblRecount.Visible := true;
    DM.mostrarMensageLabel('Aguarde, Limpando tabela temporaria...', lblMsg);
    Sleep(3000);

    qrTBvendedor := TZQuery.Create(nil);
    qrTBMilhar := TZQuery.Create(nil);
    qrSQL := TZQuery.Create(nil);
    qrSQLTemp   := TZQuery.Create(nil);
    ExcultSQL('TRUNCATE TABLE temp_processamento');

    id_clientes := integer(cbVendedoresProcessamento.Items.Objects[cbVendedoresProcessamento.ItemIndex]);
    DM.mostrarMensageLabel('Aguarde, obtendo os clientes do vendedor', lblMsg);
    Sleep(3000);
    //recuperar os vendedor do cleinte selecionado.
    with qrTBvendedor do begin
        Connection := DM.conexao;
        Connection.Connect;
        SQL.Clear;
        SQL.Add('SELECT * FROM clientes WHERE VENDEDORID IN ('+IntToStr(id_clientes)+', 0)');
        Close;
        Open;
    end;

    prg.MaxValue := 100;
    DM.mostrarMensageLabel('Aguarde, Organizando dados na tabela...', lblMsg);
    prg.Progress := 25;
    //LOOP DE VENDEDORES
    while not qrTBvendedor.Eof do begin
        Gauge1.MaxValue := 0;
         //RECUPERAMOS AS MILHARES DO VENDEDOR CORRENTE NO LOOP
         tipoVendedor := qrTBvendedor.FieldByName('IDCLIENTE').AsString;

         if tipoVendedor = '6' then begin
            tipoVendedor := '1';
         end; //if

         with qrTBMilhar do begin
              Connection := DM.conexao;
              Connection.Connect;
              SQL.Clear;
              SQL.Add('SELECT * FROM '+txtTabela.Text+' WHERE CLIENTEID = "'+qrTBvendedor.FieldByName('IDCLIENTE').AsString+'" ');
              Close;
              Open;
          end; //with qrTBMilhar

          Gauge1.MaxValue := qrTBMilhar.RecordCount;
          //Writeln(atxt, INTTOSTR(qrTBMilhar.RecordCount));
          //LOOP DE MILHAR DOS VENDEDORES
          while not qrTBMilhar.Eof do begin
              with qrSQL do begin
                  Connection := DM.conexao;
                  Connection.Connect;
                  SQL.Clear;
                  SQL.Add('INSERT INTO temp_processamento (MILHAR_TEMP,IDV_TEMP)VALUES(:MT,:IDVT)');
                  ParamByName('MT').AsString := qrTBMilhar.FieldByName('MILHAR').AsString;
                  ParamByName('IDVT').AsString := tipoVendedor;
                  ExecSQL;
              end; // with qrSQL
              qrTBMilhar.Next;
              //Writeln(atxt, qrTBMilhar.FieldByName('MILHAR').AsString);
              Gauge1.Progress := Gauge1.Progress + 1;
          end;  // loop dados clientes
        qrTBvendedor.Next;
        i := i + 1;
        //Writeln(atxt, qrTBvendedor.FieldByName('nome').AsString+';'); //PEGA O NOME DO VENDEDORES
        //prg.Progress := prg.Progress + 1;
    end; // loop vendedores

    //resentando alguns componentes
    qrTBvendedor.Close;
    qrTBMilhar.Close;
    qrSQL.Close;

    i := 1;
    Gauge1.MaxValue := 0;
    prg.Progress := 50;
    //limpando tabela original
    ExcultSQL('TRUNCATE TABLE '+txtTabela.Text);
    // retornamos os dados da tabela temp para a tabela origina.
    with qrSQLTemp do begin
       Connection := DM.conexao;
       Connection.Connect;
       SQL.Clear;
       SQL.Add('SELECT * FROM temp_processamento ORDER BY idv_temp DESC');
       Close;
       Open;
    end; // qrSQLTemp
    DM.mostrarMensageLabel('Aguarde, Recuperando dados orginal...', lblMsg);

    nTal := qrSQLTemp.RecordCount;
    Gauge1.MaxValue := nTal;
    while not qrSQLTemp.Eof do  begin
        with qrSQL do begin
          Connection := DM.conexao;
          Connection.Connect;
          SQL.Clear;
          SQL.Add('INSERT INTO '+txtTabela.Text+' (MILHAR,CLIENTEID)VALUES(:M,:IDV)');
          ParamByName('M').AsString := qrSQLTemp.FieldByName('MILHAR_TEMP').AsString;
          ParamByName('IDV').AsString := qrSQLTemp.FieldByName('IDV_TEMP').AsString;
          ExecSQL;
        end;
        qrSQLTemp.Next;
        Gauge1.Progress := Gauge1.Progress + 1;

        if (CacularArredodamento(nTal) > StrToBool('0')) then  begin
          nSomaNprf := (nTal div 200);
        end else begin
          nSomaNprf := (nTal div 200) + 1;
        end;

        i := i + 1;
        if i = 5000 then begin
          prg.Progress := prg.Progress + 25;
        end;

        if i = 9999 then begin
          DM.mostrarMensageLabel('Aguarde, Finalizando...', lblRecount);
          prg.Progress := prg.Progress + 25;
          Sleep(3000);
        end;
    end;
   DM.mostrarMensageLabel('Aguarde, estamos finalizando o processo!', lblMsg);
   Sleep(3000);
   btnOrganizaDados.Visible := False;
   gTipo.Visible := True;
   DM.mostrarMensageLabel('Fim do processo', lblRecount);
   DM.mostrarMensageLabel('Finalizado!', lblMsg);
   Application.MessageBox('FIM DO PROCESSAMENTO!','SKY PAINEL', MB_OK + MB_ICONASTERISK);
end;

procedure TfPrincipal.Premios1Click(Sender: TObject);
begin
  Application.CreateForm(TfPremios, fPremios);
  fPremios.ShowModal;
  fPremios.Free;
end;

procedure TfPrincipal.rCapasClick(Sender: TObject);
begin
  btnProcessamento.Visible := True;
  btnProcessamento.Enabled := true;
end;

procedure TfPrincipal.rEscolhidoClick(Sender: TObject);
begin
    Label15.Visible := True;
    cbClientesPrecessamento.Visible := True;
    cbClientesPrecessamento.Enabled := True;
end;

procedure TfPrincipal.rTodosClick(Sender: TObject);
begin
  btnProcessamento.Visible := false;
  Label15.Visible := False;
  cbClientesPrecessamento.Visible := False;
  cbClientesPrecessamento.Enabled := False;
  cbClientesPrecessamento.ItemIndex := cbClientesPrecessamento.Items.IndexOf('') ;
  btnProcessamento.Visible := true;

    btnProcessamento.Visible := True;
  btnProcessamento.Enabled := true;
end;

procedure TfPrincipal.tabVendedoresShow(Sender: TObject);
begin
    DM.carregarLogin.Active := True;
end;

procedure TfPrincipal.TabSheet4Show(Sender: TObject);
var
item_combo:string;
begin
  with DM.carregarLogin do
  begin
    Open;
    while not Eof do
    begin
        item_combo := FieldByName('idlogin').AsString + ' - ' + FieldByName('nome').AsString;
        cbVendedoresProcessamento.Items.AddObject(item_combo, TObject(FieldByName('idlogin').AsInteger));
      Next;
    end;
  end;
end;

end.
