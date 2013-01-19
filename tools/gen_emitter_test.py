"""
I was attempting to generate StringTemplate tests from the grammar tests.
This was a nice try, but it doesn't work yet. :/

One problem is that it generates tests for tokens, which gunit doesn't like..
There's only one though (Ident) so I added the KEEP/SKIP states to skip those
rules.

Even so... It now runs, but gunit can't find the templates. :/
"""

import os, re, string
os.chdir("r:/.gen/")


def read_block(lines):
    buff = []
    line = lines.next()
    while not line.startswith(">>"):
        buff.append(line)
        line = lines.next()
    return "\n".join(buff)
  



KEEP, SKIP = 0, 1

def translate(out, tree_test):
    buff = None
    state = KEEP
    lines = iter(open(tree_test).read().split("\n"))

    for line in lines:
        
        line = line.strip()
        
        # comments
        if line.startswith("//"):
            out.write(line + "\n")

        # bad syntax (we don't test these)
        elif line.count("FAIL"):
            pass
        

        # rule names
        elif line.endswith(":"):
            if line[0] in string.uppercase:
                state = SKIP
            else:
                state = KEEP
                rule = line[:-1]
                out.write("\nemit walks {0}:\n\n".format(rule, rule))

        elif state != SKIP:

            # blocks
            if line.startswith("<<"):
                block = read_block(lines)
                out.write('<<\n{0}\n>>\n->\n<<{0}>>\n'.format(block))
                
            # rules
            elif line.startswith('"'):
                head = None
                if line.endswith('"') and not line.count('->'):
                    head = line
                else:
                    if line.count("->"): head, _ =  line.split("->")
                    elif line.count("OK"): head, _ = line.split("OK")
                assert head is not None, "weird head: %s" % line
                head = head.replace('"', '\"').strip()
                out.write("{0} -> {0}\n".format(head))

            elif line.count("->"):
                pass


out = open("OberonEmitter.gunit", "w")
out.write("gunit OberonEmitter walks Oberon07;\n")
translate(out, "r:/.gen/Oberon07.gunit")
out.close()
