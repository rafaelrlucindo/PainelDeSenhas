unit ServerMethodsUnit1;

interface

uses System.SysUtils, System.Classes, System.Json,
    DataSnap.DSProviderDataModuleAdapter, DBXPlatform,
    Datasnap.DSServer, Datasnap.DSAuth, untClassMonitor,
    untFuncoes, untClassAplicativo, fmx.DialogService,
    rest.Json, untServidor, fmx.Types, untClassVisual,
    untClassLog, ppEndUsr, ppParameter, ppDesignLayer, ppBands, ppPrnabl, ppClass, ppCtrls, ppCache, ppComm, ppRelatv, ppProd, ppReport;

type
  TServerMethods1 = class(TDSServerModule)
    ppSenha: TppReport;
    ppHeaderBand1: TppHeaderBand;
    ppDetailBand1: TppDetailBand;
    ppLabel1: TppLabel;
    pplblTipo: TppLabel;
    pplblSenha: TppLabel;
    ppLabel3: TppLabel;
    ppFooterBand1: TppFooterBand;
    ppDesignLayers1: TppDesignLayers;
    ppDesignLayer1: TppDesignLayer;
    ppParameterList1: TppParameterList;
    ppDsnSenha: TppDesigner;
    procedure DSServerModuleCreate(Sender: TObject);
    procedure DSServerModuleDestroy(Sender: TObject);
  private
    { Private declarations }
    procedure carregaImpressora(out aImpressao:TConfiguracoesAplicativo);
    function carregaDescritivo(aTipo:string):string;
  public
    { Public declarations }
//    FMonitorPadaria : TClassMonitor;
//    FMonitorAcougue : TClassMonitor;
    //FAplicativo : TConfiguracoesAplicativo;
    FImpressao : TImpressao;

    { *** display e teclado *** }
    function updatedisplay(aJson:TJSONObject):TJSONObject;
    function updatedisplayespecifico(aJson:TJSONObject):TJSONObject;
    function updatefrase(aJson:TJSONObject):TJSONObject;
    function updateconfiguracoes(aJson:TJSONObject):TJSONObject;
    function configuracoes:TJSONObject;
    function frase:TJSONObject;
    function senhas:TJSONObject;
    function padaria:TJSONObject;
    function acougue:TJSONObject;


    //function acceptdisplay(aJson:TJSONObject):TJSONObject;
    function chamaproximo(aTipo:String):TJSONObject;
    function chamarnovamente:TJSONObject;
    function updateconfiguradisplay(aJson: TJSONObject): TJSONObject;
    function updateconfiguradisplay1(aJson: TJSONObject): TJSONObject;

    { *** impressão *** }
    function configuracaoimpressao:TJSONObject;
    function updateconfiguracaoimpressao(aJson:TJSONObject):TJSONObject;

    { *** impressões *** }
    function imprimirpadarianormal:TJSONObject;
    function imprimirpadariapreferencial: TJSONObject;
    function imprimiracouguenormal: TJSONObject;
    function imprimiracouguepreferencial: TJSONObject;
    function resetasenhas:TJSONObject;
    function updateresetsenhas(aJSon:TJSONObject):TJSONObject;

    { *** som *** }
    function updateconfigurasom(aJson:TJSONObject):TJSONObject;
    function configurasom:TJSONObject;

end;

  display = class(TServerMethods1);

implementation

{%CLASSGROUP 'System.Classes.TPersistent'}

{$R *.dfm}

uses
  System.StrUtils;

var
 FMonitorPadaria : TClassMonitor;

procedure TServerMethods1.DSServerModuleCreate(Sender: TObject);
  var
    strJson : String;
begin
  FIsServidor := True;

  if FAplicativo = nil then
    FAplicativo := TConfiguracoesAplicativo.create(Self);
end;

procedure TServerMethods1.DSServerModuleDestroy(Sender: TObject);
begin
  if FAplicativo <> nil then
    FreeAndNil(FAplicativo)
end;

function TServerMethods1.frase: TJSONObject;
  var
    strJson : String;
    aValue : TJSONValue;
    FMonVisual : TClassVisual;
begin
  try
    { carrega informações do painel }
    gravaLog('DISPLAY', 'DISPLAY - Enviando Frase - Inicianddo');

    FMonVisual := TClassVisual.Create;
    leStringStrream(FAplicativo.arquivovisual, strJson);
    FMonVisual.AsJson := strJson;

    GetInvocationMetadata().ResponseCode := 200;
    GetInvocationMetadata().ResponseContentType := 'application/json';
    GetInvocationMetadata().ResponseContent := FMonVisual.AsJson;
    aValue := TJSONObject.ParseJSONValue(GetInvocationMetadata().ResponseContent);
    Result := (aValue as TJSONObject);

    FreeAndNil(FMonVisual);
    gravaLog('DISPLAY', 'DISPLAY - Enviando Frase - Finalizando');
  except
    // silenciosa
  end;
end;

function TServerMethods1.imprimiracouguenormal: TJSONObject;
  var
    FImp: TConfiguracoesAplicativo;
    strJSon : string;
