unit untDisplayFull;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.Effects, FMX.Controls.Presentation, FMX.StdCtrls, FMX.Layouts, FMX.Ani,
  untWebClient, untClassMonitor, untFuncoes, FMX.Media, untClassVisual,
  untClassAplicativo;

type
  TThreadLetreiro = class(TThread)
    private
      procedure atualizaPosicao;
    public
      procedure execute; override;
  end;

  TThreadPadaria = class(TThread)
    private
      FExecucao : Boolean;
      FOldAcougueNormal : integer;
      FOldAcouguePreferencial : integer;
      FOldPadariaNormal : integer;
      FOldPadariaPreferencial : integer;

      procedure chamarProximo(aSetor:String; aSenha: String; aIncrementar:String);
      procedure atualizaVisual;
      procedure tocarSom;
    public
      procedure execute; override;
  end;

  TfrmDisplayFull = class(TForm)
    layPrincipal: TLayout;
    rectPrincipal: TRectangle;
    rectLetreiro: TRectangle;
    ShadowEffect1: TShadowEffect;
    ShadowEffect2: TShadowEffect;
    layAcougue: TLayout;
    q: TRectangle;
    lbltituloAcougue: TLabel;
    Rectangle3: TRectangle;
    layPadaria: TLayout;
    Rectangle1: TRectangle;
    lblTituloPadaria: TLabel;
    Rectangle4: TRectangle;
    layTopo: TLayout;
    lblAcougueNormal: TLabel;
    gpDisplay: TGridPanelLayout;
    layLetreiro: TLayout;
    Rectangle2: TRectangle;
    Rectangle5: TRectangle;
    layFechar: TLayout;
    layimgFechar: TLayout;
    imgFechar: TImage;
    lblLetreiro: TLabel;
    aniLetreiro: TFloatAnimation;
    imgLogo: TImage;
    layMensagem: TLayout;
    Layout2: TLayout;
    Label2: TLabel;
    Label3: TLabel;
    layLogo: TLayout;
    layTopoCentro: TLayout;
    Rectangle6: TRectangle;
    Rectangle7: TRectangle;
    GridPanelLayout1: TGridPanelLayout;
    lblPadariaNormal: TLabel;
    lblPadariaPreferencial: TLabel;
    GridPanelLayout2: TGridPanelLayout;
    lblAcouguePreferencial: TLabel;
    procedure imgFecharClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    arrDados : array of String;
    FPosicao : integer;
    FTempoSleep : Integer;
    FReiniciar : Boolean;
    FIniciando : Boolean;
    strMensagem : String;

    tocar : TMediaPlayer;
    FPadariaNormalOld : integer;
    FPadariaPreferencialOld : integer;
    FAcougueNormalOld : integer;
    FAcouguePreferencialOld : integer;

    procedure configuraFrase;
  public
    { Public declarations }
  end;

var
  frmDisplayFull: TfrmDisplayFull;
  FThreadPadaria : TThreadPadaria;
  FThreadLetreiro : TThreadLetreiro;
  FMonitorAcougue : TClassMonitor;
  FVisual : TClassVisual;

implementation

{$R *.fmx}

procedure TfrmDisplayFull.configuraFrase;
  var
    intIndex : Integer;
    strAcumula : String;
    FConta : integer;
  const
    constMensagem : String =
      'Seja bem vindo.#' +
      'Aproveite nossas ofertas!#' +
      'Agradecemos a preferência!#' +
      'Volte Sempre!##';
