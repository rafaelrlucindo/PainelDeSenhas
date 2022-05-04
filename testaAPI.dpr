program testaAPI;

uses
  System.StartUpCopy,
  FMX.Forms,
  untTeste in 'untTeste.pas' {Form5},
  untFuncoes in 'Funcoes\untFuncoes.pas',
  untWebClient in '..\Classes\untWebClient.pas',
  untClassMonitor in 'Classes\untClassMonitor.pas',
  Pkg.Json.DTO in 'Classes\Pkg.Json.DTO.pas',
  untClassAplicativo in 'Classes\untClassAplicativo.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm5, Form5);
  Application.Run;
end.
