object fProcessamentoArquivo: TfProcessamentoArquivo
  Left = 0
  Top = 0
  BorderStyle = bsToolWindow
  Caption = 'Processamento de Dados para impressao'
  ClientHeight = 426
  ClientWidth = 648
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnActivate = FormActivate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 165
    Top = 27
    Width = 99
    Height = 13
    Caption = 'Caminho do arquivo:'
  end
  object Gauge1: TGauge
    Left = 8
    Top = 388
    Width = 630
    Height = 28
    Progress = 0
  end
  object Label2: TLabel
    Left = 8
    Top = 369
    Width = 29
    Height = 13
    Caption = 'lblMsg'
    Visible = False
  end
  object txtPorFolha: TLabel
    Left = 8
    Top = 27
    Width = 76
    Height = 13
    Caption = 'Total por Folha:'
  end
  object txtArquivoDir: TEdit
    Left = 165
    Top = 46
    Width = 425
    Height = 24
    Enabled = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    TextHint = 'Caminho do arquivo a processar'
  end
  object btnCarregar: TButton
    Left = 596
    Top = 46
    Width = 42
    Height = 25
    Cursor = crHandPoint
    Caption = '...'
    TabOrder = 1
    OnClick = btnCarregarClick
  end
  object btnProcessar: TButton
    Left = 487
    Top = 207
    Width = 151
    Height = 25
    Cursor = crHandPoint
    Caption = 'Processar Arquivo'
    Enabled = False
    TabOrder = 2
    OnClick = btnProcessarClick
  end
  object Memo1: TMemo
    Left = 8
    Top = 86
    Width = 425
    Height = 277
    ReadOnly = True
    TabOrder = 3
  end
  object DBGrid1: TDBGrid
    Left = 8
    Top = 86
    Width = 473
    Height = 277
    TabOrder = 4
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
    Columns = <
      item
        Alignment = taCenter
        Expanded = False
        FieldName = 'ID_TEMP'
        Title.Caption = 'CONTROLE'
        Width = 100
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'MILHAR_TEMP'
        Title.Caption = 'MILHAR'
        Width = 140
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'CLIENTE_TEMP'
        Title.Caption = 'CLIENTE'
        Width = 190
        Visible = True
      end>
  end
  object btnOr: TButton
    Left = 487
    Top = 338
    Width = 151
    Height = 25
    Caption = 'Organizar Arquivo'
    TabOrder = 5
    Visible = False
    OnClick = btnOrClick
  end
  object cSobras: TCheckBox
    Left = 536
    Top = 23
    Width = 102
    Height = 17
    Alignment = taLeftJustify
    Caption = 'Processar Capas'
    TabOrder = 6
  end
  object txtRegistroPorFolha: TEdit
    Left = 8
    Top = 46
    Width = 151
    Height = 21
    TabOrder = 7
  end
  object GroupBox1: TGroupBox
    Left = 489
    Top = 86
    Width = 151
    Height = 115
    TabOrder = 8
    object cBloquinho: TRadioButton
      Left = 14
      Top = 44
      Width = 113
      Height = 17
      Caption = 'Bloquinhos com 4'
      TabOrder = 0
    end
    object cCartela: TRadioButton
      Left = 14
      Top = 21
      Width = 113
      Height = 17
      Caption = 'Cartela Normal'
      TabOrder = 1
    end
    object cBloquinhocom5: TRadioButton
      Left = 14
      Top = 67
      Width = 123
      Height = 17
      Caption = 'Bloquinhos com 1 - 5'
      TabOrder = 2
    end
  end
end
