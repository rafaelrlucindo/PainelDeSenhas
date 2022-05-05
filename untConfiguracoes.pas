unit untConfiguracoes;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Edit, FMX.Ani,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Effects, FMX.Objects, FMX.Layouts,
  untFuncoes, untClassMonitor, strutils, FMX.ListBox, untWebClient, untClassVisual;

type
  TfrmConfiguracoes = class(TForm)
    layTopo: TLayout;
    Rectangle1: TRectangle;
    rectTopo: TRectangle;
    layVoltar: TLayout;
    imgVoltar: TImage;
    ShadowEffect2: TShadowEffect;
    layTitulo: TLayout;
    lblTitulo: TLabel;
    ShadowEffect1: TShadowEffect;
    layConteudo: TLayout;
    rectConteudo: TRectangle;
    ShadowEffect3: TShadowEffect;
    layMenu: TLayout;
    rectFundoMenu: TRectangle;
    layConteudoMenu: TLayout;
    layPainel: TLayout;
    Image3: TImage;
    Label2: TLabel;
    rectTituloMenu: TRectangle;
    layImagemMenu: TLayout;
    imgMenu2: TImage;
    ShadowEffect4: TShadowEffect;
    lblSubtituloMenu: TLabel;
    ShadowEffect5: TShadowEffect;
    layConfiguracoes: TLayout;
    Image2: TImage;
    Label3: TLabel;
    layFechar: TLayout;
    imgFechar: TImage;
    aniMenu: TFloatAnimation;
    StyleBook1: TStyleBook;
    layRodape: TLayout;
    Label1: TLabel;
    ShadowEffect6: TShadowEffect;
    layAcougue: TLayout;
    layDadosAcougue: TLayout;
    Layout4: TLayout;
    layAcouguePreferencial: TLayout;
    lblTituloAcouguePrefencial: TLabel;
    Rectangle2: TRectangle;
    edtAcouguePreferencial: TEdit;
    imgAcougue: TImage;
    layAcougueNormal: TLayout;
    lblTituloAgougueNormal: TLabel;
    rectAcougueNormal: TRectangle;
    edtAcougueNormal: TEdit;
    Layout2: TLayout;
    Label7: TLabel;
    Rectangle4: TRectangle;
    edtDisplay2: TEdit;
    layChamadas: TLayout;
    layDadosChamada: TLayout;
    Layout9: TLayout;
    Layout10: TLayout;
    Label6: TLabel;
    Rectangle6: TRectangle;
    Edit4: TEdit;
    imgChamada: TImage;
    layEdtChamada: TLayout;
    lblEdtChamada: TLabel;
    rectEdtChamada: TRectangle;
    edtChamadas: TEdit;
    layEdtAutomatico: TLayout;
    Label8: TLabel;
    rectAutomatico: TRectangle;
    swtAutomatico: TSwitch;
    layPadaria: TLayout;
    layDadosPAdaria: TLayout;
    Layout3: TLayout;
    layPadariaNormal: TLayout;
    lblNumPadrariaPreferencial: TLabel;
    rectEdtPadariaNormal: TRectangle;
    edtPadariaNormal: TEdit;
    layPadariaPreferencial: TLayout;
    Label5: TLabel;
    rectEdtPadariaPReferencial: TRectangle;
    edtPadariaPreferencial: TEdit;
    imgPadaria: TImage;
    Layout1: TLayout;
    Label4: TLabel;
    Rectangle3: TRectangle;
    edtDisplay1: TEdit;
    laySalvar: TLayout;
    imgSalvar: TImage;
    layServidor: TLayout;
    layServidorDados: TLayout;
    layEditServidor: TLayout;
    lblEdtServidor: TLabel;
    rectEdtServidor: TRectangle;
    edtServidor: TEdit;
    imgServidor: TImage;
    lblObservacao: TLabel;
    lblSubTitulo: TLabel;
    layCampos: TLayout;
    ScrollBox1: TScrollBox;
    rectFundoPadaria: TRectangle;
    rectFundoAcougue: TRectangle;
    rectFundoChamadas: TRectangle;
    rectFundoServidor: TRectangle;
    layTipo: TLayout;

    Layout12: TLayout;
    Rectangle5: TRectangle;
    Layout13: TLayout;
    Label12: TLabel;
    Rectangle8: TRectangle;
    imgTipo: TImage;
    cbxTipo: TComboBox;
    procedure layVoltarClick(Sender: TObject);
    procedure imgSalvarClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormVirtualKeyboardHidden(Sender: TObject; KeyboardVisible: Boolean; const Bounds: TRect);
    procedure edtChamadasEnter(Sender: TObject);
    procedure edtFraseEnter(Sender: TObject);
    procedure edtDisplay2Enter(Sender: TObject);
    procedure cbxTipoChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    FVisual : TClassVisual;
    //FMonitor : TClassMonitor;

    foco: TControl;
    fmx : TFmxObject;
    obj : TObject;

    procedure ajustarFoco; //(Sender:TObject);
  public
    { Public declarations }
  end;

