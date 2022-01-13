(in-package :thirdperson-controller)

(defclass element (component) ())

(defmethod initialize ((obj element))
  (def-foreign-slot obj elmnt-type (type))
  (def-foreign-slot obj preset (preset))
  (def-foreign-slot obj anchor (anchor))
  (def-foreign-slot obj pivot (pivot))
  (def-foreign-slot obj size (size))
  (def-foreign-slot obj margin (margin))
  (def-foreign-slot obj use-input (use-input))
  (def-foreign-slot obj layers (layers))
  (def-foreign-slot obj batch-group (batch-group))
  (call-next-method))


(defun add-element (parent &rest options &key elmnt-type &allow-other-keys)
  (let ((element-entity (ffi:new (ffi:ref "pc.Entity"))))
    (add-component element-entity "element")
    (let ((element (initialize (apply #'make-instance 'element :foreign-ref (ffi:ref element-entity element) options))))
      (when elmnt-type
        (setf (elmnt-type element) #jelmnt-type))
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

