unit m_MostrarPuntos;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

implementation

procedure CalcularYMostrarPuntos(var mMatriz: tMatriz, var mJugadores: tJugadores, esResultadoFinal: boolean)
begin
     CalcularPuntos(mMatriz, mJugadores);
     MostrarPuntos(mJugadores, esResultadoFinal);
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
end;

procedure MostrarPuntos(var mJugadores: tJugadores, esResultadoFinal: boolean)
begin
  if esResultadoFinal = true then writeln('RESULTADO FINAL DEL PARTIDO:');
  writeln('Jugador ' + mJugadores[JUGADOR_BLANCAS].nombre + ': ' + mJugadores[JUGADOR_BLANCAS].puntos + ' puntos.');
  writeln('Jugador ' + mJugadores[JUGADOR_NEGRAS].nombre + ': ' + mJugadores[JUGADOR_NEGRAS].puntos + ' puntos.');
end;

procedure MostrarGanadores(var mJugadores: tJugadores)
var
    ganador: byte;
begin
  if mJugadores[JUGADOR_BLANCAS].puntos <>  mJugadores[JUGADOR_NEGRAS].puntos then
  begin
       if mJugadores[JUGADOR_BLANCAS].puntos >  mJugadores[JUGADOR_NEGRAS].puntos then
          ganador := JUGADOR_BLANCAS;
       else
          ganador := JUGADOR_NEGRAS;
       writeln ('Felicidades ' + mJugadores[gandaor].nombre + ', ganaste!')
  end
  else
      writeln('Empataron? Qué embole!');
end;

end.

