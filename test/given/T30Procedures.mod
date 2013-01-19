MODULE T30Procedures;
IMPORT Out;

PROCEDURE WriteLn( i : INTEGER );
BEGIN
  Out.Int( i );
  Out.Ln;
END Write;

PROCEDURE Next( i : INTEGER ) : INTEGER;
BEGIN
  RETURN i + 1
END Next;

PROCEDURE VarNext( i : INTEGER; VAR j : INTEGER );
BEGIN
END;

VAR x : INTEGER;
BEGIN

  x := 0;
  WriteLn( x );         (* 0 *)
  x := Next( x );   
  WriteLn( x );         (* 1 *)
  WriteLn( Next( x ));  (* 2 *)
  VarNext( x, x );
  WriteLn( x );         (* 2 *)

END T30Procedures.
