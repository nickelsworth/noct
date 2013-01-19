PROCEDURE T31Nested;
IMPORT Out;

PROCEDURE Nested;
  PROCEDURE N1;
    PROCEDURE N2
      PROCEDURE N3
      BEGIN Out.String( "[ N3 ]" )
      END N3;
    BEGIN Out.String( "[ N2 " ); N3; Out.String( "]" )
    END N2;
  BEGIN Out.String( "[ N1 " ); N2; Out.String( "]" )
  END N1;
BEGIN Out.String( "[ Nested " ); N1; Out.String( "]" ); Out.Ln
END Nested;

BEGIN Nested
END T31Nested.
