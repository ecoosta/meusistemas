object fPrincipal: TfPrincipal
  Left = 0
  Top = 0
  Cursor = crHandPoint
  VertScrollBar.Style = ssFlat
  BorderStyle = bsToolWindow
  Caption = 'SKY PAINEL SISTEMA - PAINEL'
  ClientHeight = 649
  ClientWidth = 955
  Color = clBtnFace
  DefaultMonitor = dmDesktop
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Menu = menu
  OldCreateOrder = False
  Position = poDesktopCenter
  OnActivate = FormActivate
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object prg: TGauge
    Left = 0
    Top = 559
    Width = 955
    Height = 23
    ForeColor = clGreen
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clHighlightText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    Progress = 0
    Visible = False
  end
  object lblRecount: TLabel
    Left = 770
    Top = 540
    Width = 177
    Height = 13
    Alignment = taRightJustify
    Caption = 'Aguarde, Processo em andamento...'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    Visible = False
  end
  object Gauge1: TGauge
    Left = 0
    Top = 606
    Width = 955
    Height = 22
    Progress = 0
    Visible = False
  end
  object lblMsg: TLabel
    Left = 781
    Top = 587
    Width = 166
    Height = 13
    Alignment = taRightJustify
    Caption = 'processando aquivo de impressao.'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    Visible = False
  end
  object rvazio: TLabel
    Left = 8
    Top = 506
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
  object sbPrincipal: TStatusBar
    Left = 0
    Top = 628
    Width = 955
    Height = 21
    Panels = <
      item
        Text = 'AcessoLogado'
        Width = 250
      end
      item
        Text = 'Data e Horario'
        Width = 250
      end
      item
        Text = 'Status do Sistema'
        Width = 200
      end
      item
        Alignment = taRightJustify
        Text = 'versao do sistema'
        Width = 50
      end>
  end
  object gbprocesso: TGroupBox
    Left = 600
    Top = 8
    Width = 347
    Height = 492
    TabOrder = 1
    Visible = False
    object Label16: TLabel
      Left = 18
      Top = 11
      Width = 135
      Height = 14
      Caption = 'Selecione um Vendedor:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Label15: TLabel
      Left = 18
      Top = 106
      Width = 118
      Height = 14
      Caption = 'Selecione um Cliente:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      Visible = False
    end
    object TLabel
      Left = 18
      Top = 352
      Width = 3
      Height = 13
      Visible = False
    end
    object btnProcessamento: TButton
      Left = 18
      Top = 341
      Width = 311
      Height = 31
      Cursor = crHandPoint
      Caption = 'Gerar Arquivo'
      Enabled = False
      TabOrder = 0
      Visible = False
      OnClick = btnProcessamentoClick
    end
    object cbVendedoresProcessamento: TComboBox
      Left = 18
      Top = 31
      Width = 311
      Height = 31
      Cursor = crHandPoint
      AutoDropDown = True
      Style = csDropDownList
      DoubleBuffered = False
      DragCursor = crHandPoint
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -19
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentDoubleBuffered = False
      ParentFont = False
      TabOrder = 1
      OnChange = cbVendedoresProcessamentoChange
    end
    object cbClientesPrecessamento: TComboBox
      Left = 18
      Top = 126
      Width = 311
      Height = 31
      AutoDropDown = True
      Style = csDropDownList
      DragCursor = crHandPoint
      Enabled = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -19
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
      Visible = False
      OnChange = cbClientesPrecessamentoChange
    end
    object btnOrganizaDados: TButton
      Left = 18
      Top = 304
      Width = 311
      Height = 31
      Cursor = crHandPoint
      Caption = 'Organizar Dados'
      Enabled = False
      TabOrder = 3
      Visible = False
      OnClick = btnOrganizaDadosClick
    end
    object gTipo: TGroupBox
      Left = 18
      Top = 68
      Width = 311
      Height = 30
      TabOrder = 4
      Visible = False
      object rEscolhido: TRadioButton
        Left = 8
        Top = 6
        Width = 97
        Height = 17
        Caption = 'Gerar Escolhido'
        TabOrder = 0
        OnClick = rEscolhidoClick
      end
      object rTodos: TRadioButton
        Left = 125
        Top = 6
        Width = 81
        Height = 17
        Caption = 'Gerar Todos'
        TabOrder = 1
        OnClick = rTodosClick
      end
      object rCapas: TRadioButton
        Left = 228
        Top = 6
        Width = 81
        Height = 17
        Caption = 'Gerar Capas'
        TabOrder = 2
        OnClick = rCapasClick
      end
    end
    object Button4: TButton
      Left = 18
      Top = 415
      Width = 311
      Height = 31
      Cursor = crHandPoint
      Caption = 'Gerar Consulta'
      TabOrder = 5
      OnClick = Button4Click
    end
    object btntran: TButton
      Left = 18
      Top = 378
      Width = 311
      Height = 31
      Cursor = crHandPoint
      Caption = 'Transferir Dados'
      Enabled = False
      TabOrder = 6
      Visible = False
      OnClick = btntranClick
    end
    object Button5: TButton
      Left = 240
      Top = 449
      Width = 89
      Height = 25
      Cursor = crHandPoint
      Caption = 'Sair'
      TabOrder = 7
      OnClick = Button5Click
    end
    object GroupBox1: TGroupBox
      Left = 18
      Top = 163
      Width = 311
      Height = 89
      Color = clWhite
      ParentBackground = False
      ParentColor = False
      TabOrder = 8
      object lblQuebras: TLabel
        Left = 12
        Top = 34
        Width = 140
        Height = 19
        Caption = 'Total Quebra: 0000'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        Visible = False
      end
      object lblEscolhidas: TLabel
        Left = 12
        Top = 9
        Width = 154
        Height = 19
        Caption = 'Total Escolhida: 0000'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        Visible = False
      end
      object lblAvulsos: TLabel
        Left = 12
        Top = 59
        Width = 136
        Height = 19
        Caption = 'Total Avulso: 0000'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        Visible = False
      end
    end
  end
  object btnF1: TButton
    Left = 8
    Top = 15
    Width = 217
    Height = 85
    Cursor = crHandPoint
    Caption = 'Iniciar Processo'
    TabOrder = 2
    OnClick = btnF1Click
  end
  object txtTabela: TEdit
    Left = 784
    Top = 506
    Width = 163
    Height = 21
    TabOrder = 3
    Text = 'tabela'
    Visible = False
  end
  object Button1: TButton
    Left = 8
    Top = 295
    Width = 217
    Height = 25
    Caption = 'teste'
    TabOrder = 4
    Visible = False
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 8
    Top = 326
    Width = 217
    Height = 25
    Caption = 'Organizar tabela 5 '
    TabOrder = 5
    Visible = False
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 8
    Top = 357
    Width = 75
    Height = 25
    Caption = 'Button3'
    TabOrder = 6
    Visible = False
    OnClick = Button3Click
  end
  object menu: TMainMenu
    Left = 912
    Top = 504
    object Cadastros1: TMenuItem
      Caption = 'Cadastros'
      object mcVendedores: TMenuItem
        Caption = 'Vendedores'
        OnClick = mcVendedoresClick
      end
      object mcClientes: TMenuItem
        Caption = 'Clientes'
        OnClick = mcClientesClick
      end
      object mcMilhar: TMenuItem
        Caption = 'Milhar'
        OnClick = mcMilharClick
      end
      object Premios1: TMenuItem
        Caption = 'Premios'
        OnClick = Premios1Click
      end
    end
    object AreadeImpressao1: TMenuItem
      Caption = 'Area de Impressao'
      OnClick = AreadeImpressao1Click
    end
    object Consulta1: TMenuItem
      Caption = 'Consulta'
      OnClick = Consulta1Click
    end
    object Ajuda1: TMenuItem
      Caption = 'Ajuda'
      OnClick = Ajuda1Click
    end
  end
  object ZQuery1: TZQuery
    Params = <>
    Left = 104
    Top = 168
  end
  object ZQuery2: TZQuery
    Params = <>
    Left = 152
    Top = 168
  end
end
