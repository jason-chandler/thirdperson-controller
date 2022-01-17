(in-package :thirdperson-controller)

(defclass rigidbody (pc-component) ())

(defmethod foreign-ref-setter ((instance rigidbody) entity)
  (setf (foreign-ref instance) (ffi:ref entity "rigidbody")))

(defmethod initialize-instance :after ((instance element) &rest initargs &key &allow-other-keys)
  (def-foreign-slot instance type (type))
  (initialize-slot type))




