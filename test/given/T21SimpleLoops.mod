MODULE T21SimpleLoops;
IMPORT Out;

VAR i : INTEGER;

BEGIN
 i := 0;

 REPEAT INC( i ); Out.Int( i, 0 ); Out.Ln
 UNTIL i = 10;

 (* while loops covered in T22 *)

 FOR i := 1 TO 3 BY  1 DO Out.Int( i, 0 ); Out.Ln END;
 FOR i := 3 TO 1 BY -1 DO Out.Int( i, 0 ); Out.Ln END;
 FOR i := 8 TO 2 BY -2 DO Out.Int( i, 0 ); Out.Ln END;

END T21SimpleLoops.
