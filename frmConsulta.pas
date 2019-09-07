unit frmConsulta;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, zLib, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls,ZAbstractRODataset, ZAbstractDataset, ZDataset, DB, Grids, DBGrids,IniFiles,
  ADODB, ZAbstractConnection, ZConnection;

type
  TfConsulta = class(TForm)
    txtMilharf: TEdit;
    Label1: TLabel;
    Panel1: TPanel;
    btnBuscar: TButton;
    gResultado: TGroupBox;
    rmilhar: TLabel;
    rcontrole: TLabel;
    rvendedor: TLabel;
    rvazio: TLabel;
    Button1: TButton;
    Label2: TLabel;
    Label3: TLabel;
    Label6: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    txtpremio: TLabel;
    txtdatasorteio: TLabel;
    cbVendedoresProcessamento: TComboBox;
    Label16: TLabel;
    txtTabela: TEdit;
    carregarLoginCB: TZQuery;
    procedure btnBuscarClick(Sender: TObject);
    procedure txtMilharfKeyPress(Sender: TObject; var Key: Char);
    procedure ExecultConsultaSQL;
    procedure FormActivate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure txtMilharfChange(Sender: TObject);
    procedure cbVendedoresProcessamentoChange(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    tabela: string;
     arConfig: TIniFile;
  end;

var
  fConsulta: TfConsulta;

implementation

uses frmDM;



{$R *.dfm}

procedure Descomprimir(ArquivoZip: TFileName; DiretorioDestino: string);
var
  NomeSaida: string;
  FileEntrada, FileOut: TFileStream;
  Descompressor: TDecompressionStream;
  NumArq, I, Len, Size: Integer;
  Fim: Byte;
begin
  FileEntrada := TFileStream.Create(ArquivoZip, fmOpenRead and fmShareExclusive);
  Descompressor := TDecompressionStream.Create(FileEntrada);
  Descompressor.Read(NumArq, SizeOf(Integer));
  try
    I := 0;
    while I < NumArq do begin
      Descompressor.Read(Len, SizeOf(Integer));
      SetLength(NomeSaida, Len);
      Descompressor.Read(NomeSaida[1], Len);
      Descompressor.Read(Size, SizeOf(Integer));
      FileOut := TFileStream.Create(
        IncludeTrailingBackslash(DiretorioDestino) + NomeSaida,
        fmCreate or fmShareExclusive);
      try
        FileOut.CopyFrom(Descompressor, Size);
      finally
        FileOut.Free;
      end;
      Descompressor.Read(Fim, SizeOf(Byte));
      Inc(I);
    end;
  finally
    FreeAndNil(Descompressor);
    FreeAndNil(FileEntrada);
  end;
end;

procedure TfConsulta.btnBuscarClick(Sender: TObject);
begin
ExecultConsultaSQL;
end;

procedure TfConsulta.Button1Click(Sender: TObject);
begin
    Descomprimir('zipArq.zip', 'C:\xml');
end;

procedure TfConsulta.cbVendedoresProcessamentoChange(Sender: TObject);
var
tabelaVendedores,tabelaClientes,qQuebra,qAvulsos,qEscolhidas:TZQuery;
id_vendedor,tClientes:integer;
begin
  id_vendedor := Integer( cbVendedoresProcessamento.Items.Objects[cbVendedoresProcessamento.ItemIndex ] );
  tabelaVendedores := TZQuery.Create(nil);
  tabelaVendedores.Connection :=  DM.conexao;
  tabelaVendedores.SQL.Clear;
  tabelaVendedores.SQL.Add('SELECT * FROM login WHERE IDLOGIN = "' + IntToStr(id_vendedor)+ '"');
  tabelaVendedores.Close;
  tabelaVendedores.Open;
  txtTabela.Text := tabelaVendedores.FieldByName('tabela').AsString;
end;

procedure TfConsulta.ExecultConsultaSQL;
var
consultaSQL: TZQuery;
milhar: string;
id_vendedor:integer;
begin
  if (cbVendedoresProcessamento.Text = '') then begin
     Application.MessageBox('Informe um vendedor primeiro','SKY PAINEL', MB_OK + MB_ICONWARNING);
     Abort;
  end;
  milhar := txtMilharf.Text;
  if (milhar = '') then begin
     rvazio.Visible := true;
     rvazio.Left := 172;
     rvazio.Top := 132;
     rcontrole.Visible := false;
     rmilhar.Visible := false;
     rvendedor.Visible := false;
     Abort;
  end;

  //id_vendedor := Integer( cbVendedoresProcessamento.Items.Objects[cbVendedoresProcessamento.ItemIndex ] );

  try
    consultaSQL := TZQuery.Create(nil);
    with consultaSQL do begin
      Connection :=  DM.conexao;
      Connection.Connect;
      Close;
      SQL.Clear;
      SQL.Add('SELECT * FROM '+txtTabela.Text+' t INNER JOIN clientes c ON c.idcliente = t.clienteid  WHERE MILHAR = :M');
      ParamByName('M').AsString := milhar;
      Open;
    end;

    if (consultaSQL.RecordCount > 0) then  begin
       rvazio.Visible := false;
       rcontrole.Visible := true;
       rmilhar.Visible := true;
       rvendedor.Visible := true;

       rcontrole.Caption := FormatFloat('0000',  StrToInt(consultaSQL.FieldByName( 'ID').AsString))+'.0000';
       rmilhar.Caption := FormatFloat('0000',  StrToInt(consultaSQL.FieldByName('MILHAR').AsString));
       rvendedor.Caption := consultaSQL.FieldByName('NOME_CLIENTE').AsString;
    end else begin
       rcontrole.Visible := false;
       rmilhar.Visible := false;
       rvendedor.Visible := false;

       rvazio.Visible := true;
       rvazio.Left := 288;
       rvazio.Top := 74;
    end;
   except on e : exception do  begin
      rvazio.Visible := true;
      rvazio.Left := 16;
      rvazio.Top := 74;
      rvazio.Caption := 'Sem Conex�o de BANCO DE DADOS CONFIG: '+ e.message;
      abort;
    end;
  end;

end;

procedure TfConsulta.FormActivate(Sender: TObject);
var
cDir: string;
consultapremio: TZQuery;
item_combo,item_id_combo:string;
begin

  with carregarLoginCB do
  begin
   close;
    Open;
    while not Eof do
    begin
        item_combo := FieldByName('idlogin').AsString + ' - ' + FieldByName('nome').AsString;
        cbVendedoresProcessamento.Items.AddObject(item_combo, TObject(FieldByName('idlogin').AsInteger));
      Next;
    end;
  end;

  try
    consultapremio := TZQuery.Create(nil);
    with consultapremio do begin
      Connection :=  DM.conexao;
      Connection.Connect;
      Close;
      SQL.Clear;
      SQL.Add('SELECT * FROM premios');
      Open;

      if (RecordCount > 0) then begin
         txtpremio.Caption := FieldByName('PREMIO').AsString;
         txtdatasorteio.Caption := FieldByName('DATASORTEIO').AsString;
      end else begin
         txtpremio.Font.Color := clRed;
         txtdatasorteio.Font.Color := clRed;
         txtpremio.Caption := 'Premio n�o cadastrado';
         txtdatasorteio.Caption := 'Data n�o defenida';
      end;

    end;
   except on e : exception do  begin
      rvazio.Visible := true;
      rvazio.Caption := 'Sem Conex�o de BANCO DE DADOS CONFIG: '+ e.message;
      abort;
    end;
  end;
end;

procedure TfConsulta.txtMilharfChange(Sender: TObject);
begin
   // acao
     ExecultConsultaSQL;
end;

procedure TfConsulta.txtMilharfKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then begin
     // aca
     ExecultConsultaSQL;
  end;
end;

end.
