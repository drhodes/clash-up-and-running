<div id="table-of-contents">
<h2>Table of Contents</h2>
<div id="text-table-of-contents">
<ul>
<li><a href="#org434c5df">1. (THIS IS WORK IN PROGRESS)</a>
<ul>
<li><a href="#orgb0b64ed">1.1. Installing clash from scratch</a></li>
<li><a href="#org1982bfe">1.2. Getting the emacs environment up and running</a>
<ul>
<li><a href="#orgdcce524">1.2.1. Splitting up .emacs</a></li>
<li><a href="#org4c849f8">1.2.2. Loading the haskell sub-config</a></li>
</ul>
</li>
<li><a href="#orgee8599e">1.3. Installing clash with stack</a></li>
<li><a href="#org8b39272">1.4. What is applicative?</a></li>
<li><a href="#orgdbce723">1.5. </a></li>
</ul>
</li>
</ul>
</div>
</div>
this is the real page:
[blog page](<https://drhodes.github.io/clash-up-and-running/>)


<a id="org434c5df"></a>

# (THIS IS WORK IN PROGRESS)


<a id="orgb0b64ed"></a>

## Installing clash from scratch

get a minimal virtualized debian

    $ vagrant box add https://atlas.hashicorp.com/ARTACK/boxes/debian-jessie

install stack


<a id="org1982bfe"></a>

## Getting the emacs environment up and running

link over to the haskell-mode tutorial
<https://wiki.haskell.org/Emacs/Inferior_Haskell_processes>
include .sub-haskell.el 


<a id="orgdcce524"></a>

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


<a id="org4c849f8"></a>

### Loading the haskell sub-config

-   At the bottom of my main ~/.emacs file, there is a small loader that
    loads all sub configs for different languages. 
    
        ;; https://elpa.gnu.org/packages/load-dir.html
        (require 'load-dir)
        ;; a custom directory containing all sub-configs.
        (load-dir-one "~/.emacs.d/sub-macs/") ;; sub-haskell.el is in here


<a id="orgee8599e"></a>

## Installing clash with stack

ref <http://dev.stephendiehl.com/hask/#applicative-do>
ref <http://learnyouahaskell.com/functors-applicative-functors-and-monoids#applicative-functors>
ref <http://simonmar.github.io/bib/papers/applicativedo.pdf>

    stack install --resolver lts-8.5 clash-ghc

    stack install --resolver=lts-8.5 clash-prelude

    stack exec --resolver=nightly -- clash --interactive


<a id="org8b39272"></a>

## What is applicative?


<a id="orgdbce723"></a>

## 

