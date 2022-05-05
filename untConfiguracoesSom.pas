unit untConfiguracoesSom;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Edit, FMX.Ani,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Effects, FMX.Objects, FMX.Layouts,
  untFuncoes, untClassMonitor, strutils, FMX.Memo.Types, FMX.ScrollBox, FMX.Memo,
  FMX.ListBox, System.IOUtils, FMX.Media, untWebClient;

type
  TfrmConfiguracoesSom = class(TForm)
    layTopo: TLayout;
    Rectangle1: TRectangle;
    rectTopo: TRectangle;
    layVoltar: TLayout;
    imgVoltar: TImage;
    ShadowEffect2: TShadowEffect;
    layTitulo: TLayout;
    lblTitulo: TLabel;
    ShadowEffect1: TShadowEffect;
    layConteudo: TLayout;
    layMenu: TLayout;
    rectFundoMenu: TRectangle;
    layConteudoMenu: TLayout;
    layPainel: TLayout;
    Image3: TImage;
    Label2: TLabel;
    rectTituloMenu: TRectangle;
    layImagemMenu: TLayout;
    imgMenu2: TImage;
    ShadowEffect4: TShadowEffect;
    lblSubtituloMenu: TLabel;
    ShadowEffect5: TShadowEffect;
    layConfiguracoes: TLayout;
    Image2: TImage;
    Label3: TLabel;
    layFechar: TLayout;
    imgFechar: TImage;
    aniMenu: TFloatAnimation;
    StyleBook1: TStyleBook;
    layRodape: TLayout;
    Label1: TLabel;
    ShadowEffect6: TShadowEffect;
    rectConteudo: TRectangle;
    ShadowEffect3: TShadowEffect;
    laySalvar: TLayout;
    imgSalvar: TImage;
    lblObservacao: TLabel;
    layCampos: TLayout;
    ScrollBox1: TScrollBox;
    layLogoEmpresa: TLayout;
    layServidorDados: TLayout;
    rectFundoPadaria: TRectangle;
    layEditServidor: TLayout;
    lblEdtServidor: TLabel;
    lblSubTitulo: TLabel;
    Layout17: TLayout;
    layTransmitir: TLayout;
    lblConfigurado: TLabel;
    imgTocar: TImage;
    rectAutomatico: TRectangle;
    cbxSom: TComboBox;
    procedure layVoltarClick(Sender: TObject);
    procedure imgSalvarClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure cbxSomChange(Sender: TObject);
    procedure imgTocarClick(Sender: TObject);
  private
    { Private declarations }
    FMonitor : TClassMonitor;
    foco: TControl;
    fmx : TFmxObject;
    obj : TObject;

  public
    { Public declarations }
  end;

var
  frmConfiguracoesSom: TfrmConfiguracoesSom;
  tocar : TMediaPlayer;

implementation

{$R *.fmx}

uses untConfiguracoes;

procedure TfrmConfiguracoesSom.cbxSomChange(Sender: TObject);
begin
  if not vazio(cbxSom.Selected.Text) then
    begin
      lblConfigurado.Text := cbxSom.Selected.Text;
    end;
end;

procedure TfrmConfiguracoesSom.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := TCloseAction.caFree;
end;

procedure TfrmConfiguracoesSom.FormCreate(Sender: TObject);
  var
    srrSons : TDynArrayTypeInfo;
    strSom : string;
    strDir : String;
begin
  strDir := TPath.Combine(FAplicativo.Instancia.diretoriopadrao, 'som');

  if DirectoryExists(strDir) then
    begin
      for strSom in TDirectory.GetFiles(strDir) do
        begin
          if ExtractFileExt(strSom) = '.mp3' then
          cbxSom.Items.Add(strSom);
        end;

      if cbxSom.Items.Count > 0 then
        cbxSom.ItemIndex := cbxSom.Items.IndexOf(FAplicativo.arquivosom);
    end
  else
    Close;

  ScrollBox1.Margins.Bottom := 0;
end;

procedure TfrmConfiguracoesSom.FormDestroy(Sender: TObject);
begin
  frmConfiguracoesSom := nil;
end;

procedure TfrmConfiguracoesSom.imgSalvarClick(Sender: TObject);
begin
  FAplicativo.arquivosom := cbxSom.Selected.Text;
  gravaStringStream(FAplicativo.arquivoaplicativo, FAplicativo.AsJson);

  try
    TWebClient.consomeApi(FAplicativo.Servidor + '/api/painel/display/configurasom', 'post', FAplicativo.AsJson);
  finally
    FreeAndNil(TWebClient.FWebClient);
    TWebClient.FWebClient := nil;

    if TWebClient.StatusCode = 200 then
      Close;
  end;
end;

procedure TfrmConfiguracoesSom.imgTocarClick(Sender: TObject);
begin
  tocar := TMediaPlayer.Create(Self);
  tocar.FileName := lblConfigurado.Text;
  tocar.Volume := 100;
  tocar.Stop;
  tocar.Play;
end;

procedure TfrmConfiguracoesSom.layVoltarClick(Sender: TObject);
begin
  Close;
end;

end.
