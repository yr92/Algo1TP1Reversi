program principal;

uses
  Crt;

const
  COLUMNAS = 8;
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
    puntos: byte;
    //en vez contadores sueltos, mejor que quede guardado el puntaje en cada jugador
  end;

  trCasilla = record
    ficha: byte;
  end;
  tDireccionesValidas = array[1..MAX_DIRECCIONES] of byte;

  trJugada = record
    x: byte;
    y: byte;
    jugador: byte; //para ver que jugador hizo la jugada
    valida: boolean;
    mensajeError: string;
    puntosASumar: byte;
    direccionesValidas: tDireccionesValidas;
  end;

  trDireccion = record
    dirX: shortint;
    dirY: shortint;
  end;

  tJugadasValidas = array[1..MAX_JUGADASVALIDAS] of trJugada;
  tJugadores = array[1..MAX_JUGADORES] of trJugador;
  tDirecciones = array[1..MAX_DIRECCIONES] of trDireccion;
  tMatriz = array [1..FILAS, 1..COLUMNAS] of trCasilla;

  procedure inicializarDirecciones(var mDirecciones: tDirecciones);
  //esto tendria que estar en inicializarvariables()
  begin
    mDirecciones[DIR_IZQUIERDA_ARRIBA].dirX := IZQUIERDA;
    mDirecciones[DIR_ARRIBA].dirX := NEUTRO;
    mDirecciones[DIR_DERECHA_ARRIBA].dirX := DERECHA;
    mDirecciones[DIR_IZQUIERDA].dirX := IZQUIERDA;
    mDirecciones[DIR_DERECHA].dirX := DERECHA;
    mDirecciones[DIR_IZQUIERDA_ABAJO].dirX := IZQUIERDA;
    mDirecciones[DIR_ABAJO].dirX := NEUTRO;
    mDirecciones[DIR_DERECHA_ABAJO].dirX := DERECHA;

    mDirecciones[DIR_IZQUIERDA_ARRIBA].dirY := ARRIBA;
    mDirecciones[DIR_ARRIBA].dirY := ARRIBA;
    mDirecciones[DIR_DERECHA_ARRIBA].dirY := ARRIBA;
    mDirecciones[DIR_IZQUIERDA].dirY := NEUTRO;
    mDirecciones[DIR_DERECHA].dirY := NEUTRO;
    mDirecciones[DIR_IZQUIERDA_ABAJO].dirY := ABAJO;
    mDirecciones[DIR_ABAJO].dirY := ABAJO;
    mDirecciones[DIR_DERECHA_ABAJO].dirY := ABAJO;
  end;

  procedure InicializarJugadasValidas(var mJugadasValidas: tJugadasValidas);
  var
    i: byte;
    j: byte;
  begin
    for i := 1 to MAX_JUGADASVALIDAS do
      with mJugadasValidas[i] do
      begin
        x := 0;
        y := 0;
        jugador := FICHA_VACIA; //para ver que jugador hizo la jugada
        valida := False;
        puntosASumar := 0;
        for j := 1 to MAX_DIRECCIONES do
          direccionesValidas[j] := 0;
      end;
  end;

  procedure inicializarVariables(var mDirecciones: tDirecciones;
  var mJugadasValidas: tJugadasValidas; var mJugada: trJugada);
  //agregar a medida que haga falta inicializar mas cosas
  begin
    inicializarDirecciones(mDirecciones);
    inicializarJugadasValidas(mJugadasValidas);
    mJugada.jugador := FICHA_BLANCA;
  end;

function ValidarSN(mDato: string): boolean;
  begin
    ValidarSN := ((mDato = 'S') or (mDato = 'N') or (mDato = 's') or (mDato = 'n'));
  end;

function PedirNombre(numeroJugador: byte): string;
var
    nombre: string;
    valido: boolean;
begin
  valido := false;
  repeat
    write('Jugador ', numeroJugador, ', ingrese su nombre: ');
    readln(nombre);
    if nombre = '' then
        writeln('El nombre no puede estar vacío.')
    else
        valido := true;
  until valido;
  PedirNombre := nombre;
