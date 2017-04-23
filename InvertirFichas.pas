procedure InvertirFichas (var mMatriz: tMatriz, vector: tDirecciones) //Aca va el nombre del vector donde se van a almacenar las fichas que van a cambiar de color
var
begin
     i := 1
     while i <= TAMAÑO VECTOR and HayJugadaValida = true do
     case vector of
     turnoBlancas: vector[i].ficha := FICHA_BLANCA;
     turnoNegras: vector[i].ficha := FICHA_NEGRA;
     end;






