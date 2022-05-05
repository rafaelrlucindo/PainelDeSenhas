unit untClassMonitor;

interface

uses
  Pkg.Json.DTO, System.Generics.Collections, REST.Json.Types;

{$M+}

type
  TAcougue = class(TJsonDTO)
  private
    FAcouguenormal: Integer;
    FAcouguenormalproximo: Integer;
    FAcouguepreferencial: Integer;
    FAcouguepreferencialproximo: Integer;
    FDatamovimento: string;
    FDescritivo: string;
    FAlterado: string;
  published
    property Acouguenormal: Integer read FAcouguenormal write FAcouguenormal;
    property Acouguenormalproximo: Integer read FAcouguenormalproximo write FAcouguenormalproximo;
    property Acouguepreferencial: Integer read FAcouguepreferencial write FAcouguepreferencial;
    property Acouguepreferencialproximo: Integer read FAcouguepreferencialproximo write FAcouguepreferencialproximo;
    property Datamovimento: string read FDatamovimento write FDatamovimento;
    property Descritivo: string read FDescritivo write FDescritivo;
    property alterado : string read FAlterado write FAlterado;
  end;

  TPadaria = class(TJsonDTO)
  private
    FDatamovimento: string;
    FDescritivo: string;
    FPadarianormal: Integer;
    FPadarianormalproximo: Integer;
    FPadariapreferencial: Integer;
    FPadariapreferencialproximo: Integer;
    FAlterado: string;
  published
    property Datamovimento: string read FDatamovimento write FDatamovimento;
    property Descritivo: string read FDescritivo write FDescritivo;
    property Padarianormal: Integer read FPadarianormal write FPadarianormal;
    property Padarianormalproximo: Integer read FPadarianormalproximo write FPadarianormalproximo;
    property Padariapreferencial: Integer read FPadariapreferencial write FPadariapreferencial;
    property Padariapreferencialproximo: Integer read FPadariapreferencialproximo write FPadariapreferencialproximo;
    property alterado : string read FAlterado write FAlterado;
  end;

  TClassMonitor = class(TJsonDTO)
  private
    FAcougue: TAcougue;
    FPadaria: TPadaria;
    FChamandoNovamente: string;
    FTipo: string;
    FVariante : String;
  published
    property Acougue: TAcougue read FAcougue;
    property Padaria: TPadaria read FPadaria;
    property chamandonovamente : string read FChamandoNovamente write FChamandoNovamente;
    property tipo : string read FTipo write FTipo;
    property variante: string read FVariante write FVariante;
  public
    constructor Create; override;
    destructor Destroy; override;
  end;

implementation

{ TRoot }

constructor TClassMonitor.Create;
begin
  inherited;
  FPadaria := TPadaria.Create;
  FAcougue := TAcougue.Create;
end;

destructor TClassMonitor.Destroy;
begin
  FPadaria.Free;
  FAcougue.Free;
inherited;
end;

end.
