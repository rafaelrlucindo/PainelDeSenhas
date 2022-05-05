unit untSenha;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Layouts, FMX.Effects
  {$IFDEF ANDROID}
  ,Androidapi.JNI.PowerManager
  {$ENDIF}

  ,untWebClient, untfuncoes, untClassAplicativo, untClassMonitor, untClassVisual;

type
  TfrmSenha = class(TForm)
    layPrincipal: TLayout;
    layImpressos: TLayout;
    laySenhaPadaria: TLayout;
    layAcougueNormal: TLayout;
    lblNormal: TLabel;
    layPreferencial: TLayout;
    Layout7: TLayout;
    Rectangle3: TRectangle;
    Label1: TLabel;
    Rectangle4: TRectangle;
    Label2: TLabel;
    Layout1: TLayout;
    GridPanelLayout1: TGridPanelLayout;
    layAcougue: TLayout;
    rectAcougue: TRectangle;
    lbltituloAcougue: TLabel;
    rectAcougueNormal: TRectangle;
    layPadaria: TLayout;
    rectAcouguePreferencial: TRectangle;
    layAcouguePreferencial: TLayout;
    Label7: TLabel;
    q: TRectangle;
    lblTituloPadaria: TLabel;
    rectPadariaNormal: TRectangle;
    layPadariaNormal: TLayout;
    Label8: TLabel;
    rectPadariaPreferencial: TRectangle;
    layPadariaPreferencial: TLayout;
    Label9: TLabel;
    Layout2: TLayout;
    layTitulo: TLayout;
    layLogo: TLayout;
    imgLogo: TImage;
    layMensagem: TLayout;
    Layout6: TLayout;
    Layout10: TLayout;
    Label5: TLabel;
    Layout9: TLayout;
    Label3: TLabel;
    ShadowEffect1: TShadowEffect;
    ShadowEffect2: TShadowEffect;
    ShadowEffect3: TShadowEffect;
    ShadowEffect4: TShadowEffect;
    ShadowEffect5: TShadowEffect;
    ShadowEffect6: TShadowEffect;
    ShadowEffect7: TShadowEffect;
    ShadowEffect8: TShadowEffect;
    ShadowEffect9: TShadowEffect;
    ShadowEffect10: TShadowEffect;
    GlowEffect1: TGlowEffect;
    GlowEffect2: TGlowEffect;
    GridPanelLayout2: TGridPanelLayout;
    procedure layImpressosDblClick(Sender: TObject);
    procedure layPadariaNormalClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure imgFecharClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmSenha: TfrmSenha;
  FVisual : TClassVisual;

implementation

{$R *.fmx}

procedure TfrmSenha.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  FreeAndNil(FVisual);
end;

procedure TfrmSenha.FormDestroy(Sender: TObject);
begin
  frmSenha := nil;
end;

procedure TfrmSenha.FormShow(Sender: TObject);
  var
    strJson : String;
    FMonTemp : TClassMonitor;
begin
  try
    try
      layAcougueNormal.TagString := 'imprimiracouguenormal';
      layAcouguePreferencial.TagString := 'imprimiracouguepreferencial';

      layPadariaNormal.TagString := 'imprimirpadarianormal';
      layPadariaPreferencial.TagString := 'imprimirpadariapreferencial';

      TThread.CreateAnonymousThread(
        procedure
          begin
            TWebClient.consomeApi(FAplicativo.servidor + '/api/painel/display/display', 'post', '{"setor" : "ACOUGUE", "senha" : "NORMAL", "incrementar" : "CONSULTAR"}');
            Sleep(200);
            if TWebClient.StatusCode = 200 then
              begin
                TThread.Synchronize(TThread.Current,
                  procedure
                    begin
                      FMonTemp := TClassMonitor.Create;
                      FMonTemp.AsJson := TWebClient.ResponseBody;
                      lbltituloAcougue.Text := FMonTemp.Acougue.Descritivo;
                      lblTituloPadaria.Text := FMonTemp.Padaria.Descritivo;
                      FreeAndNil(FMonTemp);
                    end);
              end;
          end).Start;

      FVisual := TClassVisual.Create;
      leStringStrream(FAplicativo.arquivovisual, strJson);
      FVisual.AsJson := strJson;

      if FVisual.Configuracoes.Mostrarlogo = 'sim' then
        begin
          if not vazio(FVisual.Configuracoes.logoEmpresa) then
            begin
              if FileExists(FVisual.Configuracoes.logoEmpresa) then
                imgLogo.Bitmap.LoadFromFile(FVisual.Configuracoes.logoEmpresa);
            end
          else
            begin
              imgLogo.Bitmap := nil;

              layLogo.Width := 0;
              layLogo.Align := TAlignLayout.None;
              layMensagem.Align := TAlignLayout.Client;
            end;
        end
      else
        begin
          imgLogo.Bitmap := nil;
          layLogo.Width := 0;
          layLogo.Align := TAlignLayout.None;
          layMensagem.Align := TAlignLayout.Client;
        end;
    except
      // silenciosa
    end;
  finally

  end;
end;

procedure TfrmSenha.imgFecharClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmSenha.layPadariaNormalClick(Sender: TObject);
begin
  try
    try
      TWebClient.consomeApi(FAplicativo.Servidor + '/api/painel/display/' + TLayout(Sender).TagString, 'get', '');
    except
      // silenciosa, nao remover
    end;
  finally
    TWebClient.FWebClient.Destroy;
    TWebClient.FWebClient := nil;
  end;
end;

procedure TfrmSenha.layImpressosDblClick(Sender: TObject);
begin
  Self.FullScreen := True;
end;

end.
