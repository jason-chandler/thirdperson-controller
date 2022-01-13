(in-package :thirdperson-controller)

(defclass screen (component) ())

(defmethod initialize ((obj screen))
  (def-foreign-slot obj screen-space (screen-space))
  (def-foreign-slot obj enabled (enabled))
  (def-foreign-slot obj priority (priority))
  (def-foreign-slot obj reference-resolution (reference-resolution))
  (def-foreign-slot obj resolution (resolution))
  (def-foreign-slot obj scale-blend (scale-blend))
  (def-foreign-slot obj scale-mode (scale-mode))
  (call-next-method))

(let ((screen-entity (ffi:new (ffi:ref "pc.Entity"))))
  (add-component screen-entity #j"screen")
  (defparameter *screen* (initialize (make-instance 'screen 
                                                    :parent-name "SCREEN"
                                                    :foreign-ref (ffi:ref screen-entity screen)))))

;; (setf (screen-space *screen*) js:true)


;; (log console #j(parent-name *screen*))
;; (log console (ffi:ref (foreign-ref *screen*) entity name))
;; (log console (foreign-ref *screen*))
;; (log console (foreign-ref *screen*))
;; (log console (screen-space *screen*))

