(ffi:require js:react "react")
(ffi:require js:react-dom "react-dom")

(in-package :thirdperson-controller)

(define-react-component <app> ()
  (jsx (:h1 () "")))

(load-static-custom "./files/assets/maps/1/pokemon3.glb" t "./files/assets/maps/1/pokemon3_coll.glb")

(defparameter player (find-by-name "PLAYER"))
(set-up-model player "./files/assets/rion.glb")
(set-up-animations player model-entity)

(defparameter light (find-by-name "LIGHT"))
(js-setf (light light shadow-distance) 100
         (light light shadow-resolution) 2048)

(js-setf (player rigidbody mass) 1
         (player rigidbody angular-factor) (ffi:ref js:pc -vec3 -z-e-r-o)
         (player rigidbody restitution) 0.1)

(defparameter cam (find-by-name "CAMERA"))
(let ((cam-parent (ffi:ref cam parent)))
  ((ffi:ref cam reparent) js:null)
  ((ffi:ref cam set-local-position) 0 0.6 10)
  ((ffi:ref cam reparent) cam-parent))
(set-up-camera cam)

(setup '<app> "root" :remote-eval t)

(teleport (find-by-name "PLAYER") :x 0 :y 10 :z 0 :rot-x 0 :rot-y 0 :rot-z 0 :keep-vel nil)
