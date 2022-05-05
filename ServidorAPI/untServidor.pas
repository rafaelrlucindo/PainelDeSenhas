unit untServidor;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Edit, IdHTTPWebBrokerBridge, IdGlobal, Web.HTTPApp, FMX.Controls.Presentation,
  ppParameter, ppDesignLayer, ppBands, ppPrnabl, ppClass, ppCtrls, ppCache, ppComm,
  ppRelatv, ppProd, ppReport, ppEndUsr, system.IOUtils;

type
  TfrmServidor = class(TForm)
    ButtonStart: TButton;
    ButtonStop: TButton;
    EditPort: TEdit;
    Label1: TLabel;
    ButtonOpenBrowser: TButton;
    q: TButton;
    ppSenha: TppReport;
    ppHeaderBand1: TppHeaderBand;
    ppDetailBand1: TppDetailBand;
    ppLabel1: TppLabel;
    pplblTipo: TppLabel;
    pplblSenha: TppLabel;
    ppFooterBand1: TppFooterBand;
    ppDesignLayers1: TppDesignLayers;
    ppDesignLayer1: TppDesignLayer;
    ppParameterList1: TppParameterList;
    btnConfigurar: TButton;
    ppDsnSenha: TppDesigner;
    ppLabel3: TppLabel;
    btnConfReport: TButton;
    procedure FormCreate(Sender: TObject);
    procedure ButtonStartClick(Sender: TObject);
    procedure ButtonStopClick(Sender: TObject);
    procedure ButtonOpenBrowserClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure qClick(Sender: TObject);
    procedure btnConfigurarClick(Sender: TObject);
    procedure btnConfReportClick(Sender: TObject);
  private
    FServer: TIdHTTPWebBrokerBridge;
    procedure StartServer;
    procedure ApplicationIdle(Sender: TObject; var Done: Boolean);
    { Private declarations }
  public
    { Public declarations }
    FExecutando : Boolean;
  end;

var
  frmServidor: TfrmServidor;

implementation

{$R *.fmx}

uses
  WinApi.Windows, Winapi.ShellApi, Datasnap.DSSession;

procedure TfrmServidor.ApplicationIdle(Sender: TObject; var Done: Boolean);
begin
  ButtonStart.Enabled := not FServer.Active;
  ButtonStop.Enabled := FServer.Active;
  EditPort.Enabled := not FServer.Active;
end;

procedure TfrmServidor.qClick(Sender: TObject);
begin
//  ppSenha.DeviceType := 'screen';
  ppSenha.Template.FileName := tpath.Combine(ExtractFilePath(ParamStr(0)), 'impressao.rtm');
  ppSenha.Template.LoadFromFile;
  ppSenha.Print;
  //ppSenha.DeviceType := 'printer';
end;

procedure TfrmServidor.btnConfigurarClick(Sender: TObject);
begin
  ppDsnSenha.Report := ppSenha;
  ppSenha.Template.FileName := tpath.Combine(ExtractFilePath(ParamStr(0)), 'impressao.rtm');
  ppSenha.Template.LoadFromFile;
  ppDsnSenha.ShowModal;
  ppSenha.Template.LoadFromFile;
end;

procedure TfrmServidor.btnConfReportClick(Sender: TObject);
  var
    dlg : TOpenDialog;
begin
  try
    dlg := TOpenDialog.Create(Self);
    dlg.Execute;

    if dlg.Files.Count > 0 then
      begin

      end;
  finally
    FreeAndNil(dlg);
  end;

end;

procedure TfrmServidor.ButtonOpenBrowserClick(Sender: TObject);
var
  LURL: string;
begin
  StartServer;
  LURL := Format('http://localhost:%s', [EditPort.Text]);
  ShellExecute(0,
        nil,
        PChar(LURL), nil, nil, SW_SHOWNOACTIVATE);
end;

procedure TfrmServidor.ButtonStartClick(Sender: TObject);
begin
  StartServer;
end;

procedure TerminateThreads;
begin
  if TDSSessionManager.Instance <> nil then
    TDSSessionManager.Instance.TerminateAllSessions;
end;

procedure TfrmServidor.ButtonStopClick(Sender: TObject);
begin
  TerminateThreads;
  FServer.Active := False;
  FServer.Bindings.Clear;
end;

procedure TfrmServidor.FormCreate(Sender: TObject);
begin
  FServer := TIdHTTPWebBrokerBridge.Create(Self);
  FExecutando := False;
  Application.OnIdle := ApplicationIdle;
end;

procedure TfrmServidor.FormShow(Sender: TObject);
begin
  ButtonStartClick(Sender);

  ppSenha.Template.FileName := tpath.Combine(ExtractFilePath(ParamStr(0)), 'impressao.rtm');
  ppSenha.Template.LoadFromFile;
end;

procedure TfrmServidor.StartServer;
begin
  if not FServer.Active then
  begin
    FServer.Bindings.Clear;
    FServer.DefaultPort := StrToInt(EditPort.Text);
    FServer.Active := True;
  end;
end;

end.
