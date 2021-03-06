(defpackage :thirdperson-controller
  (:use :cl :valtan.react-utilities)
  (:shadow LOG)
  (:export MAKE-BUTTON
           LOG
           *ROTATION-FACTOR*
           DEF-FOREIGN-METHOD
           ON-COLLISION-START
           PAIR
           SET-PAIR
           MOUSEMOVE
           ON-MOUSE-DOWN
           UPDATE-JUMP
           *JUMPING*
           TARGET-X
           *CURRENT-ANIMATION*
           CONTROLLER
           EULERS
           COMP-TYPE
           NAME
           ADD-TO-UPDATE
           ASSET-PATH
           RESULT
           COLOR
           WORLD-DIRECTION
           ENT-NAME
           INITIALIZE-SLOT
           RAYCAST-FIRST
           ANSWER
           JS-OBJECT
           CHILD
           PROTO
           IMAGE-ENTITY
           REMOVE-COMPONENT
           ON-GROUND
           *JUMP-FORCE*
           MAKE-LIGHT
           -VEC3
           SLERP
           DO-ANIM
           PLAYER-MODEL
           ADD-TO-ROOT
           SLOT-SYM
           FOREIGN-SLOTS
           ROT
           KEEP-VEL
           FUN-SYM
           SCALE-MODE
           IS-POINTER-LOCKED
           BLEND-SPEED
           METHOD-REF
           DEFPROTOMETHOD
           FOREIGN-REF-SETTER
           CREATE-THIS
           PC-COMPONENT
           UPDATE-MOVEMENT
           REFERENCE-RESOLUTION
           COPY
           ANIMATIONS
           DEF-FOREIGN-SLOT-IMPL
           ANGULAR-VELOCITY
           NULLP
           ROT-Z
           JS-OR
           ADD-CHILD-IMPL
           PATH
           CREATE-SLOT-SETTER
           VALUE
           TEMP-DIRECTION
           *GROUND-NORMAL*
           ENTITY
           UPDATE-ANIMATION
           CREATE-GETTER
           SCALE
           CREATE-METHOD
           DESTROY
           ATTR-OBJ
           LAYERS
           COMPONENT-TYPE
           GET-WORLD-POINT
           GET-GUID
           ENABLE-POINTER-LOCK
           CREATE-APPLY
           OBJ-TYPE
           USE-INPUT
           SET-POSITION
           CAM-RAY-END
           HIT
           SHADOWS
           ADD-SCRIPTS
           CREATE-SCRIPT
           ENT
           ANCHOR
           -Z-E-R-O
           SIZE
           DY
           IS-MOVEMENT-KEY-PRESSED-P
           COLLISION-PATH
           POS
           ASSETS
           ON-TRIGGER-ENTER
           REMOVE-SCRIPTS
           P-UPDATE
           JUMP
           NPC
           SET-LOCAL-EULER-ANGLES
           INSTANCE
           ON
           ATTR-NAME
           KEY
           LOAD-AUDIO
           *DT*
           UPDATE-DT
           LOOK-AT
           SCRIPT-NAME
           SET-ROTATION
           OFF
           LOOP-ANIMATION-P
           DT
           *SCREEN*
           CURRENT-ANIMATION-P
           PIVOT
           ARGS
           *MOVEMENT-SPEED*
           FOREIGN-SLOT-VALUE
           THE-SLOT
           ADD
           COMPONENT-NAME
           ROT-Y
           INVERT
           ON-MOUSE-MOVE
           ADD-MESH-COLLISION
           NORMAL
           APPLY-IMPULSE
           COLLISION
           DX
           POINT
           RESOLUTION
           OBJ
           VEC3
           IN
           ROOT
           FUN-NAME
           NORMALIZE
           FOREIGN-REF
           *JUMP-INIT*
           INVERTED-TARGET
           ELEMENT
           DEF-FOREIGN-SLOT
           MAKE-ELEMENT
           BATCH-GROUP
           MOUSEDOWN
           MODEL
           NEW
           BUTTON
           *GRAVITY*
           LINEAR-VELOCITY
           TARGET-ANG
           STOPPED-P
           ALT
           *UPDATE-LIST*
           SCALE-BLEND
           ROTATION
           PROTO-FN
           FALLING-P
           RIGHT
           GET-POSITION
           MUL-SCALAR
           IDLE
           ACTIVE
           SLOT-REF
           CONSOLE
           IS-PRESSED
           APP
           NEW-ENTITY
           FORMS
           SCREEN-SPACE
           SCREEN
           ADD-COMPONENT
           REMOVE-COMPONENT-IMPL
           RIGIDBODY
           CAMERA
           EXPAND-LIST
           APPLY-FORCE
           FUN
           ENABLED
           FALL
           FORWARD
           ADD-COMPONENT-IMPL
           IS-PRESSED-P
           *MOUSE-SPEED*
           WALK
           DEF-FOREIGN-METHOD-IMPL
           SET-LOCAL-POSITION
           SYSTEMS
           KEYBOARD
           RESOURCE
           FOREIGN-METHODS
           REMOVE-FROM-UPDATE
           VAL
           ADD-ATTRIBUTE
           PARENT
           MODEL-ENTITY
           *ROTATION-HELPER*
           *RAY-END*
           SET-EULER-ANGLES
           ROT-X
           MKSTR
           ANIM-SYM
           SYMB
           ADD-CHILD
           OPTIONS
           PRESET
           ANIMATION
           LOAD-GLB
           TARGET-Y
           PRIORITY
           ARG-LIST
           SLOT-NAME
           GET-ROTATION
           PLAYER-MODEL-ENTITY
           SCRIPT
           IMAGE-ENT
           *GROUND-CHECK-RAY*
           LOAD-FROM-URL
           ORIGIN-ENTITY
           ASSET
           PLAY
           TRANSITION-MODE
           ACTION
           ANIM
           SET-UP-ANIMATIONS
           LOAD-STATIC
           SET-UP-CAMERA
           LOAD-STATIC-CUSTOM
           SET-UP-MODEL
           TELEPORT
           FIND-BY-NAME
           JS-SETF
           MODEL-ENTITY
           VEC2
           VEC4
           WIDTH))

(defpackage :getting-familiar
  (:shadowing-import-from :thirdperson-controller :log)
  (:use :cl :valtan.react-utilities :thirdperson-controller))