end;

function PedirFicha(nombreJugador:string): char;
var
    dato: string;
    valido: boolean;
begin
  valido := false;
  repeat
    write('Jugador ' + nombreJugador + ', ingrese su ficha: ');
    readln(dato);
    if dato = '' then
        writeln('El nombre no puede estar vacío.')
    else
        begin
          if length(dato) > 1 then
              writeln('Ingrese solamente un caracter.')
          else
              valido := true;
        end;
  until valido;
  PedirFicha := dato[1];
end;

function EsHumano(nombreJugador:string): boolean;
var
    dato: string;
    humano: boolean;
    valido: boolean;
begin
  valido := false;
  repeat
    write('El jugador ' + nombreJugador + ', es humano? S/N: ');
    readln(dato);
    if ValidarSN(dato) then
    begin
        if (dato = 'S') or (dato = 's') then
            humano := true
        else
            humano := false;
        valido := true;
    end
  until valido;
  EsHumano := humano;
end;

procedure PedirDatosJugadores(var mJugadores: tJugadores);
var
    i: byte;
begin
    for i := 1 to MAX_JUGADORES do
      begin
        mJugadores[i].nombre := PedirNombre(i);
        mJugadores[i].ficha := PedirFicha(mJugadores[i].nombre);
        mJugadores[i].humano := EsHumano(mJugadores[i].nombre);
        mJugadores[i].puntos := 0;
      end;
end;

procedure LimpiarMatriz(var mMatriz:tMatriz);
var
  i,j: byte;
begin
  for i:= 1 to FILAS do
    for j:=1 to COLUMNAS do
        mMatriz[i,j].ficha := FICHA_VACIA;
end;

procedure InicializarMatriz(var mMatriz: tMatriz);
begin
    mMatriz[4,4].ficha := FICHA_BLANCA;
    mMatriz[5,5].ficha := FICHA_BLANCA;
    mMatriz[4,5].ficha := FICHA_NEGRA;
    mMatriz[5,4].ficha := FICHA_NEGRA;
end;

procedure ReiniciarTablero(var mMatriz: tMatriz);
begin
  LimpiarMatriz(mMatriz);
  InicializarMatriz(mMatriz);
end;

