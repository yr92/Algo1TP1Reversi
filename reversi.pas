PROGRAM reversi;
(* Programa: Reversi, versión 2.x
 * Archivo: reversi.pas
 * Descripción: El juego en sí.
 * Autor: Ñuño Martínez < >
 *
    Copyright (C) Ñuño Martínez, 2005

    Este programa es un Programa de Libre Distribución; usted
    puede redistribuirlo y/o modificarlo bajo los términos de
    la "Licencia de Libre Distribución de Programas (LLDP)".

    Este programa es distribuido con la esperanza de que le será
    útil, pero SIN NINGUNA GARANTÍA. Vea la "Licencia de Libre
    Distribución de Programas" para más detalles.

    Usted debe haber recibido una copia de la "Licencia de Libre
    Distribución de Programas" junto con este programa, si no es
    así, escriba a:

    Guimarprog, Apdo. 4034 09080 Burgos, España

 *)

USES mingro, mgMouse, GUI, damero, Sysutils;



TYPE
(* TABLERO_REVERSI:
 *   Define el tablero usado en el juego. *)
  TABLERO_REVERSI = CLASS (damero.TABLERO)
  PUBLIC
    CONSTRUCTOR Create;
    PROCEDURE PosicionInicio;
    PROCEDURE Dibuja; { Dibuja todo el tablero. }
    PROCEDURE Actualiza; {Dibuja sólo las casillas con piezas. }
    PROCEDURE Actualiza (x, y: INTEGER); { Dibuja sólo la pieza. }
    FUNCTION CompruebaJugada (x, y: INTEGER; Pieza: CHAR): BOOLEAN;
    PROCEDURE Mueve (x, y: INTEGER; Pieza: CHAR);
    FUNCTION CuentaFichas (CONST Pieza: CHAR): INTEGER;
  END;



CONST
(* Para facilitar el acceso. *)
  Vacio  = ' ';
  PiezaH = 'H';
  PiezaO = 'O';



VAR
(* Colores de uso común. *)
  Blanco, Negro, Fondo: LONGINT;



(*******************
 * TABLERO_REVERSI *
 *******************)

(* TABLERO_REVERSI.Create:
 *   Constructor. *)
CONSTRUCTOR TABLERO_REVERSI.Create;
BEGIN
{ Creamos el tablero. }
  INHERITED Create (64, 50, 169, 39);
{ Lo coloca en la posición de inicio. }
  PosicionInicio;
END;



(* TABLERO_REVERSI.PosicionInicio:
 *   Inicializa el tablero para empezar a jugar. *)
PROCEDURE TABLERO_REVERSI.PosicionInicio;
VAR
  x, y: INTEGER;
BEGIN
  FOR y := 0 TO 7 DO
    FOR x := 0 TO 7 DO
      PonEscaque (x, y, Vacio);
  PonEscaque (3, 3, PiezaO);
  PonEscaque (4, 4, PiezaO);
  PonEscaque (3, 4, PiezaH);
  PonEscaque (4, 3, PiezaH);
END;



(* TABLERO_REVERSI.Dibuja:
 *   Dibuja TODO el tablero. *)
PROCEDURE TABLERO_REVERSI.Dibuja;
VAR
  x, y: INTEGER;
BEGIN
  mgShowMouse (NIL); mgAcquireScreen;
{ Dibuja un marco. }
  mgRectFill (mgScreen, 167, 37, 570, 440, mgColor(153, 153, 153));
{ Dibuja los escaques. }
  INHERITED Dibuja;
{ Dibuja las piezas. }
  FOR y := 0 TO 7 DO
    FOR x := 0 TO 7 DO
      Actualiza (x, y);
  mgReleaseScreen; mgShowMouse (mgScreen);
END;



(* TABLERO_REVERSI.Actualiza:
 *   Dibuja Sólo las casillas con piezas. *)
PROCEDURE TABLERO_REVERSI.Actualiza;
VAR
  x, y: INTEGER;
BEGIN
  mgShowMouse (NIL); mgAcquireScreen;
  FOR y := 0 TO 7 DO
    FOR x := 0 TO 7 DO
      if ObtieneEscaque (x, y) <> Vacio THEN Actualiza (x, y);
  mgReleaseScreen; mgShowMouse (mgScreen);
END;



(* TABLERO_REVERSI.Actualiza:
 *   Dibuja sólo la pieza. *)
