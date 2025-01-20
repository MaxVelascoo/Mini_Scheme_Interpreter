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

; 10. Composició de funcions
(define (composicio f g x)
  (if (g x)
      (f x)
      #f))

; **Funció per sortir**
(define (sortir)
  (display "Finalitzant programa.") (newline))

; **Mode script**
(define (main)
  (let ((opcio (read)))
    (cond
      ((= opcio 1)
       (display (sumar-llista (read))) (newline) (main))
      ((= opcio 2)
       (display (duplicar-elements (read))) (newline) (main))
      ((= opcio 3)
       (display (area-cercle (read))) (newline) (main))
      ((= opcio 4)
       (display (fibonacci (read))) (newline) (main))
      ((= opcio 5)
       (display (es-parell (read))) (newline) (main))
      ((= opcio 6)
       (display (filtrar-parells (read))) (newline) (main))
      ((= opcio 7)
       (let ((massa (read)) (altura (read)))
         (display (energia-potencial massa altura)) (newline) (main)))
      ((= opcio 8)
       (display (comptar-elements (read))) (newline) (main))
      ((= opcio 9)
       (let ((llista (read)))
         (display (map dobla (filter parell? llista))) (newline) (main)))
      ((= opcio 10)
       (let ((n (read)))
         (display (composicio dobla parell? n)) (newline) (main)))
      ((= opcio 11)
       (sortir))
      (else
       (sortir)))))
