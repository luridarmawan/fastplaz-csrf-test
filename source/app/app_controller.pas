unit app_controller;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, html_lib, fpcgi, fpjson, json_lib, HTTPDefs,
  fastplaz_handler, database_lib, dateutils, string_helpers,
  datetime_helpers, array_helpers;

type

  { TAppController }

  TAppController = class(TMyCustomController)
  private
    function Tag_MainContent_Handler(const TagName: string;
      Params: TStringList): string;
    procedure BeforeRequestHandler(Sender: TObject; ARequest: TRequest);
  public
    constructor CreateNew(AOwner: TComponent; CreateMode: integer); override;
    destructor Destroy; override;

    procedure Get; override;
    procedure Post; override;
  end;

implementation

uses theme_controller, common;

constructor TAppController.CreateNew(AOwner: TComponent; CreateMode: integer);
begin
  inherited CreateNew(AOwner, CreateMode);
  BeforeRequest := @BeforeRequestHandler;
end;

destructor TAppController.Destroy;
begin
  inherited Destroy;
end;

// Init First
procedure TAppController.BeforeRequestHandler(Sender: TObject; ARequest: TRequest);
begin
end;

// GET Method Handler
procedure TAppController.Get;
begin
  Tags['maincontent'] := @Tag_MainContent_Handler; //<<-- tag maincontent handler
  Response.Content := ThemeUtil.Render();
end;

// POST Method Handler
procedure TAppController.Post;
var
  customerName, maincontent: string;
begin
  if not isValidCSRF then
  begin
    maincontent := '<div class="center-screen">CSRF tidak valid.' +
      '<br>Sepertinya anda mereload ulang halaman ini setelah post data sebelumnya' +
      '<br><br><a href="./">Kembali</a></div>';
  end
  else
  begin
    customerName := _POST['name'];
    maincontent := '<div class="center-screen">Nama customer: ' +
      customerName + '</div>';
  end;

  ThemeUtil.Assign('maincontent', maincontent);
  Response.Content := ThemeUtil.Render();
end;

function TAppController.Tag_MainContent_Handler(const TagName: string;
  Params: TStringList): string;
begin
  Result := ThemeUtil.RenderFromContent(nil, '', 'modules/form/form.html');
end;

end.
