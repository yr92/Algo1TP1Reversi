program Reversi
const COLUMNAS = 8;
      FILAS = 8;
type tMatriz: array [1..FILAS,1..COLUMNAS] of char
var
procedure mostrarMatriz (var matriz: tMatriz);
        var i,j: integer;
        begin
              for i:=1 to FILAS do
              begin
                   for j:=1 to COLUMNAS do
                        write(matriz [i,j],' ');

              end;
        end;