PROCEDURE TABLERO_REVERSI.Actualiza (x, y: INTEGER);
VAR
  Pieza: CHAR;
  Cf, Cb: INTEGER;
BEGIN
  Pieza := ObtieneEscaque (x, y); { Para no tener que repetir. }
{ Evita tener que dibujar casillas vacías o que caigan fuera del tablero. }
  IF (Pieza = Vacio) OR (Pieza = Fuera) THEN
    EXIT;
{Colores a utilizar. }
  IF Pieza = PiezaH THEN
  BEGIN
    Cf := Blanco; Cb := Negro;
  END
  ELSE BEGIN
    Cf := Negro; Cb := Blanco;
  END;
{ Dibuja la pieza.  Dibuja dos círculos superpuestos para crear un efecto
  tridimensional.  No sólo lo hace más bonito, sino que también es más fácil
  de ver. }
  x := x * 50; y := y * 50;
  mgCircleFill (Bmp, x + 24, y + 24, 20, Cf);
  mgCircle     (Bmp, x + 24, y + 24, 20, Cb);
  mgCircleFill (Bmp, x + 22, y + 22, 20, Cf);
  mgCircle     (Bmp, x + 22, y + 22, 20, Cb);
END;



(* TABLERO_REVERSI.CompruebaJugada:
 *   Comprueba si la jugada propuesta es válida.  Para comprender el algoritmo
 *   recomiendo usar un tablero con fichas de las damas y del parchís para ir
 *   siguiendo su desarrollo. *)
FUNCTION TABLERO_REVERSI.CompruebaJugada (x, y: INTEGER; Pieza: CHAR): BOOLEAN;
VAR
  Victima: CHAR;
  ix, iy: INTEGER; { Incrementos. }
  Tx, Ty: INTEGER; { Posición temporal. }
BEGIN
{ Comprueba si la casilla está dentro del tablero y vacía. }
  IF ObtieneEscaque (x, y) <> Vacio THEN
  BEGIN
    CompruebaJugada := FALSE; EXIT;
  END;
{ Para hacer bien el seguimiento. }
  IF Pieza = PiezaH THEN
    Victima := PiezaO
  ELSE
    Victima := PiezaH;
{ Comprueba las casillas adyacentes. }
  FOR ix := -1 TO 1 DO
  BEGIN
    FOR iy := -1 TO 1 DO
    BEGIN
      IF (ix = 0) AND (iy = 0) THEN { Si ambos son 0, no se mueve del sitio. }
	CONTINUE;
      IF ObtieneEscaque (x + ix, y + iy) = Victima THEN { Posible captura. }
      BEGIN
	Tx := x + ix; Ty := y + iy;
	REPEAT
	{ Si la casilla tiene una pieza del jugador, puede rodearlas. }
	  IF ObtieneEscaque (Tx, Ty) = Pieza THEN
	  BEGIN
	    CompruebaJugada := TRUE; EXIT; { Captura. }
	  END;
	{ Siguiente casilla. }
	  INC (Tx, ix); INC (Ty, iy);
	{ Hasta que pille un espacio vacío o se salga del tablero. }
	UNTIL (ObtieneEscaque (Tx, Ty) = Vacio) 
	   OR (ObtieneEscaque (Tx, Ty) = Fuera);
      END;
    END;
  END;
{ Si llega hasta aquí es que no encontró captura alguna. }
  CompruebaJugada := FALSE;
END;



(* PROCEDURE TABLERO_REVERSI.Mueve:
 *   Realiza el movimiento, que ha sido comprobado en CompruebaJugada. *)
PROCEDURE TABLERO_REVERSI.Mueve (x, y: INTEGER; Pieza: CHAR);

(* Parpadeo:
 *   Realiza un parpadeo para mostrar la pieza nueva. *)
  PROCEDURE Parpadeo (x, y: INTEGER);
  VAR
    Ce, Cnt: INTEGER;
  BEGIN
  { Si ambos escaques son pares o los dos son impares, el escaque es negro. }
    IF x MOD 2 = y MOD 2 THEN
      Ce := Negro
  { En otro caso, es blanco. }
    ELSE
      Ce := Blanco;
  { Parpadeando, que es gerundio. }
    mgShowMouse (NIL);
    FOR Cnt := 0 TO 2 DO
    BEGIN
      SELF.Actualiza (x, y);
      mgSleep (500);
      mgRectFill (SELF.Bmp, x * 50, y * 50, (x * 50) + 49, (y * 50) + 49, Ce);
      mgSleep (500);
    END;
    mgShowMouse (mgScreen);
  END;

