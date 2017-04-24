unit m_MostrarPuntos;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

implementation

procedure CalcularYMostrarPuntos(var mMatriz: tMatriz, var mJugadores: tJugadores)
begin
     CalcularPuntos(mMatriz, mJugadores);
     MostrarPuntos(mJugadores);
end

procedure CalcularPuntos(var mMatriz: tMatriz, var mJugadores: tJugadores)
var
    i,j: byte;
begin
  mJugadores[JUGADOR_BLANCAS].puntos = 0;
  mJugadores[JUGADOR_NEGRAS].puntos = 0;
  for i:= 1 to MAX_FILASCOLUMNAS do
    for j:=1 to MAX_FILASCOLUMNAS do
        if mMatriz[i,j] <> FICHA_VACIA then
           if mMatriz[i,j] = FICHA_BLANCA then
             inc(mJugadores[JUGADOR_BLANCAS].puntos);
           else
             inc(mJugadores[JUGADOR_NEGRAS].puntos);
           end
        end
end

procedure MostrarPuntos(var mJugadores: tJugadores)
begin
  writeln('Jugador ' + mJugadores[JUGADOR_BLANCAS].nombre + ': ' + mJugadores[JUGADOR_BLANCAS].puntos + ' puntos.');
  writeln('Jugador ' + mJugadores[JUGADOR_NEGRAS].nombre + ': ' + mJugadores[JUGADOR_NEGRAS].puntos + ' puntos.');
end

end.