begin
  if not vazio(fvisual.configuracoes.frase) then
    begin
      strMensagem := StringReplace(fvisual.configuracoes.frase, #13, '', [rfReplaceAll]);
      strMensagem := StringReplace(strMensagem, #10, '', [rfReplaceAll]);
      strMensagem := StringReplace(strMensagem, #0, '', [rfReplaceAll]);
    end
  else
    strMensagem := constMensagem;

  intIndex := 1;
  SetLength(arrDados, 1);

  for var i :=  0 to StrLen(pchar(strMensagem)) -1 do
    begin
      if strMensagem[i] = '#' then
        begin
          SetLength(arrDados, intIndex);
          arrDados[intIndex -1] := TrimLeft(StringReplace(strAcumula, #0, '', [rfReplaceAll]));
          strAcumula := '';
          inc(intIndex);
        end
      else
        strAcumula := strAcumula + strMensagem[i];
    end;
end;

procedure TfrmDisplayFull.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if FThreadPadaria <> nil then
    begin
      if not FThreadPadaria.Suspended then
        FThreadPadaria.Suspend;

      FThreadPadaria.Terminate;
      FreeAndNil(FThreadPadaria);
    end;

  if FThreadLetreiro <> nil then
    begin
      if not FThreadLetreiro.Suspended then
        FThreadLetreiro.TerminatedSet;

      FreeAndNil(FThreadLetreiro);
    end;

  arrDados := nil;
  Action := TCloseAction.caFree;
end;

procedure TfrmDisplayFull.FormDestroy(Sender: TObject);
begin
  frmDisplayFull := nil;
end;

procedure TfrmDisplayFull.FormShow(Sender: TObject);
  var
    strJson : String;
begin
  FReiniciar := False;
  FIniciando := True;

  if Vazio(TConfiguracoesAplicativo.Instancia.Servidor) then
    begin
      Close;
      Exit;
    end
  else
    begin
      FVisual := TClassVisual.Create;
      leStringStrream(TConfiguracoesAplicativo.Instancia.arquivovisual, strJson);
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

      lblLetreiro.Align := TAlignLayout.Left;
      lblLetreiro.Align := TAlignLayout.None;
      lblLetreiro.AutoSize := True;
      lblLetreiro.EndUpdate;
      lblLetreiro.Repaint;
      lblLetreiro.RecalcUpdateRect;
      lblLetreiro.Position.X := ClientWidth + lblLetreiro.Width;

      { get pega configuração do som }
      if FileExists(TConfiguracoesAplicativo.Instancia.arquivosom) then
        begin
          if tocar = nil then
            tocar := TMediaPlayer.Create(self);
          tocar.FileName := TConfiguracoesAplicativo.Instancia.arquivosom;
        end;

      if FVisual.Configuracoes.doisDisplay <> 'sim' then
        begin
          gpDisplay.ColumnCollection[0].Value := 0;
          gpDisplay.ColumnCollection[1].Value := 100;
        end
      else
        begin
          gpDisplay.ColumnCollection[0].Value := 50;
          gpDisplay.ColumnCollection[1].Value := 50;
        end;

      if not vazio(TConfiguracoesAplicativo.Instancia.Servidor) then
        begin
          FThreadLetreiro := TThreadLetreiro.Create(false);
          configuraFrase;
          FThreadPadaria := TThreadPadaria.Create(False);
        end;
      //frmDisplayFull.FPosicao := 0;
    end;
end;

procedure TfrmDisplayFull.imgFecharClick(Sender: TObject);
begin
  if FThreadPadaria <> nil then
    begin
      if not FThreadPadaria.Suspended then
        FThreadPadaria.TerminatedSet;

      //FThreadPadaria.Terminate;
      FreeAndNil(FThreadPadaria);
    end;

  if FThreadLetreiro <> nil then
    begin
      if not FThreadLetreiro.Suspended then
        FThreadLetreiro.TerminatedSet;

      FreeAndNil(FThreadLetreiro);
    end;

  Close;
end;

procedure TThreadPadaria.atualizaVisual;
begin
  try
    TWebClient.consomeApi(TConfiguracoesAplicativo.Instancia.servidor + '/api/painel/display/frase', 'get', '');
    TWebClient.FWebClient.Destroy;
    TWebClient.FWebClient := nil;

    if TWebClient.StatusCode = 200 then
      begin
        FVisual.AsJson := TWebClient.ResponseBody;
      end;
  except
    // silenciosa
  end;

    {talvez usar isso }
    // frmDisplayFull.lblAcougueNormal.BeginUpdate;

  frmDisplayFull.lblAcougueNormal.Font.Size := FVisual.Configuracoes.fontePadariaTamanho;
  frmDisplayFull.lblAcougueNormal.Scale.X := FVisual.Configuracoes.fontePadariaScaleX;
  frmDisplayFull.lblAcougueNormal.Scale.Y := FVisual.Configuracoes.fontePadariaScaleY;

  frmDisplayFull.lblAcouguePreferencial.Font.Size := FVisual.Configuracoes.fontePadariaTamanho;
  frmDisplayFull.lblAcouguePreferencial.Scale.X := FVisual.Configuracoes.fontePadariaScaleX;
  frmDisplayFull.lblAcouguePreferencial.Scale.Y := FVisual.Configuracoes.fontePadariaScaleY;

  frmDisplayFull.lblPadariaNormal.Font.Size := FVisual.Configuracoes.fontePadariaTamanho;
  frmDisplayFull.lblPadariaNormal.Scale.X := FVisual.Configuracoes.fontePadariaScaleX;
  frmDisplayFull.lblPadariaNormal.Scale.Y := FVisual.Configuracoes.fontePadariaScaleY;

  frmDisplayFull.lblPadariaPreferencial.Font.Size := FVisual.Configuracoes.fontePadariaTamanho;
  frmDisplayFull.lblPadariaPreferencial.Scale.X := FVisual.Configuracoes.fontePadariaScaleX;
  frmDisplayFull.lblPadariaPreferencial.Scale.Y := FVisual.Configuracoes.fontePadariaScaleY;

  {talvez usar isso }
  //  frmDisplayFull.lblSenhaAcougue.EndUpdate;


  if FVisual.Configuracoes.fatorTempoLetreito > 0 then
    frmDisplayFull.FTempoSleep := FVisual.Configuracoes.fatorTempoLetreito
  else
    frmDisplayFull.FTempoSleep := 4;

  frmDisplayFull.strMensagem := FVisual.Configuracoes.Frase;
end;

procedure TThreadPadaria.chamarProximo(aSetor, aSenha, aIncrementar: String);
var
    FMonPadaria : TClassMonitor;
    strJSon : String;

  const
    constJSon : string =
      '{' +
      '   "setor" : "%s", ' +
      '   "senha" : "%s", ' +
      '   "incrementar" : "%s"' +
      '}';
begin
  try
    try
      strJSon := Format(constJSon, [aSetor, aSenha, aIncrementar]);
      TWebClient.consomeApi(TConfiguracoesAplicativo.Instancia.servidor + '/api/painel/display/display', 'post', strJSon);

      if twebclient.StatusCode = 200 then
        begin
          FMonPadaria := TClassMonitor.Create;
          FMonPadaria.AsJson := twebclient.ResponseBody;

          frmDisplayFull.lbltituloAcougue.Text := FMonPadaria.Acougue.Descritivo;
          frmDisplayFull.lblTituloPadaria.Text := FMonPadaria.Padaria.Descritivo;

          if aSetor = 'ACOUGUE' then
            begin
              if FMonPadaria.chamandonovamente = 'sim' then
                begin
                  tocarSom;
                end
              else
                begin
                  if FOldAcouguePreferencial <> FMonPadaria.Acougue.Acouguepreferencial then
                    begin
                      TThread.Synchronize(TThread.Current,
                        procedure
                          begin
                            frmDisplayFull.lblAcouguePreferencial.Text := FormatFloat('P000#', FMonPadaria.Acougue.Acouguepreferencial);
                          end);

                      FOldAcouguePreferencial := FMonPadaria.Acougue.Acouguepreferencial;
                      tocarSom;
                    end;

                  if FOldAcougueNormal <> FMonPadaria.Acougue.Acouguenormal then
                    begin
                      TThread.Synchronize(TThread.Current,
                        procedure
                          begin
                            frmDisplayFull.lblAcougueNormal.Text := FormatFloat('N000#', FMonPadaria.Acougue.Acouguenormal);
                          end);

                      FOldAcougueNormal := FMonPadaria.Acougue.Acouguenormal;
                      tocarSom;
                    end;
                end;
            end;
        end;

      if aSetor = 'PADARIA' then
        begin
          if FMonPadaria.chamandonovamente = 'sim' then
            begin
              tocarSom;
            end
          else
            begin
              if FOldPadariaPreferencial <> FMonPadaria.Padaria.Padariapreferencial then
                begin
                  TThread.Synchronize(TThread.Current,
                    procedure
                      begin
                        frmDisplayFull.lblPadariaPreferencial.Text := FormatFloat('P000#', FMonPadaria.Padaria.Padariapreferencial);
                      end);

                  FOldPadariaPreferencial := FMonPadaria.Padaria.Padariapreferencial;
                  tocarSom;
                end;

              if FOldPadariaNormal <> FMonPadaria.Padaria.Padarianormal then
                begin
                  TThread.Synchronize(TThread.Current,
                    procedure
                      begin
                        frmDisplayFull.lblPadariaNormal.Text := FormatFloat('N000#', FMonPadaria.Padaria.Padarianormal);
                      end);

                  FOldPadariaNormal := FMonPadaria.Padaria.Padarianormal;
                  tocarSom;
                end;
            end;
        end;
    except

    end;
  finally
    TWebClient.FWebClient.Destroy;
    TWebClient.FWebClient := nil;
  end;
end;

procedure TThreadPadaria.execute;
begin
  inherited;
  FExecucao := False;
  FOldAcougueNormal := 0;
  FOldAcouguePreferencial := 0;
  FOldPadariaNormal := 0;
  FOldPadariaPreferencial := 0;

  while not Terminated do
    begin
      if not vazio(TConfiguracoesAplicativo.Instancia.Servidor) then
        begin
          chamarProximo('ACOUGUE', 'PREFERENCIAL', 'CONSULTA');
          Sleep(100);
          chamarProximo('PADARIA', 'PREFERENCIAL', 'CONSULTA');
          Sleep(100);
          atualizaVisual;
        end;
    end;
end;

procedure TThreadPadaria.tocarSom;
begin
  frmDisplayFull.tocar.Stop;
  frmDisplayFull.tocar.CurrentTime :=  0;
  frmDisplayFull.tocar.Media.Play;
end;

{ TThreadLetreiro }

procedure TThreadLetreiro.atualizaPosicao;
begin
  if frmDisplayFull.lblLetreiro.Position.X <= 0 then
    begin
      if frmDisplayFull.lblLetreiro.Position.X <= (0 - frmDisplayFull.lblLetreiro.Width) then
        begin
          frmDisplayFull.lblLetreiro.Position.x := frmDisplayFull.ClientWidth;
          frmDisplayFull.lblLetreiro.Text := frmDisplayFull.arrDados[frmDisplayFull.FPosicao];

          inc(frmDisplayFull.FPosicao);

          if frmDisplayFull.FPosicao > (Length(frmDisplayFull.arrDados)-1) then
            frmDisplayFull.FPosicao := 0;
        end;
    end;

 frmDisplayFull.lblLetreiro.Position.X := frmDisplayFull.lblLetreiro.Position.X - 1;
end;

procedure TThreadLetreiro.execute;
begin
  inherited;

  frmDisplayFull.FPosicao := 0;
  frmDisplayFull.FTempoSleep := 4;

  frmDisplayFull.lblLetreiro.Align := TAlignLayout.None;
  frmDisplayFull.lblLetreiro.Text := frmDisplayFull.arrDados[0];
  frmDisplayFull.lblLetreiro.Position.X := frmDisplayFull.ClientWidth;

  while not Terminated do
    begin
      atualizaPosicao;
      Sleep(frmDisplayFull.FTempoSleep);
    end;
end;

end.