begin
  try
    try
      TGeraLog.Instancia.TryGeraLog('GET IMPRIME', '[' + carregaDescritivo('acougue') + '] - INICIO');

      leStringStrream(TConfiguracoesAplicativo.Instancia.arquivoaplicativo, strJSon);
      FImp := TConfiguracoesAplicativo.Create(self);
      FImp.AsJson := strJSon;

      FImp.impressao.acouguemaximonormal := FImp.impressao.acouguemaximonormal + 1;
      GetInvocationMetadata().ResponseCode := 200;
      GetInvocationMetadata().ResponseContentType := 'application/json';
      GetInvocationMetadata().ResponseContent := '{ "acouguemaximonormal" : ' + FImp.impressao.acouguemaximonormal.ToString + '}';

      Result := (TJSonObject.ParseJSONValue(GetInvocationMetadata().ResponseContent) as TJSONObject);
      gravaStringStream(TConfiguracoesAplicativo.Instancia.arquivoaplicativo, FImp.AsJson);

      frmServidor.pplblTipo.Caption := carregaDescritivo('acougue');
      frmServidor.pplblSenha.caption := 'N' + FormatFloat('000#', FImp.impressao.acouguemaximonormal);
      frmServidor.ppSenha.Print;

      TGeraLog.Instancia.TryGeraLog('GET IMPRIME', '[' + carregaDescritivo('padaria') + '] - NORMAL: ' + FImp.impressao.acouguemaximonormal.ToString);
    except
      // silenciosa
    end;
  finally
    FreeAndNil(FImp);
    TGeraLog.Instancia.TryGeraLog('GET IMPRIME', '[' + carregaDescritivo('acougue') + '] - FIM');
  end;
end;

function TServerMethods1.imprimiracouguepreferencial: TJSONObject;
  var
    FImp: TConfiguracoesAplicativo;
    strJSon : string;
begin
  try
    try
      TGeraLog.Instancia.TryGeraLog('GET IMPRIME', '[' + carregaDescritivo('acougue') + '] - INICIO');
      leStringStrream(TConfiguracoesAplicativo.Instancia.arquivoaplicativo, strJSon);
      FImp := TConfiguracoesAplicativo.Create(self);
      FImp.AsJson := strJSon;

      FImp.impressao.acouguemaximoPreferencial := FImp.impressao.acouguemaximoPreferencial + 1;
      GetInvocationMetadata().ResponseCode := 200;
      GetInvocationMetadata().ResponseContentType := 'application/json';
      GetInvocationMetadata().ResponseContent := '{ "acouguemaximoPreferencial" : ' + FImp.impressao.acouguemaximoPreferencial.ToString + '}';

      Result := (TJSonObject.ParseJSONValue(GetInvocationMetadata().ResponseContent) as TJSONObject);
      gravaStringStream(TConfiguracoesAplicativo.Instancia.arquivoaplicativo, FImp.AsJson);

      frmServidor.pplblTipo.Caption := carregaDescritivo('acougue');
      frmServidor.pplblSenha.caption := 'P' + FormatFloat('000#', FImp.impressao.acouguemaximoPreferencial);
      frmServidor.ppSenha.Print;

      TGeraLog.Instancia.TryGeraLog('GET IMPRIME', '[' + carregaDescritivo('acougue') + '] - PREFERENCIAL: ' + FImp.impressao.acouguemaximoPreferencial.ToString);
    except
      // silenciosa
    end;
  finally
    FreeAndNil(FImp);
    TGeraLog.Instancia.TryGeraLog('GET IMPRIME', '[' + carregaDescritivo('acougue') + '] - FIM');
  end;
end;

function TServerMethods1.imprimirpadarianormal: TJSONObject;
  var
    FImp: TConfiguracoesAplicativo;
    strJSon : string;
begin
  try
    try
      TGeraLog.Instancia.TryGeraLog('GET IMPRIME', '[' + carregaDescritivo('padaria') + '] - INICIO');
      leStringStrream(TConfiguracoesAplicativo.Instancia.arquivoaplicativo, strJSon);
      FImp := TConfiguracoesAplicativo.Create(self);
      FImp.AsJson := strJSon;

      FImp.impressao.padariamaximonormal := FImp.impressao.padariamaximonormal + 1;
      GetInvocationMetadata().ResponseCode := 200;
      GetInvocationMetadata().ResponseContentType := 'application/json';
      GetInvocationMetadata().ResponseContent := '{ "padariamaximonormal" : ' + FImp.impressao.padariamaximonormal.ToString + '}';

      Result := (TJSonObject.ParseJSONValue(GetInvocationMetadata().ResponseContent) as TJSONObject);
      gravaStringStream(TConfiguracoesAplicativo.Instancia.arquivoaplicativo, FImp.AsJson);

      frmServidor.pplblTipo.Caption := carregaDescritivo('padaria');
      frmServidor.pplblSenha.caption := 'N' + FormatFloat('000#', FImp.impressao.padariamaximonormal);
      frmServidor.ppSenha.Print;

      TGeraLog.Instancia.TryGeraLog('GET IMPRIME', '[' + carregaDescritivo('padaria') + '] - NORMAL: ' + FImp.impressao.padariamaximonormal.ToString);
    except
      // silenciosa
    end;
  finally
    FreeAndNil(FImp);
      TGeraLog.Instancia.TryGeraLog('GET IMPRIME', '[' + carregaDescritivo('padaria') + '] - FIM');
  end;
end;

function TServerMethods1.imprimirpadariapreferencial: TJSONObject;
  var
    FImp: TConfiguracoesAplicativo;
    strJSon : string;
