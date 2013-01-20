MODULE T32Recursion;
IMPORT Out;

PROCEDURE Binary( number, digits : INTEGER );
  VAR place : INTEGER;

  PROCEDURE Helper;
    VAR bit : INTEGER;
  BEGIN
    IF ODD( number ) THEN bit := 1 ELSE bit := 0 END;
    number := number DIV 2;
    (* since we want to print the bits from highest to lowest,
       but we're starting with the lowest, we need to put the
       the recursive call in the middle. *)
    IF place > 0 THEN
      place := place - 1;
      Helper;
    END;
    (* the above code recursively printed all the bits to our left,
       so now we can print our bit and return: *)
    Out.Int( bit, 0 )
  END Helper;

BEGIN
  place := digits;
  Helper;
  Out.Ln;
END Binary;

BEGIN
  Binary( 5, 4 );   (* expect: 0101 *)
END T32Recursion.
