unit untTeste;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Controls.Presentation,
  FMX.StdCtrls, untClassMonitor, untWebClient;

type
  TThreadSincronizaDisplay = class(TThread)
    private
      procedure chamarProximo(aSetor:String; aSenha: String; aIncrementar:String);
    public
      procedure execute; override;

  end;

  TForm5 = class(TForm)
    lblAcougue: TLabel;
    lblPadaria: TLabel;
    Timer1: TTimer;
    GroupBox1: TGroupBox;
    rbAcougueNormal: TRadioButton;
    rbAcouguePreferencial: TRadioButton;
    rbPadariaNormal: TRadioButton;
    rbPadariaPreferencial: TRadioButton;
    procedure Timer1Timer(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    //procedure chamarProximo(aSetor:String; aSenha: String; aIncrementar:String);
  public
    { Public declarations }
    FOldAcougueNormal : integer;
    FOldAcouguePreferencial : integer;
    FContaNormal : Integer;
    FContaPreferencial : Integer;
    FTThreadSincronizaDisplay : TThreadSincronizaDisplay;
  end;

var
  Form5: TForm5;

implementation

{$R *.fmx}

procedure TThreadSincronizaDisplay.chamarProximo(aSetor:String; aSenha: String; aIncrementar:String);
  var
    FMonitor : TClassMonitor;
    strJSon : String;

  const
    constJSon : string =
      '{' +
      '   "setor" : "%s", ' +
      '   "senha" : "%s", ' +
      '   "incrementar" : "%s"' +
      '}';
begin
  try
    try
      strJSon := Format(constJSon, [aSetor, aSenha, aIncrementar]);
      TWebClient.consomeApi('http://192.168.100.17:8081/api/painel/display/display', 'post', strJSon);

      if twebclient.StatusCode = 200 then
        begin
          FMonitor := TClassMonitor.Create;
          FMonitor.AsJson := twebclient.ResponseBody;

          if aSetor = 'ACOUGUE' then
            begin
              if aSenha =  'PREFERENCIAL' then
                begin
                  if Form5.FOldAcouguePreferencial <> FMonitor.Acougue.Acouguepreferencial then
                    begin
//                      TThread.Synchronize(TThread.Current,
//                        procedure
//                          begin
                            Form5.lblAcougue.Text := FormatFloat('P000#', FMonitor.Acougue.Acouguepreferencial);
                            Form5.FOldAcouguePreferencial := FMonitor.Acougue.Acouguepreferencial;
//                          end);
                    end;
                end;

              if aSenha =  'NORMAL' then
                begin
                  if Form5.FOldAcougueNormal <> FMonitor.Acougue.Acouguenormal then
                    begin
                      TThread.Synchronize(TThread.Current,
                        procedure
                          begin
                            Form5.lblAcougue.Text := FormatFloat('N000#', FMonitor.Acougue.Acouguenormal);
                            Form5.FOldAcougueNormal := FMonitor.Acougue.Acouguenormal;
                          end);
                    end;
                end;
            end;

          //lblPadaria.Text := FMonitor.Padaria.Padarianormal.ToString;
        end;
    except

    end;
  finally
    TWebClient.FWebClient.Destroy;
    TWebClient.FWebClient := nil;
    Sleep(1000);
  end;
end;

procedure TForm5.FormShow(Sender: TObject);
begin
  FOldAcougueNormal := 0;
  FOldAcouguePreferencial := 0;
  FTThreadSincronizaDisplay := TThreadSincronizaDisplay.Create(false);
end;

procedure TForm5.Timer1Timer(Sender: TObject);
begin

end;

{ TThreadSincronizaDisplay }

procedure TThreadSincronizaDisplay.execute;
begin
  inherited;

  while not Terminated do
    begin
      try
        if Form5.rbAcouguePreferencial.IsChecked then
          chamarProximo('ACOUGUE', 'PREFERENCIAL', 'INCREMENTAR');

        if Form5.rbAcougueNormal.IsChecked then
          chamarProximo('ACOUGUE', 'NORMAL', 'INCREMENTAR');

        if Form5.rbPadariaPreferencial.IsChecked then
          chamarProximo('PADARIA', 'PREFERENCIAL', 'INCREMENTAR');

        if Form5.rbPadariaNormal.IsChecked then
          chamarProximo('PADARIA', 'NORMAL', 'INCREMENTAR');
      except
        // nada
      end;
    end;
end;

end.
