MODULE T22WhileElsif;
IMPORT Out;

VAR i : INTEGER;
BEGIN
 i := 0;
 WHILE i = 6 DO Out.String("C"); Out.Ln; i := 123;
 ELSIF i = 0 DO Out.String("A"); Out.Ln; i := -1
 ELSIF i < 0 DO Out.String("B"); Out.Ln; i := 6;
 END;
END T22WhileElsif.
