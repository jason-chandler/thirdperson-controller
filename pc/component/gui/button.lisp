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


;; (defparameter button-ent (make-instance 'entity))
;;  (defparameter *another-element* (make-element :ent button-ent
;;                                                :type #j"image" 
;;                                                :color (ffi:new js:pc.-color 1 1 1)
;;                                                :anchor (ffi:array 0.5 0.5 0.5 0.5)
;;                                                :height 40
;;                                                :pivot (ffi:array 0.5 0.5)
;;                                                :width 40
;;                                                :use-input js:true))
;;  (defparameter test-button (make-button :ent button-ent :ent-name #j"other-button2"))

;; (setf (anchor *another-element*) (vec4 :x 0.9 :y 0.01 :z 0.9 :w 0.15)
;;       (pivot *another-element*) (vec2 :x 0.1 :y 0.1)
;;       (width *another-element*) 30)

;; (add-child *screen* button-ent)





