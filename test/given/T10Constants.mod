MODULE T10Constants;
IMPORT Out;

CONST x = 123; y = x * 2; abc="abc";
BEGIN
  Out.String( abc ); Out.Ln;
  Out.Int( x,   0 ); Out.Ln;
  Out.Int( y,   0 ); Out.Ln;
  Out.Int( y-x, 0 ); Out.Ln;
END T10Constants.
