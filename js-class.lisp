(in-package :thirdperson-controller)

(defmacro create-method (obj path)
  (labels ((create-apply (obj path)
             `(ffi:ref ,obj ,@path apply))
           (create-this (obj path)
             `(ffi:ref ,obj ,@(reverse (cdr (reverse path))))))
    `(lambda (&rest args)
       (,(create-apply obj path) ,(create-this obj path) args))))

(defmacro create-method (obj path)
  (labels ((create-apply (obj path)
             `(ffi:ref ,obj ,@path apply))
           (create-this (obj path)
             (if (> (length path) 1)
                 `(ffi:ref ,obj ,@(reverse (cdr (reverse path))))
                 `(ffi:ref ,obj))))
    `(lambda (&rest args)
       (format t ',(create-apply obj path))
       (,(create-apply obj path) ,(create-this obj path) args))))



;; "use ffi:ref to get a function reference and then it can be used as a method on that object"
(defclass js-object () 
  ((foreign-ref :initarg :foreign-ref :accessor foreign-ref) 
   (foreign-slots :initarg :foreign-slots :initform '() :accessor foreign-slots) 
   (foreign-methods :initarg :foreign-methods :initform '() :accessor foreign-methods)))

(defgeneric def-foreign-method-impl (obj fun-sym method-ref))

(defmethod def-foreign-method-impl ((obj js-object) fun-sym method-ref)
  (setf (getf (foreign-methods obj) fun-sym) method-ref))

(defgeneric def-foreign-slot-impl (obj slot-sym slot-ref))

(defmethod def-foreign-slot-impl ((obj js-object) slot-sym slot-ref)
  (setf (getf (foreign-slots obj) slot-sym) slot-ref))

(defgeneric call-foreign-method (obj fun-sym args))

(defmacro resolve-list (method-list fun-sym)
  `(,(getf method-list fun-sym)))

(defgeneric get-foreign-slot (obj slot-sym))

(defmethod get-foreign-slot ((obj js-object) slot-sym)
  (funcall (getf (foreign-slots obj) slot-sym)))

(defmacro def-foreign-method (obj fun-name method-ref)
  "use ffi:ref to get a function reference and then it can be used as a method on that object"
  `(progn 
     (def-foreign-method-impl ,obj ',fun-name (create-method ,obj ,method-ref))
     (defmethod ,fun-name ((obj (eql ,obj)) &rest args)
       (funcall (getf (foreign-methods (symbol-value obj)) ',fun-name) (foreign-ref (symbol-value obj))
                args))))


(defmacro def-foreign-slot (obj slot-name slot-ref)
  "use ffi:ref to get a slot reference and then it can be used as a setfable slot on that object"
  (let ((gen-mac (gensym)))
    `(progn 
       (def-foreign-slot-impl ,obj ',slot-name (lambda () (macrolet ((,gen-mac () ',slot-ref))
                                                            (,gen-mac))))
       (defmethod ,slot-name ((obj (eql ,obj)))
         (get-foreign-slot (symbol-value obj) ',slot-name))
       (defmethod (setf ,slot-name) (new-value (obj (eql ,obj)))
         (ffi:set ,slot-ref new-value)))))

(defmacro def-direct-slot (obj slot-path)
  "def-direct-slot will expand to def-foreign-slot with a slot that's directly attached to the foreign reference"
  (if (consp slot-path)
      `(def-foreign-slot ,obj ,(car (last slot-path)) ,(cons 'ffi:ref (cons (list 'foreign-ref obj) slot-path)))
      `(def-foreign-slot ,obj ,slot-path ,(list 'ffi:ref (list 'foreign-ref obj) slot-path))))

(defmacro def-ndirect-slot (obj slot-name slot-path)
  "calling def-ndirect-slot instead of def-direct allows you to name the resulting accessor method"
  (if (consp slot-path)
      `(def-foreign-slot ,obj ,slot-name ,(cons 'ffi:ref (cons (list 'foreign-ref obj) slot-path)))
      `(def-foreign-slot ,obj ,slot-name ,(list 'ffi:ref (list 'foreign-ref obj) slot-path))))

(defmacro def-direct-method (obj method-path)
  (let* ((method-name (car (last method-path)))
         (method-list (if (consp method-path) 
                          (cons 'ffi:ref (cons (list 'foreign-ref obj) method-path))
                          (list 'ffi:ref (list 'foreign-ref obj) method-path))))
    `(def-foreign-method ,obj ,method-name ,method-list)))

(defmacro def-ndirect-method (obj method-name method-path)
  `(def-foreign-method ,obj ,method-name ,method-list))

        ;; (this (if (consp method-path)
        ;;           (reverse (cdr (reverse method-list)))
        ;;           (list 'foreign-ref obj)))


;; (defparameter test-fun (create-method player (rigidbody entity get-guid)))


(defparameter test-obj (make-instance 'js-object :foreign-ref player))
(def-foreign-method test-obj get-guid (get-guid))


;; (js:console.log ((ffi:ref player rigidbody entity get-guid apply) (ffi:ref player rigidbody entity)))

;; (js:console.log (funcall test-fun))

;; (merge 'list '(rigidbody _parent get-guid) (cons 'bind '(rigidbody _parent)) (lambda (x y) nil))
;; (defmacro def-ndirect-method (obj method-name method-path)
;;   "calling def-ndirect-slot instead of def-direct allows you to name the resulting accessor method"
;;   (if (consp method-path)
;;       `(def-foreign-method ,obj ,method-name ,(cons 'ffi:ref (cons (list 'foreign-ref obj) method-path))
;;          ,(reverse (cdr (reverse (cons 'ffi:ref (cons (list 'foreign-ref obj) method-path))))))
;;       `(def-foreign-method ,obj ,method-name ,(list 'ffi:ref (list 'foreign-ref obj) method-path))))


;; usage sample

;; new instance, foreign-ref is a (ffi:ref) object
;; (defparameter test-obj (make-instance 'js-object :foreign-ref player))

;; use ffi:ref to get a function reference and then it can be used as a method on that object
;; (def-foreign-method test-obj log (ffi:ref js:console log))
;; (log 'test-obj #j"test")

;; you can also use (foreign-ref obj) as the ffi:ref parent to get the slot or method from the object
;; (def-foreign-slot test-obj collision (ffi:ref (foreign-ref test-obj) "collision"))
;; (log 'test-obj (collision 'test-obj))

;; slots added this way are setfable
;; (setf (collision 'test-obj) #j"it's broken now")
;; (log 'test-obj (collision 'test-obj))

;; def-direct-slot will expand to def-foreign-slot with a slot that's directly attached to the foreign reference
;; (def-direct-slot player1 euler-angles)
;; (euler-angles 'player1)

;; if def-direct-slot is called with a list for the second param, it will add the slot navigating down the object
;; (name link) will map to the slot obj.name.link and use link as the method name
;; (def-direct-slot player1 (name link)
;; (link 'player1)

;; calling def-ndirect-slot allows you to name the resulting method
;; (def-ndirect-slot player1 player-link (name link)
;; (player-link 'player1)

