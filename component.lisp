(in-package :thirdperson-controller)

(defclass component (js-object) ((parent-ent :initarg :parent-ent :accessor parent-ent :initform '())
                                 (parent-name :initarg :parent-name :accessor parent-name :initform '())))

(defmethod initialize ((obj component))
  (when (parent-name obj)
    (ffi:set (ffi:ref (foreign-ref obj) entity name) #j(parent-name obj)))
  (unless (parent-ent obj)
    (setf (parent-ent obj) (ffi:ref (foreign-ref obj) entity)))
  (def-foreign-slot obj parent-name (entity name))
  (call-next-method))