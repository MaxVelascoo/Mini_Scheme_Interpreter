; **Definició de constants**
(define PI 3.14159)

; **Funcions**

; 1. Sumar elements d'una llista
(define (sumar-llista llista)
  (if (null? llista)
      0
      (+ (car llista) (sumar-llista (cdr llista)))))

; 2. Duplicar elements d'una llista
(define (duplicar-elements llista)
  (if (null? llista)
      '()
      (cons (* 2 (car llista)) (duplicar-elements (cdr llista)))))

; 3. Calcular l'àrea d'un cercle
(define (area-cercle radi)
  (* PI (* radi radi)))

; 4. Calcular el n-èsim nombre de Fibonacci
(define (fibonacci n)
  (if (<= n 1)
      n
      (+ (fibonacci (- n 1)) (fibonacci (- n 2)))))

; 5. Verificar si un número és parell
(define (es-parell n)
  (= (mod n 2) 0))

; 6. Filtrar nombres parells d'una llista
(define (filtrar-parells llista)
  (if (null? llista)
      '()
      (if (es-parell (car llista))
          (cons (car llista) (filtrar-parells (cdr llista)))
          (filtrar-parells (cdr llista)))))

; 7. Calcular l'energia potencial
(define (energia-potencial massa altura)
  (let ((gravetat 9.8))
    (* massa (* altura gravetat))))

; 8. Comptar elements d'una llista
(define (comptar-elements llista)
  (if (null? llista)
      0
      (+ 1 (comptar-elements (cdr llista)))))

; 9. filter + map
(define (dobla x) (* x 2))
(define (parell? x) (= (mod x 2) 0))

(define (map func llista)
  (cond
    ((null? llista) '())
    (else (cons (func (car llista)) (map func (cdr llista))))))

(define (filter predicat llista)
  (cond
    ((null? llista) '())
    ((predicat (car llista))
     (cons (car llista) (filter predicat (cdr llista))))
    (#t (filter predicat (cdr llista)))))

; 10. Composició de funcions corregida
(define (composicio f g x)
  (if (g x)
      (f x)
      #f))

; **Main interactiu**
(define (main)
  (display "=== Joc de Proves Interactiu ===") (newline)
  (display "1. Sumar elements d'una llista") (newline)
  (display "2. Duplicar elements d'una llista") (newline)
  (display "3. Calcular l'àrea d'un cercle") (newline)
  (display "4. Calcular el n-èsim nombre de Fibonacci") (newline)
  (display "5. Verificar si un número és parell") (newline)
  (display "6. Filtrar nombres parells d'una llista") (newline)
  (display "7. Calcular l'energia potencial") (newline)
  (display "8. Comptar elements d'una llista") (newline)
  (display "9. Aplicar filter i map sobre una llista") (newline)
  (display "10. Composició de funcions (dobla després de verificar si és parell)") (newline)
  (display "11. Sortir del programa") (newline)
  (display "Escull una opció (1-11): ")
  (let ((opcio (read)))
    (cond
      ((= opcio 1)
       (display "Introdueix una llista per sumar els seus elements (exemple: '(1 2 3 4 5)): ")
       (let ((llista (read)))
         (display "Resultat: ")
         (display (sumar-llista llista)) (newline))
       (main))
      ((= opcio 2)
       (display "Introdueix una llista per duplicar els seus elements (exemple: '(1 2 3)): ")
       (let ((llista (read)))
         (display "Resultat: ")
         (display (duplicar-elements llista)) (newline))
       (main))
      ((= opcio 3)
       (display "Introdueix el radi del cercle per calcular-ne l'àrea: ")
       (let ((radi (read)))
         (display "Resultat: ")
         (display (area-cercle radi)) (newline))
       (main))
      ((= opcio 4)
       (display "Introdueix un nombre per calcular el n-èsim terme de Fibonacci: ")
       (let ((n (read)))
         (display "Resultat: ")
         (display (fibonacci n)) (newline))
       (main))
      ((= opcio 5)
       (display "Introdueix un nombre per verificar si és parell: ")
       (let ((n (read)))
         (display "Resultat: ")
         (display (es-parell n)) (newline))
       (main))
      ((= opcio 6)
       (display "Introdueix una llista per filtrar els nombres parells (exemple: '(1 2 3 4 5)): ")
       (let ((llista (read)))
         (display "Resultat: ")
         (display (filtrar-parells llista)) (newline))
       (main))
      ((= opcio 7)
       (display "Introdueix la massa (kg) per calcular l'energia potencial: ")
       (let ((massa (read)))
         (display "Introdueix l'altura (m) per calcular l'energia potencial: ")
         (let ((altura (read)))
           (display "Resultat: ")
           (display (energia-potencial massa altura)) (newline)))
       (main))
      ((= opcio 8)
       (display "Introdueix una llista per comptar els seus elements (exemple: '(1 2 3 4 5)): ")
       (let ((llista (read)))
         (display "Resultat: ")
         (display (comptar-elements llista)) (newline))
       (main))
      ((= opcio 9)
       (display "Introdueix una llista per aplicar filter i map (exemple: '(1 2 3 4 5 6 7 8)): ")
       (let ((llista (read)))
         (display "Resultat (pares doblats): ")
         (display (map dobla (filter parell? llista))) (newline))
       (main))
      ((= opcio 10)
       (display "Introdueix un nombre per aplicar la composició de funcions (dobla després de verificar si és parell): ")
       (let ((n (read)))
         (display "Resultat: ")
         (display (composicio dobla parell? n)) (newline))
       (main))
      ((= opcio 11)
       (display "Sortint del programa...") (newline))
      (else
       (display "Opció no vàlida, torna-ho a intentar.") (newline)
       (main)))))
