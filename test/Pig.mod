MODULE Pig;
   IMPORT Out, Random;

  (*
   *  Pig Latin
   *
   *  Originally written in Turbo Pascal, October 25, 1992
   *  by Michal J. Wallace
   *
   *  Converted to Oberon April 17 and 22-23, 2012
   *  by Michal J. Wallace while working on a compiler. :)
   *
   *
   *  "I"ve got no strings to hold me down"
   *  -------------------------------------
   *
   *  The original pascal code defined a constant array of strings,
   *  and looped through them.
   *
   *  Strs in pascal are fixed width arrays of 255 characters,
   *  plus an extra byte at the beginning representing the length.
   *
   *  In Oberon, strings are null-terminated arrays with arbitrary
   *  lengths (as in C).
   *
   *  Oddly, while strings themselves are arrays of characters
   *  of arbitrary length, and functions can take references
   *  to arrays of arbitrary length, you can not create an
   *  array literal, nor can you define the type of an array
   *  of arbitrary-length strings.
   *
   *  Probably the "oberon way" is to just use Text as the data
   *  structure, but since I don"t have that working yet, I could
   *  also just use an "ARRAY kCount OF ARRAY kStrLen OF CHAR" ,
   *  where kStrLen is larger than the longest string we"ll use.
   *
   *  Even simpler is to just not have an array at all, and simply
   *  call the function each time. :)
   *
   *  But... That"s no fun, so instead of doing them in order, we"ll
   *  used the fixed arrays, and generate a message at random.
   *
   *)

   CONST
      kStrLen = 256;
      DEBUG = FALSE;

   TYPE
      Str* = POINTER TO StrObj;
      StrObj* = RECORD
         len   : INTEGER;
         chars : ARRAY kStrLen OF CHAR;
      END;



  (* --- PUBLIC INTERFACE --------------------------------- *)

  (* I'm inclined to put everything public at the top, but  *)
  (* the grammar forces declarations to appear first.       *)

   PROCEDURE latin*( chars : ARRAY OF CHAR ) : Str;
   BEGIN
      RETURN translate( newStr( chars ))
   END latin;

   PROCEDURE demo*;
      VAR i, o : Str;
   BEGIN
      Out.String( "This little piggy said:" ); Out.Ln;
      Out.String( "-----------------------" ); Out.Ln;

      i :=  newStr( "Hello, good Sir. How are you today?" );
      (* i := mPhrases[ Random.roll( kStrCount )]; *)

      Out.String( "old: " );
      o := oldTranslate( i );
      o.writeLn;

      Out.String( "new: " );
      o := translate( i );
      o.writeLn;

   END demo;


   (* --- IMPLEMENTATION  --------------------------------- *)

   (* CHARS *)
   CONST vowels = "AEIOUaeiou";

   PROCEDURE charIsAlpha( ch : CHAR ) : BOOLEAN;
   BEGIN
      RETURN charIsUpCase( ch ) OR charIsLoCase( ch )
   END charIsAlpha;


   PROCEDURE charIsUpCase( ch : CHAR ) : BOOLEAN;
   BEGIN
      RETURN ( ch >= "A" ) & ( ch <= "Z" )
   END charIsUpCase;


   PROCEDURE charIsLoCase( ch : CHAR ) : BOOLEAN;
   BEGIN
      RETURN ( ch >= "a" ) & ( ch <= "z" )
   END charIsLoCase;


   PROCEDURE dnCase( ch : CHAR  ) : CHAR;
      VAR res : CHAR;
   BEGIN
      res := ch;
      IF charIsUpCase( ch )THEN
         res := CHR( ORD( ch ) + ORD( "a" ) - ORD( "A" ));
      END;
      RETURN res;
   END dnCase;


   PROCEDURE upCase( ch : CHAR  ) : CHAR;
      VAR res : CHAR;
   BEGIN
      res := ch;
      IF charIsLoCase( ch )THEN
         res := CHR( ORD( ch ) + ORD( "A" ) - ORD( "a" ));
      END;
      RETURN res;
   END upCase;


   PROCEDURE charIsAnyOf( ch : CHAR; VAR chars : ARRAY OF CHAR ) : BOOLEAN;
      VAR i : INTEGER;
      VAR found : BOOLEAN;
   BEGIN
      i := 0; found := FALSE;
      WHILE (i < LEN( chars )) & ~ found DO
         IF chars[ i ] = ch THEN
            found := TRUE;
         END;
         INC( i );
      END;
      RETURN found;
   END charIsAnyOf;


   PROCEDURE charIsVowel( ch : CHAR ) : BOOLEAN;
   BEGIN
      RETURN charIsAnyOf( ch, vowels );
   END charIsVowel;


   PROCEDURE charIsConsonant( ch : CHAR ) : BOOLEAN;
   BEGIN
      RETURN charIsAlpha( ch ) & ~charIsVowel( ch );
   END charIsConsonant;


   (* STRINGS *)

   PROCEDURE newStr*( chars : ARRAY OF CHAR ) : Str;
      VAR res : Str;
   BEGIN
      NEW( res );
      res.len := 0;
      res.extend( chars );
      RETURN res
   END newStr;


   PROCEDURE ( s : Str ) clone(): Str;
      VAR res : Str;
   BEGIN
      res := newStr( s.chars );
      res.len := s.len;
      RETURN res
   END clone;


   PROCEDURE ( s : Str ) append( ch : CHAR );
   BEGIN
      IF DEBUG THEN
         Out.String("-- append -- '");
         Out.String( s.chars );
         Out.String("' += '");
         Out.Char( ch );
         Out.Char("'");
         Out.Ln;
      END;
      ASSERT( s.len < kStrLen );
      s.chars[ s.len ] := ch;
      s.len := s.len + 1;
   END append;


   PROCEDURE ( s : Str ) extend( tail : ARRAY OF CHAR );
      VAR i : INTEGER;
   BEGIN
      IF DEBUG THEN
         Out.String("## extend ## '");
         Out.String( s.chars );
         Out.String("' += '");
         Out.String( tail );
         Out.Char("'");
         Out.Ln;
      END;
      FOR i := 0 TO LEN( tail ) - 2 DO
         s.append( tail[ i ]);
      END;
      IF DEBUG THEN Out.String("^ extend ##"); Out.Ln; END
   END extend;


   PROCEDURE ( s : Str ) extendStr( tail : Str );
      VAR i : INTEGER;
   BEGIN
      IF DEBUG THEN
         Out.String("%% EXTEND %% ");
         Out.String( s.chars );
         Out.String(" += ");
         Out.String( tail.chars );
         Out.Ln;
      END;
      FOR i := 0 TO tail.len - 1 DO
         s.append( tail.chars[ i ]);
      END;
      IF DEBUG THEN Out.String("^ extendStr ##"); Out.Ln; END;
   END extendStr;


   PROCEDURE ( s : Str ) clear;
      VAR i : INTEGER;
   BEGIN
      FOR i := 0 TO kStrLen - 1 DO
         s.chars[ 0 ] := 0X;
      END;
      s.len := 0;
   END clear;


   PROCEDURE ( s : Str ) write();
   BEGIN
      Out.String( s.chars );
   END write;


   PROCEDURE ( s : Str ) writeLn();
   BEGIN
      Out.String( s.chars );
      Out.Ln;
   END writeLn;


   PROCEDURE ( s : Str ) delete( start, count : INTEGER );
      VAR i, len : INTEGER;
   BEGIN
      len := s.len;
      FOR i := 0 TO len - count DO
         
         s.chars[ i ] := s.chars[ i + 1 ];
      END;
      s.len := s.len - count;
   END delete;


   PROCEDURE strUp( s : Str ) : Str;
      VAR i   : INTEGER;
          res : Str;
   BEGIN
      res := s.clone();
      FOR i := 0 TO LEN( s.chars )-1 DO
         res.chars[ i ] := upCase( s.chars[ i ])
      END;
      RETURN res
   END strUp;


   PROCEDURE ( str : Str ) strIsAllCons( ) : BOOLEAN;
      VAR i   : INTEGER;
          res : BOOLEAN;
   BEGIN
      i := 0;
      res := TRUE;
      WHILE res & (i < LEN( str.chars )) DO
         IF charIsConsonant( str.chars[ i ]) THEN res := FALSE END;
         INC( i )
      END;
      RETURN res
   END strIsAllCons;


   PROCEDURE ( str : Str ) hasVowels( ) : BOOLEAN;
      VAR i     : INTEGER;
          found : BOOLEAN;
   BEGIN
      i := 0;
      found := FALSE;
      REPEAT
         IF charIsVowel( str.chars[ i ]) THEN
            found := TRUE
         END;
         INC( i )
      UNTIL found OR ( i = LEN( str.chars ));
      RETURN found
   END hasVowels;


   PROCEDURE oldTranslate*( str : Str ) : Str;

      (* This is my old algorithm from high school. It's shorter,
       * but also more confusing and less efficient.
       *
       * Basically, it's buffering all the letters in each word,
       * and then rotating them around at the end.
       *
       * Also, I converted everything to uppercase... Probably
       * the assignment suggested that, so we didn't have to deal
       * with capitalization.
       *
       * I've changed the names of the variables (they were just
       * letters) and the functions (trying to move toward a more
       * class-centric style, hence the prefixes)... Other than
       * the names, though, this is a direct translation of  my
       * ancient pascal code. (All of the comments are also new.)
       *)

      VAR caps, buf, res : Str;
      VAR ch : CHAR;
      VAR r  : INTEGER;

   BEGIN

      NEW( buf );
      NEW( res );
      caps := strUp( str );
      r := -1;  (* Position the "read" cursor before first char. *)

      WHILE r < caps.len DO
         INC( r );

         (* The read cursor is on an alpha character or apostophe: buffer it. *)
         IF ( caps.chars[ r ] >= "A" ) & ( caps.chars[ r ] <= "Z" )
         OR ( caps.chars[ r ] = "'" ) THEN

            buf.append( caps.chars[ r ]);

         ELSE

            (* The read cursor is outside of a word. If there's a buffer, dump it. *)
            (* First consider buffers starting with consonants: *)
            IF charIsConsonant( buf.chars[ 0 ]) THEN

               (* If there are vowels, move the consonants to the end.        *)
               (* The check prevents an infinite loop if there are no vowels. *)
               IF strHasVowels( buf ) THEN
                  WHILE charIsConsonant( buf.chars[ 0 ]) DO
                     ch := buf.chars[ 0 ];
                     buf.delete( 0, 1 );
                     buf.append( ch );
                  END
               END ;

               (* If there was a vowel, it's now the first char. Append "AY" *)
               IF charIsVowel( buf.chars[ 0 ]) THEN
                  buf.extend( "AY" );

                  (* Otherwise, it was all consonants. The check here is unecessary. *)
                  (* It's included only to be faithful to the old code.              *)
               ELSIF strIsAllCons( buf ) THEN
                  buf.extend( "YAY" );
               END

            (* now consider buffers that start with a vowel (or a "Y") *)
            ELSIF charIsVowel( buf.chars[ 0 ]) THEN
               IF buf.chars[ 0 ] = "Y" THEN
                  buf.delete( 0, 1 );
               END;
               buf.extend( "YAY" );

            ELSE
               (* the buffer was empty, so do nothing. *)
            END;

            (* now append the buffer (even if it's empty!) and the current char. *)
            res.extendStr( buf );
            res.append( caps.chars[ r ]);

            (* and finally, clear out the buffer -- again, even if it's empty.   *)
            buf.clear();
         END
      END ;
      RETURN res
   END oldTranslate;



   PROCEDURE translate( str : Str ) : Str;

     (* Here's how I chose to implement the algorithm today, before
      * deciphering the above code. It's a straightforward loop
      * through the input string, and only the initial consonants
      * in a word are buffered.
      *)

      CONST
         outside = 0;  (* copy whitespace / punctuation *)
         capture = 1;  (* buffer the initial consonants *)
         inside  = 2;  (* inside a word, so just copy.  *)

      VAR
         state      : INTEGER; (* one of the above states *)
         capitalize : BOOLEAN; (* captitalize the current word? *)
         res, buf   : Str;     (* result and buffer *)

         ch         : CHAR;    (* loop character *)
         r          : INTEGER; (* loop index *)

   BEGIN

      NEW( buf );
      NEW( res );

      capitalize := FALSE;
      state := outside;

      FOR r := 0 TO str.len DO

         ch := str.chars[ r ];
         ASSERT( state IN { outside, inside, capture });

         (* -- planning phase --*)

         (* handle letters *)
         IF charIsAlpha( ch ) THEN

            (* handle /first/ letter of a word *)
            IF state = outside THEN
               capitalize := charIsUpCase( ch );
               IF capitalize THEN ch := dnCase( ch ) END
            END;

            (* and of course pig latin treats vowels and consonants separately *)
            IF charIsVowel( ch ) THEN
               CASE state OF
               | outside : buf.append( "y" );
               | inside  :
               | capture :
               END;
               state := inside;
            ELSIF state = outside THEN  (* initial consonant *)
               state := capture;
            END
         ELSE
            (* We're outside a word. If we /just/ left, emit the suffix. *)
            IF state = inside THEN
               state := outside;
               res.extendStr( buf );
               res.extend( "ay" );
               buf.clear();
            END
         END;

         (* -- action phase --*)

         CASE state OF
         | outside : res.append( ch );
         | capture : buf.append( ch );
         | inside  :
            IF capitalize THEN
               ch := upCase( ch );
               capitalize := FALSE;
            END;
            res.append( ch );
         END;

         IF DEBUG THEN
            Out.Char( ch );
            Out.Int( state, 2 );
            Out.String("' : '"); Out.String( res.chars );
            Out.String("' : '"); Out.String( buf.chars );
            Out.Ln;
         END
      END;
      RETURN res
   END translate;

BEGIN
   demo();
END Pig.

(* --- INITIALIZATION ----------------------------------- *)

VAR
   gPhraseCount : ARRAY 20 OF Str;

PROCEDURE register( s : ARRAY OF CHAR );
BEGIN
   INC(gCounter);
END register;


BEGIN

   (*
    * Module initialization. We"re just registering quotes here.
    *
    * The first few are from the original code. They were probably
    * BBS taglines. I guess I thought they were clever. :)
    *
    * Note that the first one has both an apostrophe and a word with
    * no vowels (TV).
    *)

   (* #0 - #5 *)
   register( "I'm not an actor... But I play one on TV. ");
   register( "Life is like an analogy. ");
   register( "We should strive for immortality, or die trying. ");
   register( "Anyone who sees a shrink should have his head examined. ");
   register( "Time is an illusion; lunchtime doubly so. -- Douglas Adams. ");

   (*
    * There was also a dumb comment about Mr Rogers, for which I
    * hang my head in shame. :/
    *
    * To make up for my youthful ignorance, here are a few words
    * of wisdom from various smart people.
    *
    * I would hope that my compiler is wise enough to concatenate
    * these string constants at compile time. :)
    *)

   (* #6 *)
   register("Instead of imagining that our main task is to instruct a " +
            "computer what to do, let us concentrate rather on explaining " +
            "to human beings what we want a computer to do. " +
            "-- Donald Knuth ");
   (* #7 *)
   register("The reasonable man adapts himself to the world. The unreasonable " +
            "man persists in trying to adapt the world to himself. Therefore, "+
            "all progress depends on the unreasonable man. " +
            "-- George Bernard Shaw ");
   (* #8 *)
   register("It is better to have 100 functions operate on one data " +
            "structure than 10 functions on 10 data structures. " +
            "-- Alan Perils ");
   (* #9 *)
   register("The Oberon System is distinguished ... by a highly flexible " +
            "scheme of command activation ... [and] most importantly, by "+
            "the virtual absence of hidden states. " +
            "-- Nicklaus Wirth and Jurg Gutknecht, (Project Oberon)");
   (* #10 *)
   register("Complexity puts a limit to the level of understanding of the " +
            "system a person might reach, and therefore limits the things " +
            "that can be done with it. -- Juan Vuletich (Cuis) ");
   (* #11 *)
   register("If a system is to serve the creative spirit, it must be "+
            "entirely comprehensible to a single individual." +
            "-- Dan Ingalls (Design Principles behind Smalltalk-80)");
   (* #12 *)
   register("The line is a stark data structure and everywhere it is passed "+
            "there is much duplication of process. It is a perfect vehicle "+
            "for hiding information. -- Alan Perlis ");
   (* #13 *)
   register("A really good language should be both clean and dirty: cleanly "+
            "designed, with a small core of well understood and highly "+
            "orthogonal operators, but dirty in the sense that it lets "+
            "hackers have their way with it... A real hacker's language will "+
            "always have a slightly raffish character. -- Paul Graham (Arc) ");
   (* #14 *)
   register("The best way to predict the future is to invent it. "+
            "-- Alan Kay ( Smalltalk, Squeak )" );
   (* #15 : One for the haters... :) *)
   register("At the other end of the continuum are languages like Ada and "+
            "Pascal, models of propriety that are good for teaching and "+
            "not much else. -- Paul Graham ");

   (* Th-tha-th-that's all, folks!  *)

   (* ... except that for oxford oberon, you put the program main() here, too... *)
   demo();

END Pig.