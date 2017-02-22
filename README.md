# start on a scratch instance.

* Using Clash 

** Installing clash from scratch
  get a minimal docker instance with debian.
  install stack

** Getting the emacs environment up and running
   link over to the haskell-mode tutorial
   https://wiki.haskell.org/Emacs/Inferior_Haskell_processes
   include .sub-haskell.el 

*** Splitting up .emacs
- Personally, I've split my .emacs into lots of different
  sub-initialization files, this my haskell config.el

(eval-after-load 'haskell-mode
  '(define-key haskell-mode-map [f10] 'haskell-navigate-imports))

(eval-after-load 'haskell-mode
  (custom-set-variables
   '(haskell-process-suggest-remove-import-lines t)
   '(haskell-process-auto-import-loaded-modules t)
   '(haskell-process-log t)))

(eval-after-load 'haskell-cabal
  '(progn
     (define-key haskell-cabal-mode-map (kbd "C-c C-z") 'haskell-interactive-switch)
     (define-key haskell-cabal-mode-map (kbd "C-c C-k") 'haskell-interactive-mode-clear)
     (define-key haskell-cabal-mode-map (kbd "C-c C-c") 'haskell-process-cabal-build)
     (define-key haskell-cabal-mode-map (kbd "C-c c") 'haskell-process-cabal)))

(eval-after-load 'haskell-mode
  '(progn
     (define-key haskell-mode-map (kbd "C-c C-l") 'haskell-process-load-or-reload)
     (define-key haskell-mode-map (kbd "C-c C-z") 'haskell-interactive-switch)
     (define-key haskell-mode-map (kbd "C-c C-n C-t") 'haskell-process-do-type)
     (define-key haskell-mode-map (kbd "C-c C-n C-i") 'haskell-process-do-info)
     (define-key haskell-mode-map (kbd "C-c C-n C-c") 'haskell-process-cabal-build)
     (define-key haskell-mode-map (kbd "C-c C-n c") 'haskell-process-cabal)))

(eval-after-load 'haskell-cabal
  (custom-set-variables '(haskell-process-type 'stack-ghci)))

(require 'haskell-mode)

(require 'haskell-interactive-mode)
(require 'haskell-process)
(add-hook 'haskell-mode-hook 'interactive-haskell-mode)

(custom-set-variables
 '(haskell-process-suggest-remove-import-lines t)
 '(haskell-process-auto-import-loaded-modules t)
 '(haskell-process-log t))

*** Loading the haskell sub-config
- At the bottom of my main ~/.emacs file, there is a small loader that
  loads all sub configs for different languages. 
    
  ;; https://elpa.gnu.org/packages/load-dir.html
  (require 'load-dir)
  (load-dir-one "~/.emacs.d/sub-macs/") ;; sub-haskell.el is in here
  



** Installing clash with stack
   # getting installing the new clash (based on ghc8, has feature ApplicativeDo)
   # what is applicative anyways?   

   # lts-8.2 may be a little newer than the clash compiler.
   # why does that matter? hmm.
   stack install --resolver lts-8.2 clash-ghc

   # this needs to be run so emacs haskell interactive mode can find 
   # clash modules in the project stack repo.
   # interactive-haskell-mode reaches out to 
   # ghc here for type checking in the 
   stack install --resolver=lts-8.2 clash-prelude

   # this is how clash is run from the terminal using the version of
   # clash installed by stack. 
   stack exec --resolver=nightly -- clash --interactive

** What is applicative?
** 
