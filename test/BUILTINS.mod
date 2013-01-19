MODULE BUILTINS;  (* See Oberon-07-Report.pdf , page 13 *)

PROCEDURE ABS*( x :  INTEGER ) : INTEGER;
BEGIN
   IF x < 0 THEN
      x := -x
   END;
   RETURN x
END ABS;

PROCEDURE ODD*( x : INTEGER ) : BOOLEAN;
BEGIN   
   RETURN (x MOD 2) = 1
END ODD;


PROCEDURE LEN*( v : ARRAY OF INTEGER ) : INTEGER; (* TODO *)
BEGIN
   RETURN 0
END LEN;


PROCEDURE LSL*( x : INTEGER ) : INTEGER; (* TODO: TEST *)
VAR
   i : INTEGER;
BEGIN
   FOR i := 0 TO x DO
      x := x * 2;
   END
   RETURN x
END LSL;

PROCEDURE ASR*( x : INTEGER ) : INTEGER; (* TODO: TEST *)
VAR
   i : INTEGER;
BEGIN
   FOR i := 0 TO x DO
      x := x DIV 2;
   END
   RETURN x
END ASR;

PROCEDURE ROR*( x : INTEGER ) : INTEGER; (* TODO: TEST *)
VAR
   i : INTEGER;
BEGIN
   RETURN x
END ROR;


PROCEDURE FLOOR*( x : REAL ) : INTEGER; (* TODO : CAST TO INT *)
RETURN 0
END FLOOR;


PROCEDURE FLT( x : INTEGER ) : REAL; (* TODO : CAST TO REAL *)
BEGIN
RETURN 0;
END FLT;


PROCEDURE ORD*( x : CHAR ) : INTEGER; (* TODO: ORDINAL NUMBER OF X *)
BEGIN
RETURN 0
END ORD;

(*
PROCEDURE ORD*( x : SET ) : INTEGER; (* TODO: what does this even mean? *)
RETURN 0
END ORD;

PROCEDURE ORD*( x : BOOLEAN ) : INTEGER;
VAR
   res : INTEGER;
BEGIN
   IF x THEN res = 1 ELSE x = 0 END
   RETURN res
END ORD;
*)

PROCEDURE CHR*( x : INTEGER ) : CHAR; (* TODO: cast to char *)
RETURN 20X;
END CHR;

(* PROCEDURE LONG*( x : REAL ) : LONGREAL;   TODO : Do I really need this?
   PROCEDURE SHORT*( x : LONGREAL ) : REAL;  TODO : or this?
*)



PROCEDURE INC*( VAR v : INTEGER );
BEGIN
   v := v + 1
END INC;


PROCEDURE DEC*( VAR v : INTEGER );
BEGIN
   v := v - 1
END DEC;


PROCEDURE IntToSet( x : INTEGER ) : SET;
VAR
   i, elem : INTEGER;
BEGIN
   elem := 1;
   FOR i := 1 TO x DO
      elem := elem * 2
   END
   RETURN elem
END IntToSet;


PROCEDURE INCL*( VAR s : SET; x : INTEGER );
BEGIN
   s := s + IntToSet(x)
END INCL;


PROCEDURE EXCL*( VAR s : SET; x : INTEGER );
BEGIN
   s := s - IntToSet(x)
END EXCL;

PROCEDURE COPY*( src : ARRAY; VAR dst : ARRAY ); (* TODO *)
END COPY;

PROCEDURE NEW*( v : POINTER ); (* TODO *)
END NEW;


PROCEDURE ASSERT( b : BOOLEAN ); (* TODO : ASSERT( b,n)  *)
BEGIN
   IF ~ b THEN
      (* TODO : stop execution *)
   END
END ASSERT;



(* The parameter y of PACK represents the exponent of x. PACK(x, y) is
 * equivalent to x := x * 2y. UNPK is the reverse operation of PACK.
 *  The resulting x is normalized, i.e. 1.0 <= x < 2.0.
 *
 *  - oberon report, pg 14
 *)

PROCEDURE PACK( x REAL ; y : INTEGER );  (* TODO pack x and y into x *)
BEGIN
END PACK;

PROCEDURE UNPK( x REAL ; y : INTEGER );  (* TODO unpack x into x and y *)
BEGIN
END UNPK;


END BUILTINS.

