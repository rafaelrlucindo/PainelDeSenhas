unit Unit1;

interface

uses
  SysUtils, Variants, Classes, math, StrUtils, TypInfo, System.NetEncoding,
  Soap.EncdDecd, system.ioutils;

type
  TAplicativo = class
    private

    protected
      class var FDiretorioAcougue: string;
      class var FDiretorioPadrao: string;
      class var FDiretorioPadaria: string;
      class var FAplicativo: TAplicativo;
    published
      class property diretoriopadrao : string read FDiretorioPadrao write FDiretorioPadrao;
      class property diretorioacogue : string read FDiretorioAcougue write FDiretorioAcougue;
      class property diretorioPadaria : string read FDiretorioPadaria write FDiretorioPadaria;
      class property Aplicativo : TAplicativo strinf read FAplicativo write FAplicativo;
  end;

implementation

end.
