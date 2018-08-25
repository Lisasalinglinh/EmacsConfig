;; custom-post.el --- Initialize company configurations.	-*- lexical-binding: t -*-

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
;; Auto-completion configurations.
;;

;;; Code:




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;       conpany extral settings             ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; NOT to load company-mode for certain major modes.
;; Ironic that I suggested this feature but I totally forgot it
;; until two years later.
;; https://github.com/company-mode/company-mode/issues/29
(setq company-global-modes
      '(not
        eshell-mode comint-mode erc-mode gud-mode rcirc-mode
        minibuffer-inactive-mode))

;; (use-package company-posframe
;;   :if (display-graphic-p)
;;   :after company

;;   :hook (company-mode . company-posframe-mode)
;;   )



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;       Ivy extral settings                 ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;; (use-package flx
;;   :defer t
;;   :init
;;   (setq ivy-re-builders-alist
;;         '((counsel-ag . ivy--regex-plus)
;;           (counsel-grep . ivy--regex-plus)
;;           (swiper . ivy--regex-plus)
;;           (t . ivy--regex-fuzzy))
;;         ivy-initial-inputs-alist nil))

(use-package flycheck-posframe
  :after flycheck
  :config
  (add-hook 'flycheck-mode-hook #'flycheck-posframe-mode))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;      org-mode extral settings             ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(org-babel-do-load-languages 'org-babel-load-languages
                             '((emacs-lisp . t)
                               (python . t)
                               (shell . t)
                               (latex . t)
                               (dot . t)
                               (C . t)
                               (plantuml . t)
                               (ditaa . t)
                               (clojure . t)
                               (ruby . t)))
;;pluml
(setq org-plantuml-jar-path
      (expand-file-name "~/.emacs.d/plugin/plantuml.jar"))
;; (setq org-ditaa-jar-path (format "%s%s" (expand-file-name "/home/ttt/emacsBackEnd/ditaa0_9.jar")) )
;; Enable plantuml-mode for PlantUML files
(add-to-list 'auto-mode-alist '("\\.plantuml\\'" . plantuml-mode))

;; Integration with org-mode
(add-to-list 'org-src-lang-modes '("plantuml" . plantuml))
;;代码按语法高亮
(setq org-src-fontify-natively t)
(setq org-src-tab-acts-natively t)
(add-to-list 'org-export-backends 'md)


(with-eval-after-load 'hydra
  (eval-and-compile
    (defun hot-expand (str &optional mod)
      "Expand org template."
      (let (text)
        (when (region-active-p)
          (setq text (buffer-substring (region-beginning) (region-end)))
          (delete-region (region-beginning) (region-end)))
        (insert str)
        (org-try-structure-completion)
        (when mod (insert mod) (forward-line))
        (when text (insert text)))))

  (defhydra hydra-org-template (:color blue :hint nil)
    "
_c_++     qu_o_te     _e_macs-lisp    _L_aTeX:
_l_atex   _E_xample   _r_uby          _i_ndex:
_a_scii   _v_erse     p_y_thon        _I_NCLUDE:
_s_rc     _g_o        _p_erl          _H_TML:
_h_tml    plant_u_ml  _S_HELL         _A_SCII:
_C_       ^ ^         _P_erl          ^ ^
^ ^       ^ ^         ^ ^
"
    ("s" (hot-expand "<s"))
    ("E" (hot-expand "<e"))
    ("o" (hot-expand "<q"))
    ("v" (hot-expand "<v"))
    ("c" (hot-expand "<c"))
    ("l" (hot-expand "<l"))
    ("h" (hot-expand "<h"))
    ("a" (hot-expand "<a"))
    ("L" (hot-expand "<L"))
    ("i" (hot-expand "<i"))
    ("e" (hot-expand "<s" "emacs-lisp -n -r :exports both"))
    ("r" (hot-expand "<s" "ruby"))
    ("c" (hot-expand "<s" "C++ -n -r :exports both"))
    ("C" (hot-expand "<s" "C -n -r :exports both"))
    ("y" (hot-expand "<s" "python :results output"))
    ("g" (hot-expand "<s" "go :imports '\(\"fmt\"\)"))
    ("p" (hot-expand "<s" "perl"))
    ("S" (hot-expand "<s" "sh"))
    ("u" (hot-expand "<s" "plantuml :file figures/CHANGE.png :exports results"))
    ("P" (progn
           (insert "#+HEADERS: :results output :exports both :shebang \"#!/usr/bin/env perl\"\n")
           (hot-expand "<s" "perl")))
    ("I" (hot-expand "<I"))
    ("H" (hot-expand "<H"))
    ("A" (hot-expand "<A"))
    ("<" self-insert-command "ins")
    ("q" nil "quit"))
  (defun hot-expand (str &optional mod)
    "Expand org template."
    (let (text)
      (when (region-active-p)
        (setq text (buffer-substring (region-beginning) (region-end)))
        (delete-region (region-beginning) (region-end)))
      (insert str)
      (org-try-structure-completion)
      (when mod (insert mod) (forward-line))
      (when text (insert text))))

  (bind-key "<"
            (lambda () (interactive)
              (if (or (region-active-p) (looking-back "^" 1))
                  (hydra-org-template/body)
                (self-insert-command 1)))
            org-mode-map))

