(in-package :thirdperson-controller)

(defclass controller (entity) ())

(defmethod initialize ((obj controller))
  (call-next-method))
