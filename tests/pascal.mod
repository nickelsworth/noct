MODULE pascal;
IMPORT Crt;

CONST
  pub* = 1;
  prv  = 2;

PROCEDURE pubFunc*(a, b : INTEGER) : INTEGER;
   RETURN a + b
END pubFunc;

PROCEDURE prvProc(VAR a : INTEGER);
BEGIN
   INC(a);
END prvProc;

BEGIN
  WRITELN(pub # prv); (*   WRITELN(pub <> prv);  *)
END pascal.
