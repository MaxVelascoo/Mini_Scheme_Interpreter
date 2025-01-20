from schemeVisitor import schemeVisitor


class schemeInterpreter(schemeVisitor):

    def __init__(self):
        self.global_env = {}  # Entorn global per emmagatzemar funcions i constants

    # Evaluació d'una expressió
    def visitExpression(self, ctx):
        if ctx.value():
            return self.visit(ctx.value())
        elif ctx.ID():
            identifier = ctx.ID().getText()
            if identifier in self.global_env:
                return self.global_env[identifier]
            else:
                raise Exception(f"Identificador no definido: {identifier}")
        elif ctx.function_call():
            return self.visit(ctx.function_call())
        elif ctx.let_expression():
            return self.visit(ctx.let_expression())
        elif ctx.cond_expression():
            return self.visit(ctx.cond_expression())
        elif ctx.read_expression():
            return self.visit(ctx.read_expression())
        elif ctx.if_expression():
            return self.visit(ctx.if_expression())
        elif ctx.newline_expression():
            return self.visit(ctx.newline_expression())
        else:
            return self.visitChildren(ctx)

    # Evaluació d'un valor literal (nombres, cadenes, booleans)
    def visitValue(self, ctx):
        if ctx.BOOLEAN():
            return ctx.BOOLEAN().getText() == "#t"
        elif ctx.NUMBER():
            return float(ctx.NUMBER().getText())
        elif ctx.STRING():
            return ctx.STRING().getText()[1:-1]     # Elimina les comilles
        elif ctx.list_literal():
            return self.visit(ctx.list_literal())   # Evalúa una llista literal
        return None

    # Evaluació d'un display
    def visitDisplay_expression(self, ctx):
        value = self.visit(ctx.expression())
        if isinstance(value, bool):
            value = "#t" if value else "#f"         # Convertim True/False a #t/#f
        # Mostra el valor en pantalla
        print(value, end="")
        return value

    # Evaluació d'una definició constant
    def visitConstant_definition(self, ctx):
        identifier = ctx.ID().getText()
        value = self.visit(ctx.expression())
        # Guarda la constant en l'entorn global
        self.global_env[identifier] = value
        return None

    # Evaluació d'una definició de funció
    def visitFunction_definition(self, ctx):
        # Nom de la funció
        function_name = ctx.ID(0).getText()
        params = [param.getText() for param in ctx.ID()[1:]
                  ]  # Paràmetres de la funció
        body = ctx.expression()                               # Cos de la funció

        def user_defined_function(*args):
            if len(args) != len(params):
                raise Exception(f"Funció {function_name} espera {len(params)} arguments, però s'han rebut {len(args)}.")
            # Creem un entorn local pels arguments
            local_env = dict(zip(params, args))
            return self.evaluate_function_body(body, local_env)

        self.global_env[function_name] = user_defined_function
        return None

    # Evaluació d'una trucada a funció
    def visitFunction_call(self, ctx):
        # Verifiquem si es una operació de llista
        if ctx.list_operations():
            return self.visit(ctx.list_operations())

        # Verifiquem si es una funció definida
        if ctx.ID():
            function_name = ctx.ID().getText()
            if function_name not in self.global_env:
                raise Exception(f"funció no definida: {function_name}")

            function = self.global_env[function_name]
            args = [self.visit(arg) for arg in ctx.expression()]

            if isinstance(function, dict):
                local_env = dict(zip(function["params"], args))
                return self.evaluate_function_body(function["body"], local_env)
            elif callable(function):
                return function(*args)
            else:
                raise Exception(f"{function_name} no es una funció válida.")

        raise Exception("Llamada a funció no válida.")

    # Evaluació d'una operació aritmética
    def visitArithmetic_expression(self, ctx):
        operator = ctx.aritmeticOp().getText()
        left = self.visit(ctx.expression(0))
        right = self.visit(ctx.expression(1))
        if operator == "+":
            return left + right
        elif operator == "-":
            return left - right
        elif operator == "*":
            return left * right
        elif operator == "/":
            if right == 0:
                raise Exception("Divisió per zero")
            return left / right
        elif operator == "mod":
            if right == 0:
                raise Exception("Divisió per zero en 'mod'")
            return left % right
        return None

    # Evaluació d'una operació lògica
    def visitLogic_expression(self, ctx):
        # Verifiquem si es un operador lògic (>, <, =, <=, >=)
        if ctx.logicOp():
            operator = ctx.logicOp().getText()
            left = self.visit(ctx.expression(0))
            right = self.visit(ctx.expression(1))
            if operator == ">":
                return left > right
            elif operator == "<":
                return left < right
            elif operator == "=":
                return left == right
            elif operator == "<=":
                return left <= right
            elif operator == ">=":
                return left >= right
            elif operator == "<>":
                return left != right
            else:
                raise Exception(f"Operador lògic no reconegut: {operator}")

        # Verifiquem si es un operador lògic boolean (and, or, not)
        elif ctx.booleanLogicOp():
            operator = ctx.booleanLogicOp().getText()
            if operator == "and":
                return all(self.visit(expr) for expr in ctx.expression())
            elif operator == "or":
                return any(self.visit(expr) for expr in ctx.expression())
            elif operator == "not":
                if len(ctx.expression()) != 1:
                    raise Exception("El operador 'not' espera exactament un argument.")
                return not self.visit(ctx.expression(0))
            else:
                raise Exception(f"Operador boolean no reconegut: {operator}")

        # Si no coincideix cap regla
        else:
            raise Exception("Expresió lògica no reconeguda")

    # Evaluació d'una expresió `if`

    def visitIf_expression(self, ctx):
        # Primera expressió com a condició
        condition = self.visit(ctx.expression(0))

        if condition:
            return self.visit(ctx.expression(1))
        else:
            return self.visit(ctx.expression(2))

    # Evaluació d'un cond

    def visitCond_expression(self, ctx):
        for clause in ctx.cond_clause():
            if clause.getChild(1).getText() == 'else':
                results = [self.visit(expr) for expr in clause.expression()]
                return results[-1]

            # Evaluem la primera expressió com a condició
            condition = self.visit(clause.expression(0))

            if condition:  # Si la condició és certa
                results = [self.visit(expr)
                           for expr in clause.expression()[1:]]
                return results[-1]

        # Si cap condició és certa, no retornem res
        raise Exception("Cap condició en 'cond' s'ha complit.")

    # Evaluació d'una operació amb llistes
    def visitList_operations(self, ctx):
        operation = ctx.getChild(1).getText()
        if operation == "car":
            lst = self.visit(ctx.expression(0))
            if not isinstance(lst, list):
                raise Exception(
                    f"car espera una llista, però hem trobat: {lst}")
            return lst[0] if lst else None
        elif operation == "cdr":
            lst = self.visit(ctx.expression(0))
            if not isinstance(lst, list):
                raise Exception(
                    f"cdr espera una llista, però hem trobat: {lst}")
            return lst[1:] if lst else []
        elif operation == "cons":
            element = self.visit(ctx.expression(0))
            lst = self.visit(ctx.expression(1))
            if not isinstance(lst, list):
                raise Exception(
                    f"cons espera una llista, però hem trobat: {lst}")
            return [element] + lst
        elif operation == "null?":
            lst = self.visit(ctx.expression(0))
            if not isinstance(lst, list):
                raise Exception(
                    f"null? espera una llista, però hem trobat: {lst}")
            return len(lst) == 0
        else:
            raise Exception(f"operació de llista no reconeguda: {operation}")

    # Evaluació d'una llista de literals
    def visitList_literal(self, ctx):
        # Si es una llista buida
        if len(ctx.value()) == 0:
            return []
        # Si es una llista amb valors
        return [self.visit(value) for value in ctx.value()]

    # Evaluació d'un let
    def visitLet_expression(self, ctx):
        # Creem un entorn local temporal
        local_env = {}
        for binding in ctx.let_bindings().let_binding():
            identifier = binding.ID().getText()             # Obtenim l'identificador
            # Evaluem l'expressió
            value = self.visit(binding.expression())
            # L'agreguem al entorn local
            local_env[identifier] = value

        # Guardem l'entorn global original
        original_env = self.global_env.copy()

        # Actualitzem l'entorn global amb les variables locals
        self.global_env.update(local_env)

        # Evaluem el cos del let (les expresions dins del let)
        results = [self.visit(expr) for expr in ctx.expression()]

        # Restaurem l'entorn global original
        self.global_env.clear()
        self.global_env.update(original_env)

        # Retornem el resultat de la última expressió evaluada
        return results[-1] if results else None

    # Evaluació d'un valor en un entorn local
    def evaluate_function_body(self, body, local_env):
        original_env = self.global_env.copy()   # Guardem l'entorn global original
        # Actualizem l'entorn global amb variables locals
        self.global_env.update(local_env)

        # Evaluem totes les expressions del cos
        results = [self.visit(expr) for expr in body]

        self.global_env.clear()
        # Restaurem l'entorn global original
        self.global_env.update(original_env)
        return results[-1] if results else None

    # Evaluació d'un read
    def visitRead_expression(self, ctx):
        # Llegim un valor desde l'entrada estándar y eliminem espais
        # innecesaris
        value = input().strip()

        if value == "#t":
            return True  # Convertim #t a True
        elif value == "#f":
            return False  # Convertim #f a False
        elif value.startswith("'(") and value.endswith(")"):
            value = value[2:-1]  # Treiem el prefixe ' i els parèntesis
            try:
                parsed_list = value.split()
                return [int(x) if x.isdigit() else x for x in parsed_list]
            except Exception as e:
                raise Exception(
                    f"Error al interpretar la llista: {value}. Detalles: {e}")

        try:
            return float(value) if '.' in value else int(value)
        except ValueError:
            return value

    # Evaluació d'una newline
    def visitNewline_expression(self, ctx):
        print()  # Imprimim una nova línea
        return None
