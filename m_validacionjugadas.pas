unit m_ValidacionJugadas;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

implementation

procedure ListarJugadasValidas(var mMatriz: tMatriz; var mJugadaTurnoActual: trJugada; var mJugadores: tJugadores; var mDirecciones: tDirecciones; var mJugadasValidas: tJugadasValidas);
var
  i: byte;
  j: byte;
  jugadaAValidar: trJugada;
begin
    if HayCasillasVacias(mMatriz) = true then
    begin
      if HayFichasAmbosColores(mMatriz) = true then
      begin
         for i:= 1 to MAX_FILASCOLUMNAS do
          for j:= 1 to MAX_FILASCOLUMNAS do
            jugadaAValidar.x := i;
            jugadaAValidar.y := j;
            if CasilleroEstaVacio(jugadaAValidar, mMatriz) true then
            begin
               //jugadaAValidar no tiene ficha! solo coordenadas!!
               if ChequearJugadaValida(mMatriz, mDirecciones, mJugadaTurnoActual, jugadaAValidar) = true then
                   AgregarJugadaValida(jugadaAValidar, mJugadasValidas);
            end;
      end;
    end;
end;

function ChequearJugadaValida(var mMatriz: tMatriz; var mDirecciones: tDirecciones; var mJugadaTurnoActual, mJugadaAValidar: trJugada): Boolean;
var
  i: byte;
  j: byte;
  k: byte;
  fichaJugador: byte;
  fichaRival: byte;
  jugadaAux: trJugada;
  sigoRecorriendo: boolean;
  esValida: boolean;
  contadorPuntosASumar: byte;
begin
    esValida:= false;
    fichaJugador:= mJugadaTurnoActual.ficha;
    if fichaJugador = FICHA_BLANCA then
      fichaRival = FICHA_NEGRA;
    else
      fichaRival = FICHA_BLANCA;
    for i= 1 to MAX_DIRECCIONES do
        contadorPuntosASumar:= 0;
        jugadaAux.x:= mJugadaAValidar.x + mDirecciones[i].dirX;
        jugadaAux.y:= mJugadaAValidar.y + mDirecciones[i].dirY;
        sigoRecorriendo:= true;
        if jugadaEstaEnTablero(jugadaAux) = true then
        begin
           if EstaVacioCasillero(jugadaAux) = false then
           begin
             if CasilleroHayFicha(jugadaAux, fichaRival, mMatriz) = true then
               begin
                  //encontre una ficha rival, empiezo a recorrer en la direccion
                  jugadaAux.x:= jugadaAux.x + mDirecciones[i].dirX;
                  jugadaAux.y:= jugadaAux.y + mDirecciones[i].dirY;
                  while jugadaEstaEnTablero(jugadaAux) = true and EstaVacioCasillero(jugadaAux) = false and sigoRecorriendo = true do
                  begin
                      inc(contadorPuntosASumar);
                      if CasilleroHayFicha(jugadaAux, fichaJugador, mMatriz) = true then
                      begin
                         sigoRecorriendo:= false;
                         esValida:= true;
                         mjugadaAValidar.puntosASumar:= mjugadaAValidar.puntosASumar + contadorPuntosASumar;
                      end;
                      else //hay otra ficha rival
                      begin
                        jugadaAux.x:= jugadaAux.x + mDirecciones[i].dirX;
                        jugadaAux.y:= jugadaAux.y + mDirecciones[i].dirY;
                      end;
                  end;
               end;
           end;
        end;
    ChequearJugadaValida:= esValida;
end;

function CasilleroHayFicha(var mJugadaAValidar: trJugada; fichaAEncontrar: byte; var mMatriz: tvMatriz): boolean;
//en mJugadaAValidar van las coords de donde queremos ir y el tipo de ficha que queremos encontrar!
var
  resultado: boolean;
begin
     if EstaVacioCasillero(mJugadaAValidar) = false then
     begin
        if mMatriz[(mJugadaAValidar.x), (mJugadaAValidar.y)].ficha = fichaAEncontrar then
           resultado:= true;
        else
           resultado:= false;
    CasilleroHayFichaRival:= resultado;
end;

function HayCasillasVacias(var mMatriz: tMatriz):boolean;
var
  i: byte;
  j: byte;
  resultado: boolean;
begin
  resultado:= false;
  i:= 1;
  j:= 1;
  while i< MAX_FILASCOLUMNAS or resultado = false do
  begin
    while j< MAX_FILASCOLUMNAS or resultado = false do
    begin
        if mMatriz[i,j].ficha <> FICHA_VACIA then
           resultado:= true;
    end;
  end;
  HayCasillasVacias:= resultado;
end;

function HayFichasAmbosColores(var mMatriz: tMatriz):boolean;
var
  i: byte;
  j: byte;
  hayBlancas: boolean;
  hayNegras: boolean;
  resultado: boolean;
begin
  resultado:= false;
  i:= 1;
  j:= 1;
  while i< MAX_FILASCOLUMNAS or resultado:= true do
  begin
    while j< MAX_FILASCOLUMNAS or resultado:= true do
    begin
        if mMatriz[i,j].ficha <> FICHA_VACIA then
           if mMatriz[i,j].ficha = FICHA_BLANCA then
              hayBlancas:= true;
           else
              hayNegras:= true;
           if (hayBlancas = true and hayNegras = true) then
              resultado:= true;
    end;
  end;
  HayFichasAmbosColores:= resultado;
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
           puntosASumar:= mJugada.puntosASumar;
           guardado:= true;
        end;
      end;
    end;
end;

function HayJugadasValidas(var mJugadasValidas: tJugadasValidas):boolean;
//si encuentra el primer reg del vector vacio, asume que todo lo demas tmb esta, ergo no hay jugadas validas
var
  resultado: boolean;
begin
  if  mJugadasValidas[i].x = 0 then
      resultado:= false;
  else
      resultado:= true;
end;

function jugadaEstaEnTablero(var mJugada: trJugada): boolean;
var
  resultado: boolean;
begin
  if mJugada.x <= MAX_FILASCOLUMNAS and mJugada.x >= MIN_FILASCOLUMNAS then
  begin
     if mJugada.y <= MAX_FILASCOLUMNAS and mJugada.y >= MIN_FILASCOLUMNAS then
           resultado:= true
       else
           resultado:= false;
  else
      estaAdentro:= false;
  end;
  jugadaEstaEnTablero:= resultado;
end;

function CasilleroEstaVacio(var mJugada: trJugada; var mMatriz: tvMatriz): boolean;
var
   vacio: boolean;
begin
  if mMatriz[mJugada.x, mJugada.y].ficha = FICHA_VACIA then
    vacio:= true
  else
    vacio:= false;
  CasilleroEstaVacio:= vacio;
end;



end.

