(in-package :thirdperson-controller)

(defclass screen (pc-component) ())

(defmethod foreign-ref-setter ((instance screen) entity)
  (setf (foreign-ref instance) (ffi:ref entity "screen")))

(defmethod initialize-instance :after ((instance screen) &rest initargs &key &allow-other-keys)
  (def-foreign-slot instance screen-space (screen-space))
  (def-foreign-slot instance enabled (enabled))
  (def-foreign-slot instance priority (priority))
  (def-foreign-slot instance reference-resolution (reference-resolution))
  (def-foreign-slot instance resolution (resolution))
  (def-foreign-slot instance scale-blend (scale-blend))
  (def-foreign-slot instance scale-mode (scale-mode))
  (initialize-slot screen-space)
  (initialize-slot enabled)
  (initialize-slot priority)
  (initialize-slot reference-resolution)
  (initialize-slot resolution)
  (initialize-slot scale-blend)
  (initialize-slot scale-mode))

 (defparameter *screen* (make-instance 'screen 
                                       :ent-name #j"SCREEN"
                                       :scale-mode #j"blend"
                                       :screen-space js:true
                                       :enabled js:true))

(add-to-root *screen*)

