unit untConfiguracoesDisplay;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Edit, FMX.Ani,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Effects, FMX.Objects, FMX.Layouts,
  untFuncoes, untClassMonitor, strutils, FMX.Memo.Types, FMX.ScrollBox, FMX.Memo,
  untWebClient, untClassVisual, System.Actions, FMX.ActnList, FMX.StdActns,
  FMX.MediaLibrary.Actions, System.IOUtils, untClassAplicativo;

type
  TfrmConfiguracoesDisplay = class(TForm)
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
    layDisplay: TLayout;
    layDadosFrase: TLayout;
    Rectangle2: TRectangle;
    imgFrase: TImage;
    lblEdtFrase: TLabel;
    layLogoEmpresa: TLayout;
    layServidorDados: TLayout;
    rectFundoPadaria: TRectangle;
    layEditServidor: TLayout;
    lblEdtServidor: TLabel;
    layFrase: TLayout;
    Layout4: TLayout;
    Layout7: TLayout;
    Rectangle4: TRectangle;
    Layout9: TLayout;
    Label5: TLabel;
    Rectangle5: TRectangle;
    mmoLetreiro: TMemo;
    Label6: TLabel;
    Image1: TImage;
    lblSubTitulo: TLabel;
    Layout1: TLayout;
    Layout15: TLayout;
    layFonteDisplay: TLayout;
    Label4: TLabel;
    Rectangle3: TRectangle;
    edtFonteDisplay: TEdit;
    layFonte: TLayout;
    q: TLayout;
    Label10: TLabel;
    Rectangle8: TRectangle;
    edtScaleY: TEdit;
    Layout16: TLayout;
    Label11: TLabel;
    Rectangle10: TRectangle;
    edtScaleX: TEdit;
    Layout17: TLayout;
    layEdtAutomatico: TLayout;
    lblMostrar: TLabel;
    rectAutomatico: TRectangle;
    swtMostrarLogo: TSwitch;
    imgLogo: TImage;
    StyleBook1: TStyleBook;
    ActionList1: TActionList;
    actLogo: TTakePhotoFromLibraryAction;
    Layout10: TLayout;
    Layout11: TLayout;
    Layout12: TLayout;
    Label7: TLabel;
    Rectangle6: TRectangle;
    edtTempoLetreiro: TEdit;
    Layout2: TLayout;
    Layout6: TLayout;
    rectFundoDisplay: TRectangle;
    imgDisplay: TImage;
    Layout3: TLayout;
    Label8: TLabel;
    rectDisplay: TRectangle;
    swtDisplay: TSwitch;
    Layout8: TLayout;
    Layout5: TLayout;
    Label9: TLabel;
    Rectangle7: TRectangle;
    Edit1: TEdit;
    Layout13: TLayout;
    Label12: TLabel;
    Rectangle9: TRectangle;
    swtSenhaDupla: TSwitch;
    procedure layVoltarClick(Sender: TObject);
    procedure imgSalvarClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure FormVirtualKeyboardHidden(Sender: TObject; KeyboardVisible: Boolean; const Bounds: TRect);
    procedure edtFraseEnter(Sender: TObject);
    procedure edtDisplay2Enter(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure imgLogoClick(Sender: TObject);
    procedure actLogoDidFinishTaking(Image: TBitmap);
  private
    { Private declarations }
    FVisual : TClassVisual;
    foco: TControl;
    fmx : TFmxObject;
    obj : TObject;

    procedure ajustarFoco; //(Sender:TObject);
  public
    { Public declarations }
  end;

var
  frmConfiguracoesDisplay: TfrmConfiguracoesDisplay;
  FArquivoLogo : STring;

implementation

{$R *.fmx}

uses untConfiguracoes;

procedure TfrmConfiguracoesDisplay.actLogoDidFinishTaking(Image: TBitmap);
begin
  imgLogo.Bitmap.Assign(Image);

  FVisual.Configuracoes.logoEmpresa :=
    System.ioUtils.TPath.Combine(FAplicativo.diretoriopadrao, 'logo.png');

  imgLogo.Bitmap.SaveToFile(FVisual.Configuracoes.logoEmpresa)
end;

procedure TfrmConfiguracoesDisplay.ajustarFoco;
begin
  {$IFDEF Android }
    with frmConfiguracoesDisplay do
      begin
        ScrollBox1.Margins.Bottom := 250;
        ScrollBox1.ViewportPosition := PointF(
          ScrollBox1.ViewportPosition.X,
          TLayout(obj).Position.Y - 90
        );
      end;
  {$ENDIF}
end;

procedure TfrmConfiguracoesDisplay.edtDisplay2Enter(Sender: TObject);
  var
    ancestral1 : string;
begin
  foco := TControl(TEdit(Sender).Parent);
  ancestral1 := foco.Name;
  obj := FindComponent(tedit(Sender).TagString);
  ajustarFoco;
end;

procedure TfrmConfiguracoesDisplay.edtFraseEnter(Sender: TObject);
  var
    ancestral1 : string;
begin
  foco := TControl(TEdit(Sender).Parent);
  ancestral1 := foco.Name;
  obj := FindComponent(tedit(Sender).TagString);
  ajustarFoco;
end;

procedure TfrmConfiguracoesDisplay.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if FVisual <> nil then
    FreeAndNil(FVisual);

  Action := TCloseAction.caFree;
end;

procedure TfrmConfiguracoesDisplay.FormDestroy(Sender: TObject);
begin
  frmConfiguracoes := nil;
end;

procedure TfrmConfiguracoesDisplay.FormShow(Sender: TObject);
  var
    FMonDisp : TClassVisual;
    strJSon : string;
begin
  FVisual := TClassVisual.Create;
  leStringStrream(TConfiguracoesAplicativo.Instancia.arquivovisual, strJSon);
  FVisual.AsJson := strJSon;

  ScrollBox1.Margins.Bottom := 0;

  edtFonteDisplay.TagString := 'layDisplay';
  edtScaleX.TagString := 'layDisplay';
  edtScaleY.TagString := 'layDisplay';

  mmoLetreiro.TagString := 'layLetreiro';
  edtTempoLetreiro.TagString := 'layFrase';

  try
    TWebClient.consomeApi(FAplicativo.servidor + '/api/painel/display/frase', 'get', '');
    TWebClient.FWebClient.Destroy;
    TWebClient.FWebClient := nil;

    if TWebClient.StatusCode = 200 then
      begin
        FMonDisp := TClassVisual.Create;
        FMonDisp.AsJson := TWebClient.ResponseBody;

        FVisual.Configuracoes.Mostrarlogo := FMonDisp.Configuracoes.Mostrarlogo;

        { fonte display }
        FVisual.Configuracoes.fontePadariaTamanho := FMonDisp.Configuracoes.fontePadariaTamanho;
        FVisual.Configuracoes.fontePadariaScaleX := FMonDisp.Configuracoes.fontePadariaScaleX;
        FVisual.Configuracoes.fontePadariaScaleY := FMonDisp.Configuracoes.fontePadariaScaleY;

        { fonte letreiro }
        FVisual.Configuracoes.fonteLetreitoTamanho := FMonDisp.Configuracoes.fonteLetreitoTamanho;
        FVisual.Configuracoes.fatorTempoLetreito := FMonDisp.Configuracoes.fatorTempoLetreito;
        FVisual.Configuracoes.Frase := FMonDisp.Configuracoes.Frase;
        FVisual.Configuracoes.senhaDupla := FMonDisp.Configuracoes.senhaDupla;
        FVisual.Configuracoes.doisDisplay := FMonDisp.Configuracoes.doisDisplay;
      end;
  except
    // silenciosa
  end;

  { logo emmpresa }
  if FileExists(FVisual.Configuracoes.logoEmpresa) then
    begin
      {$IFDEF MSWINDOWS}
        imgLogo.Bitmap.LoadFromFile(FVisual.Configuracoes.logoEmpresa);
        FArquivoLogo := FVisual.Configuracoes.logoEmpresa;
      {$ELSE}
        FArquivoLogo := TPath.Combine(FAplicativo.diretoriopadrao, 'logo.png');
        imgLogo.Bitmap.LoadFromFile(FArquivoLogo);
      {$ENDIF}
    end;

  mmoLetreiro.Lines.Text := FVisual.Configuracoes.Frase;
  FVisual.Configuracoes.fonteLetreitoTamanho := 64;

  swtDisplay.IsChecked := iif(FMonDisp.Configuracoes.doisDisplay = 'sim', True, False);
  swtSenhaDupla.IsChecked := iif(FVisual.Configuracoes.senhaDupla = 'sim', True, False);

  edtTempoLetreiro.Text := iif(
    FVisual.Configuracoes.fatorTempoLetreito = 0,
      '0.03',
      FVisual.Configuracoes.fatorTempoLetreito.ToString
  );

  { display - scala da fonte e tamanho }
  edtFonteDisplay.Text := iif(
    FVisual.Configuracoes.fontePadariaTamanho = 0,
      '160',
      FVisual.Configuracoes.fontePadariaTamanho
  );

  edtScaleX.Text := iif(
    FVisual.Configuracoes.fontePadariaScaleX = 0,
      '1,5',
      FVisual.Configuracoes.fontePadariaScaleX
  );

  edtScaleY.Text := iif(
    FVisual.Configuracoes.fontePadariaScaleY = 0,
      '3',
      FVisual.Configuracoes.fontePadariaScaleY
  );
end;

procedure TfrmConfiguracoesDisplay.FormVirtualKeyboardHidden(Sender: TObject; KeyboardVisible: Boolean; const Bounds: TRect);
begin
  ScrollBox1.Margins.Bottom := 0;
end;

procedure TfrmConfiguracoesDisplay.imgLogoClick(Sender: TObject);
  var
    opnDlg : TOpenDialog;
begin
  {$IFDEF MSWINDOWS}
    try
      opnDlg := TOpenDialog.Create(Self);
      opnDlg.Execute;

      if opnDlg.Files.Count > 0 then
        begin
          imgLogo.Bitmap.LoadFromFile(opnDlg.FileName);
          FVisual.Configuracoes.logoEmpresa := opnDlg.FileName;
        end;
    finally
      FreeAndNil(opnDlg);
    end;
  {$ELSE}
    actLogo.Execute;
  {$ENDIF}
end;

procedure TfrmConfiguracoesDisplay.imgSalvarClick(Sender: TObject);
begin
  try
    try
      { senha dupla no mesmo display }
      FVisual.Configuracoes.senhaDupla := iif(swtSenhaDupla.IsChecked, 'sim', 'não');
      FVisual.Configuracoes.doisDisplay := iif(swtDisplay.IsChecked, 'sim', 'não');

      { logo }
      FVisual.Configuracoes.Mostrarlogo := iif(swtMostrarLogo.IsChecked, 'sim', 'não');

      { fonte display }
      FVisual.Configuracoes.fontePadariaTamanho := edtFonteDisplay.Text.ToSingle;
      FVisual.Configuracoes.fontePadariaScaleX := edtScaleX.Text.ToSingle;
      FVisual.Configuracoes.fontePadariaScaleY := edtScaleY.Text.ToSingle;

      { fonte letreiro }
FVisual.Configuracoes.fatorTempoLetreito := StrToIntDef(edtTempoLetreiro.Text, 3);

      FVisual.Configuracoes.Mostrarlogo := iif(swtMostrarLogo.IsChecked, 'sim', 'não');

      { frase }
      FVisual.Configuracoes.Frase := mmoLetreiro.Text + '#';

      gravaStringStream(TConfiguracoesAplicativo.Instancia.arquivovisual, FVisual.AsJson);

      TWebClient.consomeApi(FAplicativo.servidor + '/api/painel/display/frase', 'post', FVisual.AsJson);
      TWebClient.FWebClient.Destroy;
      TWebClient.FWebClient := nil;

      if TWebClient.StatusCode = 200 then
        begin
          // nao faz nada mesmo, ver um dia
        end;

      //Close;
    except
      // silenciosa
    end;
  finally

  end;
end;

procedure TfrmConfiguracoesDisplay.layVoltarClick(Sender: TObject);
begin
  Close;
end;

end.
