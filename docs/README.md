<div id="table-of-contents">
<h2>Table of Contents</h2>
<div id="text-table-of-contents">
<ul>
<li><a href="#org8fd8139">1. Using Clash</a>
<ul>
<li><a href="#org7bac0ed">1.1. Installing clash from scratch</a></li>
<li><a href="#orgf61b78b">1.2. Getting the emacs environment up and running</a>
<ul>
<li><a href="#org8705e48">1.2.1. Splitting up .emacs</a></li>
<li><a href="#org8122ab4">1.2.2. Loading the haskell sub-config</a></li>
</ul>
</li>
<li><a href="#org602d08a">1.3. Installing clash with stack</a></li>
<li><a href="#orgf7a693c">1.4. What is applicative?</a></li>
<li><a href="#org4201c53">1.5. </a></li>
</ul>
</li>
</ul>
</div>
</div>

<a id="org8fd8139"></a>

# Using Clash


<a id="org7bac0ed"></a>

## Installing clash from scratch

get a minimal docker instance with debian.
install stack


<a id="orgf61b78b"></a>

## Getting the emacs environment up and running

link over to the haskell-mode tutorial
<https://wiki.haskell.org/Emacs/Inferior_Haskell_processes>
include .sub-haskell.el 


<a id="org8705e48"></a>

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


<a id="org8122ab4"></a>

### Loading the haskell sub-config

-   At the bottom of my main ~/.emacs file, there is a small loader that
    loads all sub configs for different languages. 
    
        ;; https://elpa.gnu.org/packages/load-dir.html
        (require 'load-dir)
        (load-dir-one "~/.emacs.d/sub-macs/") ;; sub-haskell.el is in here


<a id="org602d08a"></a>

## Installing clash with stack

stack install &#x2013;resolver lts-8.2 clash-ghc

stack install &#x2013;resolver=lts-8.2 clash-prelude

stack exec &#x2013;resolver=nightly &#x2013; clash &#x2013;interactive


<a id="orgf7a693c"></a>

## What is applicative?


<a id="org4201c53"></a>

## 

