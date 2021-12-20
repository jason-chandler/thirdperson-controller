(in-package :thirdperson-controller)

(defclass console (js-object) ())

(defmethod initialize ((obj console))
  (def-foreign-method obj log (log))
  (call-next-method))

;; This serves as the original example. There should just be one of these.
(defparameter console (initialize (make-instance 'console :foreign-ref js:console)))
