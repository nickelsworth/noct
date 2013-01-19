#=[ configuration ]========================================================
#
# You can override these on the command line. Example:
#
#     $ make emit emit.mod=/r/oberon/  emit.stg=.gen/Java.stg
#
#--------------------------------------------------------------------------
JDK        = /usr/src/jdk1.7.0_10
GEN        = .gen

antlrjar3  = jars/antlr-3.4-complete.jar
CLASSPATH  = "$(antlrjar3):$(GEN)"

JAVA       = $(JDK)/bin/java -cp $(CLASSPATH)
JAVAC      = $(JDK)/bin/javac

antlr3     = $(JAVA) org.antlr.Tool -o $(GEN)
gunit      = $(JAVA) org.antlr.gunit.Interp

ob_g       = Oberon07.g


# default arguments for "make emit":
emit_mod   = test/ReformatMe.mod
emit_stg   = targets/Oberon.stg

#--------------------------------------------------------------------------

# default rule:
main: oberon.test

init:
	mkdir -p .gen

clean:
	rm -f $(GEN)/*.java



%.class: %.java
	$(JAVAC) -cp $(CLASSPATH) $<


# these should be redundant now
# ------------------------------
#$(GEN)/Oberon07Parser.class: $(GEN)/Oberon07Parser.java
#	$(JAVAC) $(GEN)/Oberon07*.java
#$(GEN)/OberonEmitter.class: $(GEN)/OberonEmitter.java
#	$(JAVAC) $(GEN)/OberonEmitter.java


$(GEN)/Oberon07Parser.java: $(ob_g)
	$(antlr3) $(ob_g)

$(GEN)/OberonEmitter.java: OberonEmitter.g $(GEN)/Oberon07Parser.java
	$(antlr3) OberonEmitter.g



# pascal backend:

pascal : $(GEN)/pascal.pas $(GEN)/BUILTINS.pas
	$(fpc) $(GEN)/pascal.pas

pig     : Pig.pas
	$(fpc) $(GEN)/Pig.pas
pig.pas : $(GEN)/Pig.pas
	$(cat)  $(GEN)/Pig.pas

$(GEN)/BUILTINS.pas: oberon.emitter $(GEN)/Pascal.stg test/BUILTINS.mod
	$(JAVA) OberonEmitter $(GEN)/Pascal.stg < test/BUILTINS.mod | tail -n +1 >  $(GEN)/BUILTINS.pas

$(GEN)/pascal.pas: oberon.emitter $(GEN)/Pascal.stg test/pascal.mod
	$(JAVA) OberonEmitter $(GEN)/Pascal.stg < test/pascal.mod | tail -n +1 > $(GEN)/pascal.pas

$(GEN)/Pig.pas: oberon.emitter $(GEN)/Pascal.stg test/Pig.mod
	$(JAVA) OberonEmitter $(GEN)/Pascal.stg < test/Pig.mod | tail -n +1 > $(GEN)/Pig.pas


# shortcuts:

oberon       : $(GEN)/Oberon07Parser.java
oberon.bin   : $(GEN)/Oberon07Parser.class $(GEN)/Oberon07Lexer.class
oberon.test  : oberon.bin
	$(gunit) test/Oberon07.gunit

oberon.emitter: $(GEN)/OberonEmitter.class
java.emitter: $(GEN)/JavaEmitter.class

emit: oberon.emitter
	$(JAVA) OberonEmitter $(emit_stg) < $(emit_mod)


$(GEN)/OberonEmitter.gunit: test/Oberon07.gunit tools/gen_emitter_test.py
	$(python) tools/gen_emitter_test.py

emit.test : oberon.bin $(GEN)/OberonEmitter.gunit
	$(gunit) $(GEN)/OberonEmitter.gunit