begin
  try
    try
      TGeraLog.Instancia.TryGeraLog('GET IMPRIME', '[' + carregaDescritivo('padaria') + '] - INICIO');
      leStringStrream(TConfiguracoesAplicativo.Instancia.arquivoaplicativo, strJSon);
      FImp := TConfiguracoesAplicativo.Create(self);
      FImp.AsJson := strJSon;

      FImp.impressao.padariamaximopreferencial := FImp.impressao.padariamaximopreferencial + 1;
      GetInvocationMetadata().ResponseCode := 200;
      GetInvocationMetadata().ResponseContentType := 'application/json';
      GetInvocationMetadata().ResponseContent := '{ "padariamaximonormalpreferencial" : ' + FImp.impressao.padariamaximopreferencial.ToString + '}';

      Result := (TJSonObject.ParseJSONValue(GetInvocationMetadata().ResponseContent) as TJSONObject);
      gravaStringStream(TConfiguracoesAplicativo.Instancia.arquivoaplicativo, FImp.AsJson);

      frmServidor.pplblTipo.Caption := carregaDescritivo('padaria');
      frmServidor.pplblSenha.caption := 'P' + FormatFloat('000#', FImp.impressao.padariamaximopreferencial);
      frmServidor.ppSenha.Print;

      TGeraLog.Instancia.TryGeraLog('GET IMPRIME', '[' + carregaDescritivo('padaria') + '] - PREFERENCIAL: ' + FImp.impressao.padariamaximonormal.ToString);
    except
      // silenciosa
    end;
  finally
    FreeAndNil(FImp);
      TGeraLog.Instancia.TryGeraLog('GET IMPRIME', '[' + carregaDescritivo('padaria') + '] - FIM');
  end;
end;

function TServerMethods1.resetasenhas: TJSONObject;
  var
    FAcouguePadaria : TClassMonitor;
    FSenhas : TConfiguracoesAplicativo;
    FResetImpressao : TImpressao;
    strJSon : string;
begin
  try
    FAcouguePadaria := TClassMonitor.Create;

    leStringStrream(FAplicativo.arquivodisplay, strJSon);
    FAcouguePadaria.AsJson := strJSon;

    FAcouguePadaria.Padaria.Padarianormal := 0;
    FAcouguePadaria.Padaria.Padarianormalproximo := 0;
    FAcouguePadaria.Padaria.Padariapreferencial := 0;
    FAcouguePadaria.Padaria.Padariapreferencialproximo := 0;

    FAcouguePadaria.Acougue.Acouguenormal := 0;
    FAcouguePadaria.Acougue.Acouguenormalproximo := 0;
    FAcouguePadaria.Acougue.Acouguepreferencial := 0;
    FAcouguePadaria.Acougue.Acouguepreferencialproximo := 0;

    gravaStringStream(FAplicativo.arquivodisplay, FAcouguePadaria.AsJson);

    FSenhas := TConfiguracoesAplicativo.Create(Self);
    FResetImpressao := TImpressao.Create;

    leStringStrream(FAplicativo.arquivoaplicativo, strJSon);
    FSenhas.AsJson := strJSon;

    FResetImpressao.acouguemaximoPreferencial := 0;
    FResetImpressao.acouguemaximonormal := 0;
    FResetImpressao.padariamaximonormal := 0;
    FResetImpressao.padariamaximopreferencial := 0;
    FSenhas.impressao := FResetImpressao;

    gravaStringStream(FAplicativo.arquivoaplicativo, FSenhas.AsJson);

    GetInvocationMetadata().ResponseCode := 200;
    GetInvocationMetadata().ResponseContentType := 'application/json';
    GetInvocationMetadata().ResponseContent := '{ "sucesso" : "sim"}';
    Result := (TJSONObject.ParseJSONValue(GetInvocationMetadata().ResponseContent) as TJSONObject);
  except
    // silenciosa
  end;
end;

function TServerMethods1.senhas: TJSONObject;
  var
    FImpSenha : TConfiguracoesAplicativo;
    strJSon : String;
begin
  try
    try
      TGeraLog.Instancia.TryGeraLog('GET SENHA', 'STATUS DE SENHA - INICIO');

      FImpSenha := TConfiguracoesAplicativo.Create(Self);
      leStringStrream(FAplicativo.arquivoaplicativo, strJson);
      FImpSenha.AsJson := strJson;

      GetInvocationMetadata().ResponseCode := 200;
      GetInvocationMetadata().ResponseContentType := 'application/json';
      GetInvocationMetadata().ResponseContent := FImpSenha.impressao.AsJson;
      Result := (TJSONObject.ParseJSONValue(GetInvocationMetadata().ResponseContent) as TJSONObject);

      TGeraLog.Instancia.TryGeraLog('GET SENHA', Result.ToString);
    except
      // silenciosa
    end;
  finally
    FreeAndNil(FImpSenha);
    TGeraLog.Instancia.TryGeraLog('GET SENHA', 'STATUS DE SENHA - FIM');
  end;
end;

function TServerMethods1.padaria: TJSONObject;
  var
    FStatusPadaria : TClassMonitor;
    strJSon : String;
begin
  try
    try
      TGeraLog.Instancia.TryGeraLog('GET STATUS PADARIA', 'STATUS DE SENHA - INICIO');

      FStatusPadaria := TClassMonitor.Create;
      leStringStrream(FAplicativo.arquivodisplay, strJson);
      FStatusPadaria.AsJson := strJson;

      GetInvocationMetadata().ResponseCode := 200;
      GetInvocationMetadata().ResponseContentType := 'application/json';
      GetInvocationMetadata().ResponseContent := FStatusPadaria.Padaria.AsJson;
      Result := (TJSONObject.ParseJSONValue(GetInvocationMetadata().ResponseContent) as TJSONObject);

      //TGeraLog.Instancia.TryGeraLog('GET STATUS PADARIA', Result.ToString);
    except
      // silenciosa
    end;
  finally
    FreeAndNil(FStatusPadaria);
    TGeraLog.Instancia.TryGeraLog('GET STATUS PADARIA', 'STATUS DE SENHA - FIM');
  end;
end;

function TServerMethods1.acougue: TJSONObject;
  var
    FStatusAcougue : TClassMonitor;
    strJSon : String;
