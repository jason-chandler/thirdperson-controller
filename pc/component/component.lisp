(in-package :thirdperson-controller)

(defclass pc-component (js-object) ())

(defmethod component-type ((instance pc-component))
  (string-downcase (string (class-name (class-of instance)))))

(defmethod add-component ((obj pc-component) component-name)
  (add-component-impl obj #jcomponent-name))

(defmethod add-child ((obj t) (child pc-component))
  ((ffi:ref obj add-child) (foreign-ref (ent child))))

(defmethod add-child ((obj entity) (child pc-component))
  (add-child-impl obj (foreign-ref (ent child))))

(defmethod add-child ((obj pc-component) (child t))
  (add-child-impl obj (foreign-ref child)))

(defmethod add-child ((obj pc-component) (child pc-component))
  (add-child-impl obj (foreign-ref (ent child))))

(defmethod foreign-ref-setter ((instance pc-component) entity)
  (log console #j"FOREIGN-REF-SETTER NOT DEFINED FOR COMPONENT")
  (setf (foreign-ref instance) (ffi:ref entity "component")))

(defmethod initialize-instance :after ((instance pc-component) &rest initargs &key &allow-other-keys)
  (if (not (getf initargs :ent))
      (let ((new-entity (ffi:new (ffi:ref "pc.Entity"))))
        (setf initargs (cons :ent (cons new-entity initargs)))))
  (def-foreign-slot instance ent (entity))
  (setf (getf initargs :ent) (foreign-ref (getf initargs :ent)))
  (initialize-slot ent)
  (def-foreign-slot instance ent-name (entity name))
  (initialize-slot ent-name)
  (def-foreign-method instance add-child-impl (entity add-child))
  (def-foreign-method instance add-component-impl (entity add-component))
  (when (getf initargs :parent)
    (add-child (getf initargs :parent) (ent instance)))
  (def-foreign-slot instance parent (entity parent))
  (initialize-slot parent)
  (when (or (not (slot-boundp instance 'foreign-ref)) (not (foreign-ref instance)))
    ((ffi:ref (foreign-ref (getf initargs :ent)) add-component) #j(component-type instance))
    (foreign-ref-setter instance (ent instance))))

(defmethod add-to-root ((obj pc-component))
  ((ffi:ref js:pc app root add-child) (foreign-ref (ent obj))))

