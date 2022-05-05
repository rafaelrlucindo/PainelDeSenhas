program ServidorAPI1;
{$APPTYPE GUI}

{$R *.dres}

uses
  FMX.Forms,
  Web.WebReq,
  IdHTTPWebBrokerBridge,
  untServidor in 'untServidor.pas' {frmServidor},
  ServerMethodsUnit1 in 'ServerMethodsUnit1.pas' {ServerMethods1: TDSServerModule},
  ServerContainerUnit1 in 'ServerContainerUnit1.pas' {ServerContainer1: TDataModule},
  WebModuleUnit1 in 'WebModuleUnit1.pas' {WebModule1: TWebModule},
  untClassMonitor in '..\Classes\untClassMonitor.pas',
  Pkg.Json.DTO in '..\Classes\Pkg.Json.DTO.pas',
  untFuncoes in '..\Funcoes\untFuncoes.pas',
  untClassAplicativo in '..\Classes\untClassAplicativo.pas',
  untClassVisual in '..\Classes\untClassVisual.pas',
  untClassLog in '..\..\Classes\untClassLog.pas';

{$R *.res}

begin
  if WebRequestHandler <> nil then
    WebRequestHandler.WebModuleClass := WebModuleClass;
  Application.Initialize;
  Application.CreateForm(TfrmServidor, frmServidor);
  Application.Run;
end.