procedure DibujarTablero(var mMatriz: tMatriz; var mJugadores: tJugadores);
  var
    i, j: byte;
  begin
    writeln(TABLERO_HEADER);
    writeln('  ', LIN_HORIZONTAL);
    for i := 1 to MAX_FILASCOLUMNAS do
    begin
      Write(i);
      for j := 1 to MAX_FILASCOLUMNAS do
      begin
        Write(' ', LIN_VERTICAL, ' ');
        if (mMatriz[i, j].ficha <> FICHA_VACIA) then
          Write(mJugadores[mMatriz[i, j].ficha].ficha)
        else
          Write(' ');
      end;
      Write(' ', LIN_VERTICAL);
      writeln;
      Write('  ', LIN_HORIZONTAL);
      writeln;
    end;
  end;

  function CasilleroEstaVacio(var mJugada: trJugada; var mMatriz: tMatriz): boolean;
  var
    vacio: boolean;
  begin
    if mMatriz[mJugada.x, mJugada.y].ficha = FICHA_VACIA then
      vacio := True
    else
      vacio := False;
    CasilleroEstaVacio := vacio;
  end;

  function CasilleroHayFicha(var mJugadaAValidar: trJugada;
    fichaAEncontrar: byte; var mMatriz: tMatriz): boolean;
    //en mJugadaAValidar van las coords de donde queremos ir y el tipo de ficha que queremos encontrar!
  var
    resultado: boolean;
  begin
    if CasilleroEstaVacio(mJugadaAValidar, mMatriz) = False then
    begin
      if (mMatriz[mJugadaAValidar.x, mJugadaAValidar.y].ficha = fichaAEncontrar) then
        resultado := True
      else
        resultado := False;
      //CasilleroHayFichaRival:= resultado;
      CasilleroHayFicha := resultado;
    end;
  end;

  procedure voltearFichas(var mJugada: trJugada; var mMatriz: tMatriz;
  var mDirecciones: tDirecciones; mDireccion: byte);
  var
    jugadaAux: trJugada;
    sigoRecorriendo: boolean;
  begin
    jugadaAux.x := jugadaAux.x +
      mDirecciones[mJugada.direccionesValidas[mDireccion]].dirX;
    jugadaAux.y := jugadaAux.y +
      mDirecciones[mJugada.direccionesValidas[mDireccion]].dirY;
    sigoRecorriendo := True;
    while sigoRecorriendo = True do
    begin
      if CasilleroHayFicha(jugadaAux, mJugada.jugador, mMatriz) = True then
        sigoRecorriendo := False
      else //hay otra ficha rival
      begin
        mMatriz[jugadaAux.x, jugadaAux.y].ficha := mJugada.jugador;
        jugadaAux.x := jugadaAux.x +
          mDirecciones[mJugada.direccionesValidas[mDireccion]].dirX;
        jugadaAux.y := jugadaAux.y +
          mDirecciones[mJugada.direccionesValidas[mDireccion]].dirY;
      end;
    end;
  end;

  procedure HacerJugada(var mJugada: trJugada; var mMatriz: tMatriz;
  var mDirecciones: tDirecciones);
  var
    i: byte;
    sigoRecorriendo: boolean;
    //direccionValida: boolean;
    //contadorPuntosASumar: byte;
  begin
    i := 0;
    sigoRecorriendo := True;
    while ((i < MAX_DIRECCIONES) and sigoRecorriendo = True) do
    begin
      Inc(i);
      if mJugada.direccionesValidas[i] > 0 then
        voltearFichas(mJugada, mMatriz, mDirecciones, i)
      else
        sigoRecorriendo := False;
    end;
  end;

  function JugadaEstaEnCursorValidas(var mJugada: trJugada;
  var mJugadasValidas: tJugadasValidas): boolean;
  var
    i: byte;
    resultado: boolean;
  begin
    i := 1;
    resultado := False;
    while ((i < MAX_JUGADASVALIDAS) and (mJugadasValidas[i].x > 0) and resultado = true) do
    begin
      if (mJugadasValidas[i].x = mJugada.x) and (mJugadasValidas[i].y = mJugada.y) then
        resultado := True;
      Inc(i);
    end;
    JugadaEstaEnCursorValidas := resultado;
  end;

  function validarTexto(mDato: string): boolean;
  var
    valido: boolean;
  begin
    if length(mDato) <> 1 then
      valido := False
    else
      valido := True;
    validarTexto := valido;
  end;

  procedure IngresarCoordenada(var mJugada: trJugada; var mJugadores: tJugadores;
    filaOcolumna: string);
  var
    dato: string;
    valido: boolean;
    code: integer;
  begin
    repeat
      write('Jugador ' , mJugadores[mJugada.jugador].nombre , ', ingrese la ' ,
        filaOcolumna , ' de su jugada: ');
      readln(dato);
      if validarTexto(dato) = False then
        writeln('Dato inválido. El valor ingresado debe ser un único número entre 1 y 8.')
      else
        valido := True;
    until valido;
    if filaOcolumna = STR_FILA then
      val(dato,mJugada.X,code)
    else
      val(dato,mJugada.Y,code)
  end;

  procedure MostrarErrorJugada(var mJugada: trJugada);
  begin
    writeln('La jugada no es válida. ' , mJugada.mensajeError);
  end;

  procedure IngresarJugada(var mJugada: trJugada; var mJugadores: tJugadores);
  begin
    IngresarCoordenada(mJugada, mJugadores, STR_FILA);
    IngresarCoordenada(mJugada, mJugadores, STR_COLUMNA);
  end;

  function HayCasillasVacias(var mMatriz: tMatriz): boolean;
  var
    i: byte;
    j: byte;
    resultado: boolean;
  begin
    resultado := False;
    i := 1;
    j := 1;
    //writeln('casillas vacias, hay o no hay?');
    while (i < MAX_FILASCOLUMNAS) and resultado = False do
    begin
      while (j < MAX_FILASCOLUMNAS) and resultado = False do
      begin
        //writeln('probando probando');
        if mMatriz[i, j].ficha <> FICHA_VACIA then
          resultado := True;
        inc(j);
      end;
      inc(i);
    end;
    HayCasillasVacias := resultado;
  end;

  function HayFichasAmbosColores(var mMatriz: tMatriz): boolean;
  var
    i: byte;
    j: byte;
    hayBlancas: boolean;
    hayNegras: boolean;
    resultado: boolean;
  begin
    resultado := False;
    i := 1;
    j := 1;
    while (i < MAX_FILASCOLUMNAS) and resultado = False do
    begin
      while (j < MAX_FILASCOLUMNAS) and resultado = False do
      begin
        if mMatriz[i, j].ficha <> FICHA_VACIA then
        begin
          if mMatriz[i, j].ficha = FICHA_BLANCA then
            hayBlancas := True
          else
            hayNegras := True;
          if (hayBlancas = True and hayNegras = True) then
            resultado := True;
        end;
        inc(j);
      end;
      inc(i);
    end;
    HayFichasAmbosColores := resultado;
  end;

  procedure JugadaAgregarDireccionValida(var mJugada: trJugada; direccion: byte);
  var
    i: byte;
    guardado: boolean;
  begin
    i := 0;
    guardado := False;
    while (i < MAX_DIRECCIONES) and guardado = False do ;
    begin
      Inc(i);
      if mJugada.direccionesValidas[i] = 0 then
      begin
        mJugada.direccionesValidas[i] := direccion;
        guardado := True;
      end;
    end;
  end;

