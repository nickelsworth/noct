MODULE T02Precedence;
IMPORT Out;

BEGIN
  Out.Int( 1 + 2 * 3,   0 ); Out.Ln;
  Out.Int( (1 + 2) * 3, 0 ); Out.Ln;
END T02Precedence.
