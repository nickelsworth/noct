
tree grammar OberonEmitter;

options
{
    tokenVocab = Oberon07;
    ASTLabelType = CommonTree;
    output = template;
}
  
@header
{
  import org.antlr.runtime.*;
  import org.antlr.runtime.tree.*;
  import org.antlr.stringtemplate.*;
  import java.io.*;
}
   
@members
{

      
      public static void main(String[] args) throws IOException, RecognitionException, FileNotFoundException
      {
        
         // CONST
         String stg_load_path = ".gen"; // colon-separated string
      
         // VAR
         CommonTokenStream tokens;
         CommonTreeNodeStream nodes;
         CommonTree ast;
        
         Oberon07Parser parser;
         OberonEmitter emitter;
        
        
       
         // BEGIN 
        
         // build the lexer:
         tokens = new CommonTokenStream(
            new Oberon07Lexer(
               new ANTLRInputStream(System.in)));
        
        
         // build the parser:
         parser =  new Oberon07Parser(tokens);
        
         // parse the input stream:
         ast = (CommonTree) parser.module().getTree();
        
         // turn the ast into a stream of nodes:
         nodes = new CommonTreeNodeStream(ast);
         nodes.setTokenStream(tokens);
        
         // hook the node stream up to the emitter:
         emitter = new OberonEmitter(nodes);
        
      
      
         //  StringTemplate part:
         StringTemplate result;
         StringTemplateGroup stg;
         StringTemplateGroupLoader loader;
         String main_stg_path;
      
  
  /*      
         // You need all this junk to allow template inheritance:
         loader = new CommonGroupLoader(main_stg_path, 
             new StringTemplateErrorListener()
             {
                public void error(String msg, Throwable e)
                { 
                   System.out.println(msg + ":" + e.toString());
                }
                public void warning(String msg)
                { 
                   System.out.println(msg);
                }
             }
         );
         StringTemplateGroup.registerGroupLoader(loader);
    
         // now we can load the main  language template
         // stg = StringTemplateGroup.loadGroup("Oberon");
  */
      
         // configure the template group to use:
         main_stg_path = (args.length == 1)? args[0] : ".gen/Oberon.stg";
         stg = new StringTemplateGroup(new FileReader(main_stg_path));
        
         // finally, hook the template to the emitter and generate output:
         emitter.setTemplateLib(stg);
         result = (StringTemplate) emitter.emit().getTemplate();
         System.out.println(result.toString());
      
      }
          
    
  public String getErrorMessage(RecognitionException e,
                                String[] tokenNames)
  {
      List stack = getRuleInvocationStack(e, this.getClass().getName());
      String msg = null;
      if ( e instanceof NoViableAltException ) {
          NoViableAltException nvae = (NoViableAltException)e;
          msg = " no viable alt; token="+e.token+
              " (decision="+nvae.decisionNumber+
              " state "+nvae.stateNumber+")"+
              " decision=";
      }
      else
      {
          msg = super.getErrorMessage(e, tokenNames);
      }
      return stack+" "+msg;
  }
  public String getTokenErrorDisplay(Token t)
  {
      return t.toString();
  }
}
  
  
emit
    : module -> emit(data={$module.st})
    ;
  
ident
    : Ident  -> ident(name={$Ident.text})
    ;

new_ident
    : ^(PUBLIC pub=ident)           -> new_public(ident={$pub.st})
    | priv=ident                    -> {$priv.st}
    ;

qualident
    : ^('.' a=ident b=ident)  -> qualident(mod={$a.st}, ident={$b.st})
    | ident -> {$ident.st}
    ;

typed_idents
    : ^(DECLARE type names+=new_ident+)   -> declare(type={$type.st}, names={$names})
    ;

const_decl
    : ^(EQ id=new_ident expr)       -> declare_const(name={$id.st}, value={$expr.st})
    ;

type_decl
    : ^(EQ new_ident structure)  -> declare_type(name={$new_ident.st}, structure={$structure.st})
    ;

structure
    : a=array_type    -> {$a.st}
    | r=record_type   -> {$r.st}
    | po=pointer_type -> {$po.st}
    | pr=proc_type    -> {$pr.st}
    ;

