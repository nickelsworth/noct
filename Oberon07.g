
grammar Oberon07;

options
{
    output = AST;
}

tokens
{
    ADD;
    ASSIGN;
    ARGS;         // indicates (), even if the arg list is empty (as opposed to implicit invoke)
    ATTR;
    BLOCK;        // a block of statemetns
    COND;
    DECLARE;
    DEREF;        // dereference a pointer
    EXTENDS;      
    GROUP;        // expr grouping (i.e., parentheses)
    GUARD;
    HEXCHAR;
    INDEX;
    INVOKE;
    MUL;
    NEG;
    NOT;
    PASS;         // an empty block
    POS;
    PUBLIC;       // makred public with the '*' marker
    QUAL;         // qualified name
    RETURNS;      // return type
    SET_LIT;      // set literal (e.g., {0, 1..3})
    SIGNATURE;    // parameter list
    STRING;
    SUB;
}


@header
{
   import java.util.HashSet;
}


@members
{
   // add_module and is_module for qualident rule:
   
   private HashSet<String> known_modules = initial_modules();
   
   static HashSet initial_modules()
   {
       HashSet<String> set = new HashSet<String>();
       set.add("BUILTINS");
       return set;
   }
   
   void add_module(String s)
   {
       this.known_modules.add(s);
   }
   
   boolean is_module(String s)
   {
       boolean res = this.known_modules.contains(s);
       return res;
   }
   
   
   private HashSet<String> known_types = initial_types();
   
   static HashSet initial_types()
   {
       HashSet<String> set = new HashSet<String>();
       set.add("BOOLEAN");
       set.add("CHAR");
       set.add("INTEGER");
       set.add("REAL");
       set.add("LONGREAL");
       set.add("SET");
       return set;
   }
   
   
   void add_type(String s)
   {
       this.known_types.add(s);
   }
     
     
   boolean is_type(String s)
   {
       return this.known_types.contains(s);
   }
     
   // suppose we see Mod.X ... Is it a type or a const?
   // No way to know unless we've already parsed Mod.
   // Since we're just pretty-printing, though, we don't really care.
   boolean is_known(String s)
   {
       return this.is_module(s) || this.is_type(s);
   }
   

   // add_type and is_type for typeguard rule:
   
}

// 3. Vocabulary
//    (Put the keywords up top or else ANTLR will lex them as identifiers)
  
ARRAY      : 'ARRAY';
BEGIN      : 'BEGIN';
BY         : 'BY';      // new in oberon-07
CASE       : 'CASE';
CONST      : 'CONST';
DIV        : 'DIV';
DO         : 'DO';
ELSE       : 'ELSE';
ELSIF      : 'ELSIF';
END        : 'END';
FALSE      : 'FALSE';  // new as token in 07
FOR        : 'FOR';    // for statement added in 07
IF         : 'IF';
IMPORT     : 'IMPORT';
IN         : 'IN';
IS         : 'IS';
MOD        : 'MOD';
MODULE     : 'MODULE';
NIL        : 'NIL';
OF         : 'OF';
OR         : 'OR';
POINTER    : 'POINTER';
PROCEDURE  : 'PROCEDURE';
RECORD     : 'RECORD';
REPEAT     : 'REPEAT';
RETURN     : 'RETURN';
THEN       : 'THEN';
TO         : 'TO';
TRUE       : 'TRUE';   // new as token in 07
TYPE       : 'TYPE';
UNTIL      : 'UNTIL';
VAR        : 'VAR';
WHILE      : 'WHILE';
  
  
AND        : '&';
BANG       : '!';
BECOMES    : ':=';
CARET      : '^';
COLON      : ':';
COMMA      : ',';
DOT        : '.';
EQ         : '=';
GE         : '>=';
GT         : '>';
LBRACK     : '[';
LCURLY     : '{';
LE         : '<=';
LPAREN     : '(';
LT         : '<';
DASH       : '-';
NE         : '#';
PIPE       : '|';
PLUS       : '+';
RAT        : '/';
RBRACK     : ']';
RCURLY     : '}';
RPAREN     : ')';
SEMI       : ';';
STAR       : '*';
TILDE      : '~';
UPTO       : '..';
  
