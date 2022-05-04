unit untTeclado;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Controls.Presentation,
  FMX.StdCtrls, FMX.Objects, FMX.Layouts, untWebClient, untFuncoes, untClassMonitor,
  untClassAplicativo;

type
  TfrmTeclado = class(TForm)
    Layout1: TLayout;
    Layout2: TLayout;
    Layout3: TLayout;
    GridPanelLayout1: TGridPanelLayout;
    rectNum1: TRectangle;
    lblNum1: TLabel;
    rectNum2: TRectangle;
    lblNum2: TLabel;
    rectNum3: TRectangle;
    lblNum3: TLabel;
    rectNumver1: TRectangle;
    rectNum4: TRectangle;
    lblNum4: TLabel;
    rectNum5: TRectangle;
    lblNum5: TLabel;
    rectNum6: TRectangle;
    lblNum6: TLabel;
    rectPreferencial: TRectangle;
    rectNum7: TRectangle;
    lblNum7: TLabel;
    rectNum8: TRectangle;
    lblNum8: TLabel;
    rectNum9: TRectangle;
    lblNum9: TLabel;
    rectChamar: TRectangle;
    rectNumVoltar: TRectangle;
    lblVoltar: TLabel;
    rectNum0: TRectangle;
    Label2: TLabel;
    rectProx: TRectangle;
    lblAvancar: TLabel;
    Rectangle4: TRectangle;
    Label6: TLabel;
    imgKimpar: TImage;
    imgChamar: TImage;
    imgPref: TImage;
    Rectangle1: TRectangle;
    lblDisplay: TLabel;
    lblDescritivo: TLabel;
    procedure lblDisplayDblClick(Sender: TObject);

    procedure rectProxClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure rectChamarClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure rectNum1Click(Sender: TObject);
    procedure imgKimparClick(Sender: TObject);
    procedure rectPreferencialClick(Sender: TObject);
  private
    { Private declarations }

    procedure chamarProximoPreferencial(aSetor, aSenha, aIncrementar: String);
    procedure chamarProximoAlternado(aSetor, aSenha, aIncrementar: String);



    //procedure chamaProximo;
  public
    { Public declarations }
    FSetor : String;
    FIsPreferencial : Boolean;
    FConta : Integer;
    FOldAcougueNormal : integer;
    FOldAcouguePreferencial : integer;
    FOldPadariaNormal : integer;
    FOldPadariaPreferencial : integer;
    FMonitorTeclado : TClassMonitor;
    //FThreadPadaria : TThreadPadaria;
    FTipoTeclado : string;
  end;

var
  frmTeclado: TfrmTeclado;

implementation

{$R *.fmx}

procedure TfrmTeclado.chamarProximoAlternado(aSetor, aSenha, aIncrementar: String);
  var
    FMonPadaria : TClassMonitor;
    strJSon : String;

  const
    constJSon : string =
      '{' +
      '   "setor" : "%s", ' +
      '   "senha" : "%s", ' +
      '   "incrementar" : "%s", ' +
      '   "proximo" : %d' +
      '}';
begin
  try
    try
      FMonPadaria := TClassMonitor.Create;

      if vazio(frmTeclado.lblDisplay.Text) then
        begin
          strJSon := Format(constJSon, [aSetor, aSenha, aIncrementar, 0]);
          TWebClient.consomeApi(FAplicativo.servidor + '/api/painel/display/display', 'post', strJSon);
        end
      else
        begin
          if FIsPreferencial then
            strJSon := Format(constJSon, [aSetor, 'PREFERENCIAL', aIncrementar, frmTeclado.lblDisplay.Text.ToInteger])
          else
            strJSon := Format(constJSon, [aSetor, 'NORMAL', aIncrementar, frmTeclado.lblDisplay.Text.ToInteger]);

          TWebClient.consomeApi(FAplicativo.servidor + '/api/painel/display/displayespecifico', 'post', strJSon);

          Sleep(500);
        end;

      if twebclient.StatusCode = 200 then
        FMonPadaria.AsJson := twebclient.ResponseBody;

      if aSetor = 'PADARIA' then
        begin
          if aSenha = 'PREFERENCIAL' then
            begin
              if FOldPadariaPreferencial = FMonPadaria.Padaria.Padariapreferencial then
                begin
                  strJSon := Format(constJSon, [aSetor, 'NORMAL', aIncrementar, 0]);
                  TWebClient.consomeApi(FAplicativo.servidor + '/api/painel/display/display', 'post', strJSon);
                end;
            end
          else
            begin
              if FOldPadariaNormal = FMonPadaria.Padaria.Padarianormal then
                begin
                  strJSon := Format(constJSon, [aSetor, 'PREFERENCIAL', aIncrementar, 0]);
                  TWebClient.consomeApi(FAplicativo.servidor + '/api/painel/display/display', 'post', strJSon);
                end;
            end;

          if twebclient.StatusCode = 200 then
            FMonPadaria.AsJson := twebclient.ResponseBody;

          FOldPadariaNormal := FMonPadaria.Padaria.Padarianormal;
          FOldPadariaPreferencial := FMonPadaria.Padaria.Padariapreferencial;
        end
      else
        begin
          if aSenha = 'PREFERENCIAL' then
            begin
              if FOldAcouguePreferencial = FMonPadaria.Acougue.Acouguepreferencial then
                begin
                  strJSon := Format(constJSon, [aSetor, 'NORMAL', aIncrementar, 0]);
                  TWebClient.consomeApi(FAplicativo.servidor + '/api/painel/display/display', 'post', strJSon);
                end;
            end
          else
            begin
              if FOldAcougueNormal = FMonPadaria.Acougue.Acouguenormal then
                begin
                  strJSon := Format(constJSon, [aSetor, 'PREFERENCIAL', aIncrementar, 0]);
                  TWebClient.consomeApi(FAplicativo.servidor + '/api/painel/display/display', 'post', strJSon);
                end;
            end;

          if twebclient.StatusCode = 200 then
            FMonPadaria.AsJson := twebclient.ResponseBody;

          FOldAcougueNormal := FMonPadaria.Acougue.Acouguenormal;
          FOldAcouguePreferencial := FMonPadaria.Acougue.Acouguepreferencial;
        end;

      FreeAndNil(FMonPadaria);

      frmTeclado.lblDisplay.Text := '';
      TWebClient.FWebClient.Destroy;
      TWebClient.FWebClient := nil;

      //Suspend;
    except
      // silenciosa
    end;
  finally
    //Sleep(1000);
  end;
