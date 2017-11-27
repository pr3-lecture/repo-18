; Silvia Altrichter. Gruppe: siehe repo 51
; Aufgabe 1:

; a)
(defun rotiere (x) (append (rest x) (list (first x))))

; b)
(defun neues-vorletztes (param1 param2)
  (append
    (append
      (loop for x from 1 to (- (list-length param2) 1)
        collect (nth x param)) param1) (last param2)))

; c)
(defun my-length (param) (loop for x in param count x))

; ODER

(defun my-length (param) (list-length param))

; d)
(defun my-lengthR (param)(loop for x in param sum
  (if (listp x)
    (my-lengthR x)
    1)))

; e)
(defun my-reverse (param)(loop for x from 1 to (list-length param)
  collect (
    nth (- (list-length param) x) param
  )))

; f)
(defun my-reverseR (param)(loop for x from 1 to (list-length param)
  collect (if (listp (setq item (nth (- (list-length param) x) param)))
     (my-reverseR item)
      item
      )))

; Aufgabe 2:

; https://lvb-wissen.de/informatik/datenstrukturen/binearbaum/traversierungsverfahren:-Preorder-Inorder-und-Postorder-8592095901.html

; a)
;(10 (5 (3) (7)) (13 (12) (20)))

;    10
;    / \
;   5   13
;  /\   /\
; 3  7 12 20

; b)

; PREORDER:
(defun preorder(param) (print (first param))
  (if (nth 1 param)(preorder (nth 1 param)))
  (if (nth 2 param)(preorder (nth 2 param))))

; Ausgabe: 10 5 3 7 13 12 20

; INORDER:
(defun inorder(param)
  (if (nth 1 param)(inorder (nth 1 param)))
  (print (first param))
  (if (nth 2 param)(inorder (nth 2 param))))

; Ausgabe: 3 5 7 10 12 13 20

; POSTORDER:
(defun postorder(param)
  (if (nth 1 param)(postorder (nth 1 param)))
  (if (nth 2 param)(postorder (nth 2 param)))
  (print (first param)))

; Ausgabe:  3 7 5 12 20 13 10
