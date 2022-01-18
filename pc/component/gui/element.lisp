(in-package :thirdperson-controller)

(defclass element (pc-component) ())

(defmethod foreign-ref-setter ((instance element) entity)
  (setf (foreign-ref instance) (ffi:ref entity "element")))

(defmethod initialize-instance :after ((instance element) &rest initargs &key &allow-other-keys)
  (def-foreign-slot instance type (type))
  (def-foreign-slot instance color (color))
  (def-foreign-slot instance preset (preset))
  (def-foreign-slot instance anchor (anchor))
  (def-foreign-slot instance pivot (pivot))
  (def-foreign-slot instance size (size))
  (def-foreign-slot instance margin (margin))
  (def-foreign-slot instance use-input (use-input))
  (def-foreign-slot instance layers (layers))
  (def-foreign-slot instance batch-group (batch-group))
  (initialize-slot type)
  (initialize-slot color)
  (initialize-slot preset)
  (initialize-slot anchor)
  (initialize-slot pivot)
  (initialize-slot size)
  (initialize-slot margin)
  (initialize-slot use-input)
  (initialize-slot layers)
  (initialize-slot batch-group))

(defun make-element (&rest options &key &allow-other-keys)
  (let ((element (apply #'make-instance 'element options)))
    element))

;; (defparameter test-element2 (make-element  :parent *screen*
;;                                            :type #j"image" 
;;                                            :ent-name #j"test"
;;                                            :anchor (ffi:array 0.5 0.5 0.5 0.5)
;;                                            :height 64
;;                                            :pivot (ffi:array 0.5 0.5)
;;                                            :width 175
;;                                            :use-input js:true))
