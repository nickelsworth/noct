MODULE T20IfThenElse;
IMPORT Out;

VAR p : BOOLEAN; i : INTEGER;
BEGIN

  p := TRUE;
  IF p THEN Out.String( "P" ) ELSE Out.String( "~P" ) END; Out.Ln;

  p := ~p;
  IF p THEN Out.String( "P" ) ELSE Out.String( "~P" ) END; Out.Ln;

  IF 1 # 2 THEN Out.String( "TRUE" ) ELSE Out.String( "FALSE" ) END; Out.Ln;
  IF 1 = 2 THEN Out.String( "TRUE" ) ELSE Out.String( "FALSE" ) END; Out.Ln;
  IF 1 > 2 THEN Out.String( "TRUE" ) ELSE Out.String( "FALSE" ) END; Out.Ln;
  IF 1 < 2 THEN Out.String( "TRUE" ) ELSE Out.String( "FALSE" ) END; Out.Ln;
  IF 1 >= 2 THEN Out.String( "TRUE" ) ELSE Out.String( "FALSE" ) END; Out.Ln;
  IF 1 <= 2 THEN Out.String( "TRUE" ) ELSE Out.String( "FALSE" ) END; Out.Ln;

  i := -1;
  IF i > 0 THEN Out.String( "+" ) ELSIF i < 0 THEN Out.String( "-" ) ELSE Out.String("0") END;
  Out.Ln;

  i := 0;
  IF i > 0 THEN Out.String( "+" ) ELSIF i < 0 THEN Out.String( "-" ) ELSE Out.String("0") END;
  Out.Ln;

  i := 1;
  IF i > 0 THEN Out.String( "+" ) ELSIF i < 0 THEN Out.String( "-" ) ELSE Out.String("0") END;
  Out.Ln;

END T20IfThenElse.