var
  frmConfiguracoes: TfrmConfiguracoes;

implementation

{$R *.fmx}

procedure TfrmConfiguracoes.ajustarFoco;
begin
  {$IFDEF Android }
    with frmConfiguracoes do
      begin
        ScrollBox1.Margins.Bottom := 250;
        ScrollBox1.ViewportPosition := PointF(
          ScrollBox1.ViewportPosition.X,
          TLayout(obj).Position.Y - 90
        );
      end;
  {$ENDIF}
end;

procedure TfrmConfiguracoes.cbxTipoChange(Sender: TObject);
begin
  if cbxTipo.ItemIndex = 0 then
    begin { display }
      layServidor.Visible := True;
      layTipo.Visible := True;
//      layDisplay.Visible := True;
      layPadaria.Visible := True;
      layAcougue.Visible := True;
      layChamadas.Visible := True;
      //layZerarDia.Visible := True;
    end
  else if cbxTipo.ItemIndex = 1 then
    begin { teclado padaria }
      layServidor.Visible := True;
      layTipo.Visible := True;
      layPadaria.Visible := True;
      layAcougue.Visible := False;
//      layDisplay.Visible := True;
      layChamadas.Visible := False;
      //layZerarDia.Visible := False;
    end
  else if cbxTipo.ItemIndex = 2 then
    begin { teclado padaria }
      layServidor.Visible := True;
      layTipo.Visible := True;
      layAcougue.Visible := True;
      layPadaria.Visible := False;
//      layDisplay.Visible := True;
      layChamadas.Visible := False;
      //layZerarDia.Visible := False;
    end
  else if cbxTipo.ItemIndex = 3 then
    begin { impressão }
      layServidor.Visible := True;
      layTipo.Visible := True;
      layAcougue.Visible := True;
      layPadaria.Visible := True;
//      layDisplay.Visible := False;
      layChamadas.Visible := False;
      //layZerarDia.Visible := False;
    end;
end;

procedure TfrmConfiguracoes.edtChamadasEnter(Sender: TObject);
  var
    ancestral1 : string;
begin
  foco := TControl(TEdit(Sender).Parent);
  ancestral1 := foco.Name;
  obj := FindComponent(tedit(Sender).TagString);
  ajustarFoco;
end;

procedure TfrmConfiguracoes.edtDisplay2Enter(Sender: TObject);
  var
    ancestral1 : string;
begin
  foco := TControl(TEdit(Sender).Parent);
  ancestral1 := foco.Name;
  obj := FindComponent(tedit(Sender).TagString);
  ajustarFoco;
end;

procedure TfrmConfiguracoes.edtFraseEnter(Sender: TObject);
  var
    ancestral1 : string;
begin
  foco := TControl(TEdit(Sender).Parent);
  ancestral1 := foco.Name;
  obj := FindComponent(tedit(Sender).TagString);
  ajustarFoco;
