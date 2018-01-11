# This code can be put in any Python module, it does not require IPython
# itself to be running already.  It only creates the magics subclass but
# doesn't instantiate it yet.
from __future__ import print_function
import inspect
from pygments import highlight
from pygments.lexers import PythonLexer
from pygments.formatters import HtmlFormatter
from IPython.display import display, HTML
from IPython.core.magic import (Magics, magics_class, line_magic,
                                cell_magic, line_cell_magic)

HTML_TEMPLATE = """<style>
        {}
        </style>
        {}
        """

# The class MUST call this class decorator at creation time
@magics_class
class MyMagics(Magics):

    @line_magic
    def inspect(self, line):
        lines = inspect.getsourcelines(self.shell.ev(line))
        code = "".join(lines[0])
        html_code = highlight(code, PythonLexer(), HtmlFormatter())
        css = HtmlFormatter().get_style_defs()
        html = HTML_TEMPLATE.format(css, html_code)
        display(HTML(html))


# In order to actually use these magics, you must register them with a
# running IPython.  This code must be placed in a file that is loaded once
# IPython is up and running:
ip = get_ipython()
# You can register the class itself without instantiating it.  IPython will
# call the default constructor on it.
ip.register_magics(MyMagics)
