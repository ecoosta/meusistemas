unit BASE;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, DB, ZAbstractRODataset, ZAbstractDataset, ZDataset,
  ZAbstractConnection, ZConnection, Grids, DBGrids, Gauges, ExtCtrls, ShellApi;

function ExcultSQLOpen(qrerySQL: string; gridDados: TDBGrid): boolean;
function ExcultSQL(qrerySQL: string): boolean;
function ExcultSQLOpenRecount(qrerySQL: string): boolean;
function DigitoCep(cCep: String): String;
function TabExistsB(DB: String; Table: String; qrExists: TZQuery): boolean;
function EditTexts(Form: TForm): String;
function CacularArredodamento(n: integer): boolean;
function ExecutarEEsperarHide(NomeArquivo: String): boolean;
procedure OpenPDF(aFile: TFileName; TypeForm: integer = SW_NORMAL);
procedure HabFieldsForm(xForm: TForm; Hab: boolean);
function ObterDiretorioPrincipal(strDir: string): string;
Function TrimChar(texto: string; delchar: char): string;
function RemoverAcento(Key: char): char;
function RemoverCaracteresEspeciais(strTexto: string): string;
function AsciiToInt(Caracter: char): integer;
function Criptografa(texto: string; chave: integer): String;
function DesCriptografa(texto: string; chave: integer): String;
function GetIdeDiskSerialNumber: String;
Function SerialNum(FDrive: String): String;
function numeroAleatorio():string;
function TextoAleatorio(Tam: Integer = -1): string;
function usuarioWindows: String;

implementation

uses frmPrincipal, frmDM;

function usuarioWindows: String;
var
  I: DWord;
  user: string;
begin
  I := 255;
  SetLength(user, I);
  Windows.GetUserName(PChar(user), I);
  user := string(PChar(user));
  result := user;
end;

function TextoAleatorio(Tam: Integer): string;
var
  I: Integer;
begin

  Setlength(Result, Tam);
  for I := 1 to Tam do
    if Random(2) = 0 then
      Result[I] := Chr(Ord('A') + Random(Ord('Z') - Ord('A') + 1))
    else
      Result[I] := Chr(Ord('0') + Random(Ord('9') - Ord('0') + 1));
end;

function numeroAleatorio():string;
const	str='1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ';
var
x:integer;
begin
   for x := 1 to 10 do  begin
      Result := str[Random(Length(str)) + 1];

      if x = 10 then begin
          Break;
      end;
   end;
end;

Function SerialNum(FDrive: String): String;
Var
  Serial: DWord;
  DirLen, Flags: DWord;
  DLabel: Array [0 .. 11] of char;