function jugadaEstaEnTablero(var mJugada: trJugada): boolean;
var
  resultado: boolean;
begin
  resultado:= false;
  //writeln(mJugada.x,',',mJugada.y);
  if (mJugada.x <= MAX_FILASCOLUMNAS) and (mJugada.x >= MIN_FILASCOLUMNAS) then
  begin
    if (mJugada.y <= MAX_FILASCOLUMNAS) and (mJugada.y >= MIN_FILASCOLUMNAS) then
      resultado := True

  end;
  //else
    //estaAdentro := False;
  jugadaEstaEnTablero := resultado;
end;

  function ChequearJugadaValida(var mMatriz: tMatriz; var mDirecciones: tDirecciones;
  var mJugadaTurnoActual, mJugadaAValidar: trJugada): boolean;
  var
    i: byte;
    fichaJugador: byte;
    fichaRival: byte;
    jugadaAux: trJugada;
    sigoRecorriendo: boolean;
    esValida: boolean;
    contadorPuntosASumar: byte;
  begin
    esValida := False;
    fichaJugador := mJugadaTurnoActual.jugador;
    if fichaJugador = FICHA_BLANCA then
      fichaRival := FICHA_NEGRA
    else
      fichaRival := FICHA_BLANCA;
    //writeln('valido las direcciones para ', mJugadaAValidar.x, ',', mJugadaAValidar.y);
    for i := 1 to MAX_DIRECCIONES do
    begin
      //writeln('miro en la direccion ', i);
      contadorPuntosASumar := 0;
      jugadaAux.x := mJugadaAValidar.x + mDirecciones[i].dirX;
      jugadaAux.y := mJugadaAValidar.y + mDirecciones[i].dirY;
      sigoRecorriendo := True;
      //writeln('que hay en el casillero ',jugadaAux.x,',',jugadaAux.y,'?');
      if jugadaEstaEnTablero(jugadaAux) = True then
      begin
        //writeln('esta en el tablero, sigo validando');
        //readln();
        if CasilleroEstaVacio(jugadaAux, mMatriz) = False then
        begin
          //writeln('esta vacio');
          //readln();
          if CasilleroHayFicha(jugadaAux, fichaRival, mMatriz) = True then
          begin
            //encontre una ficha rival, empiezo a recorrer en la direccion
            //writeln('encontre una ficha rival, empiezo a recorrer en la direccion');
            jugadaAux.x := jugadaAux.x + mDirecciones[i].dirX;
            jugadaAux.y := jugadaAux.y + mDirecciones[i].dirY;
            while jugadaEstaEnTablero(jugadaAux) = True and
              CasilleroEstaVacio(jugadaAux, mMatriz) = False and sigoRecorriendo = True do
            begin
              Inc(contadorPuntosASumar);
              if CasilleroHayFicha(jugadaAux, fichaJugador, mMatriz) = True then
              begin
                sigoRecorriendo := False;
                esValida := True;
                mjugadaAValidar.puntosASumar :=
                  mjugadaAValidar.puntosASumar + contadorPuntosASumar;
                JugadaAgregarDireccionValida(mJugadaAValidar, i);
              end
              else //hay otra ficha rival
              begin
                jugadaAux.x := jugadaAux.x + mDirecciones[i].dirX;
                jugadaAux.y := jugadaAux.y + mDirecciones[i].dirY;
              end;
            end;
          end;
        end;
      end;

    end;
    //writeln('la jugada no es valida');
    //readln();
    ChequearJugadaValida := esValida;
  end;

  procedure AgregarJugadaValida(var mJugada: trJugada;
  var mJugadasValidas: tJugadasValidas);
  var
    i: byte;
    guardado: boolean;
  begin
    i := 0;
    guardado := False;
    while (i < MAX_JUGADASVALIDAS) and (guardado = False) do ;
    begin
      Inc(i);
        if mJugadasValidas[i].x = 0 then
        begin
          mJugadasValidas[i].x := mJugada.x;
          mJugadasValidas[i].y := mJugada.y;
          mJugadasValidas[i].puntosASumar := mJugada.puntosASumar;
          guardado := True;
          mJugadasValidas[i].direccionesValidas := mJugada.direccionesValidas;
        end;
    end;
  end;

  procedure ListarJugadasValidas(var mMatriz: tMatriz;
  var mJugadaTurnoActual: trJugada; var mJugadores: tJugadores;
  var mDirecciones: tDirecciones; var mJugadasValidas: tJugadasValidas);
  var
    i: byte;
    j: byte;
    jugadaAValidar: trJugada;
  begin
    if HayCasillasVacias(mMatriz) then
    begin
      //writeln('hay casillas vacias');
      //  readln();
      if HayFichasAmbosColores(mMatriz) then
      begin
      //  writeln('hay dfe ambos colores');
      //  writeln('empezando a validarrrrr');
      //  readln();
        for i := 1 to MAX_FILASCOLUMNAS do
        begin
          jugadaAValidar.x := i;
          //writeln(i);
          for j := 1 to MAX_FILASCOLUMNAS do
          begin
            jugadaAValidar.y := j;
            //writeln(j);
            //writeln('valido ',i,',',j);
            if (CasilleroEstaVacio(jugadaAValidar, mMatriz) = true) then
            begin
              //writeln(i,',',j,'esta vacio');
              //jugadaAValidar no tiene ficha! solo coordenadas!!
              if ChequearJugadaValida(mMatriz, mDirecciones,
                mJugadaTurnoActual, jugadaAValidar) = True then
                begin
              //    writeln('hay jugada valida en ',i,',',j, ', al vector!');
                  AgregarJugadaValida(jugadaAValidar, mJugadasValidas);

                end;
            end;
          end;
        end;
      end;
    end;
  end;

  function HayJugadasValidas(var mJugadasValidas: tJugadasValidas): boolean;
    //si encuentra el primer reg del vector vacio, asume que todo lo demas tmb esta, ergo no hay jugadas validas
  var
    resultado: boolean;
  begin
    if mJugadasValidas[1].x = 0 then
      resultado := False
    else
      resultado := True;
    HayJugadasValidas := resultado;
  end;

  procedure RefrescarPantalla(var mMatriz: tMatriz; var mJugadores: tJugadores);
  begin
    ClrScr;
    DibujarTablero(mMatriz, mJugadores);
  end;

  procedure IngresarYValidarJugada(var mJugada: trJugada; var mJugadores: tJugadores; var mJugadasValidas: tJugadasValidas);
  begin
      IngresarJugada(mJugada, mJugadores);
      if JugadaEstaEnCursorValidas(mJugada, mJugadasValidas) = true then
         mJugada.valida:= true
      else
         mJugada.valida:= false;
  end;

  procedure JugarHumano(var mJugada: trJugada; var mJugadores: tJugadores;
  var mMatriz: tMatriz; var mDirecciones: tDirecciones; var mJugadasValidas: tJugadasValidas);
  begin
    repeat
      IngresarYValidarJugada(mJugada, mJugadores, mJugadasValidas);
      if mJugada.valida = True then
        HacerJugada(mJugada, mMatriz, mDirecciones)
      else
        RefrescarPantalla(mMatriz, mJugadores);
      MostrarErrorJugada(mJugada);
    until mJugada.valida;
  end;

  procedure ObtenerJugadaGloton(var mJugadasValidas: tJugadasValidas;
  var mJugadaGloton: trJugada);
  var
    jGloton: trJugada;
    i: byte;
  begin
    i := 1;
    jGloton.x := 0;
    jGloton.y := 0;
    jGloton.puntosASumar := 0;
    while (i < MAX_JUGADASVALIDAS) and (mJugadasValidas[i].x > 0) do
    begin
      if (mJugadasValidas[i].puntosASumar > jgloton.puntosASumar) then
      begin
        jGloton.x := mJugadasValidas[i].x;
        jGloton.y := mJugadasValidas[i].y;
        jGloton.puntosASumar := mJugadasValidas[i].puntosASumar;
      end;
      Inc(i);
    end;
    mJugadaGloton := jGloton;
  end;

  procedure JugarGloton(var mJugada: trJugada; var mMatriz: tMatriz;
  var mDirecciones: tDirecciones; var mJugadasValidas: tJugadasValidas);
  var
    jugadaAux: trJugada;
  begin
    ObtenerJugadaGloton(mJugadasValidas, jugadaAux);
    jugadaAux.jugador := mJugada.jugador;
    HacerJugada(mJugada, mMatriz, mDirecciones);
  end;

  procedure mostrarTurno(var mJugadores: tJugadores; var mJugada: trJugada);
  begin
    writeln('Jugador ' + mJugadores[mJugada.jugador].Nombre + ', es su turno.');
  end;

  function otraPartida(): boolean;
  var
    dato: string;
    valido: boolean;
    resultado: boolean;
  begin
    valido := False;
    repeat
      Write('Juego terminado - Otra partida? S/N: ');
      Read(dato);
      if ValidarSN(dato) = True then
        valido := True;
    until valido = True;
    if dato = 'S' then
      resultado := True
    else
      resultado := False;
    otraPartida := resultado;
  end;

  procedure LimpiarJugadasValidas(var mJugadasValidas: tJugadasValidas);
  var
    i: byte;
  begin
    i := 1;
    while (i < MAX_JUGADASVALIDAS) and (mJugadasValidas[i].valida = True) do
    begin
        mJugadasValidas[i].x := 0;
        mJugadasValidas[i].y := 0;
        mJugadasValidas[i].jugador := FICHA_VACIA;
        mJugadasValidas[i].valida := False;
        Inc(i);
    end;
  end;

  function JugadorEsHumano(var mJugada: trJugada; var mJugadores: tJugadores): boolean;
  var
    resultado: boolean;
  begin
    if mJugadores[mJugada.jugador].humano then
      resultado := True
    else
      resultado := False;
    JugadorEsHumano := resultado;
  end;

  procedure CalcularPuntos(var mMatriz: tMatriz; var mJugadores: tJugadores);
  var
      i,j: byte;
  begin
    mJugadores[FICHA_BLANCA].puntos := 0;
    mJugadores[FICHA_NEGRA].puntos := 0;
    for i:= 1 to MAX_FILASCOLUMNAS do
      for j:=1 to MAX_FILASCOLUMNAS do
          if mMatriz[i,j].ficha <> FICHA_VACIA then
             if mMatriz[i,j].ficha = FICHA_BLANCA then
               inc(mJugadores[FICHA_BLANCA].puntos)
             else
               inc(mJugadores[FICHA_NEGRA].puntos)
  end;

  procedure MostrarPuntos(var mJugadores: tJugadores; esResultadoFinal: boolean);
  begin
    if esResultadoFinal = true then writeln('RESULTADO FINAL DEL PARTIDO:');
    writeln('Jugador ' + mJugadores[FICHA_BLANCA].nombre , ': ' , mJugadores[FICHA_BLANCA].puntos , ' puntos.');
    writeln('Jugador ' + mJugadores[FICHA_NEGRA].nombre , ': ' , mJugadores[FICHA_NEGRA].puntos , ' puntos.');
  end;

  procedure CalcularYMostrarPuntos(var mMatriz: tMatriz; var mJugadores: tJugadores; esResultadoFinal: boolean);
  begin
       CalcularPuntos(mMatriz, mJugadores);
       MostrarPuntos(mJugadores, esResultadoFinal);
  end;

  procedure MostrarGanadores(var mJugadores: tJugadores);
  var
      ganador: byte;
  begin
    if mJugadores[FICHA_BLANCA].puntos <>  mJugadores[FICHA_NEGRA].puntos then
    begin
         if mJugadores[FICHA_BLANCA].puntos >  mJugadores[FICHA_NEGRA].puntos then
            ganador := FICHA_BLANCA
         else
            ganador := FICHA_NEGRA;
         writeln ('Felicidades ' , mJugadores[ganador].nombre , ', ganaste!');
    end
    else
        writeln('¿Empataron? ¡Qué embole!')
  end;

