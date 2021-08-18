(in-package :thirdperson-controller)

(defparameter *jump-init* nil)
(defparameter *current-animation* 'idle)

(defun set-up-animations (player player-model-entity)
  (labels ((current-animation-p (anim-sym)
             (eq *current-animation* anim-sym))
           (is-movement-key-pressed-p ()
             (or
              (is-pressed-p "KEY_A")
              (is-pressed-p "KEY_D")
              (is-pressed-p "KEY_S")
              (is-pressed-p "KEY_W")))
           (stopped-p ()
             (let ((x (ffi:ref player rigidbody linear-velocity x))
                   (y (ffi:ref player rigidbody linear-velocity y))
                   (z (ffi:ref player rigidbody linear-velocity z)))
               (and
                (< x 1)
                (> x -1)
                (< y 1)
                (> y -1)
                (< z 1)
                (> z -1))))
           (update-animation (dt &rest _)
             (cond 
               ((and (not *jump-init*) *jumping* (not (current-animation-p 'jump))) 
                (progn 
                  (setf *jump-init* t)
                  (do-anim player-model-entity "rion.glb/animation/2" 0.4 nil)
                  (js:set-timeout ((ffi:ref (lambda () (setf *jump-init* nil))
                                            "bind") player-model-entity) 300)))
               ((and (not *jump-init*) 
                       (not *jumping*)
                       (not (current-animation-p 'fall))
                       (eql (ffi:ref player on-ground) js:null)) (progn 
                                                                   (setf *current-animation* 'fall)
                                                                   (do-anim player-model-entity "rion.glb/animation/3" 0.8 t)))
               ((and (is-movement-key-pressed-p)
                     (not (current-animation-p 'walk))) (progn
                                                          (setf *current-animation* 'walk)
                                                          (do-anim player-model-entity "rion.glb/animation/1" 0.5 t)))
               ((and 
                 (stopped-p)
                 (not (is-movement-key-pressed-p))
                 (not (current-animation-p 'idle))
                 (ffi:ref player on-ground)) 
                (progn 
                  (setf *current-animation* 'idle)
                  (do-anim player-model-entity "rion.glb/animation/0" 0.2 t))))))
    (add-to-update :anim #'update-animation)))

