(in-package :thirdperson-controller)

(defclass screen (component) ())

(defmethod initialize-instance :after ((instance screen) &rest initargs &key &allow-other-keys)
  (def-foreign-slot instance screen-space (screen-space))
  (def-foreign-slot instance enabled (enabled))
  (def-foreign-slot instance priority (priority))
  (def-foreign-slot instance reference-resolution (reference-resolution))
  (def-foreign-slot instance resolution (resolution))
  (def-foreign-slot instance scale-blend (scale-blend))
  (def-foreign-slot instance scale-mode (scale-mode)))

(let ((screen-entity (ffi:new (ffi:ref "pc.Entity"))))
  (add-component screen-entity #j"screen")
  (defparameter *screen* (make-instance 'screen 
                                           :parent-name "SCREEN"
                                           :foreign-ref (ffi:ref screen-entity screen))))

;; (setf (screen-space *screen*) js:true)


;; (log console #j(parent-name *screen*))
;; (log console (ffi:ref (foreign-ref *screen*) entity name))
;; (log console (foreign-ref *screen*))
;; (log console (foreign-ref *screen*))
;; (log console (screen-space *screen*))