begin
  Try
    GetVolumeInformation(PChar(FDrive + ':\'), DLabel, 12, @Serial, DirLen,
      Flags, nil, 0);
    Result := IntToHex(Serial, 8);
  Except
    Result := '';
  end;
end;

procedure ChangeByteOrder(var Data; Size: integer);
var
  ptr: PChar;
  i: integer;
  c: char;
begin
  ptr := @Data;
  for i := 0 to (Size shr 1) - 1 do
  begin
    c := ptr^;
    ptr^ := (ptr + 1)^; (ptr + 1)
    ^ := c;
    Inc(ptr, 2);
  end;
end;

{ fun��o que pega o serial number F�SICO do HD e retorna string }

function GetIdeDiskSerialNumber: String;
type
  TSrbIoControl = packed record
    HeaderLength: ULONG;
    Signature: Array [0 .. 7] of char;
    Timeout: ULONG;
    ControlCode: ULONG;
    ReturnCode: ULONG;
    Length: ULONG;
  end;

  SRB_IO_CONTROL = TSrbIoControl;
  PSrbIoControl = ^TSrbIoControl;

  TIDERegs = packed record
    bFeaturesReg: Byte; // especificar "comandos" SMART
    bSectorCountReg: Byte; // registro de contador de setor
    bSectorNumberReg: Byte; // registro de n�mero de setores
    bCylLowReg: Byte; // valor de cilindro (byte mais baixo)
    bCylHighReg: Byte; // valor de cilindro (byte mais alto)
    bDriveHeadReg: Byte; // registro de drive/cabe�a
    bCommandReg: Byte; // comando IDE
    bReserved: Byte; // reservado- tem que ser zero
  end;

  IDEREGS = TIDERegs;
  PIDERegs = ^TIDERegs;

  TSendCmdInParams = packed record
    cBufferSize: DWord;
    irDriveRegs: TIDERegs;
    bDriveNumber: Byte;
    bReserved: Array [0 .. 2] of Byte;
    dwReserved: Array [0 .. 3] of DWord;
    bBuffer: Array [0 .. 0] of Byte;
  end;

  SENDCMDINPARAMS = TSendCmdInParams;
  PSendCmdInParams = ^TSendCmdInParams;

  TIdSector = packed record
    wGenConfig: Word;
    wNumCyls: Word;
    wReserved: Word;
    wNumHeads: Word;
    wBytesPerTrack: Word;
    wBytesPerSector: Word;
    wSectorsPerTrack: Word;
    wVendorUnique: Array [0 .. 2] of Word;
    sSerialNumber: Array [0 .. 19] of char;
    wBufferType: Word;
    wBufferSize: Word;
    wECCSize: Word;
    sFirmwareRev: Array [0 .. 7] of char;
    sModelNumber: Array [0 .. 39] of char;
    wMoreVendorUnique: Word;
    wDoubleWordIO: Word;
    wCapabilities: Word;
    wReserved1: Word;
    wPIOTiming: Word;
    wDMATiming: Word;
    wBS: Word;
    wNumCurrentCyls: Word;
    wNumCurrentHeads: Word;
    wNumCurrentSectorsPerTrack: Word;
    ulCurrentSectorCapacity: ULONG;
    wMultSectorStuff: Word;
    ulTotalAddressableSectors: ULONG;
    wSingleWordDMA: Word;
    wMultiWordDMA: Word;
    bReserved: Array [0 .. 127] of Byte;
  end;

  PIdSector = ^TIdSector;

const
  IDE_ID_FUNCTION = $EC;
  IDENTIFY_BUFFER_SIZE = 512;
  DFP_RECEIVE_DRIVE_DATA = $0007C088;
  IOCTL_SCSI_MINIPORT = $0004D008;
  IOCTL_SCSI_MINIPORT_IDENTIFY = $001B0501;
  DataSize = sizeof(TSendCmdInParams) - 1 + IDENTIFY_BUFFER_SIZE;
  BufferSize = sizeof(SRB_IO_CONTROL) + DataSize;
  W9xBufferSize = IDENTIFY_BUFFER_SIZE + 16;
var
  hDevice: THandle;
  cbBytesReturned: DWord;
  pInData: PSendCmdInParams;
  pOutData: Pointer; // PSendCmdOutParams
  Buffer: Array [0 .. BufferSize - 1] of Byte;
  srbControl: TSrbIoControl absolute Buffer;

begin
  Result := '';
  FillChar(Buffer, BufferSize, #0);

  if Win32Platform = VER_PLATFORM_WIN32_NT then
  // Windows NT, Windows 2000, Windows XP
  begin
    // recuperar handle da porta SCSI
    hDevice := CreateFile('\.Scsi0:',
      // Nota: '\.C:' precisa de privil�gios administrativos
      GENERIC_READ or GENERIC_WRITE, FILE_SHARE_READ or FILE_SHARE_WRITE, nil,
      OPEN_EXISTING, 0, 0);
    if hDevice = INVALID_HANDLE_VALUE then
      Exit;
    try
      srbControl.HeaderLength := sizeof(SRB_IO_CONTROL);
      System.Move('SCSIDISK', srbControl.Signature, 8);
      srbControl.Timeout := 2;
      srbControl.Length := DataSize;
      srbControl.ControlCode := IOCTL_SCSI_MINIPORT_IDENTIFY;
      pInData := PSendCmdInParams(PChar(@Buffer) + sizeof(SRB_IO_CONTROL));
      pOutData := pInData;
      with pInData^ do
      begin
        cBufferSize := IDENTIFY_BUFFER_SIZE;
        bDriveNumber := 0;
        with irDriveRegs do
        begin
          bFeaturesReg := 0;
          bSectorCountReg := 1;
          bSectorNumberReg := 1;
          bCylLowReg := 0;
          bCylHighReg := 0;
          bDriveHeadReg := $A0;
          bCommandReg := IDE_ID_FUNCTION;
        end;
      end;
      if not DeviceIoControl(hDevice, IOCTL_SCSI_MINIPORT, @Buffer, BufferSize,
        @Buffer, BufferSize, cbBytesReturned, nil) then
        Exit;
    finally
      CloseHandle(hDevice);
    end;
  end
  else
  begin
    // Windows 95 OSR2, Windows 98, Windows ME
    hDevice := CreateFile('\.SMARTVSD', 0, 0, nil, CREATE_NEW, 0, 0);
    if hDevice = INVALID_HANDLE_VALUE then
      Exit;
    try
      pInData := PSendCmdInParams(@Buffer);
      pOutData := @pInData^.bBuffer;
      with pInData^ do
      begin
        cBufferSize := IDENTIFY_BUFFER_SIZE;
        bDriveNumber := 0;
        with irDriveRegs do
        begin
          bFeaturesReg := 0;
          bSectorCountReg := 1;
          bSectorNumberReg := 1;
          bCylLowReg := 0;
          bCylHighReg := 0;
          bDriveHeadReg := $A0;
          bCommandReg := IDE_ID_FUNCTION;
        end;
      end;
      if not DeviceIoControl(hDevice, DFP_RECEIVE_DRIVE_DATA, pInData,
        sizeof(TSendCmdInParams) - 1, pOutData, W9xBufferSize,
        cbBytesReturned, nil) then
        Exit;
    finally
      CloseHandle(hDevice);
    end;
  end;
  with PIdSector(PChar(pOutData) + 16)^ do
  begin
    ChangeByteOrder(sSerialNumber, sizeof(sSerialNumber));
    SetString(Result, sSerialNumber, sizeof(sSerialNumber));
  end;
end;

// funcao que retorno o c�digo ASCII dos caracteres
function AsciiToInt(Caracter: char): integer;
var
  i: integer;
begin
  i := 32;
  while i < 255 do
  begin
    if Chr(i) = Caracter then
      Break;
    i := i + 1;
  end;
  Result := i;
end;

{ Esta funcao tem como objetivo criptografar uma string utilizando o c�digo ASCII de cada caracter e
  somando a esse c�digo o valor da CHAVE }
Function Criptografa(texto: string; chave: integer): String;
var
  cont: integer;
  retorno: string;
begin
  if (trim(texto) = EmptyStr) or (chave = 0) then
  begin
    Result := texto;
  end
  else
  begin
    retorno := '';
    for cont := 1 to Length(texto) do
    begin
      retorno := retorno + Chr(AsciiToInt(texto[cont]) + chave);
    end;
    Result := retorno;
  end;
end;

{ Esta funcao � semelhante a funcao de Criptografia mais com o objetivo de descriptografar a string }

function DesCriptografa(texto: string; chave: integer): String;
var
  cont: integer;
  retorno: string;
begin
  if (trim(texto) = EmptyStr) or (chave = 0) then
  begin
    Result := texto;
  end
  else
  begin
    retorno := '';
    for cont := 1 to Length(texto) do
    begin
      retorno := retorno + Chr(AsciiToInt(texto[cont]) - chave);
    end;
    Result := retorno;
  end;
end;


function RemoverCaracteresEspeciais(strTexto: string): string;
Var
  S: String;
  i: integer;
begin
  for i := 1 to Length(strTexto) do
  begin
    S := S + RemoverAcento(strTexto[i]); ;
  end;
  Result := TrimChar(S, ' ');
end;

function RemoverAcento(Key: char): char;

begin
  if (Key in ['�', '�', '�']) then
  begin
    Result := 'e';
  end
  else if (Key in ['�', '�', '�']) then
  begin
    Result := 'E';
  end
  else if (Key in ['�', '�', '�', '�']) then
  begin
    Result := 'a';
  end
  else if (Key in ['�', '�', '�', '�']) then
  begin
    Result := 'A';
  end
  else if (Key in ['�', '�', '�', '�', '�', '�']) then
  begin
    Result := 'i';
  end
  else if (Key in ['�', '�', '�']) then
  begin
    Result := 'I';
  end
  else if (Key in ['�', '�', '�', '�']) then
  begin
    Result := 'O';
  end
  else if (Key in ['�', '�', '�', '�']) then
  begin
    Result := 'O';
  end
  else if (Key in ['�', '�']) then
  begin
    Result := 'u';
  end
  else if (Key in ['�', '�']) then
  begin
    Result := 'U';
  end
  else if (Key in ['�']) then
  begin
    Result := 'c';
  end
  else if (Key in ['�']) then
  begin
    Result := 'C';
  end
  else
    Result := Key;
end;



Function TrimChar(texto: string; delchar: char): string;
var
  S: string;
begin
  S := texto;
  while Pos(delchar, S) > 0 do
    Delete(S, Pos(delchar, S), 1);
  Result := S;
end;

procedure HabFieldsForm(xForm: TForm; Hab: boolean);
var
  x: integer;
  nome: String;
begin

  for x := 0 to xForm.ControlCount - 1 do
    if (xForm.Controls[x] is TEdit) or (xForm.Controls[x] is TComboBox) or
      (xForm.Controls[x] is TMemo) or (xForm.Controls[x] is TLabeledEdit) or
      (xForm.Controls[x] is TButton) or (xForm.Controls[x] is TDBGrid) then
    begin
      xForm.Controls[x].Enabled := Hab;
      nome := xForm.Controls[x].Name;

      with TEdit(xForm.FindComponent(nome)) do
        if Hab = True then
          Color := clYellow
        else
          Color := clBlack;
    end;
end;

function ObterDiretorioPrincipal(strDir: string): string;
begin
  if (strDir = null) then
  begin
    Result := GetCurrentDir + '\';
  end
  else
  begin
    Result := GetCurrentDir + '\' + strDir;
  end;

end;

function ExcultSQL(qrerySQL: string): boolean;
var
  qrSQL: TZQuery;
  ds: TDataSource;
begin
  qrSQL := TZQuery.Create(Nil);

  with qrSQL do
  begin
    Connection := DM.conexao;
    Connection.Connect;
    SQL.Clear;
    Close;
    SQL.Add(qrerySQL);
    ExecSQL;
  end;
end;

function ExcultSQLOpen(qrerySQL: string; gridDados: TDBGrid): boolean;
var
  qrSQL: TZQuery;
  ds: TDataSource;
begin
  qrSQL := TZQuery.Create(Nil);
  ds := TDataSource.Create(Nil);

  with qrSQL do
  begin
    Connection := DM.conexao;
    Connection.Connect;
    SQL.Clear;
    Close;
    SQL.Add(qrerySQL);
    Open;
  end;

  with ds do
  begin
    DataSet := qrSQL;
  end;

  gridDados.DataSource := ds;
end;

function ExcultSQLOpenRecount(qrerySQL: string): boolean;
var
  qrSQL: TZQuery;
begin
  qrSQL := TZQuery.Create(Nil);
  with qrSQL do
  begin
    Connection := DM.conexao;
    Connection.Connect;
    SQL.Clear;
    Close;
    SQL.Add(qrerySQL);
    Open;
  end;

  if qrSQL.RecordCount > 0 then
  begin
    Result := True;
  end
  else
  begin
    Result := False;
  end;
end;

function DigitoCep(cCep: String): String;
var
  nDig, i, nSum: integer;
  cDig: String;
begin
  nSum := 0;
  for i := 1 to Length(cCep) do
  begin
    nSum := nSum + StrToInt(Copy(cCep, i, 1));
  end;
  nDig := 10 - (nSum Mod 10);
  if nDig > 9 then
    nDig := 0;

  cDig := IntToStr(nDig);
  Result := cDig;
end;

function TabExistsB(DB: String; Table: String; qrExists: TZQuery): boolean;
begin
  qrExists.SQL.Clear;
  qrExists.Connection := dm.conexaoRemoto;
  qrExists.Connection.Connect;
  qrExists.SQL.Add('SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME="' + Table + '" and TABLE_SCHEMA="' + DB + '"');
  qrExists.Close;
  qrExists.Open;

  if (qrExists.Eof) then
  begin
    Result := False;
  end
  else
  begin
    Result := True;
  end;
end;

function EditTexts(Form: TForm): String;
var
  i: integer;
begin
  for i := 0 to Form.ComponentCount - 1 do
  begin
    if Form.Components[i] is TCustomEdit then
    begin (Form.Components[i] as TCustomEdit)
      .Text;
    end;
  end;
end;

function CacularArredodamento(n: integer): boolean;
begin
  Result := ((n mod 2) = 0);
end;

procedure OpenPDF(aFile: TFileName; TypeForm: integer = SW_NORMAL);
var
  Pdir: PChar;
begin
  GetMem(Pdir, 256);
  StrPCopy(Pdir, aFile);
  ShellExecute(0, nil, PChar(aFile), nil, Pdir, TypeForm);
  FreeMem(Pdir, 256);
end;

function ExecutarEEsperarHide(NomeArquivo: String): boolean;
var
  Sh: TShellExecuteInfo;
  CodigoSaida: DWord;
begin
  FillChar(Sh, sizeof(Sh), 0);
  Sh.cbSize := sizeof(TShellExecuteInfo);
  with Sh do
  begin
    fMask := SEE_MASK_NOCLOSEPROCESS;
    Wnd := Application.Handle;
    lpVerb := nil;
    lpFile := PChar(NomeArquivo);
    nShow := SW_HIDE;
  end;
  if ShellExecuteEx(@Sh) then
  begin
    repeat
      Application.ProcessMessages;
      GetExitCodeProcess(Sh.hProcess, CodigoSaida);
    until not(CodigoSaida = STILL_ACTIVE);
    Result := True;
  end
  else
    Result := False;
end;

end.
