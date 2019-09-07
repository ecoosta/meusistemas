unit frmAtualizarBancoOnline;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, pngimage, ExtCtrls, Gauges, StdCtrls, dblookup, DB,
  ZAbstractRODataset, ZAbstractDataset, ZDataset, Grids, DBGrids, BASE,
  ZAbstractConnection, ZConnection, iniFiles;

type
  TfAtualizarBancoOnline = class(TForm)
    Image3: TImage;
    Gauge1: TGauge;
    Label1: TLabel;
    Label2: TLabel;
    Label4: TLabel;
    Label3: TLabel;
    txtClientes: TComboBox;
    txtCodigoCliente: TEdit;
    txtTabela: TEdit;
    Button1: TButton;
    qrSQL: TZQuery;
    ds: TDataSource;
    conexaoRemoto: TZConnection;
    procedure FormActivate(Sender: TObject);
    procedure txtCodigoClienteChange(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure ConexaoDB;
    procedure Image3Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    arqIni: TiniFile;
    cHost, cDatabase, cUsername, cPassword, cPorta, cDir, paramConfig, HostName,
    Database, username, Password, porta, TIPO: string;
  end;

var
  fAtualizarBancoOnline: TfAtualizarBancoOnline;

implementation

uses frmPrincipal, frmDM;



{$R *.dfm}

procedure TfAtualizarBancoOnline.Button1Click(Sender: TObject);
var
qrMilhar, qrTransferencia,qrTruncate:TZQuery;
aTxt:textFile;
ttReg, i: integer;
begin

    qrMilhar := TZQuery.Create(nil);
    qrTransferencia := TZQuery.Create(nil);
    qrTruncate := TZQuery.Create(nil);

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
        Connection := conexaoRemoto;
        Connection.Connect;
        SQL.Add('TRUNCATE TABLE '+txtTabela.Text);
        ExecSQL;
    end;
    Label1.Caption := 'Aguarde, Limpando dados anteriores...';
    Label1.Refresh;
    Label1.Update;
    Sleep(6000);

    i := 1;

    while not qrMilhar.Eof do begin

        with qrTransferencia do begin
            Connection := conexaoRemoto;
            Connection.Connect;
            SQL.Clear;
            SQL.Add('INSERT INTO '+txtTabela.Text+' (MILHAR, IDVENDEDOR, NCONTROLE)VALUES(:MILHAR, :IDV, :NCT)');
            ParamByName('MILHAR').AsString := qrMilhar.FieldByName('MILHAR').AsString;
            ParamByName('IDV').AsString := qrMilhar.FieldByName('IDVENDEDOR').AsString;
            ParamByName('NCT').AsString := qrMilhar.FieldByName('ID').AsString;
            ExecSQL;
        end;

         Label1.Caption := 'Aguarde, O processo de atualiza��o do banco online... ('+txtTabela.Text+')';
         Label1.Refresh;
         Label1.Update;

         Label2.Caption := 'Total de Registro: '+IntToStr(i)+' de '+IntToStr(ttReg);
         Label2.Refresh;
         Label2.Update;

         i := i + 1;

         Gauge1.Progress := Gauge1.Progress +1;
         qrMilhar.Next;
    end;
    ShowMessage(IntToStr(ttReg));
    Application.MessageBox('Algo nao encontrado','SKY PAINEL', MB_OK + MB_ICONWARNING);
end;

procedure TfAtualizarBancoOnline.ConexaoDB;
var
tipo: string;
begin
  tipo := 'REMOTO';


   // cabe�alho do arquivo ini
  cHost     := 'HOST';
  cDatabase := 'DATABASE2';
  cUsername := 'USERNAME';
  cPassword := 'PASSWORD';
  cPorta    := 'PORTA';

  try
      with conexaoRemoto do begin
        HostName        :=   arqIni.ReadString(tipo, cHost, '');
        Database        :=   arqIni.ReadString(tipo, cDatabase, '');
        User            :=   'skypai19_ecosta';//arqIni.ReadString(tipo, cUsername, '');
        Password        :=   '102030ed'; // arqIni.ReadString(tipo, cPassword, '');
        Port            :=   StrToInt(arqIni.ReadString(tipo, cPorta, ''));
        Protocol        :=   'mysql';
        LibraryLocation :=   'C:\libares\libmySQL.dll';
      end;

      conexaoRemoto.Connected := true;

  except
      on e : exception do  begin
         Application.MessageBox('Sem Conex�o de Banco de Dados!','SKY PAINEL', MB_OK + MB_ICONWARNING);
      end;
  end;
end;

procedure TfAtualizarBancoOnline.FormActivate(Sender: TObject); var
codigoVendedor: string;
qrVendedorComboBox,clientes: TZquery;
begin

 arqIni := TIniFile.Create('C:/materialsistema/config.ini');

 clientes :=  TZquery.Create(nil);

  with clientes do begin
     Connection := DM.conexao;
     Connection.Connect;
     SQL.Clear;
     SQL.Add('SELECT * FROM login');
     Close;
     Open;
  end;

  //Jogo todos cliente no txtClientes
  while not clientes.Eof do
  begin
    txtClientes.Items.Add(clientes.FieldByName('id').AsString+' - '+clientes.FieldByName('nome').AsString);
    clientes.Next;
  end;
  Label2.Caption := '';
  Label1.Caption := '';
  //fProcessamentoModal.Close;
  ConexaoDB;
end;

procedure TfAtualizarBancoOnline.Image3Click(Sender: TObject);
begin
fAtualizarBancoOnline.Close;
end;

procedure TfAtualizarBancoOnline.txtCodigoClienteChange(Sender: TObject);
var
tabelaLogin, tabelaVendedores, ListMilhar: TZQuery;
tVendedores: integer;
begin

  //
  //busco o cliente pelo codigo
  //
  tabelaLogin := TZQuery.Create(nil);
  tabelaVendedores := TZQuery.Create(nil);
  ListMilhar := TZQuery.Create(nil);

  tabelaLogin.Connection := DM.conexao;
  tabelaLogin.SQL.Clear;
  tabelaLogin.SQL.Add('SELECT * FROM login WHERE id = "'+txtCodigoCliente.Text+'"');
  tabelaLogin.Close;
  tabelaLogin.Open;



  // mostro todos registro do cliente selecionado
  with ListMilhar do begin
       Connection := DM.conexao;
       Connection.Connect;
       SQL.Clear;
       close;
       SQL.Add('SELECT * FROM '+tabelaLogin.FieldByName('tabela_cliente').AsString+' INNER JOIN vendedor ON vendedor.id = '+tabelaLogin.FieldByName('tabela_cliente').AsString+'.idvendedor');
       Close;
       Open;
  end;

  ds.DataSet := ListMilhar;

  //e seleciono o cliente no combobox apos acha-lo
  if(tabelaLogin.RecordCount > 0) then
  begin
    txtTabela.Text := tabelaLogin.FieldByName('tabela_cliente').AsString;
    with tabelaVendedores do begin
       Connection := DM.conexao;
       Connection.Connect;
       SQL.Clear;
       close;
       SQL.Add('SELECT * FROM vendedor WHERE CLIENTEID IN ('+tabelaLogin.FieldByName('id').AsString+',0)');
       Close;
       Open;
    end;
    Button1.Enabled := true;

    Label2.Caption := 'Total de Registro: '+IntToStr(ListMilhar.RecordCount);
  end
  else
  begin
    //mmVendedor.Lines.Add('Nenhum vendedor encontrado');
    abort;
  end;
end;

end.
