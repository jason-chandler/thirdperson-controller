(in-package :thirdperson-controller)

(defclass element (component) ())

(defmethod initialize-instance :after ((instance element) &rest initargs &key &allow-other-keys)
  (def-foreign-slot instance elmnt-type (type))
  (def-foreign-slot instance preset (preset))
  (def-foreign-slot instance anchor (anchor))
  (def-foreign-slot instance pivot (pivot))
  (def-foreign-slot instance size (size))
  (def-foreign-slot instance margin (margin))
  (def-foreign-slot instance use-input (use-input))
  (def-foreign-slot instance layers (layers))
  (def-foreign-slot instance batch-group (batch-group)))


(defun add-element (parent &rest options &key elmnt-type &allow-other-keys)
  (let ((element-entity (ffi:new (ffi:ref "pc.Entity"))))
    (add-component element-entity "element")
    (let ((element (apply #'make-instance 'element :foreign-ref (ffi:ref element-entity element) options)))
      (add-child parent (ffi:ref (foreign-ref element) entity))
      element)))

;; (log console (ffi:ref (foreign-ref *screen*) "entity"))

;; (log console (parent-name *screen*))
;; (log console (ffi:ref (foreign-ref *screen*) entity name))
;; (defparameter test-element2 (add-element *screen* :elmnt-type "image"))

;; (log console #j(elmnt-type test-element2))
;; (log console (ffi:ref (foreign-ref test-element2) type))
;; (setf (elmnt-type test-element2) #j"group")
;; (log console #j(elmnt-type test-element2))

;; (log console (foreign-ref test-element2))
;; (log console #j(class-name (class-of *screen*)))
;; (log console #j(typep *screen* 'screen))

