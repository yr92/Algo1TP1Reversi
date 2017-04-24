 program REVERSI;
const
      FICHA_BLANCA=1;
      LIN_HORIZONTAL='+----+----+----+----+----+----+----+----+';
      LIN_VERTICAL='|';
      FILAS=8;
      FICHA_VACIA=0;
      COLUMNAS=8;
      FICHA_NEGRA=2;
Type tMatriz=array[1..FILAS,1..COLUMNAS] of byte;

 procedure LimpiarMatriz(var mMatriz:tMatriz);
 var i,j:byte; Matriz:tMatriz;
 begin
  for i:=1 to FILAS do
  for j:=1 to COLUMNAS do
   mMatriz[i,j]:=FICHA_VACIA;
   end;

   procedure InicializarMatriz(var mMatriz:tMatriz);
   begin
   mMatriz[4,4]:=FICHA_BLANCA;
   mMatriz[5,5]:=FICHA_BLANCA;
   mMatriz[4,5]:=FICHA_NEGRA;
   mMatriz[5,4]:=FICHA_NEGRA;
   end;


   procedure DibujarTablero(var mMatriz:tMatriz);
 var Matriz:tMatriz; i,j:integer;
 begin
 writeln('   1     2     3');
 writeln('  ', LIN_HORIZONTAL);
 for i:=1 to FILAS do
   begin
    write(i);
    for j:=1 to COLUMNAS do
      begin
       write(' ',LIN_VERTICAL,'  ');
        if (mMatriz[i,j] <>0) then
         write(mMatriz[i,j]) else write(' ');
     end;
     write(' ',LIN_VERTICAL);
     writeln;
     write('  ',LIN_HORIZONTAL);
     writeln;
  end;
  readln;
  end;

  procedure Jugador_1 (var mMatriz:tMatriz);
   var x,y:byte; jugador1,reinicio:boolean;
    begin
     writeln('Turno del Jugador 1...');
     writeln('Ingresa la fila donde queres ubicar tu ficha');
      readln(x);
     writeln('Ingresa la columna donde queres ubicar tu ficha');
      readln(y);
       begin
        if (mMatriz[x,y]<>FICHA_VACIA) then jugador1:=true else jugador1:=false;
        if (jugador1=true) then
         begin
           writeln('Inserte nuevas coordenadas validas');
            readln(x);
            readln(y);
             if(mMatriz[x,y]<>FICHA_VACIA) then reinicio:=true else reinicio:=false;
              if (reinicio=true) then
                 begin
                  Jugador_1 (mMatriz);
                 end
                else
                if(reinicio=false) then mMatriz[x,y]:=FICHA_BLANCA;
              end
             else
             if(jugador1=false) then mMatriz[x,y]:=FICHA_BLANCA;
           end;
           DibujarTablero(mMatriz);
   end;

 procedure Jugador_2 (var mMatriz:tMatriz);
   var x,y:byte; jugador2,reinicio:boolean;
    begin
     writeln('Turno del Jugador 2...');
     writeln('Ingresa la fila donde queres ubicar tu ficha');
      readln(x);
     writeln('Ingresa la columna donde queres ubicar tu ficha');
      readln(y);
       begin
        if (mMatriz[x,y]<>FICHA_VACIA) then jugador2:=true else jugador2:=false;
        if (jugador2=true) then
         begin
           writeln('Inserte nuevas coordenadas validas');
            readln(x);
            readln(y);
             if(mMatriz[x,y]<>FICHA_VACIA) then reinicio:=true else reinicio:=false;
              if (reinicio=true) then
                 begin
                  Jugador_2 (mMatriz);
                 end
                else
                if(reinicio=false) then mMatriz[x,y]:=FICHA_NEGRA;
              end
             else
             if(jugador2=false) then mMatriz[x,y]:=FICHA_NEGRA;
           end;
           DibujarTablero(mMatriz);
   end;

   procedure Juegar(var mMatriz:tMatriz);
  var cont:byte;
   begin
   cont:=1;
   repeat
   Jugador_1 (mMatriz);
   Jugador_2 (mMatriz);
   inc(cont)
   until(cont=9);
   end;

   procedure ReiniciarMatriz(var mMatriz:tMatriz);
   begin
   LimpiarMatriz(mMatriz);
   InicializarMatriz(mMatriz);
   end;

  var
   cont:byte;
   mMatriz:tMatriz;
  begin
  ReiniciarMatriz(mMatriz);
  DibujarTablero(mMatriz);
  Juegar(mMatriz);
  writeln; writeln; writeln;
  end.
