object fPremios: TfPremios
  Left = 0
  Top = 0
  BorderStyle = bsToolWindow
  Caption = 'Cadastrar Premios'
  ClientHeight = 365
  ClientWidth = 690
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
  object btncad: TButton
    Left = 563
    Top = 175
    Width = 120
    Height = 32
    Caption = 'Cadastrar'
    TabOrder = 0
    OnClick = btncadClick
  end
  object DBGrid1: TDBGrid
    Left = 28
    Top = 237
    Width = 654
    Height = 120
    DataSource = dm.dsPremios
    DrawingStyle = gdsGradient
    TabOrder = 1
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
    Columns = <
      item
        Expanded = False
        FieldName = 'ID'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'NOME'
        Title.Caption = 'VENDEDOR'
        Width = 215
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'PREMIO'
        Width = 250
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'DATASORTEIO'
        Title.Alignment = taCenter
        Title.Caption = 'DATA SORTEIO'
        Width = 105
        Visible = True
      end>
  end
  object btnEdi: TButton
    Left = 437
    Top = 175
    Width = 120
    Height = 32
    Caption = 'Editar'
    TabOrder = 2
  end
  object btnExc: TButton
    Left = 311
    Top = 175
    Width = 120
    Height = 32
    Caption = 'Excluir'
    TabOrder = 3
  end
  object GroupBox1: TGroupBox
    Left = 28
    Top = 8
    Width = 654
    Height = 161
    Color = clWhite
    ParentBackground = False
    ParentColor = False
    TabOrder = 4
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
    object Label1: TLabel
      Left = 18
      Top = 76
      Width = 122
      Height = 16
      Caption = 'Descri'#231#227'o do Premio:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Label2: TLabel
      Left = 491
      Top = 76
      Width = 94
      Height = 16
      Caption = 'Data do Sorteio:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object cbVendedores: TComboBox
      Left = 18
      Top = 31
      Width = 623
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
      TabOrder = 0
    end
    object txtPremios: TEdit
      Left = 18
      Top = 98
      Width = 447
      Height = 33
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -21
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
    end
    object txtDataSorteio: TMaskEdit
      Left = 491
      Top = 98
      Width = 150
      Height = 33
      EditMask = '!99/99/0000;1;_'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Tahoma'
      Font.Style = []
      MaxLength = 10
      ParentFont = False
      TabOrder = 2
      Text = '  /  /    '
    end
  end
  object carregarLoginCB: TZQuery
    Connection = dm.conexao
    SQL.Strings = (
      'SELECT * FROM login')
    Params = <>
    Left = 288
    Top = 128
  end
end
