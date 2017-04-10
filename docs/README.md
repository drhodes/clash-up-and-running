<div id="table-of-contents">
<h2>Table of Contents</h2>
<div id="text-table-of-contents">
<ul>
<li><a href="#org8a49421">1. (THIS IS WORK IN PROGRESS)</a>
<ul>
<li><a href="#orga170fef">1.1. Installing clash from scratch</a></li>
<li><a href="#org5afd958">1.2. Getting the emacs environment up and running</a>
<ul>
<li><a href="#orgebb6ccd">1.2.1. Splitting up .emacs</a></li>
<li><a href="#org3965d89">1.2.2. Loading the haskell sub-config</a></li>
</ul>
</li>
<li><a href="#orge59749b">1.3. Installing clash with stack</a></li>
<li><a href="#org5ca8bb5">1.4. What is applicative?</a></li>
<li><a href="#org06198c0">1.5. </a></li>
</ul>
</li>
</ul>
</div>
</div>
this is the real page:
<https://drhodes.github.io/clash-up-and-running/>


<a id="org8a49421"></a>

# (THIS IS WORK IN PROGRESS)


<a id="orga170fef"></a>

## Installing clash from scratch

get a minimal virtualized debian

    $ vagrant box add https://atlas.hashicorp.com/ARTACK/boxes/debian-jessie

install stack


<a id="org5afd958"></a>

## Getting the emacs environment up and running

link over to the haskell-mode tutorial
<https://wiki.haskell.org/Emacs/Inferior_Haskell_processes>
include .sub-haskell.el 


<a id="orgebb6ccd"></a>

### Splitting up .emacs

-   Personally, I've split my .emacs into lots of different
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


<a id="org3965d89"></a>

### Loading the haskell sub-config

-   At the bottom of my main ~/.emacs file, there is a small loader that
    loads all sub configs for different languages. 
    
        ;; https://elpa.gnu.org/packages/load-dir.html
        (require 'load-dir)
        ;; a custom directory containing all sub-configs.
        (load-dir-one "~/.emacs.d/sub-macs/") ;; sub-haskell.el is in here


<a id="orge59749b"></a>

## Installing clash with stack

ref <http://dev.stephendiehl.com/hask/#applicative-do>
ref <http://learnyouahaskell.com/functors-applicative-functors-and-monoids#applicative-functors>
ref <http://simonmar.github.io/bib/papers/applicativedo.pdf>

    stack install --resolver lts-8.5 clash-ghc

    stack install --resolver=lts-8.5 clash-prelude

    stack exec --resolver=nightly -- clash --interactive


<a id="org5ca8bb5"></a>

## What is applicative?


<a id="org06198c0"></a>

## 