begin
  try
    try
      TGeraLog.Instancia.TryGeraLog('GET STATUS ACOUGUE', 'STATUS DE SENHA - INICIO');

      FStatusAcougue := TClassMonitor.Create;
      leStringStrream(FAplicativo.arquivodisplay, strJson);
      FStatusAcougue.AsJson := strJson;

      GetInvocationMetadata().ResponseCode := 200;
      GetInvocationMetadata().ResponseContentType := 'application/json';
      GetInvocationMetadata().ResponseContent := FStatusAcougue.Acougue.AsJson;
      Result := (TJSONObject.ParseJSONValue(GetInvocationMetadata().ResponseContent) as TJSONObject);

      //TGeraLog.Instancia.TryGeraLog('GET STATUS ACOUGUE', Result.ToString);
    except
      // silenciosa
    end;
  finally
    FreeAndNil(FStatusAcougue);
    TGeraLog.Instancia.TryGeraLog('GET STATUS ACOUGUE', 'STATUS DE SENHA - FIM');
  end;
end;

function TServerMethods1.carregaDescritivo(aTipo: string): string;
  var
    FImpDescritivo : TClassMonitor;
    strJson : string;
begin
  try
    FImpDescritivo := TClassMonitor.Create;

    leStringStrream(TConfiguracoesAplicativo.Instancia.arquivodisplay, strJson);
    FImpDescritivo.AsJson := strJson;

    if aTipo = 'acougue' then
      Result := FImpDescritivo.Acougue.Descritivo
    else
      Result := FImpDescritivo.Padaria.Descritivo;

  finally
    FreeAndNil(FImpDescritivo);
  end;
end;

procedure TServerMethods1.carregaImpressora(out aImpressao: TConfiguracoesAplicativo);
  var
    strJson : String;
begin
  if aImpressao = nil then
     begin
       aImpressao := TConfiguracoesAplicativo.Create(Self);
       leStringStrream(FAplicativo.arquivoaplicativo, strJson);
       aImpressao.AsJson := strJson;
     end;
end;

function TServerMethods1.chamaproximo(aTipo:String): TJSONObject;
  var
    strJson : String;
begin
  try
    { carrega informações do painel }
    gravaLog('DISPLAY', 'TECLADO - Chama proximo - Inicianddo');

    FMonitorPadaria.Padaria.Padarianormal := FMonitorPadaria.Padaria.Padarianormal + 1;

    if FileExists(FAplicativo.arquivopadaria) then
      begin
        gravaLog('DISPLAY',
          'TECLADO - Chama proximo: acougue/' + FMonitorPadaria.Acougue.Acouguenormalproximo.ToString +
           ' padaria/' + FMonitorPadaria.Padaria.Padarianormalproximo.ToString
        );

        gravaStringStream(FAplicativo.arquivopadaria, FMonitorPadaria.AsJson);
      end;

    gravaLog('DISPLAY', 'TECLADO - Chama proximo - Finalizando');
  except
    // silenciosa
  end;
end;

function TServerMethods1.chamarnovamente: TJSONObject;
  var
    strJson : String;
    FTempMonitor : TClassMonitor;
begin
  try
    gravaLog('DISPLAY', 'TECLADO - Chamando novamente - Iniciiando');

  //  if FMonitorPadaria = nil then
  //    FMonitorPadaria := TClassMonitor.Create;

    FMonitorPadaria.chamandonovamente := 'sim';

    GetInvocationMetadata().ResponseCode := 200;
    GetInvocationMetadata().ResponseContentType := 'application/json';
    GetInvocationMetadata().ResponseContent := '{ "chamandonovamente" : "ok" }"';
    Result := (TJSONObject.ParseJSONValue(GetInvocationMetadata().ResponseContent) as TJSONObject);

  //  FTempMonitor := TClassMonitor.Create;
  //  FTempMonitor.AsJson := aJson.ToString;

  //  FMonitorPadaria.Acougue.Acouguenormal := FTempMonitor.Acougue.Acouguenormal;
  //  FMonitorPadaria.Acougue.Acouguepreferencial := FTempMonitor.Acougue.Acouguepreferencial;
  //  FMonitorPadaria.Padaria.Padarianormal := FTempMonitor.Padaria.Padarianormal;
  //  FMonitorPadaria.Padaria.Padariapreferencial := FTempMonitor.Padaria.Padariapreferencial;

    gravaStringStream(FAplicativo.arquivopadaria, FMonitorPadaria.AsJson);


    gravaStringStream(FAplicativo.arquivodisplay, FMonitorPadaria.AsJson);

    gravaLog('DISPLAY', 'TECLADO - Chamando novamente - Finalizando');
  except
    // silenciosa
  end;
end;

function TServerMethods1.configuracaoimpressao: TJSONObject;
  var
    strJSon : String;
begin
  try
    strJSon := '{"usaimpressao" : "' + iif(FAplicativo.usaimrpessao = 'sim', 'sim', 'não') + '"}';

    GetInvocationMetadata().ResponseCode := 200;
    GetInvocationMetadata().ResponseContentType := 'application/json';
    GetInvocationMetadata().ResponseContent := strJson;

    Result := (TJSonObject.ParseJSONValue(strJson) as TJSONObject);
  except
    // silenciosa
  end;
end;

function TServerMethods1.configuracoes: TJSONObject;
  var
    strJson : string;
    FVisual : TClassVisual;
begin
  try
    FVisual := TClassVisual.Create;
    leStringStrream(FAplicativo.arquivovisual, strJson);
    FVisual.AsJson := strJson;
    GetInvocationMetadata().ResponseCode := 200;
    GetInvocationMetadata().ResponseContentType := 'application/json';
    GetInvocationMetadata().ResponseContent := FMonitorPadaria.AsJson;
    Result := (TJSONObject.ParseJSONValue(GetInvocationMetadata().ResponseContent) as TJSONObject);
  except
    // silenciosa
  end;
end;

function TServerMethods1.updateresetsenhas(aJSon:TJSONObject):TJSONObject;
  var
    FMonVisual : TClassVisual;
