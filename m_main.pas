program Reversi;
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
      JUGADOR_BLANCAS = 1;
      JUGADOR_NEGRAS = 2;
type
  trJugador = record
    nombre: string;
    ficha: char;
    humano: boolean;
    puntos: byte; //en vez contadores sueltos, mejor que quede guardado el puntaje en cada jugador
    jugador: byte; //para diferenciar un jugador de otro con las constantes de arriba
  end
  trCasilla= record
    ficha: byte;
  end
  trJugada= record
    x: byte;
    y: byte;
    jugador: byte; //para ver que jugador hizo la jugada
    valida: boolean
  end
  trDireccion= record
    dirX: byte;
    dirY: byte;
  end

  tJugadores: array[1..MAX_JUGADORES] of trJugador
  tDirecciones: array[1..MAX_DIRECCIONES] of trDireccion
  tMatriz: array [1..FILAS,1..COLUMNAS] of trCasilla
var
  vMatriz: tMatriz;
  vJugadores: tJugadores;
  vDirecciones: tDirecciones;
  jugada: trJugada;
  currentPlayer: byte;//para ver de quien es el turno
  gameOver: boolean;//duh
begin
  //esto de aca abajo esta asi por ahora hasta que determ
  //literalmente copiado del whatsapp, ya entraremos en mas detalles
    InicializarVariables(vDirecciones, jugada);
  repeat
    PedirDatosJugadores(vJugadores);
    clrscr;
    ReiniciarTablero(mMatriz);
    DibujarTablero(mMatriz, vJugadores);
    //empieza el partido
    MostrarTurno(vJugadores[jugada.jugador]);
    if HayJugadaValida(mMatriz, jugada) then
    begin
      repeat
       IngresarJugada(jugada, vJugadores[jugada.jugador]);
       if JugadaValida(jugada, mMatriz, vDirecciones) then
          HacerJugada(jugada, mMatriz, vDirecciones);

       else

      until jugada.valida;
    end
    else
    begin
      if TerminoElPartido(mMatriz, jugada) then //para ver si termino o si tiene que pasar nomas
         gameOver := true;
      else
          println('Jugador ' + mJugador.Nombre + ', no tiene movimientos posibles, deberá pasar su turno.');
    end

    DibujarTablero(mMatriz, vJugadores)
    CalcularYMostrarPuntos(mMatriz, vJugadores);
    PasarTurno(jugada);
    JuegoTerminado();
  until gameOver;
end;

procedure inicializarVariables(var mDirecciones: tDirecciones; var mCurrentPlayer: byte);
//agregar a medida que haga falta inicializar mas cosas
begin
    inicializarDirecciones(tDirecciones);
    jugada.jugador := JUGADOR_BLANCAS;
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
end

procedure mostrarTurno (var mJugador: trJugador);
begin
     println('Jugador ' + mJugador.Nombre + ', es su turno.');
end;
