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
  mJugadores[FICHA_BLANCA].puntos = 0;
  mJugadores[FICHA_NEGRA].puntos = 0;
  for i:= 1 to MAX_FILASCOLUMNAS do
    for j:=1 to MAX_FILASCOLUMNAS do
        if mMatriz[i,j] <> FICHA_VACIA then
           if mMatriz[i,j] = FICHA_BLANCA then
             inc(mJugadores[FICHA_BLANCA].puntos);
           else
             inc(mJugadores[FICHA_NEGRA].puntos);
end;

procedure MostrarPuntos(var mJugadores: tJugadores, esResultadoFinal: boolean)
begin
  if esResultadoFinal = true then writeln('RESULTADO FINAL DEL PARTIDO:');
  writeln('Jugador ' + mJugadores[FICHA_BLANCA].nombre + ': ' + mJugadores[FICHA_BLANCA].puntos + ' puntos.');
  writeln('Jugador ' + mJugadores[FICHA_NEGRA].nombre + ': ' + mJugadores[FICHA_NEGRA].puntos + ' puntos.');
end;

procedure MostrarGanadores(var mJugadores: tJugadores)
var
    ganador: byte;
begin
  if mJugadores[FICHA_BLANCA].puntos <>  mJugadores[FICHA_NEGRA].puntos then
  begin
       if mJugadores[FICHA_BLANCA].puntos >  mJugadores[FICHA_NEGRA].puntos then
          ganador := FICHA_BLANCA;
       else
          ganador := FICHA_NEGRA;
       writeln ('Felicidades ' + mJugadores[ganador].nombre + ', ganaste!')
  end
  else
      writeln('¿Empataron? ¡Qué embole!');
end;

end.