type
    : q=qualident  -> {$q.st}
    | s=structure  -> {$s.st}
    ;

array_type
    : ^(ARRAY type dims+=expr+) -> array_type(dims={$dims}, of_type={$type.st})
    ;

record_type
    : ^(RECORD base=base_type? fields+=typed_idents*)
      -> record_type(base={$base.st}, fields={$fields})
    ;

base_type
    : ^(EXTENDS qualident) -> based_on(qual={$qualident.st})
    ;

pointer_type
    : ^(POINTER type) -> pointer_to(type={$type.st})
    ;

proc_type
    : ^(PROCEDURE sig=signature? ret=return_type?) -> proc_type(sig={$sig.st}, ret={$ret.st})
    ;

var_decl
    : ids=typed_idents -> {$ids.st}
    ;

designator
    : chain -> {$chain.st}
    ;

head
    : qualident -> {$qualident.st}
    ;

chain
    : head -> {$head.st}
    | ^(ATTR   a=chain ident)             -> getattr(obj={$a.st}, attr={$ident.st})
    | ^(INDEX  i=chain keys+=expr+)       -> index(obj={$i.st}, keys={$keys})
    | ^(DEREF  d=chain)                   -> deref(obj={$d.st})
    | ^(GUARD  g=chain wanted=qualident)  -> type_guard(obj={$g.st}, wanted={$wanted.st})
    ;

expr
    : designator -> {$designator.st}
    | literal -> {$literal.st}
    | unary -> {$unary.st}
    | binop -> {$binop.st}
    | ^(GROUP exp=expr)                   -> grouped(expr={$exp.st})
    | invoke -> {$invoke.st}
    ;

literal
    : HexInt                      -> literal_hex(hex={$HexInt.text})
    | Integer                     -> literal_int(int={$Integer.text})
    | Real                        -> literal_num(num={$Real.text})
    | NIL                         -> literal_null()
    | TRUE                        -> literal_true()
    | FALSE                       -> literal_false()
    | ^(STRING Quoted)            -> literal_str(str={$Quoted.text})
    | ^(HEXCHAR HexChar)          -> literal_chr(chr={$HexChar.text})
    ;


set_literal
    : ^(SET_LIT members+=elem*)   -> literal_set(members={$members})
    ;

elem
    : ('..' lo=expr hi=expr)      -> range(lo={$lo.st}, hi={$hi.st})
    | expr                         -> {$expr.st}
    ;


unary
    : ^(POS expr)       -> positive(expr={$expr.st})
    | ^(NEG expr)       -> negative(expr={$expr.st})
    | ^(NOT expr)       -> inverted(expr={$expr.st})
    ;

binop
    : ^(EQ a=expr b=expr)     -> op_eq(a={$a.st}, b={$b.st})
    | ^(NE a=expr b=expr)     -> op_ne(a={$a.st}, b={$b.st})
    | ^(LT a=expr b=expr)     -> op_lt(a={$a.st}, b={$b.st})
    | ^(GT a=expr b=expr)     -> op_gt(a={$a.st}, b={$b.st})
    | ^(LE a=expr b=expr)     -> op_le(a={$a.st}, b={$b.st})
    | ^(GE a=expr b=expr)     -> op_ge(a={$a.st}, b={$b.st})
    | ^(IN a=expr b=expr)     -> op_in(a={$a.st}, b={$b.st})
    | ^(IS a=expr b=expr)     -> op_is(a={$a.st}, b={$b.st})
    | ^(ADD a=expr b=expr)    -> op_add(a={$a.st}, b={$b.st})
    | ^(SUB a=expr b=expr)    -> op_sub(a={$a.st}, b={$b.st})
    | ^(RAT a=expr b=expr)    -> op_rat(a={$a.st}, b={$b.st})
    | ^(MUL a=expr b=expr)    -> op_mul(a={$a.st}, b={$b.st})
    | ^(DIV a=expr b=expr)    -> op_div(a={$a.st}, b={$b.st})
    | ^(MOD a=expr b=expr)    -> op_mod(a={$a.st}, b={$b.st})
    | ^(AND a=expr b=expr)    -> op_and(a={$a.st}, b={$b.st})
    | ^(OR a=expr b=expr)     -> op_or(a={$a.st}, b={$b.st})
    ;