end;

procedure TfrmConfiguracoes.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := TCloseAction.caFree;
end;

procedure TfrmConfiguracoes.FormCreate(Sender: TObject);
  var
    strJson : String;
begin
  FMonitor := TClassMonitor.Create;
  FVisual := TClassVisual.Create;

  if FileExists(FAplicativo.arquivodisplay) then
    begin
      leStringStrream(FAplicativo.arquivodisplay, strJson);
      FMonitor.AsJson := strJson;
    end;

  if FileExists(FAplicativo.arquivovisual) then
    begin
      leStringStrream(FAplicativo.arquivovisual, strJson);
      FVisual.AsJson := strJson;
    end;
end;

procedure TfrmConfiguracoes.FormDestroy(Sender: TObject);
begin
  if FVisual <> nil then
    FreeAndNil(FVisual);

  frmConfiguracoes := nil;
end;

procedure TfrmConfiguracoes.FormShow(Sender: TObject);
  var
    tempDisplay : TClassMonitor;
    strJson : string;

  const
    constJSon : string =
      '{' +
      '   "setor" : "%s", ' +
      '   "senha" : "%s", ' +
      '   "incrementar" : "%s"' +
      '}';
begin
  ScrollBox1.Margins.Bottom := 0;
  edtChamadas.TagString := 'layChamadas';
  edtDisplay2.TagString := 'layAcougue';
  edtAcougueNormal.TagString := 'layAcougue';
  edtAcouguePreferencial.TagString := 'layAcougue';
  edtDisplay1.TagString := 'layPadaria';
  edtPadariaPreferencial.TagString := 'layPadaria';
  edtPadariaNormal.TagString := 'layPadaria';
  edtServidor.TagString := 'layServidor';

  FMonitor := TClassMonitor.Create;

//  if tempDisplay = nil then
//    begin
  if not vazio(FAplicativo.servidor) then
    begin
      tempDisplay := TClassMonitor.Create;

      try
        strJSon := Format(constJSon, ['ACOUGUE', 'NORMAL', 'CONSULTAR']);
        TWebClient.consomeApi(FAplicativo.servidor + '/api/painel/display/display', 'post', strJSon);

        if twebclient.StatusCode = 200 then
          begin
            //tempDisplay := TClassMonitor.Create;
            tempDisplay.AsJson := twebclient.ResponseBody;

            FMonitor.Padaria.Padarianormal := tempDisplay.Padaria.Padarianormal;
            FMonitor.Padaria.Padarianormalproximo := tempDisplay.Padaria.Padarianormalproximo;
            FMonitor.Padaria.Padariapreferencial := tempDisplay.Padaria.Padariapreferencial;
            FMonitor.Padaria.Padariapreferencialproximo := tempDisplay.Padaria.Padariapreferencialproximo;

            FMonitor.Acougue.Acouguenormal := tempDisplay.Acougue.Acouguenormal;
            FMonitor.Acougue.Acouguenormalproximo := tempDisplay.Acougue.Acouguenormalproximo;
            FMonitor.Acougue.Acouguepreferencial := tempDisplay.Acougue.Acouguepreferencial;
            FMonitor.Acougue.Acouguepreferencialproximo := tempDisplay.Acougue.Acouguepreferencialproximo;

            FMonitor.Padaria.Descritivo := tempDisplay.Padaria.Descritivo;
            FMonitor.Acougue.Descritivo := tempDisplay.Acougue.Descritivo;
          end;
      except
        // silenciosa
        FreeAndNil(tempDisplay);
      end;
    end;
