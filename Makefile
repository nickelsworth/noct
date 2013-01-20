#=[ configuration ]=============================================
#
# You can override these on the command line. Example:
#
#     $ make emit emit.mod=/r/oberon/  emit.stg=.gen/Java.stg
#
#---------------------------------------------------------------
JDK        = /usr/src/jdk1.7.0_10
GEN        = .gen

# free pascal:
FPC        = fpc

PYTHON     = /usr/bin/python


antlrjar3  = jars/antlr-3.4-complete.jar
CLASSPATH  = "$(antlrjar3):$(GEN)"

JAVA       = $(JDK)/bin/java -cp $(CLASSPATH)
JAVAC      = $(JDK)/bin/javac

antlr3     = $(JAVA) org.antlr.Tool -o $(GEN)
GUNIT      = $(JAVA) org.antlr.gunit.Interp

ob_g       = Oberon07.g


# default arguments for "make emit":
emit_mod   = test/ReformatMe.mod
emit_stg   = targets/Oberon.stg

#---------------------------------------------------------------

# default rule:
main: init
	@echo "available targets:"
	@echo
	@echo "target           purpose"
	@echo "-----------      -----------------------------------"
	@echo "oberon.test      run the test suite"
	@echo "clean            remove generated code from $(GEN)/"
	@echo
	@echo "test.haxe	test the haxe backend"
	@echo
	@echo "hello.java       'hello world' unit for java"
	@echo "pig.java         pig latin example for java"
	@echo
	@echo "hello.pas        'hello world' unit for pascal"
	@echo "pig.pas          pig latin example for pascal"
	@echo "pascal           another pascal test"
	@echo
	@echo "emit.test        (BROKEN) oberon->oberon test suite"
	@echo
	@echo "Type target name after 'make' to run. Example:"
	@echo '    $$ make hello.pas'
	@echo


init:
	@mkdir -p .gen

clean:
	rm -f $(GEN)/*.java

%.class: %.java
	$(JAVAC) -cp $(CLASSPATH) $<



$(GEN)/Oberon07Parser.java: $(ob_g)
	$(antlr3) $(ob_g)

$(GEN)/OberonEmitter.java: OberonEmitter.g $(GEN)/Oberon07Parser.java
	$(antlr3) OberonEmitter.g



$(GEN)/%.hx: test/given/%.mod oberon.emitter targets/Haxe.stg
	$(JAVA) OberonEmitter targets/Haxe.stg < $< | tail -n +1 > $@
	cat $@


# java backend:

$(GEN)/%.java: test/%.mod oberon.emitter targets/Java.stg
	$(JAVA) OberonEmitter targets/Java.stg < $< | tail -n +1 > $@
	cat $@

hello.java: $(GEN)/Hello.java
	$(FPC) $<

pig.java : $(GEN)/Pig.java
	$(FPC) $<

# pascal backend:

$(GEN)/%.pas: test/%.mod oberon.emitter targets/Pascal.stg
	$(JAVA) OberonEmitter targets/Pascal.stg < $< | tail -n +1 > $@
	cat $@

pascal : $(GEN)/pascal.pas $(GEN)/BUILTINS.pas
	$(FPC) $(GEN)/pascal.pas

hello.pas : $(GEN)/Hello.pas
	$(FPC) $<

pig.pas : $(GEN)/Pig.pas
	$(FPC) $<


# shortcuts:

oberon       : $(GEN)/Oberon07Parser.java
oberon.bin   : $(GEN)/Oberon07Parser.class $(GEN)/Oberon07Lexer.class
oberon.test  : oberon.bin
	$(GUNIT) test/Oberon07.gunit

oberon.emitter: $(GEN)/OberonEmitter.class

emit: oberon.emitter
	$(JAVA) OberonEmitter $(emit_stg) < $(emit_mod)


$(GEN)/OberonEmitter.gunit: test/Oberon07.gunit tools/gen_emitter_test.py
	$(PYTHON) tools/gen_emitter_test.py

emit.test : oberon.bin $(GEN)/OberonEmitter.gunit
	$(GUNIT) $(GEN)/OberonEmitter.gunit
