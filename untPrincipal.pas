unit untPrincipal;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Menus,
  System.Math.Vectors, FMX.Controls3D, FMX.Layers3D, FMX.Effects, FMX.Controls.Presentation,
  System.Threading, System.Permissions, FMX.DialogService, untWebClient, System.SyncObjs,

  {$IFDEF ANDROID}
    Androidapi.JNIBridge, Androidapi.JNI.JavaTypes, //Androidapi.JNI.Network,
    Androidapi.Helpers, Androidapi.JNI.Os,  Androidapi.JNI.Telephony,
    Androidapi.JNI.GraphicsContentViewText, FMX.Helpers.Android,
    FMX.PushNotification.Android, Androidapi.JNI.PowerManager,
  {$ENDIF}

  FMX.StdCtrls, FMX.Objects, FMX.Layouts, FMX.Ani, untConfiguracoes, untClassMonitor,
  untFuncoes, untClassAplicativo, System.IOUtils, untConfiguracoesDisplay,
  untConfiguracoesSom, untDisplay, untTeclado, untConfiguracoesImpressao,
  untClassVisual, untConfiguracoesReset, untSenha, untDisplayFull,
  FMX.Memo.Types, FMX.ScrollBox, FMX.Memo;

type
  TThreadFila = class(TThread)
    private
      FtarefaExecutar: TProc;
    public
      property tarefaExecutar: TProc read FtarefaExecutar write FtarefaExecutar;
      procedure execute; override;
  end;

  TfrmPrincipal = class(TForm)
    layTopo: TLayout;
    layConteudo: TLayout;
    rectTopo: TRectangle;
    layMenuTopo: TLayout;
    imgMenu: TImage;
    ShadowEffect2: TShadowEffect;
    rectConteudo: TRectangle;
    ShadowEffect3: TShadowEffect;
    layTitulo: TLayout;
    lblTitulo: TLabel;
    ShadowEffect1: TShadowEffect;
    Rectangle1: TRectangle;
    layInfoPadaria: TLayout;
    layInfoAcougue: TLayout;
    layRodape: TLayout;
    Label1: TLabel;
    lblSubTitulo: TLabel;
    layDadosAcougue: TLayout;
    Layout4: TLayout;
    Layout5: TLayout;
    Layout6: TLayout;
    lblTitAcoNor: TLabel;
    lblTitAcoPref: TLabel;
    lblAcougueNormal: TLabel;
    lblAcouguePreferencial: TLabel;
    imgAcougue: TImage;
    Layout2: TLayout;
    Layout3: TLayout;
    Layout7: TLayout;
    lblTitPadNormal: TLabel;
    lblPadariaNormal: TLabel;
    Layout8: TLayout;
    lblTitPadPref: TLabel;
    lblPadariaPreferencial: TLabel;
    Image1: TImage;
    layMenu: TLayout;
    layMenuConteudo: TLayout;
    rectTituloMenu: TRectangle;
    layImagemMenu: TLayout;
    imgMenu2: TImage;
    ShadowEffect4: TShadowEffect;
    lblSubtituloMenu: TLabel;
    ShadowEffect5: TShadowEffect;
    layConfiguracoes: TLayout;
    layPainel: TLayout;
    Image2: TImage;
    Image3: TImage;
    lblPainel: TLabel;
    lblConfiguracoes: TLabel;
    rectFundoMenu: TRectangle;
    aniMenu: TFloatAnimation;
    ShadowEffect6: TShadowEffect;
    layDisplay: TLayout;
    imgDisplay: TImage;
    lblDisplay: TLabel;
    layAudio: TLayout;
    Image4: TImage;
    lblAudio: TLabel;
    laySair: TLayout;
    Image5: TImage;
    lblSair: TLabel;
    layTeclado: TLayout;
    imgTeclado: TImage;
    lblTeclado: TLabel;
    layConfiguracaoImpressao: TLayout;
    imgConfiguracaoImpressao: TImage;
    lblConfiguracaoImpressao: TLabel;
    layImpressao: TLayout;
    imgImpressao: TImage;
    lblImpressao: TLabel;
    layResetSenha: TLayout;
    imgReset: TImage;
    Label2: TLabel;
    ScrollBar1: TScrollBar;
    lblNaoConfigurado: TLabel;
    aniNaoConfigurado: TFloatAnimation;
    layLogs: TLayout;
    mmoLogs: TMemo;
    StyleBook1: TStyleBook;
    lblVersion: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure imgMenuClick(Sender: TObject);
    procedure imgMenu2Click(Sender: TObject);
    procedure layConfiguracoesClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure layPainelClick(Sender: TObject);
    procedure laySairClick(Sender: TObject);
    procedure layAudioClick(Sender: TObject);
    procedure lblAudioClick(Sender: TObject);
    procedure layDisplayClick(Sender: TObject);
    procedure layTecladoClick(Sender: TObject);
    procedure layConfiguracaoImpressaoClick(Sender: TObject);
    procedure layImpressaoClick(Sender: TObject);
    procedure layResetSenhaClick(Sender: TObject);
  private
    { Private declarations }
    FPermissaoCamera : string;
    FPermissaoReadStorage : string;
    FPermissaoWriteStorage : string;

    procedure expandeMenu(aExpandir:Boolean=True);

    procedure carregaInfoAcougue;
    procedure carregaInfoPadaria;
    procedure carregaInformacoes;

  public
    { Public declarations }

  end;

