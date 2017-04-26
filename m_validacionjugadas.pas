unit m_ValidacionJugadas;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

implementation
procedure ListarJugadasValidas(var mMatriz: tMatriz; var mJugada: trJugada; var mJugadores: tJugadores; var mDirecciones: tDirecciones; var mJugadasValidas: tJugadasValidas);
var
  i: byte;
  j: byte;
  jugadaAValidar: trJugada;
begin
    for i:= 1 to MAX_FILASCOLUMNAS do
        for j:= 1 to MAX_FILASCOLUMNAS do
            jugadaAValidar.x := i;
            jugadaAValidar.y := j;
            if ChequearJugadaValida(mMatriz, mDirecciones, mJugada, jugadaAValidar) = true then
                 AgregarJugadaValida(jugadaAux, mJugadasValidas);
end;

function ChequearJugadaValida(var mMatriz: tMatriz; var mDirecciones: tDirecciones; var mJugada: trJugada; var mJugadaAValidar: trJugada);
var
  i: byte;
  j: byte;
  fichaJugador: byte;
  fichaRival: byte;
  jugadaAux: trJugada;
  casillaAux: trCasilla;
begin
    fichaJugador:= mJugada.ficha;
    if fichaJugador = FICHA_BLANCA then
       fichaRival:= FICHA_NEGRA;
    else
       fichaRival:= FICHA_BLANCA;
    for i:= 1 to MAX_DIRECCIONES do
        jugadaAux.x:= mJugadaAValidar.x + mDirecciones[i].dirX;
        jugadaAux.y:= mJugadaAValidar.y + mDirecciones[i].dirY;
        if EstaEnTablero(mMatriz[(jugadaAux.x), (jugadaAux.y)]) then
           casillaAux.ficha:= mMatriz[(jugadaAux.x), (jugadaAux.y)].ficha
           if
end;

procedure AgregarJugadaValida(var mJugada: trJugada; var mJugadasValidas: tJugadasValidas);
var
  i: byte;
  guardado: boolean;
begin
  i:= 0;
  guardado:= false;
  while i < MAX_JUGADASVALIDAS and guardado = false do;
    begin
      inc(i);
      with mJugadasValidas[i] do;
      begin
        if x = 0 then
        begin
           x:= mJugada.x;
           y:= mJugada.y;
           guardado:= true;
        end;
      end;
    end;
end;
end.