//     (then char literals so they don't get lexed as a number)
HexChar
    : HexDigit+ 'X'
    ;

//    (Other lexer rules)
fragment Letter
    : 'A'..'Z'
    | 'a'.. 'z'
    ;

fragment Digit
    : '0' | '1' | '2' | '3' | '4' | '5' | '6' | '7' | '8' | '9'
    ;

Ident
    : Letter (Letter | Digit)*
    ;

number
    : HexInt | Integer | Real
    ;

fragment HexDigit
    : Digit | 'A' | 'B' | 'C' | 'D' | 'E' | 'F'
    ;

fragment H
    : 'H'
    ;

HexInt
    : Digit HexDigit+ H
    ;

Integer
    : Digit+
    ;

fragment ScaleFactor
    : ('E' | 'D') ('+' | '-')? Digit+
    ;

Real
    : Digit+ '.' Digit* ScaleFactor?
    ;

string
    : Quoted
      -> ^(STRING Quoted)
    | HexChar
      -> ^(HEXCHAR HexChar)
    ;

Quoted
    :  '"' ~('"')* '"'
    ;

WS
    : (' ' | '\t' | NEWLINE)
      { $channel = HIDDEN; }
    ;
fragment NEWLINE
    : '\r' ? '\n'
    ;

Comment
    : ( '%'  .* NEWLINE | '(*' .* '*)' )
      { $channel = HIDDEN; }
    ;


// 4. Declarations and Scope Rules
new_ident
    : (Ident STAR)=> Ident STAR
      -> ^(PUBLIC Ident)
    | Ident
    ;

qualident
    : i=Ident ({is_module($i.text)}? DOT^ Ident)?
    ;


// 5. Constant declarations
const_decl
    : new_ident EQ^ const_expr
    ;

const_expr
    : expr
    ;


// 6. Type declarations
type_decl
    : new_ident EQ^ structure
    ;

structure
    : array_type
    | record_type
    | pointer_type
    | proc_type
    ;

type
    : qualident
    | structure
    ;


// 6.1 basic types
//    (no rules defined)
// 6.2 Array Types
array_type
    : (ARRAY length (COMMA length)* OF type)
      -> ^(ARRAY type length+)
    ;

length
    : const_expr
    ;

// 6.3 Record Types
record_type
    : RECORD^ base_type? fields? END!
    ;

base_type
    : LPAREN qualident RPAREN
      -> ^(EXTENDS qualident)
    ;

fields
    : typed_idents (SEMI! typed_idents)*
    ;

// 6.4 Pointer Types
pointer_type
    : POINTER^ TO! type
    ;

// 6.5 procedure-types
proc_type
    : PROCEDURE^ signature? rtype?
    ;


// 7. variable Declarations
typed_idents
    : new_idents COLON type
      -> ^(DECLARE type new_idents)
    ;

new_idents
    : new_ident (COMMA! new_ident)*
    ;

var_decl
    : typed_idents
    ;



// 8. Exprs
// 8.1 Operands
designator
    : chain
    ;

head
    : qualident
    ;

chain
    : (head -> head) // special antlr syntax for postfix chains. see p 188 in defin. antlr ref.
      ( DOT Ident
         -> ^(ATTR $chain Ident)
      | LBRACK exprs RBRACK
         -> ^(INDEX $chain exprs)
      | CARET
         -> ^(DEREF $chain)
      | BANG wanted_type=qualident
         -> ^(GUARD $wanted_type $chain)
      )*
    ;

exprs
    : expr (COMMA! expr)*
    ;

// 8.2 Operators
expr
    : simple (relation^ simple)?
    ;

relation
    : EQ | NE | LT | LE | GT | GE | IN | IS
    ;

simple
    : signed_term (add_op^ term)*
    ;


signed_term
    : PLUS  term -> ^(POS term) 
    | DASH  term -> ^(NEG term) 
    | term
    ;
  
add_op
    : PLUS->ADD | DASH->SUB | OR
    ;

