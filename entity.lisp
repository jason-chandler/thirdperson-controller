(in-package :thirdperson-controller)

(defclass entity (js-object) ())

(defmethod initialize-instance :after ((instance entity) &rest initargs &key &allow-other-keys)
  (if (not (getf initargs :foreign-ref))
      (let ((new-entity (ffi:new (ffi:ref "pc.Entity"))))
        (setf initargs (cons :foreign-ref (cons new-entity initargs)))
        (setf (foreign-ref instance) new-entity)))
  (def-foreign-slot instance name (name))
  (def-foreign-slot instance parent (parent))
  (initialize-slot name)
  (when (getf initargs :parent)
      (add-child (getf initargs :parent) instance))
  (def-foreign-method instance add-component-impl (add-component))
  (def-foreign-method instance remove-component-impl (remove-component))
  (def-foreign-method instance add-child-impl (add-child))
  (def-foreign-method instance destroy (destroy))
  (def-foreign-method instance get-guid (get-guid)))

;; (defmethod initialize-workaround ((instance entity) &rest initargs &key &allow-other-keys)
;;   (js:console.log #j "should not be running this")
;;   (if (not (getf initargs :foreign-ref))
;;       (let ((new-entity (ffi:new (ffi:ref "pc.Entity"))))
;;         (setf initargs (cons :foreign-ref (cons new-entity initargs)))
;;         (setf (foreign-ref instance) new-entity)))
;;   (call-next-method)
;;   (js:console.log 1)
;;   (js:console.log (foreign-ref instance))
;;   (def-foreign-slot instance name (name))
;;   (def-foreign-slot instance parent (parent))
;;   (initialize-slot name)
;;   (def-foreign-method instance add-component-impl (add-component))
;;   (def-foreign-method instance remove-component-impl (remove-component))
;;   (def-foreign-method instance add-child-impl (add-child))
;;   (def-foreign-method instance destroy (destroy))
;;   (def-foreign-method instance get-guid (get-guid))
;;   instance)

(defmethod add-component ((obj t) component-name)
  ((ffi:ref obj add-component) #jcomponent-name))

(defmethod add-component ((obj entity) component-name)
  (add-component-impl obj #jcomponent-name))

(defmethod remove-component ((obj entity) component-name)
  (remove-component-impl obj #jcomponent-name))

(defmethod parent ((obj t))
  (ffi:ref obj parent))

(defmethod add-child ((obj t) (child t))
  ((ffi:ref obj add-child) (foreign-ref child)))

(defmethod add-child ((obj entity) (child t))
  (add-child-impl obj (foreign-ref child)))

(defmethod add-to-root ((obj t))
  ((ffi:ref js:pc app root add-child) obj))

(defmethod add-to-root ((obj entity))
  ((ffi:ref js:pc app root add-child) (foreign-ref obj)))