begin
  try
    FMonVisual := TClassVisual.Create;
    FMonVisual.Configuracoes.Zerardiario := iif(aJSon.Values['zerardiario'].Value = 'sim', 'sim', 'não');
    gravaStringStream(FAplicativo.arquivovisual, FMonVisual.AsJson);

    GetInvocationMetadata().ResponseCode := 200;
    GetInvocationMetadata().ResponseContentType := 'application/json';
    GetInvocationMetadata().ResponseContent := '{ "sucesso" : "sim"}';

    Result := TJSONObject.ParseJSONValue(GetInvocationMetadata().ResponseContent) as TJSONObject;

    gravaLog('CONFIGURA RESET', 'DISPLAY - Recebendo Configurando resert - Finalizando');
  except
    // silenciosa
  end;
end;

function TServerMethods1.configurasom: TJSONObject;
  var
    aValue : TJSONValue;
begin
  try
    gravaLog('DISPLAY', 'DISPLAY - Recebendo Som - Iniciando');

    GetInvocationMetadata().ResponseCode := 200;
    GetInvocationMetadata().ResponseContentType := 'application/json';
    GetInvocationMetadata().ResponseContent := FAplicativo.AsJson;

    aValue := TJSONObject.ParseJSONValue(FAplicativo.AsJson);
    Result := (aValue as TJSONObject);

    gravaLog('DISPLAY', 'DISPLAY - Recebendo Som - Finalizando');
  except
    // silenciosa
  end;
end;

function TServerMethods1.updateconfiguradisplay(aJson: TJSONObject): TJSONObject;
  var
    FMonitorPadaria : TClassMonitor;
begin
  try
    try
      //gravaLog('DISPLAY', 'DISPLAY - Enviando senha - Iniciando');
      TGeraLog.Instancia.TryGeraLog('POST DISPLAY - CONFIGURACAO DISPLAY', 'RECEBENDO CONFIGURACOES - INICIO');

      FMonitorPadaria := TClassMonitor.Create;

      if aJson.Values['tipo'].Value = 'TECLADO DISPLAY 1' then
        begin
          gravaStringStream(FAplicativo.arquivoPadaria, FMonitorPadaria.AsJson);

          GetInvocationMetadata().ResponseCode := 200;
          GetInvocationMetadata().ResponseContentType := 'application/json';
          GetInvocationMetadata().ResponseContent := FMonitorPadaria.AsJson;

          FMonitorPadaria.Padaria.alterado := 'não';
          gravaStringStream(FAplicativo.arquivoPadaria, FMonitorPadaria.AsJson);
        end
      else if aJson.Values['tipo'].Value = 'TECLADO DISPLAY 2' then
        begin
          gravaStringStream(FAplicativo.arquivoacougue, FMonitorPadaria.AsJson);

          GetInvocationMetadata().ResponseCode := 200;
          GetInvocationMetadata().ResponseContentType := 'application/json';
          GetInvocationMetadata().ResponseContent := FMonitorPadaria.AsJson;

          FMonitorPadaria.Acougue.alterado := 'não';
          gravaStringStream(FAplicativo.arquivoacougue, FMonitorPadaria.AsJson);
        end
      else
        begin
          GetInvocationMetadata().ResponseCode := 200;
          GetInvocationMetadata().ResponseContentType := 'application/json';
          GetInvocationMetadata().ResponseContent := aJson.ToString;

          gravaStringStream(FAplicativo.arquivoDisplay, aJson.ToString);
          gravaStringStream(FAplicativo.arquivoPadaria, aJson.ToString);
          gravaStringStream(FAplicativo.arquivoacougue, aJson.ToString);

          FMonitorPadaria.AsJson := aJson.ToString;
          FMonitorPadaria.Padaria.alterado := 'sim';

          FMonitorPadaria.AsJson := aJson.ToString;
          FMonitorPadaria.Acougue.alterado := 'sim';
        end;

      gravaLog('DISPLAY', 'DISPLAY - Enviando senha - finalizando');
    except
      // silenciosa
    end;
  finally
    FreeAndNil(FMonitorPadaria);
  end;
end;

function TServerMethods1.updateconfiguradisplay1(aJson: TJSONObject): TJSONObject;
  var
    FMonitorPadaria : TClassMonitor;
begin
  try
    try
      gravaLog('DISPLAY', 'DISPLAY - Enviando senha - Iniciando');

      if aJson.Values['tipo'].Value = 'TECLADO DISPLAY 2' then
        begin
          gravaStringStream(FAplicativo.arquivoacougue, FMonitorPadaria.AsJson);

          GetInvocationMetadata().ResponseCode := 200;
          GetInvocationMetadata().ResponseContentType := 'application/json';
          GetInvocationMetadata().ResponseContent := FMonitorPadaria.AsJson;

          FMonitorPadaria.Acougue.alterado := 'não';
          gravaStringStream(FAplicativo.arquivoacougue, FMonitorPadaria.AsJson);
        end;

      gravaLog('DISPLAY', 'DISPLAY - Enviando senha - finalizando');
    except
      // silenciosa
    end;
  finally
    freeandnil(FMonitorPadaria);
  end;
end;

function TServerMethods1.updateconfigurasom(aJson: TJSONObject): TJSONObject;
begin
  try
    gravaLog('DISPLAY', 'DISPLAY - Configurando som - Iniciando');
    FAplicativo.arquivosom := aJson.Values['arquivoSom'].value;
    gravaStringStream(FAplicativo.arquivoaplicativo, FAplicativo.AsJson);
    gravaLog('DISPLAY', 'DISPLAY - Configurando som - Finalizando');
  except
    // silenciosa
  end;
end;

