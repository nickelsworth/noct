MODULE T11Variables;
IMPORT Out;

CONST
   abc="abc";    (* note: these strings are ARRAY 4 OF CHAR  *)
   xyz="xyz";    (* because of an implicit CHR(0) marking the end. *)

VAR
   x, y : INTEGER;
   msg : ARRAY 4 OF CHAR;
BEGIN

  x := 0;
  Out.Int( x, 0 ); Out.Ln;
  y := 1;
  Out.Int( y, 0 ); Out.Ln;

  x := 7; 
  INC( x, 3 ); Out.Int( x, 0 ); Out.Ln;
  DEC( x, 2 ); Out.Int( x, 0 ); Out.Ln;

  msg := abc;
  Out.String( msg ); Out.Ln;
  msg := xyz;
  Out.String( msg ); Out.Ln;
  msg := "123";
  Out.String( msg ); Out.Ln;

END T11Variables.
