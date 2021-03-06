program tableroInicial;

const
  LIN_HORIZONTAL = '+---+---+---+---+---+---+---+---+';
  LIN_VERTICAL = '|';
  TABLERO_HEADER = '    1   2   3   4   5   6   7   8';
  MAX_FILASCOLUMNAS = 8;
  MIN_FILASCOLUMNAS = 1;
  COLUMNAS = 8;
  FILAS = 8;
  FICHA_VACIA = 0;
  FICHA_BLANCA = 1;
  FICHA_NEGRA = 2;

type
  tMatriz = array [1..FILAS,1..COLUMNAS] of byte;

procedure LimpiarMatriz(var mMatriz:tMatriz);
var
  i,j: byte;
begin
  for i:= 1 to FILAS do
    for j:=1 to COLUMNAS do
        mMatriz[i,j] := FICHA_VACIA;
end;


procedure InicializarMatriz(var mMatriz: tMatriz);

begin
    mMatriz[4,4] := FICHA_BLANCA;
    mMatriz[5,5] := FICHA_BLANCA;
    mMatriz[4,5] := FICHA_NEGRA;
    mMatriz[5,4] := FICHA_NEGRA;
end;

procedure ReiniciarMatriz(var mMatriz: tMatriz);
begin
  LimpiarMatriz(mMatriz);
  InicializarMatriz(mMatriz);
end;

procedure DibujarTablero (var mMatriz: tMatriz);
var
  i,j : byte;
begin
  writeln(TABLERO_HEADER);
  writeln('  ', LIN_HORIZONTAL);
  for i:=1 to FILAS do
  begin
    write(i);
    for j:=1 to COLUMNAS do
    begin
      write(' ',LIN_VERTICAL,' ');
      if (mMatriz[i,j] <> 0) then
       write(mMatriz[i,j])
      else
       write(' ');
    end;
    write(' ', LIN_VERTICAL);
    writeln;
    write('  ', LIN_HORIZONTAL);
    writeln;
  end;
end;


var
  mMatriz : tMatriz;

begin
  ReiniciarMatriz(mMatriz);
  DibujarTablero(mMatriz);
  readln;
end.                