;; publlish settings

(setq org-fontify-whole-heading-line t)
(setq org-publish-project-alist
      '(
        ;; These are the main web files
        ("org-notes"
         :base-directory "/home/ttt/org/Notes/" ;; Change this to your local dir
         :base-extension "org"
         :publishing-directory "/home/ttt/org/public_html/"
         :recursive t
         :org-publish-use-timestamps-flag nil ;;https://www.gnu.org/software/emacs/manual/html_node/org/Uploading-files.html#Uploading-files
         :publishing-function org-html-publish-to-html
         :headline-levels 4             ; Just the default for this project.
         ;; :auto-preamble t
         :auto-sitemap t
         :sitemap-filename "index.org"
         :sitemap-title "Index"
         :sitemap-sort-files alphabetically ;;按照字母表顺序排列文件
         :section-numbers t
         :table-of-contents t
         :html-preamble t
         ;; :html-head "<link rel=\"stylesheet\" href=\"/home/un/org/Notes/css/style.css\" type=\"text/css\"/>"
         ;; :html-head "<link rel=\"stylesheet\" href=\"../css/style.css\" type=\"text/css\"/>"

         )
        ;; These are static files (images, pdf, etc)
        ("org-static"
         :base-directory "/home/ttt/org/Notes/" ;; Change this to your local dir
         :base-extension "css\\|js\\|png\\|jpg\\|gif\\|pdf\\|mp3\\|ogg\\|swf\\|txt\\|asc"
         :publishing-directory "/home/ttt/org/public_html/"
         ;; :publishing-directory "/home/un/gtcp2305.github.io"
         :recursive t
         :publishing-function org-publish-attachment
         )

        ("blog" :components ("org-notes" "org-static"))
        ))