VAR
  Victima: CHAR;
  Lx, Ly: ARRAY [0..8] OF INTEGER; {/ Almacena la línea muestreada. }
  ix, iy, Cnt, Tx, Ty: INTEGER;
BEGIN
{ Para hacer bien el seguimiento. }
  IF Pieza = PiezaH THEN
    Victima := PiezaO
  ELSE
    Victima := PiezaH;
{ Coloca la pieza seleccionada. }
  PonEscaque (x, y, Pieza); Parpadeo (x, y);
{ Comprueba capturas. }
  FOR ix := -1 TO 1 DO
  BEGIN
    FOR iy := -1 TO 1 DO
    BEGIN
      IF (ix = 0) AND (iy = 0) THEN { Si ambos son 0, no se mueve del sitio. }
	CONTINUE;
      IF ObtieneEscaque (x + ix, y + iy) = Victima THEN { Posible captura. }
      BEGIN
      { Borra la línea anterior. }
	FOR Cnt := 0 TO 8 DO BEGIN Lx[Cnt] := -1; Ly[Cnt] := -1; END;
      { Cnt-> Piezas que son víctimas.  Tx, Ty-> Posición de las piezas. }
	Cnt := 0; Tx := x; Ty := y;
	REPEAT
	  INC (Tx, ix); INC (Ty, iy);
	  IF ObtieneEscaque (Tx, Ty) = Pieza THEN { Captura. }
	  BEGIN
	  { Cambia las piezas del tablero. }
	    Cnt := 0;
	    WHILE Lx[Cnt] >=0 DO
            BEGIN
	      PonEscaque (Lx[Cnt], Ly[Cnt], Pieza);
	      INC (Cnt);
	    END;
	    BREAK; { Busca la siguiente captura. }
	  END
	  ELSE BEGIN
	  { Añade la pieza capturada a la línea. }
	    Lx[Cnt] := Tx; Ly[Cnt] := Ty;
	    INC (Cnt);
	  END;
	{ Hasta que no sea la víctima, es decir, jugador, vacío o fuera. }
	UNTIL ObtieneEscaque (Tx, Ty) <> Victima;
      END;
    END;
  END;
  Actualiza;
END;



(* TABLERO_REVERSI.CuentaFichas:
 *   Cuenta las Pieza que hay en el tablero. *)
FUNCTION TABLERO_REVERSI.CuentaFichas (CONST Pieza: CHAR): INTEGER;
VAR
  x, y: INTEGER;
BEGIN
  CuentaFichas := 0;
  FOR y := 0 TO 7 DO
    FOR x := 0 TO 7 DO
      IF ObtieneEscaque (x, y) = Pieza THEN INC (CuentaFichas);
END;



(*********
 * Juego *
 *********)

VAR
(* Para los bucles. *)
  Continuar, Recomenzar: BOOLEAN;
(* El tablero de juego. *)
  Tablero: TABLERO_REVERSI;
(* Muestra la pausa del ratón. *)
  CursorPausa: MG_BITMAPptr;
(* Botones. *)
  BotonTerminar, BotonRecomenzar: GUI_BOTON;



(* ActualizaMarcadores:
 *   Actualiza los marcadores de la parte superior izquierda. *)
PROCEDURE ActualizaMarcadores;
BEGIN
  mgShowMouse (NIL); mgAcquireScreen;
{ Borramos el marcador anterior. }
  mgRectFill (mgScreen, 88,80,120,108, Fondo);
{Nuevo marcador. }
  mgTextout (mgScreen, mgDefaultFont, 91, 80, Blanco,
	     INTTOSTR (Tablero.CuentaFichas (PiezaO)));
  mgTextout (mgScreen, mgDefaultFont, 91, 100, Blanco,
	     INTTOSTR (Tablero.CuentaFichas (PiezaH)));
  mgReleaseScreen; mgShowMouse (mgScreen);
END;



(* Inicializa:
 *   Realiza las operaciones de preparación del programa. *)
FUNCTION Inicializa: BOOLEAN;

  PROCEDURE MuestraMensajeError (CONST Mensaje: STRING);
  BEGIN
    WRITELN (Mensaje);
    mgReadKey;
  END;

