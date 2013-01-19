(* test for the pretty printer *)
MODULE ReformatMe; IMPORT Texts, Math; CONST  gPub* = "Hello, "; gPriv="world!"; true=TRUE; TYPE List = 
POINTER TO ListData; VAR v : INTEGER; TYPE STR = ARRAY 256 OF CHAR; p = PROCEDURE(a:INT; b:INT): INT; CONST space = 20X; TYPE ListData = RECORD data : STR; next : List END; PROCEDURE Hello;  VAR inHere 
: BOOLEAN;  PROCEDURE nested : BOOLEAN;  RETURN TRUE  END nested; PROCEDURE world:STR; VAR x:INT; 
BEGIN x := 0; RETURN gPriv END world; BEGIN Write(gPub); Write(World) END Hello; PROCEDURE anotherOne(x, y: REAL): REAL; RETURN Math.SQRT(x*x + y*y) END anotherOne; BEGIN Hello END ReformatMe.

