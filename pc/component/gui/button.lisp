(in-package :thirdperson-controller)

(defclass button (pc-component) ())

(defmethod foreign-ref-setter ((instance button) entity)
  (setf (foreign-ref instance) (ffi:ref entity "button")))

(defmethod initialize-instance :after ((instance button) &rest initargs &key &allow-other-keys)
  (def-foreign-slot instance active (active))
  (def-foreign-slot instance image-ent (image-entity))
  (def-foreign-slot instance transition-mode (transition-mode))
  (initialize-slot active js:true)
  (initialize-slot image-ent (ent instance))
  (initialize-slot transition-mode #j"blend"))

(defun make-button (&rest options &key &allow-other-keys)
  (apply #'make-instance 'button options))

;; (defparameter *another-element* (make-element :type #j"image" :color (ffi:new js:pc.-color 1 1 1)))
;; (defparameter test-button (make-button :ent (ent *another-element*) :ent-name #j"other-button2"))

;; (add-child *screen* test-button)

;; (log console (foreign-ref test-button))
;; (log console (ffi:ref *screen*))



