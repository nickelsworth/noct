(* http://ooc.sourceforge.net/OOCref/OOCref_7.html#SEC72 *)
MODULE T00Output;
IMPORT Out;

BEGIN
   Out.String( "Hello World" );
   Out.Ln;
   Out.Int( -1, 0 );
   Out.Ln;
   Out.Int(  0, 0 );
   Out.Ln;
   Out.Int(  1, 0 );
   Out.Ln
END T00Output.
