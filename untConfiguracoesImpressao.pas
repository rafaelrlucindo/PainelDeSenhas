unit untConfiguracoesImpressao;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Edit, FMX.Ani,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Effects, FMX.Objects, FMX.Layouts,
  untFuncoes, untClassMonitor, strutils, FMX.Memo.Types, FMX.ScrollBox, FMX.Memo,
  MATH, untWebClient, JSON;

type
  TfrmConfiguracoesImpressao = class(TForm)
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
    layEdtAutomatico: TLayout;
    lblMostrar: TLabel;
    rectAutomatico: TRectangle;
    swtUsaImpressao: TSwitch;
    procedure layVoltarClick(Sender: TObject);
    procedure imgSalvarClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
public
    { Public declarations }
  end;

var
  frmConfiguracoesImpressao: TfrmConfiguracoesImpressao;

implementation

{$R *.fmx}

procedure TfrmConfiguracoesImpressao.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := TCloseAction.caFree;
end;

procedure TfrmConfiguracoesImpressao.FormCreate(Sender: TObject);
begin
  ScrollBox1.Margins.Bottom := 0;
end;

procedure TfrmConfiguracoesImpressao.FormDestroy(Sender: TObject);
begin
  frmConfiguracoesImpressao := nil;
end;
procedure TfrmConfiguracoesImpressao.FormShow(Sender: TObject);
  var
    aValue : TJSONValue;
begin
  try
    TWebClient.consomeApi(FAplicativo.servidor + '/api/painel/display/configuracaoimpressao', 'get' , '');
  finally
    TWebClient.FWebClient.Destroy;
    TWebClient.FWebClient := nil;

    if TWebClient.StatusCode = 200 then
      begin
        aValue := TJSONObject.ParseJSONValue(TWebClient.ResponseBody);
        FAplicativo.usaimrpessao := (aValue as TJSONObject).GetValue('usaimpressao').Value;
      end;
  end;

  swtUsaImpressao.IsChecked := (FAplicativo.usaimrpessao = 'sim');
end;

procedure TfrmConfiguracoesImpressao.imgSalvarClick(Sender: TObject);
begin
  FAplicativo.usaimrpessao := iif(swtUsaImpressao.IsChecked, 'sim', 'não');
  gravaStringStream(FAplicativo.arquivoaplicativo, FAplicativo.AsJson);

  try
    TWebClient.consomeApi(FAplicativo.Servidor + '/api/painel/display/configuracaoimpressao', 'post' ,
      '{"usaimpressao" : "' + iif(swtUsaImpressao.IsChecked, 'sim', 'não') + '"}');
  finally
    TWebClient.FWebClient.Destroy;
    TWebClient.FWebClient := nil;

    if TWebClient.StatusCode = 200 then
      begin
        // nao faz nada, ver um dia
      end;
  end;

  Close;
end;

procedure TfrmConfiguracoesImpressao.layVoltarClick(Sender: TObject);
begin
  Close;
end;

end.
