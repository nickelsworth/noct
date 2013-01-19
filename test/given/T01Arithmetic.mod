MODULE T01Arithmetic;
IMPORT Out;

BEGIN
  Out.Int( 2 + 3,   0 ); Out.Ln;
  Out.Int( 2 - 3,   0 ); Out.Ln;
  Out.Int( 2 * 3,   0 ); Out.Ln;
  Out.Int( 2 DIV 3, 0 ); Out.Ln;
  Out.Int( 2 MOD 3, 0 ); Out.Ln;

  Out.Int( 3 + 2,   0 ); Out.Ln;
  Out.Int( 3 - 2,   0 ); Out.Ln;
  Out.Int( 3 * 2,   0 ); Out.Ln;
  Out.Int( 3 DIV 2, 0 ); Out.Ln;
  Out.Int( 3 MOD 2, 0 ); Out.Ln;

  Out.Int( -0 ,   0 ); Out.Ln;  (* should output 0 of course, without the "-" *)
END T01Arithmetic.