function TServerMethods1.updatedisplay(aJson:TJSONObject):TJSONObject;
  var
    strJson : String;
    aValue : TJSONValue;
    momTemp: TClassMonitor;
    FMonPadaria : TClassMonitor;
    FCentroImpressao : TConfiguracoesAplicativo;
begin
  { carrega informações do painel }
//  gravaLog('DISPLAY', 'DISPLAY - Lendo controle de senhas - Inicianddo');
  TGeraLog.Instancia.TryGeraLog('POST DISPLAY', 'LENDO CONTROLE DE SENHAS - INICIO');

  try
    if aJson.Values['setor'].Value = 'PADARIA' then
      begin
        if FMonPadaria = nil then
          FMonPadaria := TClassMonitor.Create;

        leStringStrream(TConfiguracoesAplicativo.Instancia.arquivodisplay, strJson);
        FMonPadaria.AsJson := strJson;

        carregaImpressora(FCentroImpressao);

        frmServidor.FExecutando := True;

        TGeraLog.Instancia.TryGeraLog('POST DISPLAY', 'LENDO CONTROLE DE SENHAS - [TECLADO 1]');

        if aJson.Values['incrementar'].Value = 'INCREMENTAR' then
          begin
            if aJson.Values['senha'].Value = 'PREFERENCIAL' then
              begin
                if (FCentroImpressao.impressao.padariamaximopreferencial > FMonPadaria.padaria.padariapreferencial) then
                  begin
                    FMonPadaria.padaria.padariapreferencial := FMonPadaria.padaria.padariapreferencial + 1;
                    TGeraLog.Instancia.TryGeraLog('POST DISPLAY', 'LENDO CONTROLE DE SENHAS - PREFERENCIAL[TECLADO 1]: ' + FMonPadaria.padaria.padariapreferencial.ToString);
                  end
                else
                  TGeraLog.Instancia.TryGeraLog('POST DISPLAY', 'LENDO CONTROLE DE SENHAS - PREFERENCIAL[TECLADO 1]: NAO EXISTE SENHAS AGUARDANDO ');

              end
            else if aJson.Values['senha'].Value = 'NORMAL' then
              begin
                if (FCentroImpressao.impressao.padariamaximonormal > FMonPadaria.padaria.padarianormal) then
                  begin
                    FMonPadaria.padaria.padarianormal := FMonPadaria.padaria.padarianormal + 1;
                    TGeraLog.Instancia.TryGeraLog('POST DISPLAY', 'LENDO CONTROLE DE SENHAS - NORMAL[TECLADO 1]: ' + FMonPadaria.padaria.Padarianormal.ToString);
                  end
                else
                  TGeraLog.Instancia.TryGeraLog('POST DISPLAY', 'LENDO CONTROLE DE SENHAS - NORMAL[TECLADO 1]: NAO EXISTE SENHAS AGUARDANDO ');
              end;

            TGeraLog.Instancia.TryGeraLog('POST DISPLAY', 'PREFERENCIAL[TECLADO 1]: ' + FMonPadaria.padaria.padariapreferencial.ToString);
            TGeraLog.Instancia.TryGeraLog('POST DISPLAY', 'NORMAL[TECLADO 1]: ' + FMonPadaria.padaria.Padarianormal.ToString);
          end;

        GetInvocationMetadata().ResponseContentType := 'application/json';
        GetInvocationMetadata().ResponseContent := FMonPadaria.AsJson;
        aValue := TJSONObject.ParseJSONValue(GetInvocationMetadata().ResponseContent);
        Result := aValue as TJSONObject;

        FMonPadaria.Padaria.alterado := 'não';
        FMonPadaria.chamandonovamente := 'não';
        FMonPadaria.Padaria.Padarianormalproximo := 0;

        gravaStringStream(TConfiguracoesAplicativo.Instancia.arquivodisplay, FMonPadaria.AsJson);
        frmServidor.FExecutando := False;
        FreeAndNil(FMonPadaria);
      end
    else if aJson.Values['setor'].Value = 'ACOUGUE' then
      begin
        try
          if FMonPadaria = nil then
            FMonPadaria := TClassMonitor.Create;

          leStringStrream(TConfiguracoesAplicativo.Instancia.arquivodisplay, strJson);
          FMonPadaria.AsJson := strJson;

          frmServidor.FExecutando := True;

          TGeraLog.Instancia.TryGeraLog('POST DISPLAY', 'LENDO CONTROLE DE SENHAS - [TECLADO 2]');

          carregaImpressora(FCentroImpressao);

          if aJson.Values['incrementar'].Value = 'INCREMENTAR' then
            begin
              if aJson.Values['senha'].Value = 'PREFERENCIAL' then
                begin

                  if (FCentroImpressao.impressao.acouguemaximoPreferencial > FMonPadaria.Acougue.Acouguepreferencial) then
                    begin
                      FMonPadaria.Acougue.Acouguepreferencial := FMonPadaria.Acougue.Acouguepreferencial + 1;
                      TGeraLog.Instancia.TryGeraLog('POST DISPLAY', 'LENDO CONTROLE DE SENHAS - PREFERENCIAL[TECLADO 2]: ' + FMonPadaria.Acougue.Acouguepreferencial.ToString);
                    end
                  else
                    TGeraLog.Instancia.TryGeraLog('POST DISPLAY', 'LENDO CONTROLE DE SENHAS - PREFERENCIAL[TECLADO 2]: NAO EXISTE SENHAS AGUARDANDO ');
                end
              else if aJson.Values['senha'].Value = 'NORMAL' then
                begin
                  if (FCentroImpressao.impressao.acouguemaximonormal > FMonPadaria.Acougue.Acouguenormal) then
                    begin
                      FMonPadaria.Acougue.Acouguenormal := FMonPadaria.Acougue.Acouguenormal + 1;
                      TGeraLog.Instancia.TryGeraLog('POST DISPLAY', 'LENDO CONTROLE DE SENHAS - NORMAL[TECLADO 2]: ' + FMonPadaria.Acougue.Acouguenormal.ToString);
                    end
                  else
                    TGeraLog.Instancia.TryGeraLog('POST DISPLAY', 'LENDO CONTROLE DE SENHAS - NORMAL[TECLADO 2]: NAO EXISTE SENHAS AGUARDANDO ');
                end;

              TGeraLog.Instancia.TryGeraLog('POST DISPLAY', 'PREFERENCIAL[TECLADO 1]: ' + FMonPadaria.Acougue.Acouguepreferencial.ToString);
              TGeraLog.Instancia.TryGeraLog('POST DISPLAY', 'NORMAL[TECLADO 1]: ' + FMonPadaria.Acougue.Acouguenormal.ToString);
            end;

          GetInvocationMetadata().ResponseContentType := 'application/json';
          GetInvocationMetadata().ResponseContent := FMonPadaria.AsJson;
          aValue := TJSONObject.ParseJSONValue(GetInvocationMetadata().ResponseContent);
          Result := aValue as TJSONObject;

          FMonPadaria.Padaria.alterado := 'não';
          FMonPadaria.chamandonovamente := 'não';
          FMonPadaria.Padaria.Padarianormalproximo := 0;

          gravaLog('DISPLAY', 'DISPLAY - Lendo controle de senhas - Teclado Dispay 2');
          gravaLog('DISPLAY','[ACOUGUE] - Teclado Dispay 1 - NORMAL ' + FMonPadaria.Acougue.Acouguenormal.toString);
          gravaLog('DISPLAY','[ACOUGUE] - Teclado Dispay 1  - PREFERENCIAL ' + FMonPadaria.Acougue.Acouguenormal.toString);

          gravaStringStream(TConfiguracoesAplicativo.Instancia.arquivodisplay, FMonPadaria.AsJson);
          frmServidor.FExecutando := False;
          FreeAndNil(FMonPadaria);
          FreeAndNil(FCentroImpressao);
        except

        END;
      end;
  except
    // silenciosa
  end;
