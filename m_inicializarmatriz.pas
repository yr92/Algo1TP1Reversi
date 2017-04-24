unit m_InicializarMatriz;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

implementation
procedure ReiniciarTablero(var mMatriz:tMatriz)
begin
  LimpiarMatriz(mMatriz);
  InicializarMatriz(mMatriz);
end

procedure LimpiarTablero(var mMatriz:tMatriz)
var
  i,j byte
begin
  for i:= 1 to MAX_FILASCOLUMNAS do
    for j:=1 to MAX_FILASCOLUMNAS do
        mMatriz[i,j].ficha = FICHAVACIA;
end

Procedure InicializarTablero(var mMatriz:tMatriz)
var
  i,j byte
begin
    mMatriz[4,4].ficha = FICHABLANCA;
    mMatriz[5,5].ficha = FICHABLANCA;
    mMatriz[4,5].ficha = FICHANEGRA;
    mMatriz[5,4].ficha = FICHANEGRA;
end

end.

