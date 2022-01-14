(in-package :thirdperson-controller)

(defclass component (js-object) ())

(defmethod initialize-instance :after ((instance component) &rest initargs &key &allow-other-keys)
  (def-foreign-method instance add-child-impl (entity add-child))
  (def-foreign-slot instance parent-name (entity name))
  (def-foreign-slot instance parent-ent (entity)))

(defmethod add-child ((obj component) child)
  (add-child-impl obj (foreign-ref child)))

(defmethod add-to-root ((obj component))
  ((ffi:ref js:pc app root add-child) (foreign-ref (parent-ent obj))))

