(in-package :thirdperson-controller)

;; (on update (ffi:ref js:pc app) (lambda (dt &rest _)
;;                                 (js:console.log dt)))

(defparameter *mouse-speed* 1.4)


(defun set-up-camera (camera)
  (let ((eulers (vec3))
        (app (ffi:ref js:pc app))
        (ray-end (find-by-name "RAYCAST-ENDPOINT")))
    (labels ((on-mouse-move (e &rest _)
               (if ((ffi:ref js:pc -mouse is-pointer-locked))
                   (progn 
                     (js-setf (eulers x) (- (ffi:ref eulers x)
                                                    (mod (/ (* *mouse-speed* (ffi:ref e dx)) 60) 360))
                              (eulers y) (+ (ffi:ref eulers y) (mod (/ (* *mouse-speed* (ffi:ref e dy)) 60) 360)))
                     (if (< (ffi:ref eulers x) 0)
                         (ffi:set (ffi:ref eulers x) (+ (ffi:ref eulers x) 360)))
                     (if (< (ffi:ref eulers y) 0)
                         (ffi:set (ffi:ref eulers y) (+ (ffi:ref eulers y) 360))))))
             (on-mouse-down (e &rest _)
               ((ffi:ref app mouse enable-pointer-lock)))
             (get-world-point (&rest _)
               (let* ((from ((ffi:ref camera parent get-position)))
                      (to ((ffi:ref ray-end get-position)))
                      (hit-point to)
                      (hit ((ffi:ref app systems rigidbody raycast-first) from to)))
                 (if hit
                     (ffi:ref hit point)
                     to)))
             (p-update (dt &rest _)
               (let* ((origin-entity (ffi:ref camera parent))
                     (target-y (+ (ffi:ref eulers x) 180))
                     (target-x (ffi:ref eulers y))
                     (target-ang (vec3 :x (- target-x) :y target-y)))
                 ((ffi:ref origin-entity set-euler-angles) target-ang)
                 ((ffi:ref camera set-position) (get-world-point))
                 ((ffi:ref camera look-at) origin-entity))))
      (on mousemove (ffi:ref app mouse) #'on-mouse-move camera)
      (on mousedown (ffi:ref app mouse) #'on-mouse-down camera)
      (add-to-post-update :cam #'p-update))))


(js:console.log (remove-from-post-update :cam))
(defparameter cam (find-by-name "CAMERA"))

(js:console.log (find-by-name "CAMERA"))

(set-up-camera cam)

(js:console.log *post-update-list*)

(js:console.log (find-by-name "RAYCAST-ENDPOINT"))