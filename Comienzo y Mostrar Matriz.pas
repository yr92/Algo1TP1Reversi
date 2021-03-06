program Reversi__;
uses crt; //Librería necesaria para limpiar pantalla
const COLUMNAS = 8;
      FILAS = 8;
      FICHA_VACIA = 0;
      FICHA_BLANCA = 1;
      FICHA_NEGRA = 2;
      MAX_DIRECCIONES = 8;
      DIR_ARRIBA = 1;
      DIR_DERECHA_ARRIBA = 2;
      DIR_DERECHA = 3;
      DIR_DERECHA_ABAJO = 4;
      DIR_ABAJO = 5;
      DIR_IZQUIERDA_ABAJO = 6;
      DIR_IZQUIERDA = 7;
      DIR_IZQUIERDA_ARRIBA = 8;
      ARRIBA = -1;
      ABAJO = 1;
      IZQUIERDA = -1;
      DERECHA = 1;
      NEUTRO = 0;
type
  trJugador: record
    nombre: char(20);
    letra: char(1);
    humano: boolean;
    puntos: byte; //en vez contadores sueltos, mejor que quede guardado el puntaje en cada jugador
    blancas: boolean; //para diferenciar un jugador de otro
  end
  trCasilla: record
    ficha: byte;
  end
  trJugada: record
    x: byte;
    y: byte;
    blancas: boolean; //para ver que jugador hizo la jugada
    valida: boolean
  end
  trDireccion: record
    dirX: byte;
    dirY: byte;
  end

  tDirecciones: array[1..MAX_DIRECCIONES] of trDireccion
  tMatriz: array [1..FILAS,1..COLUMNAS] of trCasilla
var
  vMatriz: tMatriz;
  jugadorBlanco: trJugador;
  jugadorNegro: trJugador;
  jueganBlancas: boolean;//para ver de quien es el turno
  gameOver: boolean;//duh
begin
  //esto de aca abajo esta asi por ahora hasta que determ
  //literalmente copiado del whatsapp, ya entraremos en mas detalles
  repeat  
    InicializarVariables();
    PedirNombreYFichas();
    CrearTablero();
    clrscr; //Limpiar pantalla 
    DibujarTablero();
    ReiniciarTablero();
    //empieza el partido
    if HayJugadaValida() then
       IndicarJugada();
       CasilleroEsValido();
       HacerJugada();
    end
    CalcularYMostrarPuntos();
    PasarTurno();
    JuegoTerminado();
  until gameOver;
end

procedure inicializarDirecciones(var mDirecciones: tDirecciones);
begin
      mDirecciones[DIR_ARRIBA].dirX=NEUTRO;
      mDirecciones[DIR_DERECHA_ARRIBA].dirX=ARRIBA;
      mDirecciones[DIR_DERECHA].dirX=NEUTRO;
      mDirecciones[DIR_DERECHA_ABAJO].dirX=DERECHA;
      mDirecciones[DIR_ABAJO].dirX=NEUTRO;
      mDirecciones[DIR_IZQUIERDA_ABAJO].dirX=IZQUIERDA;
      mDirecciones[DIR_IZQUIERDA].dirX=IZQUIERDA;
      mDirecciones[DIR_IZQUIERDA_ARRIBA].dirX=IZQUIERDA;
      mDirecciones[DIR_ARRIBA].dirY=ARRIBA;
      mDirecciones[DIR_DERECHA_ARRIBA].dirY=ARRIBA;
      mDirecciones[DIR_DERECHA].dirY=NEUTRO;
      mDirecciones[DIR_DERECHA_ABAJO].dirY=ABAJO;
      mDirecciones[DIR_ABAJO].dirY=ABAJO;
      mDirecciones[DIR_IZQUIERDA_ABAJO].dirY=ABAJO;
      mDirecciones[DIR_IZQUIERDA].dirY=NEUTRO;
      mDirecciones[DIR_IZQUIERDA_ARRIBA].dirY=ARRIBA;
end

procedure mostrarMatriz (var matriz: tMatriz);
        var i,j: integer;
        begin
              for i:=1 to FILAS do
              begin
                   for j:=1 to COLUMNAS do
                        write(matriz [i,j],' ');

              end;
        end;
