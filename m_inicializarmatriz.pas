unit m_InicializarMatriz;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

implementation
procedure ReiniciarMatriz(var mMatriz:tMatriz, maxFilasCols:int)
begin
  LimpiarMatriz(mMatriz, maxFilasCols);
  InicializarMatriz(mMatriz);
end

procedure LimpiarMatriz(var mMatriz:tMatriz)
var
  i,j byte
begin
  for i:= 1 to maxFilas do
    for j:=1 to maxColumnas do
        mMatriz[i,j].ficha = FICHAVACIA;
end

Procedure InicializarMatriz(var mMatriz:tMatriz)
var
  i,j byte
begin
    mMatriz[4,4].ficha = FICHABLANCA;
    mMatriz[5,5].ficha = FICHABLANCA;
    mMatriz[4,5].ficha = FICHANEGRA;
    mMatriz[5,4].ficha = FICHANEGRA;
end

end.

