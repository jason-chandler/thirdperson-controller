(in-package :thirdperson-controller)

(defun vec2 (&key (x 0) (y 0))
  (ffi:new (ffi:ref "pc.Vec2") x y))

(defun vec3 (&key (x 0) (y 0) (z 0))
  (ffi:new (ffi:ref "pc.Vec3") x y z))

(defun vec4 (&key (x 0) (y 0) (z 0) (w 0))
  (ffi:new (ffi:ref "pc.Vec4") x y z w))