var
  mMatriz: tMatriz;
  vJugadores: tJugadores;
  vDirecciones: tDirecciones;
  vJugadasValidas: tJugadasValidas;
  jugada: trJugada;
  currentPlayer: byte;//para ver de quien es el turno
  gameOver: boolean;//duh

begin
  InicializarVariables(vDirecciones, vJugadasValidas, jugada);
  repeat  //repeat 1, solamente de cuando se arranca un partido nuevo
    PedirDatosJugadores(vJugadores);
    ReiniciarTablero(mMatriz);
    RefrescarPantalla(mMatriz, vJugadores);
    //empieza el partido
  // repeat //repeat 2, de toda la partida
      MostrarTurno(vJugadores, jugada);
      //writeln('listando jugadas validas');
      ListarJugadasValidas(mMatriz, jugada, vJugadores, vDirecciones, vJugadasValidas);
      //writeln('jugadas validas listadas');
      if not HayJugadasValidas(vJugadasValidas) then  //Al parecer, poniendo not, anda :P
        if JugadorEsHumano(jugada, vJugadores) then
          JugarHumano(jugada, vJugadores, mMatriz, vDirecciones, vJugadasValidas)
        else
          JugarGloton(jugada, mMatriz, vDirecciones, vJugadasValidas)
      else
      begin
        if 1 = 1 then//TerminoElPartido(mMatriz, jugada) then
          //para ver si termino o si tiene que pasar nomas
          gameOver := True
        else
          writeln('Jugador ', vJugadores[jugada.jugador].Nombre,
            ', no tiene movimientos posibles, deberá pasar su turno.');
      end;
     // RefrescarPantalla(mMatriz, vJugadores);
      DibujarTablero(mMatriz, vJugadores);
      CalcularYMostrarPuntos(mMatriz, vJugadores, false);
      //PasarTurno(jugada);
      //JuegoTerminado();
    //until gameOver; //fin repeat de todo el partido

    CalcularYMostrarPuntos(mMatriz, vJugadores, true);
    MostrarGanadores(vJugadores);
    //otra partida? s/n - se la banca suelta como funcion o hay que declarar var y demas?
  until (otraPartida() = False);  //fin repeat 1,
end.
