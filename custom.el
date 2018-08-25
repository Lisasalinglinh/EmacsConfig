;;; custom.el --- user customization file    -*- no-byte-compile: t -*-
;;; Commentary:
;;;       Copy custom-example.el to custom.el and change the configurations,
;;;       then restart Emacs.
;;; Code:

(setq centaur-logo t)                        ; Logo file or nil (official logo)
;; (setq centaur-full-name "user name")           ; User full name
;; (setq centaur-mail-address "user@email.com")   ; Email address
;; (setq centaur-proxy "127.0.0.1:1080")          ; Network proxy
(setq centaur-package-archives 'tuna)  ; Package repo: melpa, melpa-mirror, emacs-china or tuna
(setq centaur-theme 'doom)                     ; Color theme: default, doom, dark, light or daylight
(setq centaur-dashboard t)                     ; Use dashboard at startup or not: t or nil
;; (setq centaur-lsp t)                           ; Enable language servers or not: t or nil
;; (setq centaur-company-enable-yas t)            ; Enable yasnippet for company or not: t or nil
;; (setq centaur-benchmark t)                     ; Enable initialization benchmark or not: t or nil

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(diff-hl-draw-borders nil)
 '(fringe-mode '(4 . 8) nil (fringe))
 '(fringes-outside-margins t t)
 '(helm-display-header-line t)
 '(template-use-package t nil (template)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(diff-hl-change ((t (:background "DeepSkyBlue"))))
 '(diff-hl-delete ((t (:background "OrangeRed"))))
 '(diff-hl-insert ((t (:background "YellowGreen"))))
 '(hl-todo ((t (:box t :bold t))))
 '(switch-window-label ((t (:inherit font-lock-keyword-face :height 3.0)))))

;;; custom.el ends here
