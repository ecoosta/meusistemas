object fConfiguracoes: TfConfiguracoes
  Left = 0
  Top = 0
  BorderStyle = bsNone
  Caption = 'Configura'#231#245'es do Arquivo INI- SKY PAINEL SISTEMAS'
  ClientHeight = 136
  ClientWidth = 438
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Label2: TLabel
    Left = 8
    Top = 10
    Width = 150
    Height = 19
    Caption = 'Informe o Vendedor:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object btnConnectar: TButton
    Left = 8
    Top = 86
    Width = 177
    Height = 33
    Cursor = crHandPoint
    Caption = 'Salva Configura'#231#245'es'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ModalResult = 1
    ParentFont = False
    TabOrder = 0
    OnClick = btnConnectarClick
  end
  object txtServidor: TEdit
    Left = 8
    Top = 35
    Width = 409
    Height = 33
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -21
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
  end
  object Button1: TButton
    Left = 342
    Top = 86
    Width = 75
    Height = 33
    Caption = 'Cancelar'
    TabOrder = 2
    OnClick = Button1Click
  end
end
