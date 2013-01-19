MODULE T21Loops;
IMPORT Out;

VAR i : INTEGER;

BEGIN
 i := 0;

 REPEAT INC( i ); Out.Int( i ); Out.Ln
 UNTIL i = 10;

 WHILE i > -10 DO 
   DEC( i, 5 ); Out.Int( i ); Out.Ln
 END;

 WHILE i > -10 DO 
   Out.String("This should not Appear");
 ELSE
      
 END;
 
 FOR i := 1 TO 3 BY  1 DO Out.Int( i ); Out.Ln END;
 FOR i := 3 TO 1 BY -1 DO Out.Int( i ); Out.Ln END;
 FOR i := 8 TO 2 BY -2 DO Out.Int( i ); Out.Ln END;
  
END T21Loops.
