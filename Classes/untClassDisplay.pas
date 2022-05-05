unit untClassDisplay;

interface

implementation

end.
unit untClassMonitor;

interface

uses
  Pkg.Json.DTO, System.Generics.Collections, REST.Json.Types;

{$M+}

type
  TDisplay = class
  private
    FAutomatico: string;
    FChamadas: Integer;
    FFrase: string;
    FZerardiario: string;
    FServidor : string;

    { configurações de visuais}
    FMostrarlogo: string;
    FDoisDisplay : string;
    FLogoEmpresa : String;
    FFontePadariaTamanho : Single;
    FFontePadariaScaleX : Double;
    FFontePadariaScaleY : Double;
    FFatorTempoLetreito : integer;
    FFonteLetreitoTamanho : Single;
    FVisualAlterado: string;

  published
    property Automatico: string read FAutomatico write FAutomatico;
    property Chamadas: Integer read FChamadas write FChamadas;
    property Frase: string read FFrase write FFrase;
    property Mostrarlogo: string read FMostrarlogo write FMostrarlogo;
    property Zerardiario: string read FZerardiario write FZerardiario;
    property Servidor: string read FServidor write FServidor;
    property logoEmpresa: string read FLogoEmpresa write FLogoEmpresa;
    property doisDisplay : string read FDoisDisplay write FDoisDisplay;
    property fontePadariaTamanho : Single read FFontePadariaTamanho write FFontePadariaTamanho;
    property fontePadariaScaleX : Double read FFontePadariaScaleX write FFontePadariaScaleX;
    property fontePadariaScaleY : Double read FFontePadariaScaleY write FFontePadariaScaleY;
    property fatorTempoLetreito : integer read FFatorTempoLetreito write FFatorTempoLetreito;
    property fonteLetreitoTamanho : Single read FFonteLetreitoTamanho write FFonteLetreitoTamanho;
    property visualalterado : string read FVisualAlterado write FVisualAlterado;
  end;

  TClassDisplay = class(TJsonDTO)
  private
    FConfiguracoes: TDisplay;
  published
    property Configuracoes: TDisplay read FConfiguracoes;
  public
    constructor Create; override;
    destructor Destroy; override;
  end;

implementation

{ TRoot }

constructor TClassDisplay.Create;
begin
  inherited;
  FConfiguracoes := TDisplay.Create;
end;

destructor TClassDisplay.Destroy;
begin
  FConfiguracoes.Free;
inherited;
end;

end.