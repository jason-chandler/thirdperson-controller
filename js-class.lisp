(in-package :thirdperson-controller)

(defmacro create-method (obj path)
  (labels ((create-apply (obj path)
             `(ffi:ref ,obj ,@path apply))
           (create-this (obj path)
             (if (> (length path) 1)
                 `(ffi:ref ,obj ,@(reverse (cdr (reverse path))))
                 `(ffi:ref ,obj))))
    `(lambda (args)
       ;; Some kind of odd bug turns up with return retrieval for macros nested in CLOS methods
       ;; workaround is to use let binding
       (let ((answer (,(create-apply obj path) ,(create-this obj path) (apply #'ffi:array args))))
         answer))))

 (defmacro create-slot (obj path)
   (labels ((create-getter (obj path)
              `(ffi:ref ,obj ,@path)))
     `(lambda ()
        ,(create-getter obj path))))

(defmacro create-slot-setter (obj path)
  (labels ((the-slot (obj path)
              `(ffi:ref ,obj ,@path)))
     `(lambda (val)
        (ffi:set ,(the-slot obj path) val))))

;; "use ffi:ref to get a function reference and then it can be used as a method on that object"
(defclass js-object () 
  ((foreign-ref :initarg :foreign-ref :accessor foreign-ref) 
   (foreign-slots :initarg :foreign-slots :initform '() :accessor foreign-slots) 
   (foreign-methods :initarg :foreign-methods :initform '() :accessor foreign-methods)))

;; if foreign-ref is used on something without one, return object as-is
(defmethod foreign-ref ((obj t))
  obj)

(defgeneric def-foreign-method-impl (obj fun-sym method-ref))

(defmethod def-foreign-method-impl ((obj js-object) fun-sym method-ref)
  (setf (getf (foreign-methods obj) fun-sym) method-ref))

(defgeneric def-foreign-slot-impl (obj slot-sym slot-ref))

(defmethod def-foreign-slot-impl ((obj js-object) slot-sym slot-ref)
  (setf (getf (foreign-slots obj) slot-sym) slot-ref))

(defgeneric get-foreign-slot (obj slot-sym))

(defmethod get-foreign-slot ((obj js-object) slot-sym)
  (getf (foreign-slots obj) slot-sym))

(defmacro def-foreign-method (obj fun-name method-ref)
  "use ffi:ref to get a function reference and then it can be used as a method on that object"
  `(progn 
     (def-foreign-method-impl ,obj ',fun-name (create-method (foreign-ref ,obj) ,method-ref))
     (defmethod ,fun-name ((obj js-object) &rest args)
       (funcall (getf (foreign-methods obj) ',fun-name) args))))

(defmacro def-foreign-slot (obj slot-name slot-ref)
  "use ffi:ref to get a slot reference and then it can be used as a setfable slot on that object"
  `(progn 
     (def-foreign-slot-impl ,obj ',slot-name (create-slot (foreign-ref ,obj) ,slot-ref))
     (defmethod ,slot-name ((obj js-object))
       (funcall (get-foreign-slot obj ',slot-name)))
     (defmethod (setf ,slot-name) (new-value (obj js-object))
       (funcall (create-slot-setter (foreign-ref obj) ,slot-ref) new-value))))

;; usage sample

;; New instance, foreign-ref is a (ffi:ref) object
;; (defparameter test-console (make-instance 'js-object :foreign-ref js:console))
;; (defparameter test-player (make-instance 'js-object :foreign-ref (find-by-name "PLAYER")))

;; Call define as: (def-foreign-method js-obj name-of-new-generic-function (path from foreign-ref down to child fun)
;; (def-foreign-method test-console log (log))
;; (log test-console #j"test")

;; Definition is similar for slots
;; (def-foreign-slot test-player collision (collision))
;; (log test-console (collision test-player))

;; Slots added this way are setfable
;; (setf (collision test-player) #j"it's broken now")
;; (log test-console (collision test-player))

(defmethod initialize-instance :after ((instance js-object) &rest initargs &key &allow-other-keys)
  (setf (foreign-ref instance) (getf initargs :foreign-ref)))
