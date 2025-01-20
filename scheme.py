import sys
from antlr4 import FileStream, CommonTokenStream
from schemeLexer import schemeLexer
from schemeParser import schemeParser
from interpreter import schemeInterpreter


def main(argv):
    if len(argv) < 2:
        print("Error: No s'ha proporcionat cap fitxer .scm.")
        sys.exit(1)

    file_name = argv[1]
    if not file_name.endswith('.scm'):
        print("Error: El fitxer proporcionat no té l'extensió .scm.")
        sys.exit(1)

    input_stream = FileStream(file_name, encoding='utf-8')
    lexer = schemeLexer(input_stream)
    stream = CommonTokenStream(lexer)
    parser = schemeParser(stream)
    tree = parser.root()

    interpreter = schemeInterpreter()

    try:
        interpreter.visit(tree)
        if 'main' in interpreter.global_env and callable(
                interpreter.global_env['main']):
            interpreter.global_env['main']()  # Crida a la funció `main`
        else:
            print("Error: El programa ha de començar amb una funció main.")
    except Exception as e:
        print(f"Error: {e}")  # Mostra el missatge de l'excepció


if __name__ == "__main__":
    main(sys.argv)
