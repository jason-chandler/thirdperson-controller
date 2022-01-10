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
  (defparameter *screen* (initialize (make-instance 'screen 
                                                    :name "SCREEN"
                                                    :foreign-ref ((ffi:ref screen-entity add-component)
                                                                  #j"screen")))))

;; (setf (screen-space *screen*) js:true)


;; (log console #j(name *screen-entity*))
;; (log console (foreign-ref *screen*))
(log console (foreign-ref *screen*))
(log console (screen-space *screen*))

