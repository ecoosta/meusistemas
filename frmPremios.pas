unit frmPremios;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Mask, Grids, DBGrids, DB, ZAbstractRODataset,
  ZAbstractDataset, ZDataset, ZAbstractConnection, ZConnection;

type
  TfPremios = class(TForm)
    carregarLoginCB: TZQuery;
    btncad: TButton;
    DBGrid1: TDBGrid;
    btnEdi: TButton;
    btnExc: TButton;
    GroupBox1: TGroupBox;
    Label16: TLabel;
    cbVendedores: TComboBox;
    txtPremios: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    txtDataSorteio: TMaskEdit;
    procedure FormActivate(Sender: TObject);
    procedure btncadClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    funcao:boolean;
  end;

var
  fPremios: TfPremios;

implementation

uses frmDM;

{$R *.dfm}

procedure TfPremios.btncadClick(Sender: TObject);
var
queryInsert:TZQuery;
vendedorid:integer;
data, novaData,novaDataHora:string;
begin
    if (cbVendedores.Text = '') then begin
        Application.MessageBox('Informe um vendedor','SKY PAINEL', MB_OK + MB_ICONWARNING);
        cbVendedores.SetFocus;
        abort;
    end;
    if (txtPremios.Text = '') then begin
        Application.MessageBox('Informe a descri�ao do premios','SKY PAINEL', MB_OK + MB_ICONWARNING);
        txtPremios.SetFocus;
        abort;
    end;

    if (txtDataSorteio.Text = '  /  /    ') then begin
        Application.MessageBox('Escolhar uma data do sorteio','SKY PAINEL', MB_OK + MB_ICONWARNING);
        txtDataSorteio.SetFocus;
        abort;
    end;
    data := txtDataSorteio.Text;
    //18/06/1989 21:52:69
    novaData := Copy(data, 7, 4)+'/'+Copy(data, 4, 2)+'/'+Copy(data, 1,2);
    novaDataHora := '';
    queryInsert := TZQuery.Create(nil);
    vendedorid := Integer( cbVendedores.Items.Objects[cbVendedores.ItemIndex ] );  //Pega o id do registro selecionado no combox
    with queryInsert do begin
      Connection := dm.conexao;
      Connection.Connect;
      Close;
      SQL.Clear;
      SQL.Add('INSERT INTO premios (premio,vendedorid,datasorteio,DAPROCESSAMENTO)values(:premio,:vendedorid,:datasorteio,:DAPROCESSAMENTO)');
      ParamByName('premio').AsString := txtPremios.Text;
      ParamByName('vendedorid').AsInteger :=  vendedorid;
      ParamByName('datasorteio').AsString :=  novaData;
      ParamByName('DAPROCESSAMENTO').AsString := FormatDateTime('yyyy/mm/dd - hh:nn:ss', Now);
      ExecSQL;
    end;
    Application.MessageBox('Registros cadastrado com sucesso','SKY PAINEL', MB_OK + MB_ICONWARNING);
    dm.carregarPremios.Refresh;
end;

procedure TfPremios.FormActivate(Sender: TObject);
var
item_combo: string;
begin
  with carregarLoginCB do
  begin
  close;
    Open;
    while not Eof do
    begin
        item_combo := FieldByName('IDLOGIN').AsString + ' - ' + FieldByName('NOME').AsString;
        cbVendedores.Items.AddObject(item_combo, TObject(FieldByName('IDLOGIN').AsInteger));
      Next;
    end;
  end;
  funcao := true;

end;

end.