//    end;

  { servidor }
  edtServidor.Text := FAplicativo.Servidor;

  { tipo }
  cbxTipo.ItemIndex := cbxTipo.Items.IndexOf(FAplicativo.tipo);

  { padaria - display 1 }
  edtDisplay1.Text := FMonitor.Padaria.Descritivo;


  edtPadariaNormal.Text := iif(
    FMonitor.Padaria.Padarianormal = 0,
      1,
      FMonitor.Padaria.Padarianormal.ToString
  );

  edtPadariaPreferencial.Text := iif(
    FMonitor.Padaria.Padariapreferencial = 0,
      1,
      FMonitor.Padaria.Padariapreferencial.ToString
  );

  { açougue - display 2 }
  edtDisplay2.Text := FMonitor.Acougue.Descritivo;

  edtAcougueNormal.Text := iif(
    FMonitor.Acougue.Acouguenormal = 0,
      1,
      FMonitor.Acougue.Acouguenormal.ToString
  );

  edtAcouguePreferencial.Text := iif(
    FMonitor.Acougue.Acouguepreferencial = 0,
      1,
      FMonitor.Acougue.Acouguepreferencial.ToString
  );

  { chamadas }
  edtChamadas.Text := iif(FVisual.Configuracoes.Chamadas = 0, 3, FVisual.Configuracoes.Chamadas);
  swtAutomatico.IsChecked := iif(FVisual.Configuracoes.Automatico = 'sim', True, False);

  edtChamadas.Text := FVisual.Configuracoes.Chamadas.ToString;
  swtAutomatico.IsChecked := iif(FVisual.Configuracoes.Automatico = 'sim', True, False);

  cbxTipoChange(Sender);
end;

procedure TfrmConfiguracoes.FormVirtualKeyboardHidden(Sender: TObject; KeyboardVisible: Boolean; const Bounds: TRect);
begin
  ScrollBox1.Margins.Bottom := 0;
end;

procedure TfrmConfiguracoes.imgSalvarClick(Sender: TObject);
begin
  FAplicativo.Servidor := edtServidor.Text;

  FMonitor.Padaria.Descritivo := iif(vazio(edtDisplay1.Text), 'Padaria', edtDisplay1.Text);
  FMonitor.Padaria.Padarianormal := StrToIntDef(edtPadariaNormal.Text, 1);
  FMonitor.Padaria.Padariapreferencial := StrToIntDef(edtPadariaPreferencial.Text, 1);

  FMonitor.Acougue.Descritivo := iif(vazio(edtDisplay2.Text), 'Açougue', edtDisplay2.Text);
  FMonitor.Acougue.Acouguenormal := StrToIntDef(edtAcougueNormal.Text, 1);
  FMonitor.Acougue.Acouguepreferencial := StrToIntDef(edtAcouguePreferencial.Text, 1);

  FVisual.Configuracoes.Chamadas := edtChamadas.Text.ToInteger;
  FVisual.Configuracoes.Automatico := iif(swtAutomatico.IsChecked, 'sim', 'não');

  FAplicativo.tipo := cbxTipo.Selected.Text;

  if FAplicativo.tipo = 'DISPLAY' then
    begin
      FMonitor.Acougue.alterado := 'sim';
      FMonitor.Padaria.alterado := 'sim';
    end;

  if cbxTipo.ItemIndex in[1..2] then
    begin
      FAplicativo.tipo := iif(cbxTipo.ItemIndex = 1, 'TECLADO DISPLAY 1', 'TECLADO DISPLAY 2');
    end;

  if not vazio(FAplicativo.servidor) then
    try
      TWebClient.consomeApi(FAplicativo.servidor + '/api/painel/display/configuracoes', 'post', FMonitor.AsJson);

      if twebclient.StatusCode = 200 then
        begin
          // nao faz nada com o retorno mesmo
        end;
    except
      // silenciosa
    end;

  FMonitor.tipo := FAplicativo.tipo;
  gravaStringStream(FAplicativo.arquivodisplay, FMonitor.AsJson);
  Sleep(20);
  gravaStringStream(FAplicativo.arquivoaplicativo, FAplicativo.AsJson);
  Sleep(20);
  gravaStringStream(FAplicativo.arquivovisual, FVisual.AsJson);


  Close;
end;

procedure TfrmConfiguracoes.layVoltarClick(Sender: TObject);
begin
  Close;
end;

end.
