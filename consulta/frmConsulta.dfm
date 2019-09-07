object fConsulta: TfConsulta
  Left = 0
  Top = 0
  BorderStyle = bsToolWindow
  Caption = 'SISTEMA DE CONSULTA :: SKY PAINEL SISTEMA'
  ClientHeight = 340
  ClientWidth = 763
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnActivate = FormActivate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 24
    Top = 16
    Width = 133
    Height = 19
    Caption = 'Digite uma milhar:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object gResultado: TGroupBox
    Left = 24
    Top = 94
    Width = 720
    Height = 228
    Color = clBtnHighlight
    ParentBackground = False
    ParentColor = False
    TabOrder = 3
    object rmilhar: TLabel
      Left = 248
      Top = 59
      Width = 68
      Height = 33
      Caption = '1415'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clHighlight
      Font.Height = -27
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      Visible = False
    end
    object rcontrole: TLabel
      Left = 16
      Top = 59
      Width = 128
      Height = 33
      Caption = '0001.0000'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -27
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      Visible = False
    end
    object rvendedor: TLabel
      Left = 488
      Top = 59
      Width = 163
      Height = 33
      Caption = 'Edson Ribeiro'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -27
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      Visible = False
    end
    object rvazio: TLabel
      Left = 172
      Top = 116
      Width = 387
      Height = 33
      Caption = 'Nenhum registro foi encontrado.'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -27
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      Visible = False
    end
    object Label4: TLabel
      Left = 16
      Top = 171
      Width = 75
      Height = 23
      Caption = 'PREMIO:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -19
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Label5: TLabel
      Left = 16
      Top = 200
      Width = 169
      Height = 23
      Caption = 'DATA DO SORTEIO:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -19
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object txtpremio: TLabel
      Left = 100
      Top = 171
      Width = 199
      Height = 23
      Caption = 'HB20 EIX FLEX 2019'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 16744448
      Font.Height = -19
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object txtdatasorteio: TLabel
      Left = 191
      Top = 200
      Width = 118
      Height = 23
      Caption = '18/10/2019'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 16744448
      Font.Height = -19
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
  end
  object Panel1: TPanel
    Left = 24
    Top = 110
    Width = 720
    Height = 41
    TabOrder = 1
    object Label2: TLabel
      Left = 16
      Top = 10
      Width = 95
      Height = 19
      Caption = 'CONTROLE:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 16744448
      Font.Height = -16
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label3: TLabel
      Left = 248
      Top = 10
      Width = 72
      Height = 19
      Caption = 'MILHAR:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 16744448
      Font.Height = -16
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label6: TLabel
      Left = 488
      Top = 10
      Width = 97
      Height = 19
      Caption = 'VENDEDOR:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 16744448
      Font.Height = -16
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
  end
  object txtMilharf: TEdit
    Left = 24
    Top = 41
    Width = 610
    Height = 47
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -32
    Font.Name = 'Tahoma'
    Font.Style = []
    MaxLength = 4
    ParentFont = False
    TabOrder = 0
    OnChange = txtMilharfChange
    OnKeyPress = txtMilharfKeyPress
  end
  object btnBuscar: TButton
    Left = 640
    Top = 41
    Width = 104
    Height = 47
    Cursor = crHandPoint
    Caption = 'Consulta'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 2
    OnClick = btnBuscarClick
  end
  object Button1: TButton
    Left = 496
    Top = 10
    Width = 75
    Height = 25
    Caption = 'Button1'
    TabOrder = 4
    Visible = False
    OnClick = Button1Click
  end
  object conexao: TADOConnection
    LoginPrompt = False
    Mode = cmShareDenyNone
    Provider = 'Microsoft.Jet.OLEDB.4.0'
    Left = 696
    Top = 201
  end
  object consultaSQL: TADOQuery
    Connection = conexao
    CursorType = ctStatic
    Parameters = <>
    Left = 696
    Top = 265
  end
  object consultapremio: TADOQuery
    Connection = conexao
    CursorType = ctStatic
    Parameters = <>
    Left = 592
    Top = 257
  end
end
