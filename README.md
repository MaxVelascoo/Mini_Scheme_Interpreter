# **Mini_Scheme_Interpreter**

Aquest projecte és un intèrpret per a un subconjunt del llenguatge Scheme, pensat per aprendre i experimentar amb conceptes de programació funcional. Permet executar funcionalitats bàsiques com **recursivitat**, manipulació de **llistes**, **condicionals** i **funcions d'ordre superior** com `map` i `filter`. A més, inclou un joc de proves interactiu i suport per executar scripts amb entrada i sortida automatitzades. És una eina ideal per practicar i entendre com funciona un llenguatge funcional de forma pràctica i senzilla.


## **FUNCIONS PRINCIPALS**

- **Operacions bàsiques** Ús de operadors aritmètics com `+`, `-`, `*`, `/` i operadors relacionals: `>`, `<`, `>=`, `<=`, `=`, `<>`.
- **Definició de funcions** Suport per definir funcions mitjançant `define`.
- **Definició de constants** Suport per definir constants mitjançant `define`.
- **Condicionals** Ús del condicional `if` i per condicions múltiples tenim l'ús de `cond`.
- **Llistes** Podem utilitzar llistes amb un apòstrof devant. Exemple: `'(1 2 3 4 5)`. A una llista li podem aplicar: `car`, `cdr`, `cons`, `null?`.
- **Recursivitat:** Suport per a càlculs com la successió de Fibonacci.
- **Noms locals amb let** Amb `let`podem definir variables locals dins d'una expressió.
- **Entrades i sortides:** Ús de `read` per llegir valors, `display` per escriure valors, `newline` per imprimir una nova línia, i redirecció de fitxers.
- **Booleans** Suport per booleans, `#t` representa true i `#f` representa false. Li podem aplicar operacions lògiques: `and`, `or`, `not`.
- **Funcions d'ordre superior:** Funcions com `map`, `filter` i composició de funcions.


## **ESTRUCTURA DEL PROJECTE**

```plaintext
scheme_Max_Velasco/
│
├── antlr-4.13.2-complete
├── Makefile               # Script per compilar i netejar
├── scheme.py              # Intèrpret amb la funcio main
├── interpreter.py         # Fitxer que conté visitors i funcions auxiliars
├── README.md              # Documentació del projecte
├── script.scm             # Script
├── script.inp             # Input per passar-li a Script
├── script.out             # Output esperat del Script
└── jocs_de_prova.scm      # Jocs de prova
```


## **REQUISITS**
- Python 3.10 o superior.
- Instal·lació dels paquets requerits (ANTLR4).

## **MAKEFILE**

El projecte inclou un Makefile que automatitza diverses tasques. Els objectius disponibles són els següents:

- **all**: Executa els objectius `clean`, `build` i `run` per netejar l'entorn, compilar la gramàtica i executar el projecte.
- **build**: Prepara l'entorn, incloent la compilació de la gramàtica Scheme utilitzant ANTLR.
- **compile_grammar**: Compila la gramàtica `scheme.g4` i genera els fitxers necessaris per a l'intèrpret.
- **clean**: Neteja els fitxers temporals i generats per ANTLR (`*.pyc`, `__pycache__`, `*.interp`, etc.).
- **test**: Executa l'intèrpret amb un fitxer d'entrada i redirigeix la sortida a un fitxer especificat (`output.txt`).

### **Exemple d'ús**

**Per compilar la gramàtica i preparar l'entorn:**

   ```bash
   make build
   ```

   o bé

   ```bash
   make
   ```

**Per netejar els fitxers generats:**

   ```bash
   make clean
   ```

**Per executar el script amb entrada i sortida:**

   ```bash
   make test
   ```


## **JOCS DE PROVES**

### **Interactiu**
Hi ha un fitxer anomenat jocs_de_prova.scm, el qual és un joc de prova interactiu. Et dona 10 funcions diferents per escollir i asseguren que l'intèrpret funcioni correctament amb diferents funcionalitats.

### **Script**
A més hi ha un fitxer que anomenat script.scm, el qual és un script al que li passem mitjançant una pipe un script.inp. Amb un altre pipe redireccionem la sortida a un fitxer anomenat output.txt. Aquest script també el podem executar amb:

### **Instal·lació**

1. Compila el projecte:

   ```bash
   make all
   ```

2. **Primera opció** Executa l'intèrpret amb el joc de prova interactiu en Scheme:

   ```bash
   python3 scheme.py jocs_de_prova.scm
   ```

3. **Segona opció** Executa l'intèrpret amb un Script, redireccionant l'entrada i la sortida amb pipes:

   ```bash
   python3 scheme.py Script.scm < entrada.txt > sortida.txt
   ```

   o bé

   ```bash
   make test
   ```


## **DECISIONS DE DISENY**

1. **Estructura modular**: 
   El projecte està separat en fitxers per millorar la claredat i mantenibilitat:
   - `scheme.py` per al punt d'entrada.
   - `interpreter.py` per a la lògica de l'intèrpret.
   - Gramàtica (`scheme.g4`) per definir les regles del llenguatge.

2. **Gramàtica clara i extensible**: 
   La gramàtica està dissenyada per evitar ambigüitats i permetre una fàcil extensió si cal afegir noves funcionalitats al llenguatge.

3. **Gestió d'errors**: 
   Es detecten errors com identificadors no definits o usos incorrectes d'operadors, amb missatges clars per facilitar la depuració.
