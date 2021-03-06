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
        mMatriz[i,j].ficha := FICHA_VACIA;
        mMatriz[i,j].jugadaValida := false;
end;

function estaEnTablero(jugadaX, jugadaY: byte): boolean;
//Para meter adentro del procedimiento de "EsJugadaValida"
var
  estaAdentro: boolean;
begin
  if ((jugadaX <= MAX_FILASCOLUMNAS) and (jugadaX >= MIN_FILASCOLUMNAS) and (jugadaY <= MAX_FILASCOLUMNAS) and (jugadaY >= MIN_FILASCOLUMNAS)) then
       estaAdentro:= true
   else
       estaAdentro:= false;
  estaEnTablero:= estaAdentro;
end;

function EstaVacio(mMatriz: tvMatriz; x,y: byte): boolean;
var
   vacio: boolean;
begin
    if ((mMatriz[x,y] = FICHA_BLANCA) or (mMatriz[x,y] = FICHA_NEGRA)) then
      vacio:= false
    else
      vacio:= true;
    EstaVacio:= vacio;
end; 

procedure InicializarMatriz(var mMatriz: tMatriz);
begin
    mMatriz[4,4].ficha := FICHA_BLANCA;
    mMatriz[5,5].ficha := FICHA_BLANCA;
    mMatriz[4,5].ficha := FICHA_NEGRA;
    mMatriz[5,4].ficha := FICHA_NEGRA;
end;

procedure ReiniciarMatriz(var mMatriz: tMatriz);
begin
  LimpiarMatriz(mMatriz);
  InicializarMatriz(mMatriz);
end;

procedure HacerJugada(var mMatriz: tMatriz; var mJugada: trJugada; var mJugador: trJugador);
var
  x:byte;
  y:byte;
begin
  IngresarJugada(mJugada, mJugador);
  while (not estaEnTablero(x,y)) do  //Hay que validar completamente, esto solo se fija que este en tablero
    begin
    writeln('Ingrese una jugada valida.'); writeln;
    write('Ingrese la fila de su jugada: ');
    readln(x);
    write('Ingrese la columna de su jugada: ');
    read(y);
    end;
  mMatriz[x,y]:= 1;
  //Aca deberia ser con el jugador que le corresponda y bla bla
end;
//

procedure IngresarYValidarJugada(var mJugada: trJugada; var mJugadores: tJugadores; var mJugadasValidas: tJugadasValidas);
begin
    IngresarJugada(mJugada, mJugadores);
    if JugadaEstaEnCursorValidas(mJugada, mJugadasValidas) = true then
       mJugada.valida:= true;
    else
       mJugada.valida:= false;
end;


function JugadaEstaEnCursorValidas(var mJugada: trJugada; var mJugadasValidas: tJugadasValidas): boolean;
var
  i: byte;
  resultado: boolean;
begin
  i:= 1;
  resultado:= false;
  while (i < MAX_JUGADASVALIDAS and mJugadasValidas[i].x> 0) and resultado = true do
  begin
      if (mJugadasValidas[i].x = mJugada.x) and (mJugadasValidas[i].y = mJugada.y) then
        resultado:= true;
      inc(i);
  end;
  JugadaEstaEnCursorValidas:= resultado;
end;

procedure MostrarErrorJugada(var mJugada: trJugada);
begin
    println('La jugada no es válida. ' + jugada.mensajeError);
end;

procedure IngresarJugada(var mJugada: trJugada; var mJugadores: tJugadores);
begin
    IngresarCoordenada(mJugada, mJugadores, STR_FILA);
    IngresarCoordenada(mJugada, mJugadores, STR_COLUMNA);
end;

procedure IngresarCoordenada(var mJugada: trJugada; var mJugadores: tJugadores; filaOcolumna: string);
var
    dato: string;
    valido: boolean;
begin
    repeat
      write('Jugador ' + mJugadores[trJugada].nombre + ', ingrese la ' + filaOcolumna + ' de su jugada: ');
      readln(dato);
      if validarTexto(dato) = false then
         writeln('Dato inválido. El valor ingresado debe ser un único número entre 1 y 8.');
      else
         valido := true;
     until valido;
     if filaOcolumna = STR_FILA then
          mJugada.X := strtoint(dato);
     else
          mJugada.Y := strtoint(dato);
end;

function validarTexto(mDato: string): boolean;
var
    valido: boolean;
begin
     if strlen(mDato) <> 1 or not isnumber (mDato) then
        valido := false;
     else
         valido := true;
     validarTexto := valido;
end;

procedure Puntuacion(var mMatriz: tMatriz);
var
  i,j: byte;
  puntuacionBlancas,puntuacionNegras: byte;
begin
  puntuacionBlancas:= 0;
  puntuacionNegras:= 0;
  for i:= MIN_FILASCOLUMNAS to MAX_FILASCOLUMNAS do
    for j:= MIN_FILASCOLUMNAS to MAX_FILASCOLUMNAS do
      begin
      if (mMatriz[i,j] = 1) then
       inc(puntuacionBlancas);
      if (mMatriz[i,j] = 2) then
       inc(puntuacionNegras);
      end;
  write('       Blancas: ', puntuacionBlancas, ' - Negras: ', puntuacionNegras);
end;

procedure DibujarTablero (var mMatriz: tMatriz; var mJugadores: tJugadores);
var
  i,j : byte;
begin
  writeln(TABLERO_HEADER);
  writeln('  ', LIN_HORIZONTAL);
  for i:=1 to MAX_FILASCOLUMNAS do
  begin
    write(i);
    for j:=1 to MAX_FILASCOLUMNAS do
    begin
      write(' ',LIN_VERTICAL,' ');
      if (mMatriz[i,j].ficha <> FICHA_VACIA) then
       write(mJugadores[mMatriz[i,j].ficha].ficha)
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
  cont: byte;
  mMatriz : tMatriz;

begin
  cont:=0; //parte de la condicion temporal del ciclo
  ReiniciarMatriz(mMatriz);
  repeat
    DibujarTablero(mMatriz);
    Puntuacion(mMatriz);
    writeln; writeln;
    HacerJugada(mMatriz);
    writeln; writeln; writeln;
    inc(cont);
  until (cont > 42); //Condicion temporal para que cicle

  readln;
end.
      
