program appPainel;

uses
  System.StartUpCopy,
  FMX.Forms,
  FMX.Types,
  untPrincipal in 'untPrincipal.pas' {frmPrincipal},
  Pkg.Json.DTO in 'Classes\Pkg.Json.DTO.pas',
  untClassMonitor in 'Classes\untClassMonitor.pas',
  untClassAplicativo in 'Classes\untClassAplicativo.pas',
  untFuncoes in 'Funcoes\untFuncoes.pas',
  untDisplay in 'untDisplay.pas' {frmDisplay},
  untWebClient in 'Classes\untWebClient.pas',
  untConfiguracoesDisplay in 'untConfiguracoesDisplay.pas' {frmConfiguracoesDisplay},
  untConfiguracoes in 'untConfiguracoes.pas' {frmConfiguracoes},
  untConfiguracoesSom in 'untConfiguracoesSom.pas' {frmConfiguracoesSom},
  untTeclado in 'untTeclado.pas' {frmTeclado},
  untClassVisual in 'Classes\untClassVisual.pas';

{$R *.res}

begin
  {$IFDEF Android}
    VKAutoShowMode := TVKAutoShowMode.Always;
  {$ENDIF}

  Application.Initialize;
  Application.CreateForm(TfrmPrincipal, frmPrincipal);
  Application.Run;
end.
