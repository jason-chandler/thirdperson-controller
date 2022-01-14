(in-package :thirdperson-controller)

(defclass controller (entity) ())

(defmethod initialize-instance :after ((instance controller) &rest initargs &key &allow-other-keys))