VAR
  Cnt, x, y, Verde: INTEGER;
BEGIN
{ Por defecto, la cosa va bien. }
  Inicializa := TRUE;
{ Inicializa Mingro. }
  IF NOT mgStartup THEN
  BEGIN
    WRITELN ('No pudo inicializarse el sistema.');
    Inicializa := FALSE;
    EXIT;
  END;
{ Inicializa el modo gráfico. }
  if NOT mgSetGfxModeEx (640, 480, 8, TRUE) THEN
    if NOT mgSetGfxMode (640, 480, 8) THEN
    BEGIN
      MuestraMensajeError ('No puede inicializarse el modo gráfico.');
      Inicializa := FALSE;
      EXIT;
    END;
{ Inicializa el ratón. }
  IF mgInitMouse = 0 THEN
  BEGIN
    MuestraMensajeError ('El ratón es imprescindible para jugar.');
    Inicializa := FALSE;
    EXIT;
  END;
  mgShowMouse (mgScreen);
{ Colores de uso común. }
  Blanco := mgColor (255, 255, 255);
  Negro  := mgColor (0, 0, 0);
  Fondo  := mgColor (51, 51, 51);
{ Crea el cursor "pausa". }
  CursorPausa := mgCreateBitmap (32, 32);
  mgClearBitmapToColor (CursorPausa, mgBitmapMaskColor (mgScreen));
  FOR Cnt := 1 TO 10 DO
  BEGIN
    x := TRUNC (COS (Cnt * (3.141569 * 0.2)) * 10); INC (x, 16);
    y := TRUNC (SIN (Cnt * (3.141569 * 0.2)) * 10); INC (y, 16);
    mgRectFill (CursorPausa, x - 1, y - 1, x + 1, y + 1, Negro);
    mgPutPixel (CursorPausa, x, y, Blanco);
  END;
  mgSetMouseSprite (CursorPausa, 15, 15);
{ Pantalla. }
  mgShowMouse (NIL);
  mgClearBitmapToColor (mgScreen, Fondo);
  mgTextout (mgScreen, mgDefaultFont, 10,  80, Blanco, 'Ordenador:');
  mgTextout (mgScreen, mgDefaultFont, 10, 100, Blanco, 'Humano   :');
{ Publicidad. }
  mgTextout (mgScreen, mgDefaultFont, 22, 400, Blanco, ' Ñuño 1998, 2005');
  mgCircle  (mgScreen, 24, 403, 4, Blanco);
  mgline    (mgScreen, 22, 402, 22, 404, Blanco);
  mgline    (mgScreen, 23, 401, 25, 401, Blanco);
  mgline    (mgScreen, 23, 405, 25, 405, Blanco);
  mgTextout (mgScreen, mgDefaultFont, 30, 360, Blanco, 'Presentado por');
  mgTextout (mgScreen, mgDefaultFont, 58, 380, mgColor (0, 151, 51), 'B   J ');
  Verde := mgColor (0, 215, 70);
  mgTextout (mgScreen, mgDefaultFont, 58, 380, Verde, '  RD I');
  FOR x := 0 TO 3 DO
  BEGIN
   mgLine (mgScreen, x + 66, x + 380, x + 66, x + 383, Verde);
   mgLine (mgScreen, 72 - x, x + 380, 72 - x, x + 383, Verde);
   mgLine (mgScreen, x + 104, 386 - x, x + 104, 385 - x, Verde);
   mgLine (mgScreen, 110 - x, 386 - x, 110 - x, 385 - x, Verde);
  END;
  mgLine (mgScreen, 72, 385, 72, 386, Verde);
  mgLine (mgScreen, 107, 380, 107, 385, Verde);
  mgPutPixel (mgScreen, 71, 383, Fondo);
  mgShowMouse (mgScreen);
{ Controles. }
  BotonTerminar := GUI_BOTON.Crea ('Terminar', 10, 200, 100, 17);
  BotonTerminar.Dibuja;
  BotonRecomenzar := GUI_BOTON.Crea ('Recomenzar', 10, 220, 100, 17);
  BotonRecomenzar.Dibuja;
{ Tablero. }
  TRY
    Tablero := TABLERO_REVERSI.Create;
  EXCEPT
    ON E: EXCEP_DAMERO DO BEGIN
      MuestraMensajeError (E.MESSAGE);
      Inicializa := FALSE;
      EXIT;
    END;
  END;
{ Para los bucles. }
  Continuar := TRUE; Recomenzar := FALSE;
{ Generador de números aleatorios.  Da variedad al juego del ordenador. }
  RANDOMIZE;
{ Recupera el ratón normal. }
  mgSetMouseSprite (NIL, 1, 1);