var
  frmPrincipal: TfrmPrincipal;
  //FThreadDisplay : TThreadDisplay;

implementation

{$R *.fmx}

procedure TfrmPrincipal.carregaInfoAcougue;
  var
    FAcougue : TAcougue;
    FPadaria : TPadaria;
    FCriticaAcougue : TCriticalSection;
begin
  if not vazio(FAplicativo.servidor) then
    begin
      { *** informações sobre o açougue *** }
      try
        FCriticaAcougue := TCriticalSection.Create;
        FCriticaAcougue.Enter;

        try
          TWebClient.consomeApi(FAplicativo.servidor + '/api/painel/display/acougue', 'get', '');
          Sleep(100);

          if twebclient.StatusCode = 200 then
            begin
              FAcougue := TAcougue.Create;
              FAcougue.AsJson := TWebClient.ResponseBody;

              mmoLogs.BeginUpdate;
              mmoLogs.Lines.Insert(0, '[AÇOUGUE] - NORMAL: ' + FAcougue.Acouguenormal.ToString);
              mmoLogs.Lines.Insert(0, '[AÇOUGUE] - PREFERENCIAL: ' + FAcougue.Acouguepreferencial.ToString);
              mmoLogs.StyleLookup := 'styleMemo';
              mmoLogs.EndUpdate;
              mmoLogs.ApplyStyleLookup;
              mmoLogs.NeedStyleLookup;

              FreeAndNil(FAcougue);
            end;
        except
          // silenciosa
        end;
      finally
        FCriticaAcougue.Leave;
        FreeAndNil(FCriticaAcougue);
        TWebClient.FWebClient.Destroy;
        TWebClient.FWebClient := nil;
      end;
    end;
end;

procedure TfrmPrincipal.carregaInfoPadaria;
  var
    FAcougue : TAcougue;
    FPadaria : TPadaria;
    FCriticaPadaria : TCriticalSection;
begin
  if not vazio(FAplicativo.servidor) then
    begin
      { *** informações sobre o padaria *** }
      try
        FCriticaPadaria := TCriticalSection.Create;
        FCriticaPadaria.Enter;

        try
          TWebClient.consomeApi(FAplicativo.servidor + '/api/painel/display/padaria', 'get', '');
          Sleep(100);

          if twebclient.StatusCode = 200 then
            begin
              FPadaria := TPadaria.Create;
              FPadaria.AsJson := TWebClient.ResponseBody;

              mmoLogs.BeginUpdate;
              mmoLogs.Lines.Insert(0, '[PADARIA] - NORMAL: ' + FPadaria.Padarianormal.ToString);
              mmoLogs.Lines.Insert(0, '[PADARIA] - PREFERENCIAL: ' + FPadaria.Padariapreferencial.ToString);
              mmoLogs.EndUpdate;
              mmoLogs.StyleLookup := 'styleMemo';
              mmoLogs.ApplyStyleLookup;
              mmoLogs.NeedStyleLookup;

              FreeAndNil(FPadaria);
            end;
        except
          // silenciosa
        end;
      finally
        FCriticaPadaria.Leave;
        FreeAndNil(FCriticaPadaria);
        TWebClient.FWebClient.Destroy;
        TWebClient.FWebClient := nil;
      end;
    end;
