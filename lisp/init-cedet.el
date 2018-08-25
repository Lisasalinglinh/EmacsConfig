;; init-cedet.el --- Initialize c configurations.	-*- lexical-binding: t -*-

;; Copyright (C) 2018 Vincent Zhang

;; Author: Vincent Zhang <seagle0128@gmail.com>
;; URL: https://github.com/seagle0128/.emacs.d

;; This file is not part of GNU Emacs.
;;
;; This program is free software; you can redistribute it and/or
;; modify it under the terms of the GNU General Public License as
;; published by the Free Software Foundation; either version 2, or
;; (at your option) any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
;; General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with this program; see the file COPYING.  If not, write to
;; the Free Software Foundation, Inc., 51 Franklin Street, Fifth
;; Floor, Boston, MA 02110-1301, USA.
;;

;;; Commentary:
;;
;; C/C++ configuration.
;;

;;; Code:

;; C/C++ Mode
;;http://cedet.sourceforge.net/ and http://alexott.net/en/writings/emacs-devenv/EmacsCedet.html
;;CEDET is best used with new project, because Semantic parse code as you write. As a result, you won't have to wait for parsing unknown source files to get completion candidates.
(require 'cedet)
(require 'cc-mode)
(require 'semantic)
;;system include file
(require 'semantic/bovine/gcc)


(global-semanticdb-minor-mode 1)
(global-semantic-idle-scheduler-mode 1)
(global-semantic-stickyfunc-mode 1)
;; (semantic-load-enable-code-helpers)

(semantic-mode 1)


;; if you want to enable support for gnu global

(semanticdb-enable-gnu-global-databases 'c-mode)
(semanticdb-enable-gnu-global-databases 'c++-mode)
(global-ede-mode t)

(defun alexott/cedet-hook ()
  (local-set-key "\C-c\C-j" 'semantic-ia-fast-jump)
  (local-set-key "\C-c\C-s" 'semantic-ia-show-summary)
  ;; (local-set-key "." 'semantic-complete-self-insert)
  ;; (local-set-key ">" 'semantic-complete-self-insert)
  ;; (local-set-key [(f3)] 'semantic-ia-complete-symbol)
  ;; (local-set-key "\C-c?" 'semantic-ia-complete-symbol-menu)
  ;; (local-set-key "\C-c>" 'semantic-complete-analyze-inline)
  ;; (local-set-key "\C-cp" 'semantic-analyze-proto-impl-toggle)
  )
(add-hook 'c-mode-common-hook 'alexott/cedet-hook)
(add-hook 'c-mode-hook 'alexott/cedet-hook)
(add-hook 'c++-mode-hook 'alexott/cedet-hook)

;;add more include paths
;;additional directories
(semantic-add-system-include "/usr/include/")
;; (semantic-add-system-include "/usr/include/c++/7/" 'c++-mode) ;;only available on c++
(semantic-add-system-include "/usr/include/c++/7/" ) ;;available on both c and c++
(semantic-add-system-include "/usr/include/x86_64-linux-gnu/")
(semantic-add-system-include "/home/ttt/WorkSpace/include/")


(require 'eassist)
(defun my-c-mode-common-hook ()
  (define-key c-mode-base-map (kbd "<f4>") 'eassist-switch-h-cpp)
  (define-key c-mode-base-map (kbd "M-m") 'eassist-list-methods))
(add-hook 'c-mode-common-hook 'my-c-mode-common-hook)

;;semantic-refactor:https://github.com/tuhdo/semantic-refactor
(require 'srefactor)
(require 'srefactor-lisp)


(define-key c-mode-map (kbd "M-RET") 'srefactor-refactor-at-point)
(define-key c++-mode-map (kbd "M-RET") 'srefactor-refactor-at-point)
(global-set-key (kbd "M-RET o") 'srefactor-lisp-one-line)
(global-set-key (kbd "M-RET m") 'srefactor-lisp-format-sexp)
(global-set-key (kbd "M-RET d") 'srefactor-lisp-format-defun)
(global-set-key (kbd "M-RET b") 'srefactor-lisp-format-buffer)
(global-set-key (kbd "C-c l") 'senator-previous-tag)
(global-set-key (kbd "C-c n") 'senator-next-tag)



;;Package function-args,

(require 'function-args)
(fa-config-default)
(add-to-list 'auto-mode-alist '("\\.h\\'" . c++-mode))
(require 'semantic/bovine/c)
(add-to-list 'semantic-lex-c-preprocessor-symbol-file
             "/usr/lib/gcc/x86_64-linux-gnu/7/include/stddef.h")
(define-key c++-mode-map (kbd "C-c f s") 'fa-show)
(define-key c++-mode-map (kbd "C-c f j") 'fa-jump)
(define-key c++-mode-map (kbd "C-c f l") 'moo-jump-local)         ;;Offers to jump to any tag in current buffer.
(define-key c++-mode-map (kbd "C-c f d") 'moo-jump-directory)
(define-key c++-mode-map (kbd "C-c f v") 'moo-propose-virtual)   ;;Lists the virtual members of current class' parents. The selected candidate will be inserted at point.
(define-key c++-mode-map (kbd "C-c f o") 'moo-propose-override)  ;;Lists all member functions of current class' parents. The selected candidate will be inserted at point.

(add-to-list 'semantic-default-submodes 'global-semantic-stickyfunc-mode)

(provide 'init-cedet)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; init-cedet.el ends here
