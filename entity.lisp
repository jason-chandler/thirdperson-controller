(in-package :thirdperson-controller)

(defclass entity (js-object) ())

(defmethod initialize ((obj entity))
  (def-foreign-method obj add-component-impl (add-component))
  (def-foreign-method obj remove-component-impl (remove-component))
  (def-foreign-method obj add-child-impl (add-child))
  (def-foreign-method obj destroy (destroy))
  (def-foreign-method obj get-guid (get-guid))
  (call-next-method))

(defmethod add-component ((obj entity) component-name)
  (add-component-impl obj #jcomponent-name))

(defmethod remove-component ((obj entity) component-name)
  (remove-component-impl obj #jcomponent-name))

(defmethod add-child ((obj entity) child)
  (add-child-impl obj (foreign-ref child)))

(defmethod add-to-root ((obj entity))
  ((ffi:ref js:pc app root add-child) (foreign-ref obj)))