end;

procedure TfrmPrincipal.carregaInformacoes;
begin
  var FThreadAcougue : TThread;
  FThreadAcougue := TThread.CreateAnonymousThread(
    procedure
      begin
        carregaInfoAcougue;
      end);
  FThreadAcougue.FreeOnTerminate := False;
  FThreadAcougue.Start;

  var FThreadPadaria : TThread;
  FThreadPadaria := TThread.CreateAnonymousThread(
    procedure
      begin
        carregaInfoPadaria;
      end);

  FThreadPadaria.FreeOnTerminate := False;

  while (FThreadAcougue.WaitFor <> 0) do
    begin
      // segura o processo;
    end;

  if FThreadAcougue.WaitFor = 0 then
    FThreadPadaria.Start;

  FreeAndNil(FThreadAcougue);
  FreeAndNil(FThreadPadaria)
end;

procedure TfrmPrincipal.expandeMenu(aExpandir: Boolean);
begin
  if aExpandir then
    begin
      layMenu.Position.X := (frmPrincipal.Width * -1);
      aniMenu.StartValue := layMenu.Position.X;
      aniMenu.StopValue := 0;
      layMenu.Visible := True;
      layMenu.BringToFront;
      aniMenu.Start;
    end
  else
    begin
      aniMenu.StartValue := 0;
      aniMenu.StopValue := (frmPrincipal.Width * -1);
      layMenu.Visible := True;
      aniMenu.Start;
    end;
end;

procedure TfrmPrincipal.FormCreate(Sender: TObject);
begin
  lblNaoConfigurado.Visible := False;
  layMenu.Visible := False;
  layMenu.Position.X := (frmPrincipal.Width * -1);

  FAplicativo := TConfiguracoesAplicativo.Create(Self);

  if FMonitor = nil then
    FMonitor := TClassMonitor.Create;

  FAplicativo.retornaDados;
end;

procedure TfrmPrincipal.FormDestroy(Sender: TObject);
begin
  FreeAndNil(FAplicativo);
end;

procedure TfrmPrincipal.FormShow(Sender: TObject);
  var
    tmpMonitor : TClassMonitor;
//    {$IFDEF ANDROID}
//      PackageManager: JPackageManager;
//      PackageInfo: JPackageInfo;
//    {$ENDIF}
begin
  {$IFDEF ANDROID}
    PackageManager := SharedActivityContext.getPackageManager;
    PackageInfo := PackageManager.getPackageInfo(SharedActivityContext.getPackageName, 0);
    lblVersion.text := JStringToString(PackageInfo.versionName);

    Androidapi.JNI.PowerManager.AcquireWakeLock;

    permCam := JStringToString(TJManifest_permission.JavaClass.CAMERA);
    FPermissaoReadStorage := JStringToString(TJManifest_permission.JavaClass.READ_EXTERNAL_STORAGE);
    FPermissaoWriteStorage := JStringToString(TJManifest_permission.JavaClass.WRITE_EXTERNAL_STORAGE);

    PermissionsService.RequestPermissions([JStringToString(TJManifest_permission.JavaClass.READ_EXTERNAL_STORAGE)],
      procedure(const APermissions: TArray<string>; const AGrantResults: TArray<TPermissionStatus>)
      begin
        if (Length(AGrantResults) = 2)
          and (AGrantResults[0] = TPermissionStatus.Granted)
              and (AGrantResults[1] = TPermissionStatus.Granted)
                  and (AGrantResults[2] = TPermissionStatus.Granted) then
          begin

          end
        else
          begin
            TDialogService.ShowMessage('Sem permissão!');
          end;
      end);
  {$ENDIF}

  layInfoPadaria.Height := 0;
  layInfoAcougue.Height := 0;

  carregaInformacoes;
end;

procedure TfrmPrincipal.imgMenu2Click(Sender: TObject);
begin
// fecha menu
  expandeMenu(False);
end;

procedure TfrmPrincipal.imgMenuClick(Sender: TObject);
begin
  // abre menu
  expandeMenu;
end;

procedure TfrmPrincipal.layAudioClick(Sender: TObject);
begin
  // configuracoes do painel
  frmConfiguracoes := TfrmConfiguracoes.Create(self);
  frmConfiguracoes.ShowModal(procedure(AResult:TModalResult)
    begin
      expandeMenu(False);
      carregaInformacoes;
    end);
