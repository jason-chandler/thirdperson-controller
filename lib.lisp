(in-package :thirdperson-controller)

(defparameter *dt* nil)

(defparameter *update-list* nil)

;; Paul Graham helper function
(defun mkstr (&rest args)
  (with-output-to-string (s)
    (dolist (a args) (princ a s))))

;; Paul Graham helper function
(defun symb (&rest args)
  (values (intern (apply #'mkstr args))))

(defun create-script (script-name)
  (js:pc.create-script #jscript-name))

(defmacro add-attribute (obj attr-name &rest attr-obj)
  `((ffi:ref ,obj "attributes" "add") #j,attr-name (ffi:object ,@attr-obj)))

(defmacro defprotomethod (slot-name proto lambda-list &body proto-fn)
  `(ffi:set (ffi:ref ,proto "prototype" ,(compiler::kebab-to-lower-camel-case 
                                          (string slot-name)))
            (lambda (,@lambda-list) ,@proto-fn)))

(defmacro new (obj-type &rest args)
  `(let ((this (ffi:object)))
     (if (null (list ,@args))
         (progn 
           ((ffi:ref js:pc ,obj-type "prototype" "constructor" "call") this)
           this)
         (progn 
           ((ffi:ref js:pc ,obj-type "prototype" "constructor" "call") this ,@args)
           this))))

;; not needed
(defmacro js-or (&rest args)
  (flet ((expand-list (arg-list) 
           (mapcar #'(lambda (arg)
                       `(if (and 
                             (not (eql ,arg js:undefined))
                             (not (eql ,arg js:false))
                             (not (eql ,arg js:null)))
                            (progn 
                              (js:console.log ,arg)
                              ,arg)))
                   arg-list)))
    `(or ,@(funcall #'expand-list args))))

(defun vec3 (&key (x 0) (y 0) (z 0))
  (ffi:new (ffi:ref "pc.Vec3") x y z))

(defmacro js-setf (&rest forms)
  (flet ((set-pair (pair)
           (if (listp (car pair))
               `(ffi:set (ffi:ref ,@(car pair)) ,(cadr pair))
               `(setf ,(car pair) ,(cadr pair)))))
    `(progn ,@(mapcar #'set-pair (loop for (key value) on forms by #'cddr
                                     collect (list key value))))))
   
(defun add-scripts (ent script-list)
  (loop for script in script-list
        do ((ffi:ref ent "script" "create") #jscript)))

(defun remove-scripts (ent script-list)
  (loop for script in script-list
        do ((ffi:ref ent "script" "destroy") #jscript)))

(defmethod add-component ((ent t) comp-type)
  ((ffi:ref ent "addComponent") #jcomp-type))

(defun find-by-name (name)
  (js:pc.app.root.find-by-name #jname))

(defun add-to-root (child)
  ((ffi:ref js:pc app root add-child) child))

(defun on-collision-start (ent fun)
  ((ffi:ref ent collision on) #j"collisionstart" fun ent))

(defun on-trigger-enter (ent fun)
  ((ffi:ref ent collision on) #j"triggerenter" fun ent))

(defun teleport (ent &key x y z rot-x rot-y rot-z keep-vel)
  (if (not keep-vel)
      (progn (ffi:set (ffi:ref ent rigidbody linear-velocity) (ffi:ref js:pc -vec3 -z-e-r-o))
             (ffi:set (ffi:ref ent rigidbody angular-velocity) (ffi:ref js:pc -vec3 -z-e-r-o))))
  ((ffi:ref ent rigidbody teleport) (ffi:new (ffi:ref "pc.Vec3") x y z)
                                    (ffi:new (ffi:ref "pc.Vec3") rot-x rot-y rot-z)))

(defun load-glb (entity path shadows &rest args)
  ((ffi:ref entity add-component) #j"model" (ffi:object #j"type" #j"asset"
                                                        #j"castShadows" shadows
                                                        #j"receiveShadows" shadows))
  ((ffi:ref js:pc app assets load-from-url) #jpath 
                                            #j"container"
                                            (lambda (err asset)
                                              ((ffi:ref entity add-component) #j"animation")
                                              (js-setf (asset preload) t
                                                       (entity model asset) (ffi:ref asset resource model)
                                                       (entity model animations) (ffi:ref asset resource animations)
                                                       (entity animation assets) (ffi:ref entity model animations))
                                              (loop for fun in args
                                                    do (if fun 
                                                           (funcall fun)))))
  entity)

(defun add-mesh-collision (entity path)
  ((ffi:ref entity add-component) #j"collision")
  (js-setf (entity collision type) #j"mesh")
  ((ffi:ref js:pc app assets load-from-url) #jpath 
                                            #j"container"
                                            (lambda (err asset)
                                              (js-setf (entity collision asset) (ffi:ref asset resource model)))))


(defun load-static (path shadows &rest args)
  (let ((ent (ffi:new (ffi:ref "pc.Entity"))))
    (load-glb ent path shadows args)
    (add-mesh-collision ent path)
    ((ffi:ref ent add-component) #j"rigidbody")
    ((ffi:ref js:pc app root add-child) ent)
    (or ent)))

(defun make-light (parent x y z type &key (r 1) (g 1) (b 1) (a 1))
  (let ((ent (ffi:new (ffi:ref "pc.Entity"))))
    ((ffi:ref parent add-child) ent)
    ((ffi:ref ent add-component) #j"light")
    (js-setf (ent light color) (ffi:new (ffi:ref "pc.Color") r g b a)
             (ent light type) #jtype
             (ent position) (vec3 :x x :y y :z z))
    (or ent)))

(defun update-dt ()
  ((ffi:ref js:pc app on) #j"update" (lambda (dt &rest _) 
                                       (setf *dt* dt)
                                       (loop for (key . val) in *update-list*
                                             do (when val (funcall val *dt*))))))

(defun add-to-update (key val)
  (push (cons key val) *update-list*))

(defun remove-from-update (key)
  (setf *update-list* (remove key *update-list* :key #'car)))

(defun load-audio (entity path &rest args)
  ((ffi:ref js:pc app assets load-from-url) #jpath 
                                            #j"audio"
                                            (lambda (err asset)
                                              (js-setf (entity asset) asset))
                                            entity)
  (or entity))

(defmacro on (action entity fun &optional (this entity))
  `((ffi:ref ,entity on) (ffi:cl->js ,(compiler::kebab-to-lower-camel-case (string action))) ,fun ,this))

(defmacro off (action entity fun &optional (this entity))
  `((ffi:ref ,entity off) (ffi:cl->js ,(compiler::kebab-to-lower-camel-case (string action))) ,fun ,this))

(defmacro is-pressed-p (key)
  `(eql ((ffi:ref js:pc app keyboard is-pressed) (ffi:ref js:pc ,key)) 
        js:true))

(defun nullp (comp)
  (if (or (equal js:null comp) (equal js:undefined comp))
      t))

(defun do-anim (entity anim blend-speed loop-animation-p)
  (when (not (nullp (ffi:ref entity animation)))
      (if (and loop-animation-p (not (equal (ffi:ref entity animation) js:undefined)))
          (js-setf (entity animation loop) js:true)
          (js-setf (entity animation loop) js:false))
      (when (not (nullp (ffi:ref entity animation play)))
          ((ffi:ref entity animation play) #janim blend-speed))))

(update-dt)

