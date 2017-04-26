program Reversi;
uses Crt;
const COLUMNAS = 8;
      FILAS = 8;

      FICHA_VACIA = 0;
      FICHA_BLANCA = 1;
      FICHA_NEGRA = 2;

      LIN_HORIZONTAL = '+---+---+---+---+---+---+---+---+';
      LIN_VERTICAL = '|';
      TABLERO_HEADER = '    1   2   3   4   5   6   7   8';

      MAX_FILASCOLUMNAS = 8;
      MIN_FILASCOLUMNAS = 1;

      MAX_DIRECCIONES = 8;
      DIR_IZQUIERDA_ARRIBA = 1;
      DIR_ARRIBA = 2;
      DIR_DERECHA_ARRIBA = 3;
      DIR_IZQUIERDA = 4;
      DIR_DERECHA = 5;
      DIR_IZQUIERDA_ABAJO = 6;
      DIR_ABAJO = 7;
      DIR_DERECHA_ABAJO = 8;
      ARRIBA = -1;
      ABAJO = 1;
      IZQUIERDA = -1;
      DERECHA = 1;
      NEUTRO = 0;

      MAX_JUGADORES = 2;
      MAX_JUGADASVALIDAS = 32;

      STR_FILA = 'fila';
      STR_COLUMNA = 'columna';
type
  trJugador = record
    nombre: string;
    ficha: char;
    humano: boolean;
    puntos: byte; //en vez contadores sueltos, mejor que quede guardado el puntaje en cada jugador
  end;
  trCasilla= record
    ficha: byte;
  end;
  trJugada= record
    x: byte;
    y: byte;
    jugador: byte; //para ver que jugador hizo la jugada
    valida: boolean;
    mensajeError: string;
  end;
  trDireccion= record
    dirX: byte;
    dirY: byte;
  end;

  tJugadasValidas = array[1..MAX_JUGADASVALIDAS] of trJugada;
  tJugadores = array[1..MAX_JUGADORES] of trJugador;
  tDirecciones = array[1..MAX_DIRECCIONES] of trDireccion;
  tMatriz = array [1..FILAS,1..COLUMNAS] of trCasilla;
var
  vMatriz: tMatriz;
  vJugadores: tJugadores;
  vDirecciones: tDirecciones;
  vJugadasValidas: tJugadasValidas;
  jugada: trJugada;
  currentPlayer: byte;//para ver de quien es el turno
  gameOver: boolean;//duh
  otraPartida: boolean;
begin
      InicializarVariables(vDirecciones, vJugadasValidas, jugada);
    repeat  //repeat 1, solamente de cuando se arranca un partido nuevo
      PedirDatosJugadores(vJugadores);
      ReiniciarTablero(mMatriz);
      RefrescarPantalla(mMatriz, vJugadores);
      //empieza el partido
      repeat //repeat 2, de toda la partida
        MostrarTurno(vJugadores, jugada);
        ListarJugadasValidas(mMatriz, jugada, vJugadores, vDirecciones, vJugadasValidas)
        if HayJugadaValida(mMatriz, jugada) then
          begin
            //el hayjugadavalida y el resto del algoritmo hay que cambiarlo dps para cuando hagamos al gloton,
            //primero listamos todas las posiciones en un vector, y dps mas facil para validar es ver si la pos ingresada esta ahi.

            repeat
             IngresarYValidarJugada(jugada, vJugadores, mMatriz, vDirecciones);
             if jugada.valida = true then
                HacerJugada(jugada, mMatriz, vDirecciones);
             else
                RefrescarPantalla(mMatriz, vJugadores);
                MostrarErrorJugada(jugada);
            until jugada.valida;
          end
        else
          begin
            if TerminoElPartido(mMatriz, jugada) then //para ver si termino o si tiene que pasar nomas
               gameOver := true;
            else
                println('Jugador ' + mJugador.Nombre + ', no tiene movimientos posibles, deberá pasar su turno.');
        end;
        RefrescarPantalla(mMatriz, vJugadores);
        DibujarTablero(mMatriz, vJugadores)
        CalcularYMostrarPuntos(mMatriz, vJugadores);
        PasarTurno(jugada);
        JuegoTerminado();
      until gameOver; //fin repeat de todo el partido

      MostrarResultadoFinal(vJugadores, mMatriz);
      MostrarGanador(vJugadores);
      //otra partida? s/n - se la banca suelta como funcion o hay que declarar var y demas?
    until otraPartida() = false;  //fin repeat 1,
