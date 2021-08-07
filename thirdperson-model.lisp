(in-package :thirdperson-controller)

(defparameter player-model (ffi:new (ffi:ref "pc.Entity") #j"PLAYER-MODEL"))
(defparameter *rotation-factor* 5)

(defun set-up-model (player asset-path)
  (let ((camera (find-by-name "CAMERA-AXIS")))
    ((ffi:ref player add-child) player-model)
    (load-glb player-model asset-path js:true)
    (labels ((update-movement (dt &rest _)
               (let* ((forward (ffi:ref camera forward))
                     (right (ffi:ref camera right))
                     (x 0)
                     (z 0)
                     (target-y (ffi:ref ((ffi:ref camera get-euler-angles)) y))
                     (target-rot ((ffi:ref camera get-rotation)))
                     (target-rot2 ((ffi:ref (ffi:new (ffi:ref "pc.Quat")) set-from-euler-angles) 0 target-y 0))
                     (rot (ffi:new (ffi:ref "pc.Quat"))))
                 (if (is-pressed-p "KEY_A")
                     (decf x))
                 (if (is-pressed-p "KEY_D")
                     (incf x))
                 (if (is-pressed-p "KEY_W")
                     (incf z))
                 (if (is-pressed-p "KEY_S")
                     (decf z))
                 (if (or 
                      (not (zerop x))
                      (not (zerop z)))
                     (progn
                       ((ffi:ref rot copy) ((ffi:ref player-model get-rotation)))
                       ((ffi:ref rot slerp) rot
                                            target-rot
                                            (* (or *rotation-factor* 1) dt))
                       ((ffi:ref player-model set-rotation) rot))))))
      (add-to-update :model-rotate #'update-movement))))

(js:console.log )
(on update player (lambda (dt &rest _) (js:console.log "this")))
(progn
  (defparameter player (find-by-name "PLAYER"))
  (set-up-model player "./files/assets/testbox.glb"))