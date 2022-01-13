(in-package :thirdperson-controller)

(defclass component (js-object) ())

(defmethod initialize ((obj component))
  (def-foreign-method obj add-child-impl (entity add-child))
  (def-foreign-slot obj parent-name (entity name))
  (def-foreign-slot obj parent-ent (entity))
  (call-next-method))

(defmethod add-child ((obj component) child)
  (add-child-impl obj (foreign-ref child)))qq

(defmethod add-to-root ((obj component))
  ((ffi:ref js:pc app root add-child) (foreign-ref (parent-ent obj))))

