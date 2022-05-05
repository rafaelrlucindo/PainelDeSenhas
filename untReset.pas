unit untReset;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Layouts, FMX.Ani, FMX.Controls.Presentation, FMX.Effects, FMX.Objects,
  untClassAplicativo, untClassVisual, untFuncoes, untWebClient, fmx.DialogService;

type
  TfrmResert = class(TForm)
    layTopo: TLayout;
    Rectangle1: TRectangle;
    rectTopo: TRectangle;
    layVoltar: TLayout;
    imgVoltar: TImage;
    ShadowEffect2: TShadowEffect;
    layTitulo: TLayout;
    lblTitulo: TLabel;
    ShadowEffect1: TShadowEffect;
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
    layConteudo: TLayout;
    rectConteudo: TRectangle;
    ShadowEffect3: TShadowEffect;
    laySalvar: TLayout;
    imgSalvar: TImage;
    lblObservacao: TLabel;
    layCampos: TLayout;
    ScrollBox1: TScrollBox;
    layDisplay: TLayout;
    layLogoEmpresa: TLayout;
    layServidorDados: TLayout;
    rectFundoPadaria: TRectangle;
    layEditServidor: TLayout;
    lblEdtServidor: TLabel;
    Layout17: TLayout;
    layEdtAutomatico: TLayout;
    swtReset: TSwitch;
    lblSubTitulo: TLabel;
    Layout1: TLayout;
    imgReset: TImage;
    Label4: TLabel;
    imgZerarDia: TImage;
    procedure FormShow(Sender: TObject);
    procedure imgResetClick(Sender: TObject);
    procedure imgSalvarClick(Sender: TObject);
    procedure imgVoltarClick(Sender: TObject);
  private
    { Private declarations }
    FReset : TClassVisual;
  public
    { Public declarations }
  end;

var
  FrmResert: TFrmResert;

implementation

{$R *.fmx}

procedure TfrmResert.FormShow(Sender: TObject);
  var
    strJSon : string;
begin
  FReset := TClassVisual.Create;
  leStringStrream(FAplicativo.arquivovisual, strJSon);
  FReset.AsJson := strJSon;

  swtReset.IsChecked := (FReset.Configuracoes.Zerardiario = 'sim');
end;

procedure TfrmResert.imgResetClick(Sender: TObject);
begin
  if not vazio(FAplicativo.servidor) then
    begin
      try
        TWebClient.consomeApi(FAplicativo.servidor + '/api/painel/display/resetasenhas', 'get', '');

        TDialogService.ShowMessage('As senhas foram zeradas!');
        Close;
      except
        // silenciosa
      end;
    end;
end;

procedure TfrmResert.imgSalvarClick(Sender: TObject);
begin
  if not vazio(FAplicativo.servidor) then
    begin
      try
        TWebClient.consomeApi(FAplicativo.servidor + '/api/painel/display/resetasenhas', 'post', '{ "zerardiario" : "sim"}');
        Close;
      except
        // silenciosa
      end;
    end;

end;

procedure TfrmResert.imgVoltarClick(Sender: TObject);
begin
  Close;
end;

end.
