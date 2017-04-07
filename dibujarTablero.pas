program dibujarTablero;

const
  LIN_HORIZONTAL = '+---+---+---+---+---+---+---+---+';
  LIN_VERTICAL = '|';

procedure dibujarTablero ();   //hay que pasarle el tablero

var
  i,j : byte;
begin
  writeln('    1   2   3   4   5   6   7   8');
  writeln('  ', LIN_HORIZONTAL);
  for i:=1 to 8 do
  begin
    write(i);
    for j:=1 to 9 do
    begin
      write(' ',LIN_VERTICAL,' ');
      write(' '); //<------ aca hay que poner la posicion del tablero (matriz[x,y])
    end;
    writeln;
    write('  ', LIN_HORIZONTAL);
    writeln;
  end;



end;

begin
  dibujarTablero();
  readln;
end.

