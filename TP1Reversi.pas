program TP1Reversi;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Classes, SysUtils, CustApp
  { you can add units after this };

type

  { TP1Reversi }

  TP1Reversi = class(TCustomApplication)
  protected
    procedure DoRun; override;
  public
    constructor Create(TheOwner: TComponent); override;
    destructor Destroy; override;
    procedure WriteHelp; virtual;
  end;

  tFicha = Byte

  trCasillero = record
      ficha = tFicha;
  end;

{ TP1Reversi }

procedure TP1Reversi.DoRun;
var
  ErrorMsg: String;
begin
  // quick check parameters
  ErrorMsg:=CheckOptions('h', 'help');
  if ErrorMsg<>'' then begin
    ShowException(Exception.Create(ErrorMsg));
    Terminate;
    Exit;
  end;

  // parse parameters
  if HasOption('h', 'help') then begin
    WriteHelp;
    Terminate;
    Exit;
  end;

  { add your program here }
  writeln('hola');
  // stop program loop
  Terminate;
end;

procedure ReiniciarMatriz(var mMatriz:tMatriz, maxFilas:int, maxColumnas: int)
var
  i,j byte
begin
  LimpiarMatriz(mMatriz);
  InicializarMatriz(mMatriz);
end

procedure LimpiarMatriz(var mMatriz:tMatriz, maxFilas:int, maxColumnas: int)
var
  i,j byte
begin
  for i:= 1 to maxFilas do
    for j:=1 to maxFilas do
        mMatriz[i,j].ficha = FICHAVACIA;
end

Procedure InicializarMatriz(var mMatriz:tMatriz)
var
  i,j byte
begin
    mMatriz[4,4].ficha = FICHABLANCA;
    mMatriz[5,5].ficha = FICHABLANCA;
    mMatriz[4,5].ficha = FICHANEGRA;
    mMatriz[4,4].ficha = FICHANEGRA;
end


constructor TP1Reversi.Create(TheOwner: TComponent);
begin
  inherited Create(TheOwner);
  StopOnException:=True;
end;

destructor TP1Reversi.Destroy;
begin
  inherited Destroy;
end;

procedure TP1Reversi.WriteHelp;
begin
  { add your help code here }
  writeln('Usage: ', ExeName, ' -h');
end;

var
  Application: TP1Reversi;
begin
  Application:=TP1Reversi.Create(nil);
  Application.Title:='TP1Reversi';
  Application.Run;
  Application.Free;
end.