end;

//  sincronisaPadariaAcougue;


function TServerMethods1.updatedisplayespecifico(aJson: TJSONObject): TJSONObject;
  var
    strJson : String;
    aValue : TJSONValue;
    momTemp: TClassMonitor;
    FMonPadaria : TClassMonitor;
begin
  { carrega informações do painel }
  gravaLog('DISPLAY', 'DISPLAY - Lendo controle de senhas - Inicianddo');

  try
    if aJson.Values['setor'].Value = 'PADARIA' then
      begin
        if FMonPadaria = nil then
          FMonPadaria := TClassMonitor.Create;

        leStringStrream(FAplicativo.arquivodisplay, strJson);
        FMonPadaria.AsJson := strJson;

        frmServidor.FExecutando := True;

        gravaLog('DISPLAY', 'DISPLAY - Lendo controle de senhas - Teclado Dispay 1');

        if aJson.Values['incrementar'].Value = 'INCREMENTAR' then
          begin
            if aJson.Values['senha'].Value = 'PREFERENCIAL' then
              begin
                FMonPadaria.padaria.padariapreferencial := aJson.Values['proximo'].Value.ToInteger;
              end
            else if aJson.Values['senha'].Value = 'NORMAL' then
              begin
                FMonPadaria.padaria.padarianormal := aJson.Values['proximo'].Value.ToInteger;
              end;
          end;

        FMonPadaria.padaria.padariapreferencial := FMonPadaria.padaria.padariapreferencial;
        FMonPadaria.padaria.padarianormal := FMonPadaria.padaria.padarianormal;

        GetInvocationMetadata().ResponseContentType := 'application/json';
        GetInvocationMetadata().ResponseContent := FMonPadaria.AsJson;
        aValue := TJSONObject.ParseJSONValue(GetInvocationMetadata().ResponseContent);

        FMonitorPadaria.Padaria.alterado := 'não';
        FMonitorPadaria.chamandonovamente := 'não';
        FMonitorPadaria.Padaria.Padarianormalproximo := 0;

        gravaLog('DISPLAY', 'DISPLAY - Lendo controle de senhas - Teclado Dispay 1');
        gravaLog('DISPLAY','[padaria] - Teclado Dispay 1 - NORMAL ' + FMonitorPadaria.padaria.padarianormal.toString);
        gravaLog('DISPLAY','[padaria] - Teclado Dispay 1  - PREFERENCIAL ' + FMonitorPadaria.padaria.padarianormal.toString);

        gravaStringStream(FAplicativo.arquivodisplay, FMonPadaria.AsJson);
        frmServidor.FExecutando := False;
        FreeAndNil(FMonPadaria);
      end
    else if aJson.Values['setor'].Value = 'ACOUGUE' then
      begin
        try
          if FMonPadaria = nil then
            FMonPadaria := TClassMonitor.Create;

          leStringStrream(FAplicativo.arquivodisplay, strJson);
          FMonPadaria.AsJson := strJson;

          frmServidor.FExecutando := True;

          gravaLog('DISPLAY', 'DISPLAY - Lendo controle de senhas - Teclado Dispay 2');

          if aJson.Values['incrementar'].Value = 'INCREMENTAR' then
            begin
              if aJson.Values['senha'].Value = 'PREFERENCIAL' then
                begin
                  FMonPadaria.Acougue.Acouguepreferencial := aJson.Values['proximo'].Value.ToInteger;
                end
              else if aJson.Values['senha'].Value = 'NORMAL' then
                begin
                  FMonPadaria.Acougue.Acouguenormal := aJson.Values['proximo'].Value.ToInteger;
                end;
            end;

          FMonPadaria.Acougue.Acouguepreferencial := FMonPadaria.Acougue.Acouguepreferencial;
          FMonPadaria.Acougue.Acouguenormal := FMonPadaria.Acougue.Acouguenormal;

          GetInvocationMetadata().ResponseContentType := 'application/json';
          GetInvocationMetadata().ResponseContent := FMonPadaria.AsJson;
          aValue := TJSONObject.ParseJSONValue(GetInvocationMetadata().ResponseContent);

          FMonitorPadaria.Padaria.alterado := 'não';
          FMonitorPadaria.chamandonovamente := 'não';
          FMonitorPadaria.Padaria.Padarianormalproximo := 0;

          gravaLog('DISPLAY', 'DISPLAY - Lendo controle de senhas - Teclado Dispay 2');
          gravaLog('DISPLAY','[ACOUGUE] - Teclado Dispay 1 - NORMAL ' + FMonitorPadaria.Acougue.Acouguenormal.toString);
          gravaLog('DISPLAY','[ACOUGUE] - Teclado Dispay 1  - PREFERENCIAL ' + FMonitorPadaria.Acougue.Acouguenormal.toString);

          gravaStringStream(FAplicativo.arquivodisplay, FMonPadaria.AsJson);
          frmServidor.FExecutando := False;
          FreeAndNil(FMonPadaria);
        except

        end;
      end;
  except
    // silenciosa