term
    : factor (mul_op^ factor)*
    ;

mul_op
    : STAR -> MUL 
    | RAT
    | DIV
    | MOD
    | AND
    ;

factor
    : literal
  
    | (designator args)=> designator args
       -> ^(INVOKE designator args)
  
    | designator
          
    | LPAREN expr RPAREN
       -> ^(GROUP expr)
  
    | TILDE factor
       ->  ^(NOT factor)
    ;
  
literal
    : number
    | string
    | NIL
    | TRUE
    | FALSE
    | set
    ;

set
    : LCURLY (element (COMMA element)*)? RCURLY
      -> ^(SET_LIT element*)
    ;

element
    : expr (UPTO^ expr)?
    ;

args
    : LPAREN (exprs)? RPAREN -> ^(ARGS exprs?)
    ;



// 9. Statements
statement
    : (assign)=> assign
    | invoke
    | if_stmt
    | case_stmt 
    | while_stmt
    | repeat_stmt
    | for_stmt
    ; 

// 9.1 Assignments
assign
   : designator BECOMES expr
      -> ^(ASSIGN designator expr)
   ;

// 9.2 Procedure calls

// as a standalone statement, the parens are optional
invoke
    : designator args?
      -> ^(INVOKE designator args?)
    ;

// 9.3 Statement sequences
block
   : statement (SEMI statement)* SEMI?
     -> ^(BLOCK statement+)
   | 
     -> PASS
   ;

// 9.4 IF statements
if_stmt
    : IF^ ifthen
      elif_clause*
      else_clause?
      END!
    ;
ifthen
    : expr THEN block -> ^(COND expr block)
    ;
elif_clause
    : ELSIF! ifthen
    ;
else_clause
    : ELSE^ block
    ;

// 9.5 CASE statements
case_stmt
   : CASE expr OF a_case (PIPE a_case)* END
     -> ^(CASE expr a_case+)
   ;

a_case
   : (case_labels COLON^ block)?
   ;

case_labels
   : label_range (COMMA! label_range)*
   ;

label_range
   : label (UPTO^ label)*
   ;

label
   : Integer
   | string
   | Ident
   ;

// 9.6 WHILE statements
while_stmt
    : WHILE^ expr DO!
         block
      elsif_block*
      END!
    ;
elsif_block
    : ELSIF^ expr DO! 
         block
    ;

// 9.7 Repeat statements.
repeat_stmt
    : REPEAT^ block UNTIL expr
    ;

// 9.8 For statements
for_stmt
    : FOR^ Ident BECOMES! expr TO! expr (BY! const_expr)? DO!
           block
      END!
    ;
    


// 10. Procedure Declarations
proc_decl
    : PROCEDURE^ new_ident signature? rtype? SEMI!
      decls
      begin?
      return_stmt?
      END! Ident!
    ;

decls
    : (consts | types | vars)* procs?
    ;

consts
    : CONST^ (const_decl SEMI!)*
    ;

types
    : TYPE^ (type_decl SEMI!)*
    ;

vars
    : VAR^ (var_decl SEMI!)*
    ;

procs
    : (proc_decl SEMI!)+
    ;

begin
   : BEGIN^ block
   ;

return_stmt
    : RETURN^ expr
    ;

// 10.1. Formal Parameters
signature
    : LPAREN (param (SEMI param)*)? RPAREN
       -> ^(SIGNATURE param*)
    ;

param
    : VAR^ param
    | Ident(COMMA! Ident)* COLON! formal_type^
    ;

formal_type
    : (ARRAY OF)* qualident
    ;

rtype
    : COLON qualident
       -> ^(RETURNS qualident)
    ;



// 11. Modules
module
    : MODULE^ mod=Ident SEMI!
      {
         add_module($mod.text);
      }
      imports?
      decls
      begin?
      END! Ident! DOT!
    ;

imports
    : IMPORT^ module_name (COMMA! module_name)* SEMI!
    ;

module_name
    : name=Ident (BECOMES^ Ident)?
      {
         add_module($name.text);
      }
    ;


aaa : module; // for stupid dropdown in ANTLRWorks
