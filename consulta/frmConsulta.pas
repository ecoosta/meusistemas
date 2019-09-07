unit frmConsulta;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, zLib, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls,ZAbstractRODataset, ZAbstractDataset, ZDataset, DB, Grids, DBGrids,IniFiles,
  ADODB;

type
  TfConsulta = class(TForm)
    txtMilharf: TEdit;
    Label1: TLabel;
    Panel1: TPanel;
    btnBuscar: TButton;
    conexao: TADOConnection;
    consultaSQL: TADOQuery;
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
    consultapremio: TADOQuery;
    procedure btnBuscarClick(Sender: TObject);
    procedure txtMilharfKeyPress(Sender: TObject; var Key: Char);
    procedure ExecultConsultaSQL;
    procedure FormActivate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure txtMilharfChange(Sender: TObject);
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

uses frmConfiguracaoFTP;


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

procedure TfConsulta.ExecultConsultaSQL;
var
milhar: string;
begin

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


  try
    with consultaSQL do begin
      Close;
      SQL.Clear;
      SQL.Add('SELECT * FROM sorteio WHERE MILHAR = :M');
      Parameters.ParamByName('M').Value := milhar;
      Open;
    end;

    if (consultaSQL.RecordCount > 0) then  begin
       rvazio.Visible := false;
       rcontrole.Visible := true;
       rmilhar.Visible := true;
       rvendedor.Visible := true;

       rcontrole.Caption := FormatFloat('0000',  StrToInt(consultaSQL.FieldByName('IDCONTROLE').AsString))+'.0000';
       rmilhar.Caption := FormatFloat('0000',  StrToInt(consultaSQL.FieldByName('MILHAR').AsString));
       rvendedor.Caption := consultaSQL.FieldByName('CLIENTE').AsString;
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
begin
    cDir := ExtractFilePath(Application.ExeName);
    with conexao do begin
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

    try
    with consultapremio do begin
      Close;
      SQL.Clear;
      SQL.Add('SELECT * FROM premio');
      Open;

      if (RecordCount > 0) then begin
         txtpremio.Caption := FieldByName('premio').AsString;
         txtdatasorteio.Caption := FieldByName('datasorteio').AsString;
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

procedure TfConsulta.FormShow(Sender: TObject);
var
Dir: string;
cDir: string;
begin
   Dir := ExtractFilePath(Application.ExeName);
   arConfig := TIniFile.Create(Dir + 'config.ini');

   if not FileExists(Dir + 'consulta.mdb') then begin
      Application.MessageBox('Arquivo consulta.mdb n�o foi encontrado'+#13+'O Sistema ser� encerrado por esse motivo.', 'SKY PAINEL - SISTEMA DE CONSULTA', MB_OK + 16);
      Application.Terminate;
    end;

  try
  if not FileExists(Dir + 'config.ini') then begin
    Application.MessageBox('Arquivo de configuracao n�o  foi encontrado.'+#13+'Configure na tela seguinte.', 'SKY PAINEL - SISTEMA DE CONSULTA', MB_OK + 16);
       fConfiguracoes := TfConfiguracoes.Create(nil);

       if (fConfiguracoes.ShowModal = 1) then
       begin
         FreeAndNil(fConfiguracoes);
       end;
  end;
  except
    on E: Exception do begin
      Application.MessageBox('Erro na conex�o!', 'SKY PAINEL', MB_OK + 16);
    end;
  end;
  tabela := arConfig.ReadString('CONFIG', 'VENDEDOR', '');
end;

procedure TfConsulta.txtMilharfChange(Sender: TObject);
begin
   // acao
     ExecultConsultaSQL;
end;

procedure TfConsulta.txtMilharfKeyPress(Sender: TObject; var Key: Char);
begin
    if Key = #13 then
  begin
     // acao
     ExecultConsultaSQL;
  end;
end;

end.
