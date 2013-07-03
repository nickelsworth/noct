"""
noct universal parser
(a grammar combinator library)
"""
from __future__ import print_function

def rex(pattern): pass
def gra(pattern): pass
def sep(patten, by): pass
def alt(*ptns): pass
def seq(ptn_list): pass
def dfn(name, pattern):pass
def ref(name):pass
def opt(ptn):pass
def rep(ptn): pass
def maybe_some(ptn): pass
def known_type(): pass
def initial_values(): pass
def new_def(): ref('iden')
def const_expr(): pass
def new(kind, pattern): pass
def hold(kind): pass
def drop(kind):pass
def take(kind):pass
def same(kind):pass
def known(kind):pass
def other(kind):pass # like known, but exclude the one we're currently defining (type x = x)
def scope(kind):pass
def condition():pass
def fwd(rule):pass # like ref but for something not declared yet
def todo(note): print('todo:', note)

block = gra([])

dfn('<vars>', [sep(new('@var', ref('iden')), by=','),
               ':', known('@type')])


# okay, this is hideous, but it's at least nicer than writing the
# entire parser out by hand. basically it's just a big data structure
# that defines the grammar for oberon/retro pascal

grammar =\
['MODULE', hold(new('@module', dfn('iden', r'[a-z][a-zA-Z]+'))),
 'IMPORT', sep(ref('iden'), ','),
 dfn('<declarations>', [maybe_some({
     'CONST': rep([
         new('@const', ref('iden')), '=', const_expr, ';']),
     'TYPE' : rep([
         hold(new('@type', ref('iden'))), '=', dfn('<type>', alt(
             other('@type'),
             ['array', 'of', other('@type')],
             ['record', opt(['(', known('@type'), ')']),
                 sep(ref('<vars>'), ';'),
              'end'],
             ['procedure',
                 dfn('<signature>', [opt([
                   scope(['(',
                       sep([opt({'VAR', 'CONST'}), ref('<vars>')], by=';'),
                   ')'])]),
                 opt([':', known('@type')])
             ])]
         )), drop('@type'), ';']),
     'VAR': rep([ref('<vars>'), opt(['=', initial_values])]),
     'PROCEDURE': [opt('*'), hold(new('@proc', ref('iden'))),
                   scope([
                       ref('<signature>'), ';', ref('<declarations>'), ',',
                       same('@proc')])] }),
 'BEGIN', dfn('<stmts>', sep(dfn('<stmt>', alt({
    'IF': [condition, 'THEN', ref('<stmts>'),
           rep(['ELIF', condition, 'THEN', ref('<stmts>')]),
           opt(['ELSE', ref('<stmts>')]),
           'END'],
    'FOR': [known('@var'), ':=', const_expr, 'TO', const_expr,
             opt([{'WHILE', 'UNTIL'}, condition]),  # retro pascal extension
             'DO',
                ref('<stmts>'),
            'END'],
    'CASE'  : [opt('TYPE'),  # another retro pascal extension
               fwd('<expr>'), 'OF', opt({'|'}),
               sep([
                   alt(['[', dfn('<range>', [const_expr, opt(['..', const_expr])]),
                           sep(ref('<range>'), ','),
                        ']']),
                   ':' '<stmts>'], '|'),
               'ELSE', '<stmts>', 'END'],
    'WHILE' : ['DO', sep('<stmt>', ';'), 'END'],
    'REPEAT': [ref('<stmts>'), 'UNTIL', condition]
    },
    # if it's not a key word, it should be an identifier:
    [dfn('lhs',
        [known('iden'),
        {
            '.': [todo('attributes')],
            '[': [ref('expr')],
        }
        ]),
        #--
        {
            ':=': dfn('<expr>', [todo('expressions')]),
            '(' : [sep(ref('<expr>'), ','), ')']
        }
   ]
 )), by=';')),
 'END']), same('iden'), '.']



class Ob2Js(object):
    """
    A simple oberon -> Js compiler.
    """
    def __init__(self, source=None):
        if source: self.source = source
        else: self.source = ""

def translate(self, source):
    """
    Creates a generator that yields lines of javascript code.
    :param source: the oberon source code to compile
    """
    pass

