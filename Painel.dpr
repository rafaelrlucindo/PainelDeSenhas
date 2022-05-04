program Painel;

uses
  System.StartUpCopy,
  FMX.Forms,
  FMX.Types,
  untPrincipal in 'untPrincipal.pas' {frmPrincipal},
  Pkg.Json.DTO in 'Classes\Pkg.Json.DTO.pas',
  untClassMonitor in 'Classes\untClassMonitor.pas',
  untClassAplicativo in 'Classes\untClassAplicativo.pas',
  Androidapi.JNI.PowerManager in '..\Classes\Androidapi.JNI.PowerManager.pas',
  untWebClient in 'Classes\untWebClient.pas',
  untClassVisual in 'Classes\untClassVisual.pas',
  untFuncoes in 'Funcoes\untFuncoes.pas',

  untDisplay in 'untDisplay.pas' {frmDisplay},
  untConfiguracoesDisplay in 'untConfiguracoesDisplay.pas' {frmConfiguracoesDisplay},
  untConfiguracoes in 'untConfiguracoes.pas' {frmConfiguracoes},
  untConfiguracoesSom in 'untConfiguracoesSom.pas' {frmConfiguracoesSom},
  untTeclado in 'untTeclado.pas' {frmTeclado},
  untConfiguracoesImpressao in 'untConfiguracoesImpressao.pas' {frmConfiguracoesImpressao},
  untSenha in 'untSenha.pas' {frmSenha},
  untConfiguracoesReset in 'untConfiguracoesReset.pas' {frmConfiguracoesReset},
  untDisplayFull in 'untDisplayFull.pas' {frmDisplayFull};

{$R *.res}

begin
  {$IFDEF Android}
    VKAutoShowMode := TVKAutoShowMode.Always;
  {$ENDIF}

  Application.Initialize;
  Application.CreateForm(TfrmPrincipal, frmPrincipal);
  //Application.CreateForm(TfrmDisplayFull, frmDisplayFull);
  Application.Run;
end.
