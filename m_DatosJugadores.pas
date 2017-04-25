unit m_DatosJugadores;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

implementation

procedure PedirDatosJugadores(var mJugadores: tJugadores)
var
    i: byte;
begin
    for i := 1 to MAX_JUGADORES do
        mJugadores[i].Nombre = PedirNombre(i);
        mJugadores[i].Ficha = PedirFicha(mJugadores[i].Nombre);
        mJugadores[i].Humano = EsHumano(mJugadores[i].Nombre);
        mJugadores[i].Puntos = 0;
end

function PedirNombre(numeroJugador:int): string
var
    nombre: string;
    valido: boolean;
begin
  valido := false;
  repeat
    write('Jugador ', numeroJugador, ', ingrese su nombre: ');
    readln(nombre);
    if nombre = '' then
        writeln('El nombre no puede estar vacío.');
    else
        valido := true;
  until valido;
  PedirNombre := nombre;
end

function PedirFicha(nombreJugador:string): char
var
    dato: string;
    valido: boolean;
begin
  valido := false;
  repeat
    write('Jugador ' + nombreJugador + ', ingrese su ficha: ');
    readln(dato);
    if dato = '' then
        writeln('El nombre no puede estar vacío.');
    else
        begin
          if strlen(dato) > 1 then
              writeln('Ingrese solamente un caracter.');
          else
              valido := true;
        end;
  until valido;
  PedirFicha := dato;
end

function EsHumano(nombreJugador:string): boolean
var
    dato: string;
    humano: boolean;
    valido: boolean;
begin
  valido := false;
  repeat
    write('El jugador ' + nombreJugador + ', ¿es humano? S/N: ');
    readln(dato);
    if ValidarSN(dato) = true then
    begin
        if dato = 'S' then
            humano := true;
        else
            humano := false;
        valido := true;
    end
  until valido;
  EsHumano := humano;
end

end.