END;



(* Finaliza:
 *   Da por terminado el programa, liberando recursos si es necesario. *)
PROCEDURE Finaliza;
BEGIN
{ Libera los recursos del tablero. }
  Tablero.Free;
  BotonTerminar.Free; BotonRecomenzar.Free;
{ Finaliza con Mingro. }
  mgDestroyBitmap (CursorPausa);
  mgShutdown;
END;



(* JugadaHumano:
 *   Toma la entrada del jugador humano, la comprueba y la ejecuta. *)
PROCEDURE JugadaHumano;
VAR
  rx, ry, rb: INTEGER;	{ Ratón }
  cx, cy: INTEGER;	{ Casilla }
BEGIN
  mgSetMouseSprite (NIL, 1, 1);
  WHILE TRUE DO
  BEGIN
  { Espera la pulsación del usuario. }
    mgPollKeyboard;
    mgGetMousePosition (rx, ry, rb);
  { Procesa las entradas. }
    IF (mgKey[MG_KEY_ESC] <> #0) OR BotonTerminar.Pulsado (rx, ry, rb) THEN
    BEGIN
      Continuar := FALSE; EXIT;
    END;
    IF BotonRecomenzar.Pulsado (rx, ry, rb) THEN
    BEGIN
      Recomenzar := TRUE; EXIT;
    END;
    IF rb <> 0 THEN
    BEGIN
    { Esperamos a que suelte, no sea que se arrepienta. }
      REPEAT
	mgGetMousePosition (rx, ry, rb);
      UNTIL rb = 0;
    { ¿Pulsó dentro del tablero? }
      Tablero.PosACasilla (rx, ry, cx, cy);
      IF cx >= 0 THEN
      BEGIN
      { Comprueba que la jugada se acorrecta y mueve si es así. }
	IF Tablero.CompruebaJugada (cx, cy, PiezaH) THEN
	BEGIN
	  mgSetMouseSprite (CursorPausa, 15, 15);
	  Tablero.Mueve (cx, cy, PiezaH);
	  ActualizaMarcadores();
	  mgSetMouseSprite (NIL, 1, 1);
	  EXIT;
	END;
      END;
    END;
  END;
END;



(* JugadaOrdenador:
 *   Aquí hay buena parte del meollo de la cuestión.  Antes de leerlo, te
 *   propongo como ejercicio que diseñes tu propio algoritmo, a ver si te
 *   sale. *)
PROCEDURE JugadaOrdenador;
VAR
  x, y, mx, my, TmpX, TmpY: INTEGER;
  CntPiezas, CntTmp: INTEGER; { Para ver cuantas ha capturado. }
  MovFinalX, MovFinalY, CntMovFinal: INTEGER; { Datos de la mejor jugada. }
BEGIN
{ Ponemos un valor inicial a todas las variables. }
  x := 0; y := 0; mx := 0; my := 0; TmpX := 0; TmpY := 0;
  CntPiezas := 0; CntTmp := 0;
  MovFinalX := 0; MovFinalY := 0; CntMovFinal := 0;
{ Cambiamos a pausa y espera un par de segundos.  Esto es para que se vea la
  jugada, ya que el ordenador es tan rápido que no da tiempo ni a respirar. }
  mgSetMouseSprite (CursorPausa, 15, 15); mgSleep (2000);
{ Recorre todo el tablero. }
  FOR y := 0 TO 7 DO
    FOR x := 0 TO 7 DO
    BEGIN
      IF Tablero.Escaque[x, y] <> Vacio THEN { Sólo interesan las vacías. }
	CONTINUE;
    { Mira si hay posible captura. }
      IF NOT Tablero.CompruebaJugada(x, y, PiezaO) THEN CONTINUE;
    { Cuenta el número de piezas capturadas. }
      CntTmp := 0; CntPiezas := 0;
      FOR my := -1 TO 1 DO
	FOR mx := -1 TO 1 DO
	BEGIN
	  IF (mx = 0) AND (my =0) THEN continue; { Si ambos son 0 no avanza. }
	  IF Tablero.Escaque[x+mx, y+my] <> PiezaH THEN { No hay más. }
	    CONTINUE;
	{ Cuenta las piezas en Tmp y comprueba si es captura. }
	  CntTmp := 1; TmpX := x; TmpY := y;
	  REPEAT
	    INC (TmpX, mx); INC (TmpY, my); { Siguiente casilla. }
	    IF Tablero.Escaque[TmpX, TmpY] = PiezaO THEN
	    BEGIN
	    { Captura. }
	      INC (CntPiezas, CntTmp);
	      BREAK; { Siguiente. }
	    END
	    ELSE
	      INC (CntTmp); { Otra pieza más en la captura. }
	  { Hasta Vacío o Fuera. }
	  UNTIL Tablero.Escaque[TmpX, TmpY] <> PiezaH;
	END;
    { Comprueba si alguna pieza está en los bordes o en las esquinas.  Todo esto
      es aritmética pura heredada de la versión 1.  Podría haberlo hecho de otra
      forma, pero me quedó tan original que prefiero dejarlo como muestra
      arqueológica. }
      TmpX := ((y + 1) * 10) + x + 1;
      IF (TmpX DIV 10 = 1) OR (TmpX DIV 10 =8) THEN
      BEGIN
	IF (TmpX MOD 10 = 1) OR (TmpX MOD 10 =8) THEN
	  INC (CntPiezas, 3)
	ELSE
	  INC (CntPiezas, 2);
      END
      ELSE IF (TmpX MOD 10 = 1) OR (TmpX MOD 10 = 8) THEN
	INC (CntPiezas, 2);
    { Compara con el movimiento anterior. }
      IF CntPiezas > CntMovFinal THEN { Es mejor movimiento. }
      BEGIN
	MovFinalX := x; MovFinalY := y;
	CntMovFinal := CntPiezas;
      END
      ELSE IF CntPiezas = CntMovFinal THEN { Son iguales. }
      BEGIN
      { Damos algo de aleatoriedad al juego.  De esta forma evitamos que en
	circunstancias idénticas el odenador haga siempre el mismo movimiento. }
	IF RANDOM (2) = 1 THEN
	BEGIN
	  MovFinalX := x; MovFinalY := y;
	END;
      END;
    END;
{ Llegados a este punto, el ordenador ya tiene una jugada pensada. }
  Tablero.Mueve (MovFinalX, MovFinalY, PiezaO); ActualizaMarcadores();
{ Recuperamos el cursor por defecto. }
  mgSetMouseSprite (NIL, 1, 1);
END;



(* MasJugadas:
 *   Comprueba si hay alguna jugada posible con la pieza dada.  Si hay jugadas
 *   posibles, devuelve TRUE, si no hay jugadas, devuelve FALSE. *)
FUNCTION MasJugadas (Pieza: CHAR): BOOLEAN;
VAR
  x, y: INTEGER;
BEGIN
  FOR y := 0 TO 7 DO 
    FOR x := 0 TO 7 DO
      IF Tablero.CompruebaJugada (x, y, Pieza) THEN
      BEGIN
	MasJugadas := TRUE; { Hay una posible jugada, no termina. }
	EXIT;
      END;
  MasJugadas := FALSE; { No hay más jugadas, termina. }
END;



(* Inicio del programa. *)
BEGIN
{ Inicio. }
  IF Inicializa THEN
  BEGIN
    Tablero.Dibuja; ActualizaMarcadores;
    WHILE Continuar DO
    BEGIN
    { Comprueba quién empieza. }
      IF EmpiezaHumano THEN JugadaHumano;
    { Bucle del juego. }
      WHILE MasJugadas (PiezaO) AND Continuar AND (NOT Recomenzar) DO
      BEGIN
        JugadaOrdenador;
        IF NOT MasJugadas (PiezaH) OR NOT Continuar THEN BREAK;
	JugadaHumano;
      END;
    { Si no quiere salir es que o bien terminó la partida o bien el jugador
      quiere empezar de nuevo. }
      IF Continuar THEN
      BEGIN
      { Muestra el resultado final de la partida. }
        MuestraPuntuaciones (Tablero.CuentaFichas (PiezaH),
			     Tablero.CuentaFichas (PiezaO));
	Tablero.PosicionInicio; Tablero.Dibuja;
	Recomenzar := FALSE;
      END;
    END; 
  END
  ELSE
    WRITELN ('Error gordo.');
{ Terminamos. }
  Finaliza;
END.

