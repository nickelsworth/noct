MODULE T11Variables;
IMPORT Out;

VAR x : INTEGER: msg : ARRAY 3 OF CHAR;
BEGIN

  x := 0;
  Out.Int( x ); Out.Ln;
  x := 1;
  Out.Int( 1 ); Out.Ln;

  x := 7; 
  INC( x ); Out.Int( x ); Out.Ln;
  DEC( x ); Out.Int( x ); Out.Ln;

  msg := "abc";
  Out.String( msg ); Out.Ln;
  msg := "xyz";
  Out.String( msg ); Out.Ln;

END T11Variables.
