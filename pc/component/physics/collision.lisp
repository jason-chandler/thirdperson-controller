(in-package :thirdperson-controller)

(defclass collision (pc-component) ())

(defmethod foreign-ref-setter ((instance collision) entity)
  (setf (foreign-ref instance) (ffi:ref entity "collision")))

(defmethod initialize-instance :after ((instance element) &rest initargs &key &allow-other-keys)
  (def-foreign-slot instance type (type))
  (def-foreign-slot instance radius (radius))
  (def-foreign-slot instance height (height))
  (def-foreign-slot instance half-extents (half-extents))
  (initialize-slot type)
  (initialize-slot radius)
  (initialize-slot height))