statement
    : a=assign -> {$a.st}
    | v=invoke -> {$v.st}
    | i=if_stmt -> {$i.st}
    | c=case_stmt -> {$c.st}
    | w=while_stmt -> {$w.st}
    | r=repeat_stmt -> {$r.st}
    | f=for_stmt -> {$f.st}
    ; 

assign
    : ^(ASSIGN designator expr)  -> assign(obj={$designator.st}, expr={$expr.st})
    ;

invoke
    : ^(INVOKE designator args?)  -> invoke(obj={$designator.st}, args={$args.st})
    ;

args
    : ^(ARGS exps+=expr*)                 -> args(args={$exps})
    ;

block
    : ^(BLOCK stmts+=statement*)         -> block(stmts={$stmts})
    | PASS                               -> pass()
    ;

if_stmt
    : ^(IF conds+=if_cond+ el=block?)
        -> if_stmt(conds={$conds}, else_block={$el.st})
    ;

if_cond
    : ^(COND expr block)    -> if_cond(expr={$expr.st}, block={$block.st})
    ;

case_stmt
    : ^(CASE expr cases+=a_case) -> case_stmt(expr={$expr.st}, cases={$cases})
    ;

a_case
    : ^(':' labels+=elem+ block) -> a_case(labels={$labels}, block={$block.st})
    ;

while_stmt
    : ^(WHILE expr block elifs+=elsif_do*)
      -> while_stmt(cond={$expr.st}, block={$block.st}, elifs={$elifs})
    ;

elsif_do
   : ^(ELSIF expr block)   -> elsif_do(cond={$expr.st}, block={$block.st})
   ;

repeat_stmt
    : ^(REPEAT block UNTIL expr)  -> repeat_stmt(block={$block.st}, expr={$expr.st})
    ;

for_stmt
    : ^(FOR id=ident beg=expr end=expr step=expr? block)
          -> for_stmt(id={$id.st}, beg={$beg.st}, end={$end.st}, step={$step.st}, block={$block.st})
    ;

declaration
    : ^(CONST consts+=const_decl+)     -> consts(consts={$consts})
    | ^(TYPE types+=type_decl+)        -> types(types={$types})
    | ^(VAR vars+=var_decl+)           -> vars(vars={$vars})
    | procedure                         -> {$procedure.st}
    ;

procedure
    : ^(PROCEDURE id=new_ident sig=signature? rtyp=return_type?
             decs+=declaration*
             beg=begin? 
             ret=return_stmt?)
      -> procedure(id={$id.st}, sig={$sig.st}, rtyp={$rtyp.st}, decs={$decs}, beg={$beg.st}, ret={$ret.st})
    ;

signature
    : ^(SIGNATURE ps+=param*)       -> signature(params={$ps})
    ;

param
    : ^(VAR p=param)                    -> var_param(param={$p.st})
    | ^(t=formal_type names+=ident+)   -> param(type={$t.st}, names={$names})
    ;

formal_type
    : (ARRAY OF t=formal_type)         -> array_of(type={$t.st})
    |  qualident                        -> {$qualident.st}
    ;

return_type
    : ^(RETURNS q=qualident)       -> return_type(type={$q.st})
    ;


begin
    : ^(BEGIN block) -> begin(block={$block.st})
    ;

return_stmt
    : ^(RETURN expr) -> return_stmt(value={$expr.st})
    ;

module
    : ^(MODULE ident imp=import_stmt? decs+=declaration* beg=begin?)
       -> module(mod={$ident.st}, imp={$imp.st}, decs={$decs}, beg={$beg.st})
    ;

import_stmt
    : ^(IMPORT mods+=module_name*)  -> import_stmt(mods={$mods})
    ;

module_name
    : ident -> {$ident.st}
    | ^(':=' nick=ident mod=ident) -> import_as(mod={$mod.st}, nick={$nick.st})
    ;
