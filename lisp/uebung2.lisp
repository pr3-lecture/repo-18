; Beispiel Baum: (10 (5 1 6) (20 14 22))

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

(defun create-left (tree value)
    (if (< value (car tree))
         (if (and (listp (cadr tree)) (not (null (cadr tree))))
            (insert (cadr tree) value)
            (create-child (cadr tree) value)
         ) 
         (cadr tree)
    )
)

(defun create-right (tree value)
    (if (> value (car tree))
        (if (and (listp (caddr tree)) (not (null (caddr tree))))
            (insert (caddr tree) value)
            (create-child (caddr tree) value)
        ) 
        (caddr tree)
    ) 
)

(defun insert (tree value) 
    (list 
        (car tree)
        (create-left tree value)        
        (create-right tree value)
    )
)

(defun read-file (filename)
    (with-open-file(stream filename)
           (loop for word = (read stream nil 'eof)
                until (eq word 'eof) collect word)
    )
)

(defun insert-filename (tree filename) 
    (loop for x in (read-file filename)
         do (setq tree (insert tree x))  
    )
    tree
)

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

(defun isEmpty (tree)
    (if (null tree) T F)
)

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