//    on e : exception do
//     begin
//       LOG.d(E.Message);
//       FreeAndNil(FMonPadaria);
//     end;
  end;
end;

function TServerMethods1.updatefrase(aJson: TJSONObject): TJSONObject;
  var
    strJson : String;
    aValue : TJSONValue;
    FMonVisual: TClassVisual;
    FMonTemp: TClassVisual;
begin
  { carrega informações do painel }
  gravaLog('DISPLAY', 'DISPLAY - Atualizando Frase - Inicianddo');

  try
    FMonTemp := TClassVisual.Create;
    FMonTemp.AsJson := aJson.ToString;

    FMonVisual := TClassVisual.Create;
    leStringStrream(FAplicativo.arquivovisual, strJson);
    FMonVisual.AsJson := strJson;


    FMonVisual.Configuracoes.Mostrarlogo := FMonTemp.Configuracoes.Mostrarlogo;
    FMonVisual.Configuracoes.fonteLetreitoTamanho := FMonTemp.Configuracoes.fonteLetreitoTamanho;
    FMonVisual.Configuracoes.fatorTempoLetreito := FMonTemp.Configuracoes.fatorTempoLetreito;
    FMonVisual.Configuracoes.fontePadariaScaleX := FMonTemp.Configuracoes.fontePadariaScaleX;
    FMonVisual.Configuracoes.fontePadariaScaleY := FMonTemp.Configuracoes.fontePadariaScaleY;
    FMonVisual.Configuracoes.fontePadariaTamanho := FMonTemp.Configuracoes.fontePadariaTamanho;
    FMonVisual.Configuracoes.visualalterado := FMonTemp.Configuracoes.visualalterado;
    FMonVisual.Configuracoes.Frase := StringReplace(FMonTemp.Configuracoes.Frase, '##', '#', [rfReplaceAll]);

    GetInvocationMetadata().ResponseCode := 200;
    GetInvocationMetadata().ResponseContentType := 'application/json';
    GetInvocationMetadata().ResponseContent := FMonVisual.AsJson;
    aValue := TJSONObject.ParseJSONValue(GetInvocationMetadata().ResponseContent);
    Result := (aValue as TJSONObject);

    gravaStringStream(FAplicativo.arquivovisual, FMonVisual.AsJson);

    FreeAndNil(FMonVisual);
    FreeAndNil(FMonTemp);
  except
    // silenciosa
//    on e : exception do
//     begin
//       LOG.d(E.Message);
//       FreeAndNil(FMonVisual);
//     end;
  end;

  gravaLog('DISPLAY', 'DISPLAY - Atualizando Frase - Finalizando');
end;

function TServerMethods1.updateconfiguracaoimpressao(aJson: TJSONObject): TJSONObject;
begin
  try
    FAplicativo.usaimrpessao := aJson.Values['usaimpressao'].Value;
    gravaStringStream(FAplicativo.arquivoaplicativo, FAplicativo.AsJson);
  except
    // silenciosa
  end;
end;

function TServerMethods1.updateconfiguracoes(aJson: TJSONObject): TJSONObject;
  var
    strJson : String;
    aValue : TJSONValue;
    FMonConfApp: TClassMonitor;
    FMonConf : TClassMonitor;
begin
  try
    FMonConfApp := TClassMonitor.Create;
    FMonConfApp.AsJson := aJson.ToString;

    leStringStrream(FAplicativo.arquivodisplay, strJson);
    FMonConf := TClassMonitor.Create;
    FMonConf.AsJson := strJson;

    try
      FMonConf.Padaria.Descritivo := FMonConfApp.Padaria.Descritivo;
      FMonConf.Acougue.Descritivo := FMonConfApp.Acougue.Descritivo;
      gravaStringStream(FAplicativo.arquivodisplay, FMonConf.AsJson);

      GetInvocationMetadata().ResponseCode := 200;
      GetInvocationMetadata().ResponseContentType := 'application/json';
      GetInvocationMetadata().ResponseContent := FMonConf.AsJson;
      aValue := TJSONObject.ParseJSONValue(GetInvocationMetadata().ResponseContent);
      Result := (aValue as TJSONObject);
    except
      // silenciosa
    end;
  finally
    FreeAndNil(FMonConfApp);
    FreeAndNil(FMonConf);
  end;
end;

end.

