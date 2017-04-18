unit m_MostrarPuntos;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

implementation

procedure CalcularYMostrarPuntos(var mMatriz: tMatriz, var mJugadorBlancas: trJugador, var mJugadorNegras: trJugador)
begin
     CalcularPuntos(mMatriz, mJugadorBlancas, mJugadorNegras);
     MostrarPuntos(mJugadorBlancas, mJugadorNegras);
end

procedure CalcularPuntos(var mMatriz: tMatriz, var mJugadorBlancas: trJugador, var mJugadorNegras: trJugador)
var
    i,j: byte;
begin
  mJugadorBlancas.puntos = 0;
  mJugadorNegras.puntos = 0;
  for i:= 1 to FILAS do
    for j:=1 to COLUMNAS do
        if mMatriz[i,j] <> FICHA_VACIA then
           if mMatriz[i,j] = FICHA_BLANCA then
             FICHA_BLANCA: mJugadorBlancas.puntos = mJugadorBlancas.puntos + 1;
           else
             FICHA_NEGRA: mJugadorBlancas.puntos = mJugadorBlancas.puntos + 1;
           end
        end
end

procedure MostrarPuntos(var mJugadorBlancas: trJugador, var mJugadorNegras: trJugador)
begin
  writeln('Jugador ' + mJugadorNegras.nombre + ': ' + mJugadorNegras.puntos + ' puntos.');
  writeln('Jugador ' + mJugadorNegras.nombre + ': ' + mJugadorNegras.puntos + ' puntos.');
end

end.