end;

procedure TfrmTeclado.chamarProximoPreferencial(aSetor, aSenha, aIncrementar: String);
  var
    FMonPadaria : TClassMonitor;
    strJSon : String;

  const
    constJSon : string =
      '{' +
      '   "setor" : "%s", ' +
      '   "senha" : "%s", ' +
      '   "incrementar" : "%s", ' +
      '   "proximo" : %d' +
      '}';
begin
  try
    try
      FMonPadaria := TClassMonitor.Create;

      if vazio(frmTeclado.lblDisplay.Text) then
        begin
          strJSon := Format(constJSon, [aSetor, 'PREFERENCIAL', aIncrementar, 0]);
          TWebClient.consomeApi(FAplicativo.servidor + '/api/painel/display/display', 'post', strJSon);

          if twebclient.StatusCode = 200 then
            FMonPadaria.AsJson := twebclient.ResponseBody;
        end;

      FreeAndNil(FMonPadaria);

      frmTeclado.lblDisplay.Text := '';
      TWebClient.FWebClient.Destroy;
      TWebClient.FWebClient := nil;
    except
      // silenciosa
    end;
  finally
    Sleep(1000);
  end;
end;

procedure TfrmTeclado.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  FreeAndNil(FMonitorTeclado);
  Action := TCloseAction.caFree;
end;

procedure TfrmTeclado.FormCreate(Sender: TObject);
  var
    strJson : String;
begin
  FMonitorTeclado := TClassMonitor.Create;
  leStringStrream(FAplicativo.retornaArquivoConfigurado, strJson);
  FMonitorTeclado.AsJson := strJson;
end;

procedure TfrmTeclado.FormDestroy(Sender: TObject);
begin
  frmTeclado := nil;
end;

procedure TfrmTeclado.FormShow(Sender: TObject);
begin
  lblDescritivo.Text := iif(FTipoTeclado = 'TECLADO DISPLAY 1', FMonitorTeclado.Padaria.Descritivo, FMonitorTeclado.Acougue.Descritivo);
  FOldAcougueNormal := 0;
  FOldAcouguePreferencial := 0;
  FOldPadariaNormal := 0;
  FOldPadariaPreferencial := 0;
  FConta := 0;
  FIsPreferencial := False;
end;

procedure TfrmTeclado.imgKimparClick(Sender: TObject);
begin
  if not vazio(lblDisplay.Text) then
    begin
      if StrLen(pchar(lblDisplay.Text)) > 0 then
        begin
          lblDisplay.Text := Copy(lblDisplay.Text, 0, (StrLen(pchar(lblDisplay.Text))-1));
        end;
    end;
end;

procedure TfrmTeclado.lblDisplayDblClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmTeclado.rectPreferencialClick(Sender: TObject);
begin
  if( FTipoTeclado = 'TECLADO DISPLAY 1') then
    chamarProximoPreferencial('PADARIA', 'PREFERENCIAL', 'INCREMENTAR')
  else
    chamarProximoPreferencial('ACOUGUE', 'PREFERENCIAL', 'INCREMENTAR');
end;

procedure TfrmTeclado.rectProxClick(Sender: TObject);
begin
  { chama o proximo }
  TThread.CreateAnonymousThread(
    procedure
      begin
        FSetor := iif(FAplicativo.tipo = 'TECLADO DISPLAY 1', 'PADARIA', 'ACOUGUE');

        if FConta = 0 then
          begin
            chamarProximoAlternado(FSetor, 'PREFERENCIAL', 'INCREMENTAR');
            //chamarProximo(strSetor, 'PREFERENCIAL', 'INCREMENTAR');
            inc(FConta);
          end
        else
          begin
            chamarProximoAlternado(FSetor, 'NORMAL', 'INCREMENTAR');
            FConta := 0;
          end;
      end).Start;
end;

procedure TfrmTeclado.rectChamarClick(Sender: TObject);
begin
  if not vazio(FAplicativo.Servidor) then
    try
      TWebClient.consomeApi(FAplicativo.Servidor + '/api/painel/display/chamarnovamente', 'get', '');
    finally
      FreeAndNil(TWebClient.FWebClient);
      TWebClient.FWebClient := nil;
    end;

  lblDisplay.Text := '';
end;

procedure TfrmTeclado.rectNum1Click(Sender: TObject);
begin
  if sender is TRectangle then
    lblDisplay.Text := lblDisplay.Text + TRectangle(sender).Tag.ToString
  else if Sender is TLabel then
    lblDisplay.Text := lblDisplay.Text + TLabel(sender).Tag.ToString;
end;

end.
