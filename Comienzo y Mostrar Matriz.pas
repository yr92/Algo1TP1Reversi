program Reversi
const COLUMNAS = 8;
      FILAS = 8;
      FICHA_VACIA = 0;
      FICHA_BLANCA = 1;
      FICHA_NEGRA = 2;
type
  trJugador: record
    nombre: string[20];
    letra: char;
    humano: boolean;
    puntos: byte; //en vez contadores sueltos, mejor que quede guardado el puntaje en cada jugador
  end
  trCasilla: record
    ficha: byte;
  end
  tMatriz: array [1..FILAS,1..COLUMNAS] of trCasilla
var
  vMatriz: tMatriz;
  jugadorBlanco: trJugador;
  jugadorNegro: trJugador;
  jueganBlancas: boolean;//para ver de quien es el turno
begin
  //esto de aca abajo esta asi por ahora hasta que determ
  //literalmente copiado del whatsapp, ya entraremos en mas detalles
  InicializarVariables();
  PedirNombreYFichas();
  CrearTablero();
  DibujarTablero();
  ReiniciarTablero();
  HayJugadaValida();//esta deberia ser funcion, por ahora la anoto asi
  IndicarJugada();
  HacerJugada();
  PasarTurno();
  MostrarPuntos();
  CasilleroEsValido();
  JuegoTerminado();
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