end;

procedure inicializarVariables(var mDirecciones: tDirecciones; var mJugadasValidas: tJugadasValidas; var mJugada: trJugada);
//agregar a medida que haga falta inicializar mas cosas
begin
    inicializarDirecciones(mDirecciones);
    inicializarJugadasValidas(mJugadasValidas);
    mJugada.jugador := FICHA_BLANCA;
end;

procedure inicializarDirecciones(var mDirecciones: tDirecciones);
//esto tendria que estar en inicializarvariables()
begin
    mDirecciones[DIR_IZQUIERDA_ARRIBA].dirX:=IZQUIERDA;
    mDirecciones[DIR_ARRIBA].dirX:=NEUTRO;
    mDirecciones[DIR_DERECHA_ARRIBA].dirX:=DERECHA;
    mDirecciones[DIR_IZQUIERDA].dirX:=IZQUIERDA;
    mDirecciones[DIR_DERECHA].dirX:=DERECHA;
    mDirecciones[DIR_IZQUIERDA_ABAJO].dirX:=IZQUIERDA;
    mDirecciones[DIR_ABAJO].dirX:=NEUTRO;
    mDirecciones[DIR_DERECHA_ABAJO].dirX:=DERECHA;

    mDirecciones[DIR_IZQUIERDA_ARRIBA].dirY:=ARRIBA;
    mDirecciones[DIR_ARRIBA].dirY:=ARRIBA;
    mDirecciones[DIR_DERECHA_ARRIBA].dirY:=ARRIBA;
    mDirecciones[DIR_IZQUIERDA].dirY:=NEUTRO;
    mDirecciones[DIR_DERECHA].dirY:=NEUTRO;
    mDirecciones[DIR_IZQUIERDA_ABAJO].dirY:=ABAJO;
    mDirecciones[DIR_ABAJO].dirY:=ABAJO;
    mDirecciones[DIR_DERECHA_ABAJO].dirY:=ABAJO;
end;

procedure mostrarTurno (var mJugadores: tJugadores; var mJugada: trJugada);
begin
     println('Jugador ' + mJugadores[mJugada.jugador].Nombre + ', es su turno.');
end;

function otraPartida(): boolean;
var
  dato: string;
  valido: boolean;
  resultado: boolean;
begin
     valido := false;
     repeat
           print('Juego terminado - ¿Otra partida? S/N: ');
           read(dato);
           if ValidarSN(dato) = true then
              valido := true;
     until valido = true;
     if dato = 'S' then
        resultado := true;
     else
         resultado := false;
     otraPartida := resultado;
end;

function ValidarSN(mDato: string): boolean;
var
  valido: boolean;
  resultado: boolean;
begin
     resultado := ((mDato = 'S') or (mDato = 'N'))
end;

procedure RefrescarPantalla(var mMatriz: tMatriz; var mJugadores: tJugadores);
begin
    ClrScr;
    DibujarTablero(mMatriz, vJugadores);
end;

procedure InicializarJugadasValidas(var mJugadasValidas: tJugadasValidas);
var
  i: byte;
begin
    for i:= 1 to MAX_JUGADASVALIDAS do
        with mJugadasValidas[i] do
        begin
          x:= 0;
          y:= 0;
          jugador:= FICHA_VACIA; //para ver que jugador hizo la jugada
          valida:= false;
        end;
end;

procedure LimpiarJugadasValidas(var mJugadasValidas: tJugadasValidas);
var
  i: byte;
begin
    i:= 0
    while i < MAX_JUGADASVALIDAS and mJugadasValidas[i].valida = true do
        with mJugadasValidas[i] do
        begin
          x:= 0;
          y:= 0;
          jugador:= FICHA_VACIA;
          valida:= false;
        end;
        inc(i);
    end;
end;
