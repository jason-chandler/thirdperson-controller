(in-package :thirdperson-controller)

(defclass console (js-object) ())

(defmethod initialize-instance :after ((instance console) &rest initargs &key &allow-other-keys)
  (def-foreign-method instance log (log)))

;; This serves as the original example. There should just be one of these.
(defparameter console (make-instance 'console :foreign-ref js:console))
