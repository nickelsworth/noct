import org.antlr.runtime.*;
import org.antlr.runtime.tree.*;
import java.io.*;

/**
 * see parseo7.sh for usage
 */
class DumpAST
{
    public static void main( String[] args ) throws Exception
    {
	CommonTree ast;
	CommonTokenStream tokens;
	Oberon07Parser parser;
	
	// build the lexer:
	tokens =
            new CommonTokenStream(
	        new Oberon07Lexer(
	            new ANTLRInputStream(System.in)));

	// build the parser:
	parser =  new Oberon07Parser(tokens);
	
	// parse the input stream from stdin:
	ast = (CommonTree) parser.module().getTree();
	
	// dump to stdout:
	System.out.println( ast.toStringTree( ));
    }
}
