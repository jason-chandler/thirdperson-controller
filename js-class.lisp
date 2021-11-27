(in-package :thirdperson-controller)

(defclass js-object () 
  ((struct-name :initarg :struct-name :initform "JS-OBJECT" :accessor struct-name)
   (foreign-ref :initarg :foreign-ref :initform '() :accessor foreign-ref) 
   (foreign-slots :initarg :foreign-slots :initform '() :accessor foreign-slots) 
   (foreign-methods :initarg :foreign-methods :initform '() :accessor foreign-methods)))

(defgeneric def-foreign-method-impl (obj fun-sym method-ref))

(defmethod def-foreign-method-impl ((obj js-object) fun-sym (method-ref function))
  ((ffi:ref js:console log) #j"pushing method-ref ")
  ((ffi:ref js:console log) method-ref)
  ((ffi:ref js:console log) fun-sym)
  ((ffi:ref js:console log) obj)
  (push method-ref (foreign-methods obj))
  (push fun-sym (foreign-methods obj)))

(defgeneric call-foreign-method (obj fun-sym args))

(defmethod call-foreign-method ((obj js-object) fun-sym args)
  ((ffi:ref js:console log) #j"calling foreign method with: ")
  ((ffi:ref js:console log) obj)
  (apply (ffi:ref (getf (foreign-methods obj) fun-sym)) args))

(defmacro def-foreign-method (obj fun-name method-ref)
  (let ((obj-val (gensym)))
    `(progn 
       (def-foreign-method-impl ,obj ',fun-name ,method-ref)
       (let ((,obj-val ,obj))
         (defmethod ,fun-name ((obj js-object) &rest args)
           (call-foreign-method obj ',fun-name args))))))

;;(defparameter test-obj (make-instance 'js-object))
;;(defparameter test-obj2 (make-instance 'js-object))

;;(def-foreign-method test-obj test-method (ffi:ref js:console log))

;;((ffi:ref js:console log) (symbol-value (intern "TEST-OBJ")))

;;(test-method test-obj #j"test")