end;

procedure TfrmPrincipal.layConfiguracoesClick(Sender: TObject);
begin
  // configuracoes do painel
  frmConfiguracoes := TfrmConfiguracoes.Create(self);
  frmConfiguracoes.ShowModal(procedure(AResult:TModalResult)
    begin
      expandeMenu(False);
      carregaInformacoes;
    end);
end;

procedure TfrmPrincipal.layDisplayClick(Sender: TObject);
begin
  // configuracoes do display
  frmConfiguracoesDisplay := TfrmConfiguracoesDisplay.Create(self);
  frmConfiguracoesDisplay.ShowModal(procedure(AResult:TModalResult)
    begin
      expandeMenu(False);
      carregaInformacoes;
    end);
end;

procedure TfrmPrincipal.layImpressaoClick(Sender: TObject);
begin
  if FAplicativo.tipo = 'IMPRESSÃO' then
    begin
      frmSenha := TfrmSenha.Create(Self);
      frmSenha.ShowModal(procedure (aResult:TModalResult)
        begin
          { abre o display diretamente }
          expandeMenu(False);
          carregaInformacoes;
        end);
    end;
end;

procedure TfrmPrincipal.layConfiguracaoImpressaoClick(Sender: TObject);
begin
  if FAplicativo.tipo = 'IMPRESSÃO' then
    begin
      frmConfiguracoesImpressao := TfrmConfiguracoesImpressao.Create(Self);
      frmConfiguracoesImpressao.ShowModal(procedure (aResult:TModalResult)
        begin
          { abre o display diretamente }
          expandeMenu(False);
          carregaInformacoes;
        end);
    end;
end;

procedure TfrmPrincipal.layPainelClick(Sender: TObject);
  var
    FTempVisual : TClassVisual;
    strJson : string;
begin
  if FAplicativo.tipo = 'DISPLAY' then
    begin
      leStringStrream(TConfiguracoesAplicativo.Instancia.arquivovisual, strJson);
      FTempVisual := TClassVisual.Create;
      FTempVisual.AsJson := strJson;

      if FTempVisual.Configuracoes.senhaDupla = 'sim' then
        begin
          frmDisplayFull := TfrmDisplayFull.Create(Self);
          frmDisplayFull.ShowModal(procedure (aResult:TModalResult)
            begin
              { abre o display diretamente }
              expandeMenu(False);
              carregaInformacoes;
            end);
        end
      else
        begin
          frmDisplay := TfrmDisplay.Create(Self);
          frmDisplay.ShowModal(procedure (aResult:TModalResult)
            begin
              { abre o display diretamente }
              expandeMenu(False);
              carregaInformacoes;
            end);
        end;

      FreeAndNil(FTempVisual);
    end;
end;

procedure TfrmPrincipal.layResetSenhaClick(Sender: TObject);
begin
  if Pos('TECLADO', FAplicativo.tipo) > 0 then
    begin
      frmConfiguracoesReset := TfrmConfiguracoesReset.Create(Self);
      frmConfiguracoesReset.ShowModal(procedure (aResult:TModalResult)
        begin
          { abre o display diretamente }
          expandeMenu(False);
          carregaInformacoes;
        end);
    end;
end;

procedure TfrmPrincipal.laySairClick(Sender: TObject);
begin
  Close;
  Application.Terminate;
end;

procedure TfrmPrincipal.layTecladoClick(Sender: TObject);
begin
//;
  if Pos('TECLADO', FAplicativo.tipo) > 0 then
    begin
      frmTeclado := TfrmTeclado.Create(Self);
      frmTeclado.FTipoTeclado := FAplicativo.tipo;
      frmTeclado.ShowModal(procedure (aResult:TModalResult)
        begin
          { abre o display diretamente }
          expandeMenu(False);
          carregaInformacoes;
        end);
    end;
end;

procedure TfrmPrincipal.lblAudioClick(Sender: TObject);
begin
  // configuracoes do display
  frmConfiguracoesSom := TfrmConfiguracoesSom.Create(self);
  frmConfiguracoesSom.ShowModal(procedure(AResult:TModalResult)
    begin
      expandeMenu(False);
      carregaInformacoes;
    end);
end;

{ TThreadFila }

procedure TThreadFila.execute;
begin
  inherited;

  FtarefaExecutar;
end;

end.
