function Glotonpc (var vjugadasvalidas: tJugadasValidas): trJugada;
var jgloton: trJugada;
    i:byte;
begin
     jgloton.x:=0;
     jgloton.y:=0;
     jgloton.puntosASumar:=0;
     for i:=1 to FILAS do
     begin
          if (vjugadasvalidas[i].puntosASumar > jgloton.puntosASumar) then
          begin
               jgloton.x:= vjugadasvalidas[i].x;
               jgloton.y:= vjugadasvalidas[i].y;
               jgloton.puntosASumar:= vjugadasvalidas[i].puntosASumar;
          end;
     end;
     Glotonpc := jgloton;
end;
