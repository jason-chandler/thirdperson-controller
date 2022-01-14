(in-package :thirdperson-controller)

(defclass entity (js-object) ())

(defmethod initialize-instance :after ((instance entity) &rest initargs &key &allow-other-keys)
  (def-foreign-slot instance name (name))
  (initialize-slot name)
  (def-foreign-method instance add-component-impl (add-component))
  (def-foreign-method instance remove-component-impl (remove-component))
  (def-foreign-method instance add-child-impl (add-child))
  (def-foreign-method instance destroy (destroy))
  (def-foreign-method instance get-guid (get-guid)))

(defmethod add-component ((obj entity) component-name)
  (add-component-impl obj #jcomponent-name))

(defmethod remove-component ((obj entity) component-name)
  (remove-component-impl obj #jcomponent-name))

(defmethod add-child ((obj t) child)
  ((ffi:ref obj add-child) (foreign-ref child)))

(defmethod add-child ((obj entity) child)
  (add-child-impl obj (foreign-ref child)))

(defmethod add-to-root ((obj t))
  ((ffi:ref js:pc app root add-child) obj))

(defmethod add-to-root ((obj entity))
  ((ffi:ref js:pc app root add-child) (foreign-ref obj)))

