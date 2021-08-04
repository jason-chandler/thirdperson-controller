(in-package :thirdperson-controller)

(on update (ffi:ref js:pc app) (lambda (dt &rest _)
                                 (js:console.log dt)))

