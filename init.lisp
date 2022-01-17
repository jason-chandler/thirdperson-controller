(in-package :lem-user)
;;(load-library "pygments-colorthemes")

(push #P"/home/jason/common-lisp/" asdf:*central-registry*)

(unless (member "ultralisp" (ql-dist:all-dists)
                :key 'ql-dist:name
                :test 'string=)
  (ql-dist:install-dist "http://dist.ultralisp.org/"
                        :prompt nil))

(ql:quickload :valtan)

(progn (ql:quickload :trivial-ws)
       (load #P"/home/jason/.roswell/lisp/quicklisp/local-projects/lem-valtan/remote-eval")
       (load #P"/home/jason/.roswell/lisp/quicklisp/local-projects/lem-valtan/valtan-mode")
       (load #P"/home/jason/.roswell/lisp/quicklisp/local-projects/lem-valtan/main"))

(defun pared-hook ()
  (lem-paredit-mode:paredit-mode))

(add-hook lem-lisp-mode:*lisp-mode-hook* #'pared-hook)

(define-command start-web-serve () () 
(labels ((split-/ (path) (split-sequence:split-sequence "/" path :test #'string-equal :remove-empty-subseqs t))
                                                (concatenate-string (&rest seqs) (apply #'concatenate 'string seqs))
                                                (get-system (dir) (concatenate-string dir (car (last (split-/ dir))) ".system"))
                                                (concatenate-/ (target) (concatenate-string target "/"))
                                                (up-dir (path) (butlast (butlast path))))

  (let ((system-path (get-system (buffer-directory))))
    (loop :while (and (not (cl-fad:file-exists-p (pathname system-path))) (string-not-equal system-path ".system"))
          :do
             (let ((next-path (apply #'concatenate-string (mapcar #'concatenate-/  
                                                                  (up-dir 
                                                                   (split-/ system-path))))))
               (setf system-path (get-system next-path))
               system-path))
    (lem-valtan/main:start system-path))))
(loop for (k . f) in (list (cons "M-F" 'lem-paredit-mode:paredit-slurp) 
                           (cons "M-B" 'lem-paredit-mode:paredit-barf)
                           (cons "M-C-v" 'lem-valtan.valtan-mode:valtan-mode)
                           (cons "M-C-w" 'lem-user::start-web-serve))
      do (define-key lem-paredit-mode:*paredit-mode-keymap* k f))

(define-color-theme "monokai" ()
  (foreground "#eeeeee")
  (background "#262626")
  (cursor :foreground "#262626" :background "#eeeeee")
  (syntax-warning-attribute :foreground "#87005f" :background "#262626")
  (syntax-string-attribute :foreground "#d7d787" :background "#262626")
  (syntax-comment-attribute :foreground "#666666" :background "#262626")
  (syntax-keyword-attribute :foreground "#5fd7ff" :background "#262626")
  (syntax-constant-attribute :foreground "#5fd7ff" :background "#262626")
  (syntax-function-name-attribute :foreground "#afd700" :background "#262626")
  (syntax-variable-attribute :foreground nil :background "#262626")
  (syntax-type-attribute :foreground nil :background "#262626")
  (syntax-builtin-attribute :foreground nil :background "#262626"))

(load-theme "monokai")