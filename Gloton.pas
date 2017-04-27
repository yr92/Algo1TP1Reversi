procedure ObtenerJugadaGloton (var mJugadasValidas: tJugadasValidas, var mJugadaGloton: trJugada);
var jGloton: trJugada;
    i:byte;
begin
     i:= 1;
     jGloton.x:=0;
     jGloton.y:=0;
     jGloton.puntosASumar:=0;
     while i < MAX_JUGADASVALIDAS and mJugadasValidas[i].x> 0 do
     begin
          if (mJugadasValidas[i].puntosASumar > jgloton.puntosASumar) then
          begin
               jGloton.x:= mJugadasValidas[i].x;
               jGloton.y:= mJugadasValidas[i].y;
               jGloton.puntosASumar:= mJugadasValidas[i].puntosASumar;
          end;
     end;
     mJugadaGloton := jGloton;
end;
