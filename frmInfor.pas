unit frmInfor;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, pngimage, ExtCtrls, StdCtrls, ZAbstractConnection, ZConnection, DB,
  ZAbstractRODataset, ZAbstractDataset, ZDataset,inifiles,BASE;

type
  TfInfor = class(TForm)
    Label1: TLabel;
    Label3: TLabel;
    Image3: TImage;
    Label2: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    procedure Image3Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    aIni: TiniFile;
  end;

var
  fInfor: TfInfor;

implementation



{$R *.dfm}

procedure TfInfor.Image3Click(Sender: TObject);
begin
    fInfor.Close;
end;

end.
