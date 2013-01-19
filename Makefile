#=[ configuration ]========================================================
#
# You can override these on the command line. Example:
#
#     $ make emit emit.mod=/r/oberon/  emit.stg=.gen/Java.stg
#
#--------------------------------------------------------------------------
gen        = .gen    # output directory for generated files
JDK        = /usr/src/jdk1.7.0_10
JAVA       = "$(JDK)/bin/java"
JAVAC      = "$(JDK)/bin/javac"

antlrjar3  = lib/antlr-3.4-complete.jar
javac      = $(JAVAC)
java       = $(JAVA)

antlr3      = $(java) -cp "$(antlrjar3);$(gen)" org.antlr.Tool -o $(gen)
gunit      = $(java) org.antlr.gunit.Interp


#--------------------------------------------------------------------------

# default rule:
main: oberon.test

clean:
	rm $(gen)/*.java

# default arguments for "make emit":
emit_mod   = ./oberon/test/ReformatMe.mod
emit_stg   = $(gen)/Oberon.stg

# command line tools:

javac:
	$(javac)
gunit:
	$(gunit)

# oberon stuff:


$(gen)/Oberon07Parser.java: $(ob_g)
	$(antlr3) $(ob_g)
$(gen)/Oberon07Parser.class: $(gen)/Oberon07Parser.java
	$(javac) $(gen)/Oberon07*.java


$(gen)/OberonEmitter.java: $(gen)/Oberon07Parser.java $(gen)/OberonEmitter.g 
	$(antlr3) $(gen)/OberonEmitter.g
$(gen)/JavaEmitter.java: $(gen)/OberonEmitter.java $(gen)/JavaEmitter.g
	$(antlr3) $(gen)/JavaEmitter.g


$(gen)/OberonEmitter.class: $(gen)/OberonEmitter.java
	$(javac) $(gen)/OberonEmitter.java
$(gen)/JavaEmitter.class: $(gen)/JavaEmitter.java
	$(javac) $(gen)/JavaEmitter.java



# pascal backend:

pascal : $(gen)/pascal.pas $(gen)/BUILTINS.pas
	$(fpc) $(gen)/pascal.pas

pascal.pas : $(gen)/pascal.pas
	$(cat)  $(gen)/pascal.pas

builtins.pas : $(gen)/BUILTINS.pas
	$(cat)  $(gen)/BUILTINS.pas


pig     : Pig.pas
	$(fpc) $outdir/Pig.pas
pig.pas : $(gen)/Pig.pas
	$(cat)  $(gen)/Pig.pas

$(gen)/BUILTINS.pas: oberon.emitter $(gen)/Pascal.stg oberon/BUILTINS.mod
	$(java) OberonEmitter $(gen)/Pascal.stg < oberon/BUILTINS.mod | $(tail) -n +1 >  $(gen)/BUILTINS.pas

$(gen)/pascal.pas: oberon.emitter $(gen)/Pascal.stg oberon/test/pascal.mod
	$(java) OberonEmitter $(gen)/Pascal.stg < oberon/test/pascal.mod | $(tail) -n +1 > $(gen)/pascal.pas

$(gen)/Pig.pas: oberon.emitter $(gen)/Pascal.stg work/Pig.mod
	$(java) OberonEmitter $(gen)/Pascal.stg < work/Pig.mod | $(tail) -n +1 > $(gen)/Pig.pas


# shortcuts:


oberon       : $(gen)/Oberon07Parser.java
oberon.bin   : $(gen)/Oberon07Parser.class
oberon.test  : oberon.bin
	$(gunit) $(gen)/Oberon07.gunit

oberon.emitter: $(gen)/OberonEmitter.class 
java.emitter: $(gen)/JavaEmitter.class

emit: oberon.emitter
	$(java) OberonEmitter $(emit_stg) < $(emit_mod)


# this is a complete hack to make gunit use the emitter:
#$(gen)/OberonEmitterLexer.class : $(gen)/OberonEmitterLexer.java
#	$(javac) $(gen)/OberonEmitterLexer.java
#$(gen)/OberonEmitterLexer.java : $(gen)/Oberon07Lexer.java
#	$(python) tools/gen_emitter_lexer.py
#
#$(gen)/OberonEmitterParser.class : $(gen)/OberonEmitterParser.java
#	$(javac) $(gen)/OberonEmitterParser.java
#$(gen)/OberonEmitterParser.java : $(gen)/Oberon07Parser.java
#	$(python) tools/gen_emitter_lexer.py


$(gen)/OberonEmitter.gunit : $(gen)/Oberon07.gunit tools/gen_emitter_test.py #$(gen)/OberonEmitterLexer.class $(gen)/OberonEmitterParser.class 
	$(python) tools/gen_emitter_test.py

emit.test  : oberon.bin $(gen)/OberonEmitter.gunit
	$(gunit) $(gen)/OberonEmitter.gunit

