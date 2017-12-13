; Beispiel Baum: (10 (5 1 6) (20 14 22))

; if current element is null or same as the inserted value, insert the value.
; else create node on element and insert node there
(defun create-child (element value)
    (if (null element)
        value
        (if (= value element)
            value
            (list 
                element
                (if (< value element)
                    value
                    nil
                )
                (if (> value element)
                    value
                    nil            
                )
            )
        )
    )
)
; checks if value is in left path and follows it while recreating the original tree.
; call insert until tree is not a list -> create-child
(defun create-left (tree value)
    (if (< value (car tree))
         (if (and (listp (cadr tree)) (not (null (cadr tree))))
            (insert (cadr tree) value)
            (create-child (cadr tree) value)
         ) 
         (cadr tree)
    )
)
; checks if value is in right path and follows it while recreating the original tree
; call insert until tree is not a list -> create-child
(defun create-right (tree value)
    (if (> value (car tree))
        (if (and (listp (caddr tree)) (not (null (caddr tree))))
            (insert (caddr tree) value)
            (create-child (caddr tree) value)
        ) 
        (caddr tree)
    ) 
)
; Fügt val in den Baum tree ein und gibt als Ergebnis den ergänzten Baum zurück. 
; Am besten wird dabei ein neuer Baum erzeugt.
(defun insert (tree value) 
    (list 
        (car tree)
        (create-left tree value)        
        (create-right tree value)
    )
)
; reads file for insert-filename method
(defun read-file (filename)
    (with-open-file(stream filename)
           (loop for word = (read stream nil 'eof)
                until (eq word 'eof) collect word)
    )
)
; Fügt die int-Werte, die in der Datei stehen in den Baum ein.
(defun insert-filename (tree filename) 
    (loop for x in (read-file filename)
         do (setq tree (insert tree x))  
    )
    tree
)
; Testet, ob val im Baum vorhanden ist.
(defun contains (tree value)
    (setq found 'F)
    (cond
        ((= (car tree) value) 
            (setq found T) )
        ((< (car tree) value) 
            (if (listp (caddr tree)) 
                (contains (caddr tree) value) 
                (if (= (caddr tree) value) (setq found T) )))
        ((> (car tree) value) 
            (if (listp (cadr tree)) 
            (contains (cadr tree) value) 
            (if (= (cadr tree) value) (setq found T) ) ))
    )
    found    
)
; Ermittelt die Anzahl der Knoten im Baum.
(defun size (tree)
    (cond
        ((null tree) 0)
        ((atom tree) 1)
        ((listp tree) 
            (+ 1 
                (+ (size (cadr tree)) 
                    (size (caddr tree))
                )
            )
        )    
    )
)
; Ermittelt die Höhe des Baums.
(defun height (tree)
    (if (null tree)
        0
        (if (listp tree)
            (+ 1 
                (if (>= (height (caddr tree)) (height (cadr tree))) 
                    (height (caddr tree)) 
                    (height (cadr tree))
                )
            )
            0        
        )
    )
)
; speichert alle int-Werte der Knoten in einer Liste
(defun get-elements (tree) 
    (append 
        (append (list (car tree))
          (if (cadr tree)
            (if (listp (cadr tree)) 
                (get-elements (cadr tree))
                (list (cadr tree))    
            )
            NIL
          )
        )
        (if (caddr tree)
          (if (listp (caddr tree)) 
              (get-elements (caddr tree))
              (list (caddr tree))    
          )
          NIL
        )
    )
)
; Liefert das größte Element im Baum.
(defun getMax (tree)
    (let ((max)))
    (setq max (car tree))
    (loop for x in (get-elements tree)
         do (if (> x max)
                (setq max x)            
            )  
    )
    max
)
; Liefert das kleinste Element im Baum.
(defun getMin (tree)
    (let ((min)))
    (setq min (car tree))
    (loop for x in (get-elements tree)
         do (if (< x min)
                (setq min x)            
            )
    )
    min
)
; returns null if listElement null or same as value
; rekursion if listelement is list
; returns listelement if listelement is atom
(defun calculateSubTree (listElement value)
    (if (null listElement)
        NIL
        (if (listp listElement)
            (remove-value listElement value)
            (if (= listElement value)
                NIL
                listElement
            )            
        )  
    )
)
; Entfernt val aus dem Baum und gibt als Ergebnis den geänderten Baum zurÜck. Wenn ein innerer Knoten 
; gelöscht wird, dann erstetzen Sie ihn durch den kleinsten Knoten in dessen rechtem Teilbaum.
(defun remove-value (tree value) 
    (if (= (car tree) value)
        (list
            (getMin tree)
            (calculateSubTree (cadr tree) (getMin tree))
            (calculateSubTree (caddr tree) (getMin tree))           
        )
        (list
            (car tree) 
            (calculateSubTree (cadr tree) value) 
            (calculateSubTree (caddr tree) value)    
        )
    )
)
; true genau dann, wenn der Baum leer ist.
(defun isEmpty (tree)
    (if (null tree) T F)
)
;Fügt alle Elemente des übergebenen Baums (otherTree) in
den aktuellen Baum tree ein.
(defun addAll (tree otherTree)
    (loop for x in (get-elements otherTree)
         do (setq tree (insert tree x))  
    )
    tree
)

(defun printGivenLevel (tree level)
    (if (null tree) 
        NIL
        (cond
            ((= level 1)
                (if (not (null tree)) 
                (print (if (listp tree) (car tree) tree))))
            ((> level 1)
                (if  (listp tree)
                    (printGivenLevel (cadr tree) (- level 1)))
                (if  (listp tree)
                    (printGivenLevel (caddr tree) (- level 1)))
            )
        )    
    )
)
;Gibt Baum in Levelorder aus
(defun printLevelorder (tree)
    (loop for x from 1 to (+ 1 (height tree))
         do (printGivenLevel tree x)  
    )
)


(insert '(10 (5 1 6) (20 14 22)) 6)
; (10 (5 1 6) (20 14 22))

(insert '(10 (5 1 (7 NIL 8)) (20 14 22)) 6)
; (10 (5 1 (7 6 8)) (20 14 22))

(insert-filename '(10 (5 1 6) (20 14 22)) "test.txt")
; (10 (5 1 6) (20 (14 (12 NIL 13) (15 NIL 17)) 22))

(contains '(10 (5 1 6) (20 14 22)) 6)
; T

(contains '(10 (5 1 6) (20 14 22)) 7)
; F

(size '(10 (5 1 6) (20 14 22)))
; 7

(height '(10 (5 1 6) (20 (14 11 19) 22)))
; 3

(getMax '(10 (4 1 5) (15 11 20)))
; 20

(getMin '(10 (4 1 5) (15 11 20)))
; 1

(remove-value '(10 (4 1 5) (15 11 20)) 15)
; (10 (4 1 5) (11 NIL 20))

(isEmpty '())
; T

(addAll '(10 (5 1 6) (20 14 22)) '(5 4 8))
; (10 (5 (1 NIL 4) (6 NIL 8)) (20 14 22))

(printLevelorder '(1 (2 4 5) 3))
; 8 
; 6 
; 20 
; 5 
; 7 
; 14 
; 26 
; 13 
; 16
; NIL





