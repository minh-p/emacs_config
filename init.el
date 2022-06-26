(setq inhibit-startup-message t)

(scroll-bar-mode -1); disable visible scrollbar
(tool-bar-mode -1); disable the toolbar
(tooltip-mode -1); disable tooltips
(set-fringe-mode 10)

(menu-bar-mode -1) ; disable menubar

(require 'package)
(setq package-archives '(("melpa" . "https://melpa.org/packages/")
			 ("org" . "https://orgmode.org/elpa/")
			 ("elpa" . "https://elpa.gnu.org/packages/")))

(setq make-backup-files nil)
(setq custom-tab-width 4)
(setq-default electric-indent-inhibit t)
(setq-default c-basic-offset 4)
(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))

;; Make ESC quit prompts
(global-set-key (kbd "<escape>") 'keyboard-escape-quit)

;; font setting
(add-to-list 'default-frame-alist '(font . "JetBrainsMono Nerd Font Italic 11" ))

;; Initialize use-package on non-Linux platforms
(unless (package-installed-p 'use-package)
  (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)

;; column number relative and normal - like vim :)
(column-number-mode)
(global-display-line-numbers-mode)
(setq display-line-numbers-type 'relative)

(use-package undo-fu)

;; load evil
(use-package evil
  :init ;; tweak evil's configuration before loading it
  (setq evil-search-module 'evil-search)
  (setq evil-ex-complete-emacs-commands nil)
  (setq evil-vsplit-window-right t)
  (setq evil-split-window-below t)
  (setq evil-undo-system 'undo-fu)
  (setq evil-shift-round nil)
  (setq evil-want-C-u-scroll t)
  (setq evil-shift-width 4)
  :config ;; tweak evil after loading it
  (evil-mode)
  ;; example how to map a command in normal mode (called 'normal state' in evil)
  (define-key evil-normal-state-map (kbd ", w") 'evil-window-vsplit))

(use-package doom-themes
  :ensure t)
(setq doom-themes-enable-bold t
      doom-themes-enable-italic t)
(load-theme 'doom-solarized-light t)

;; transparency
(set-frame-parameter (selected-frame) 'alpha '(100 . 100))
(add-to-list 'default-frame-alist '(alpha . (100 . 100)))

;; dashboard configuration
(use-package dashboard
  :ensure t
  :config
  (dashboard-setup-startup-hook))

(setq dashboard-banner-logo-title "Hey Minh!")

;; lsp config ;;
(use-package lsp-mode
  :commands (lsp lsp-deferred)
  :init
  (setq lsp-keymap-prefix "C-c l")  ;; Or 'C-l', 's-l'
  :config
  (lsp-enable-which-key-integration t))

;; better completion with company mode
(use-package company
  :after lsp-mode
  :hook (prog-mode . company-mode)
  :bind (:map company-active-map
         ("<tab>" . company-complete-selection))
        (:map lsp-mode-map
         ("<tab>" . company-indent-or-complete-common))
  :custom
  (company-minimum-prefix-length 1)
  (company-idle-delay 0.0))

(use-package company-box
  :hook (company-mode . company-box-mode))

;; ui improvement with lsp-ui-mode
(use-package lsp-ui
  :hook (lsp-mode . lsp-ui-mode))

(defun dw/org-mode-setup ()
  (org-indent-mode t)
  (variable-pitch-mode 1)
  (auto-fill-mode 0)
  (visual-line-mode 1)
  (setq evil-auto-indent nil))

(use-package org
  :hook (org-mode . dw/org-mode-setup)
  :config
  (setq org-ellipsis " ▾"
        org-hide-emphasis-markers t
        org-pretty-entities t
        org-clock-sound "~/.config/emacs/bell.wav"
	org-startup-with-inline-images t
	org-hide-leading-stars t
	org-directory "~/org"
	org-agenda-files '("Tasks.org" "Birthdays.org" "Habits.org")
	org-agenda-start-with-log-mode t
	org-log-done 'time
	org-log-into-drawer t
	org-todo-keywords
	  '((sequence "TODO(t)" "NEXT(n)" "|" "DONE(d!)")
	    (sequence "BACKLOG(b)" "PLAN(p)" "READY(r)" "ACTIVE(a)" "REVIEW(v)" "WAIT(w@/!)" "HOLD(h)" "|" "COMPLETED(c)" "CANC(k@)"))
        ))

(require 'org-faces)
(with-eval-after-load 'org-faces)

(use-package org-bullets
  :after org
  :hook (org-mode . org-bullets-mode)
  :custom
  (org-bullets-bullet-list '("◉" "○" "●" "○" "●" "○" "●")))

;; Replace list hyphen with dot
(font-lock-add-keywords 'org-mode
                        '(("^ *\\([-]\\) "
                          (0 (prog1 () (compose-region (match-beginning 1) (match-end 1) "•"))))))

(dolist (face '((org-level-1 . 1.2)
                (org-level-2 . 1.1)
                (org-level-3 . 1.05)
                (org-level-4 . 1.0)
                (org-level-5 . 1.1)
                (org-level-6 . 1.1)
                (org-level-7 . 1.1)
                (org-level-8 . 1.1)))
    (set-face-attribute (car face) nil :font "JetBrainsMono Nerd Font" :weight 'regular :height (cdr face)))

(org-babel-do-load-languages 'org-babel-load-languages
    '(
        (shell . t)
    )
)

;; Make sure org-indent face is available
(require 'org-indent)

;; Ensure that anything that should be fixed-pitch in Org files appears that way
(set-face-attribute 'org-block nil :foreground nil :inherit 'fixed-pitch)
(set-face-attribute 'org-code nil   :inherit '(shadow fixed-pitch))
(set-face-attribute 'org-indent nil :inherit '(org-hide fixed-pitch))
(set-face-attribute 'org-verbatim nil :inherit '(shadow fixed-pitch))
(set-face-attribute 'org-special-keyword nil :inherit '(font-lock-comment-face fixed-pitch))
(set-face-attribute 'org-meta-line nil :inherit '(font-lock-comment-face fixed-pitch))
(set-face-attribute 'org-checkbox nil :inherit 'fixed-pitch)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(projectile dap-mode lsy-ivy helm-lsp flycheck lsp-treemacs which-key lsp-java fzf org-bullets lsp-mode doom-themes solarized-theme use-package evil)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(org-hide ((t nil))))
(put 'downcase-region 'disabled nil)

(use-package fzf)
(put 'scroll-left 'disabled nil)

(use-package projectile
  :init (projectile-mode +1)
  :config
    (define-key projectile-mode-map (kbd "s-p") 'projectile-command-map)
    (define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)
  )

;; lsp stuff
(use-package flycheck
  :ensure t
  :init (global-flycheck-mode))

(use-package lsp-treemacs
  :config
  (lsp-treemacs-sync-mode 1))

(use-package helm-lsp
  :config
  (define-key lsp-mode-map [remap xref-find-apropos] #'helm-lsp-workspace-symbol)
  )

(use-package dap-mode
  :config
  (setq dap-auto-configure-features '(sessions locals controls tooltip))
  )

(use-package lsp-java
  :init
  (setq lsp-java-format-settings-url "https://raw.githubusercontent.com/google/styleguide/gh-pages/eclipse-java-google-style.xml"
	lsp-java-format-settings-profile "GoogleStyle")
  :hook
  (add-hook 'java-mode-hook 'lsp)
    )
