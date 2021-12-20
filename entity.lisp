(in-package :thirdperson-controller)

(defclass entity (js-object) ())

(defmethod initialize ((obj entity))
  (def-foreign-method obj add-component-impl (add-component))
  (def-foreign-method obj get-guid (get-guid))
  (call-next-method))

(defmethod add-component ((obj entity) component-name)
  (add-component-impl obj #jcomponent-name))

