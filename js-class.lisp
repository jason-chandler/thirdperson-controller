(in-package :thirdperson-controller)

(defclass js-object () 
  ((foreign-ref :initarg :foreign-ref :accessor foreign-ref) 
   (foreign-slots :initarg :foreign-slots :initform '() :accessor foreign-slots) 
   (foreign-methods :initarg :foreign-methods :initform '() :accessor foreign-methods)))

(defgeneric def-foreign-method-impl (obj fun-sym method-ref))

(defmethod def-foreign-method-impl ((obj js-object) fun-sym (method-ref function))
  (setf (getf (foreign-methods obj) fun-sym) method-ref))

(defgeneric def-foreign-slot-impl (obj slot-sym slot-ref))

(defmethod def-foreign-slot-impl ((obj js-object) slot-sym slot-ref)
  (setf (getf (foreign-slots obj) slot-sym) slot-ref))

(defgeneric call-foreign-method (obj fun-sym args))

(defmethod call-foreign-method ((obj js-object) fun-sym args)
  (apply (ffi:ref (getf (foreign-methods obj) fun-sym)) args))

(defgeneric get-foreign-slot (obj slot-sym))

(defmethod get-foreign-slot ((obj js-object) slot-sym)
  (ffi:ref (getf (foreign-slots obj) slot-sym)))

(defmacro def-foreign-method (obj fun-name method-ref)
  (let ((class (class-name (class-of (symbol-value obj)))))
    `(progn 
       (def-foreign-method-impl ,obj ',fun-name ,method-ref)
       (defmethod ,fun-name ((obj (eql ,obj)) &rest args)
         (call-foreign-method (symbol-value obj) ',fun-name args)))))

(defmacro def-foreign-slot (obj slot-name slot-ref)
  `(progn 
     (def-foreign-slot-impl ,obj ',slot-name ,slot-ref)
     (defmethod ,slot-name ((obj (eql ,obj)))
       (get-foreign-slot (symbol-value obj) ',slot-name))
     (defmethod (setf ,slot-name) (new-value (obj (eql ,obj)))
       (ffi:set ,slot-ref new-value)
       (remf (foreign-slots (symbol-value obj)) ',slot-name)
       (setf (getf (foreign-slots (symbol-value obj)) ',slot-name) new-value))))

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
