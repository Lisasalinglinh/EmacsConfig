(use-package pyim
  :ensure nil
  :demand t
  :config
  ;; 激活 basedict 拼音词库
  ;;  (use-package pyim-basedict
  ;;    :ensure nil
  ;;    :config (pyim-basedict-enable))

  ;; 五笔用户使用 wbdict 词库
  ;; (use-package pyim-wbdict
  ;;   :ensure nil
  ;;   :config (pyim-wbdict-gbk-enable))

  (setq default-input-method "pyim")
  (global-set-key (kbd "C-\\") 'toggle-input-method)

  ;; 我使用全拼
  (setq pyim-default-scheme 'quanpin)

  ;; 设置 pyim 探针设置，这是 pyim 高级功能设置，可以实现 *无痛* 中英文切换
  ;; 我自己使用的中英文动态切换规则是：
  ;; 1. 光标只有在注释里面时，才可以输入中文。
  ;; 2. 光标前是汉字字符时，才能输入中文。
  ;; 3. 使用 M-j 快捷键，强制将光标前的拼音字符串转换为中文。
  (setq-default pyim-english-input-switch-functions
                '(pyim-probe-dynamic-english
                  pyim-probe-isearch-mode
                  pyim-probe-program-mode
                  pyim-probe-org-structure-template))

  (setq-default pyim-punctuation-half-width-functions
                '(pyim-probe-punctuation-line-beginning
                  pyim-probe-punctuation-after-punctuation))

  ;; 开启拼音搜索功能
  ;; (pyim-isearch-mode 1)


  ;; 使用 pupup-el 来绘制选词框, 如果用 emacs26, 建议设置
  ;; 为 'posframe, 速度很快并且菜单不会变形，不过需要用户
  ;; 手动安装 posframe 包。
  (require 'posframe)

  (setq pyim-page-tooltip 'posframe)


  ;;display invertical
  (setq pyim-page-style 'vertical)
  ;; 选词框显示9个候选词
  (setq pyim-page-length 10)


  ;;set dict
  ;;pyim-greatdict
  (require 'pyim-greatdict)
  (pyim-greatdict-enable)

  (setq pyim-dicts
        '((:name "greatdict" :file "/home/ttt/.emacs.d/plugin/pyim-greatdict.pyim")
          ;; (:name "basedict" :file "/home/un/.emacs.d/elpa-devel/pyim-basedict-20170726.1959/pyim-basedict.pyim")
          ))


  ;; 让 Emacs 启动时自动加载 pyim 词库
  ;; (add-hook 'emacs-startup-hook
  ;;         #'(lambda () (pyim-restart-1 t)))
  :bind
  (("M-j" . pyim-convert-code-at-point);;与 pyim-probe-dynamic-english 配合
   ;; ("C-;" . pyim-delete-word-from-personal-buffer)
   )  );;快捷键冲突
;;将光标处的拼音或者五笔字符串转换为中文 (与 vimim 的 “点石成金” 功能类似)
;; (global-set-key (kbd "M-i") 'pyim-convert-code-at-point)
(global-set-key (kbd "M-f") 'pyim-forward-word)
(global-set-key (kbd "M-b") 'pyim-backward-word)
(provide 'init-pyim)
