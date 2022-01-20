(in-package :thirdperson-controller)

(defparameter big-controller (initialize (make-instance 'controller :foreign-ref player)))

(add-component big-controller "sound")
(add-component player "sprite")
(log console (class-name (class-of player)))


(initialize other-test)
(initialize other-test2)

(log other-test #j"test")
(log other-test (log other-test2))

(defparameter other-test (make-instance 'console :foreign-ref js:console))
(defparameter other-test2 (make-instance 'controller :foreign-ref player))
(defparameter console (make-instance 'js-object :foreign-ref js:console))
(defparameter console2 (make-instance 'js-object :foreign-ref player))
(def-foreign-method console log (log))
(def-foreign-method console2 log (get-guid))

(defmacro auto-test (obj)
  `(progn 
     (def-foreign-method ,obj log (log))
     (def-foreign-method ,obj get-guid (get-guid))))

(auto-test console2)

(js:console.log (get-guid console2))
(log console (log other-test #j"hello"))
(setf (foreign-methods other-test) (foreign-methods console2))
(log console #j"hello squirreled")
(log console (log console2))

(js:console.log (foreign-methods console2))

(js:console.log ((ffi:ref player1 get-guid)))
(js:console.log (class-of player1))

(js:console.log ((ffi:ref player1 get-guid apply) (ffi:ref player1)))
(defparameter player1 (make-instance 'js-object :foreign-ref player))

(def-foreign-slot player1 rigidbody (rigidbody))
(setf (rigidbody 'player1) #j"this'll break it")
(js:console.log (rigidbody 'player1))

(def-foreign-method player1 get-guid (rigidbody entity get-guid))
(js:console.log (get-guid 'player1))

(def-foreign-method player1 teleport (rigidbody teleport))
(js:console.log (teleport 'player1 0 10 0))

(defparameter player1-collision (make-instance 'js-object :foreign-ref (ffi:ref player "collision")))

(def-direct-slot player1 (rigidbody body-type))
(def-ndirect-slot player1 player-body-type (rigidbody body-type))
(def-direct-slot player1 euler-angles)


(def-foreign-slot player1-collision entity (ffi:ref (foreign-ref player1-collision) "entity"))
(def-foreign-slot player1 obj-name (ffi:ref (foreign-ref player1) "name"))

(def-ndirect-method player1 player-activate (rigidbody activate))
(def-ndirect-method player1 get-guid get-guid)

((ffi:ref js:console log) (get-guid 'player1))

(ffi:set js:testfun (getf (foreign-methods player1) 'get-guid))
(ffi:set js:testfun (getf (foreign-methods player1) 'player-activate))
(player-activate 'player1)

(setf (obj-name 'player1) #j"Haroldson")
(setf (name 'player1) #j"Haroldson")
((ffi:ref js:console log) (body-type 'player1))
((ffi:ref js:console log) (player-body-type 'player1))
((ffi:ref js:console log) (player-length 'player1))
(setf (player-body-type 'player1) #j"cheats")

((ffi:ref js:console log) (entity 'player1-collision))
((ffi:ref js:console log) (euler-angles 'player1))

((ffi:ref js:console log) (entity 'player1-collision))
((ffi:ref js:console log) (obj-name 'player1))