;; 


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;      c/c++-mode extral settings           ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;compile
;;https://github.com/zenitani/elisp/blob/master/smart-compile.el
(require 'smart-compile)
;; (require 'c-toggle-dot-pointer)
;;https://www.emacswiki.org/emacs/CompilationMode
(defun my-recompile ()
  "Run compile and resize the compile window closing the old one if necessary"
  (interactive)
  (progn
    (if (get-buffer "*compilation*") ; If old compile window exists
        (progn
          (delete-windows-on (get-buffer "*compilation*")) ; Delete nnthe compilation windows
          (kill-buffer "*compilation*") ; and kill the buffers
          )
      )
    (call-interactively 'smart-compile)
    (enlarge-window 20)
    )
  )
(defun my-next-error ()
  "Move point to next error and highlight it"
  (interactive)
  (progn
    (next-error)
    (end-of-line-nomark)
    (beginning-of-line-mark)
    )
  )

(defun my-previous-error ()
  "Move point to previous error and highlight it"
  (interactive)
  (progn
    (previous-error)
    (end-of-line-nomark)
    (beginning-of-line-mark)
    )
  )

(global-set-key (kbd "C-M-n") 'my-next-error)
(global-set-key (kbd "C-M-p") 'my-previous-error)
(global-set-key (kbd "C-r") 'my-recompile)
;;https://www.emacswiki.org/emacs/CompileCommand
(defun notify-compilation-result(buffer msg)
  "Notify that the compilation is finished,
close the *compilation* buffer if the compilation is successful,
and set the focus back to Emacs frame"
  (if (string-match "^finished" msg)
      (progn
        (delete-windows-on buffer)
        (tooltip-show "\n Compilation Successful :-) \n "))
    (tooltip-show "\n Compilation Failed :-( \n "))
  (setq current-frame (car (car (cdr (current-frame-configuration)))))
  (select-frame-set-input-focus current-frame)
  )

(add-to-list 'compilation-finish-functions
             'notify-compilation-result)
(setq compilation-finish-functions 'compile-autoclose)
(defun compile-autoclose (buffer string)
  (cond ((string-match "finished" string)
         (message "Build maybe successful: closing window.")
         (run-with-timer 5 nil
                         'delete-window
                         (get-buffer-window buffer t)))
        (t
         (message "Compilation exited abnormally: %s" string))))

;; (defun recompile-quietly ()
;;   "Re-compile without changing the window configuration."
;;   (interactive)
;;   (save-window-excursion
;;     (recompile)))

;; code fold
(use-package origami
  :ensure t
  :commands (origami-mode)
  :bind (:map origami-mode-map
              ("C-c o :" . origami-recursively-toggle-node)
              ("C-c o a" . origami-toggle-all-nodes)
              ("C-c o t" . origami-toggle-node)
              ("C-c o o" . origami-show-only-node)
              ("C-c o u" . origami-undo)
              ("C-c o U" . origami-redo)
              ("C-c o C-r" . origami-reset)
              )
  :config
  (setq origami-show-fold-header t)
  ;; The python parser currently doesn't fold if/for/etc. blocks, which is
  ;; something we want. However, the basic indentation parser does support
  ;; this with one caveat: you must toggle the node when your cursor is on
  ;; the line of the if/for/etc. statement you want to collapse. You cannot
  ;; fold the statement by toggling in the body of the if/for/etc.
  (add-to-list 'origami-parser-alist '(python-mode . origami-indent-parser))
  :init
  (add-hook 'prog-mode-hook 'origami-mode)
  )
;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ;;;      text edit extral settings           ;;;
;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;press C-q C-j to input ^L
(defun xah-display-control-l-as-line ()
  "Display the formfeed ^L char as line.
URL `http://ergoemacs.org/emacs/emacs_form_feed_section_paging.html'
Version 2017-06-18"
  (interactive)
  ;; 2016-10-11 thanks to Steve Purcell's page-break-lines.el
  (progn
    (when (not buffer-display-table)
      (setq buffer-display-table (make-display-table)))
    (aset buffer-display-table ?\^L
          (vconcat (make-list 70 (make-glyph-code ?─ 'font-lock-comment-face))))
    (redraw-frame)))
;; keys for moving to prev/next code section (Form Feed; ^L)
(global-set-key (kbd "<C-M-prior>") 'backward-page) ; Ctrl+Alt+PageUp
(global-set-key (kbd "<C-M-next>") 'forward-page)   ; Ctrl+Alt+PageDown

;; ascii-art-to-unicode  M-x aa2u
(use-package  ascii-art-to-unicode)



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;      ui    settings                       ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; (setq inhibit-splash-screen t)

;; ;; ;; Hide the scroll bar
;; (defvar my-font-size 100)
;; ;; ;; Make mode bar small
;; (set-face-attribute 'mode-line nil  :height my-font-size)
;; ;; ;; Set the header bar font
;; (set-face-attribute 'header-line nil  :height my-font-size)

;; ;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ;; ;; Enable which function mode and set the header line to display both the
;; ;; ;; path and the function we're in
;; ;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; (which-function-mode t)

;; ;; Remove function from mode bar
;; (setq mode-line-misc-info
;;       (delete (assoc 'which-func-mode
;;                      mode-line-misc-info) mode-line-misc-info))


;; (defmacro with-face
;;     (str &rest properties)
;;   `(propertize ,str 'face (list ,@properties)))

;; (defun sl/make-header ()
;;   "."
;;   (let* ((sl/full-header (abbreviate-file-name buffer-file-name))
;;          (sl/header (file-name-directory sl/full-header))
;;          (sl/drop-str "[...]")
;;          )
;;     (if (> (length sl/full-header)
;;            (window-body-width))
;;         (if (> (length sl/header)
;;                (window-body-width))
;;             (progn
;;               (concat (with-face sl/drop-str
;;                                  :background "blue"
;;                                  :weight 'bold
;;                                  )
;;                       (with-face (substring sl/header
;;                                             (+ (- (length sl/header)
;;                                                   (window-body-width))
;;                                                (length sl/drop-str))
;;                                             (length sl/header))
;;                                  ;; :background "red"
;;                                  :weight 'bold
;;                                  )))
;;           (concat
;;            (with-face sl/header
;;                       ;; :background "red"
;;                       :foreground "red"
;;                       :weight 'bold)))
;;       (concat (if window-system ;; In the terminal the green is hard to read
;;                   (with-face sl/header
;;                              ;; :background "green"
;;                              ;; :foreground "black"
;;                              :weight 'bold
;;                              :foreground "#8fb28f"
;;                              )
;;                 (with-face sl/header
;;                            ;; :background "green"
;;                            ;; :foreground "black"
;;                            :weight 'bold
;;                            :foreground "blue"
;;                            ))
;;               (with-face (file-name-nondirectory buffer-file-name)
;;                          :weight 'bold
;;                          :foreground "#8fb000"
;;                          ;; :background "black"
;;                          )))))

;; (defun sl/display-header ()
;;   "Create the header string and display it."
;;   ;; The dark blue in the header for which-func is terrible to read.
;;   ;; However, in the terminal it's quite nice
;;   (if window-system
;;       (custom-set-faces
;;        '(which-func ((t (:foreground "green")))))
;;     (custom-set-faces
;;      '(which-func ((t (:foreground "blue"))))))
;;   ;; Set the header line
;;   (setq header-line-format

;;         (list "::"
;;               '(which-func-mode ("" which-func-format))
;;               '("-->" ;; invocation-name
;;                 (:eval (if (buffer-file-name)
;;                            (concat "[" (sl/make-header) "]")
;;                          "[%b]")))
;;               )
;;         )
;;   )
;; ;; Call the header line update
;; (add-hook 'buffer-list-update-hook 'sl/display-header)

;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ;;; custom-post.el ends here
