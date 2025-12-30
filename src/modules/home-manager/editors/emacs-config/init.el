;; file settings
(setq user-emacs-directory "~/.config/emacs/")
(defvar emacs-runtime-dir "~/.econf/")
(make-directory emacs-runtime-dir t)
(setq straight-base-dir (expand-file-name "straight" emacs-runtime-dir))
(make-directory straight-base-dir t)
(setq yas-snippet-dirs (list (expand-file-name "snippets" emacs-runtime-dir)))
(make-directory (car yas-snippet-dirs) t)
(setq lsp-session-file (expand-file-name ".lsp-session-v1" emacs-runtime-dir))

;; suppress warnings
(setq native-comp-async-report-warnings-errors nil)

;; ui changes
(tool-bar-mode 0)
(scroll-bar-mode 0)
(setq inhibit-splash-screen t)
(setq use-file-dialog nil)

(push '(menu-bar-lines . 0) default-frame-alist)
(push '(tool-bar-lines . 0) default-frame-alist)
(push '(vertical-scroll-bars) default-frame-alist)

;; package manager
(defvar bootstrap-version)
(let ((bootstrap-file (expand-file-name "repos/straight.el/bootstrap.el" straight-base-dir))
      (bootstrap-version 7))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/radian-software/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))
(straight-use-package 'use-package)

(setq straight-use-package-by-default t)
(setq use-package-always-defer t)

;; garbage collector
(use-package gcmh
  :demand
  :config
  (gcmh-mode 1))

;; emacs package config
(use-package emacs
  :init
  (add-to-list 'default-frame-alist '(ns-transparent-titlebar . t))
  (add-to-list 'default-frame-alist '(ns-appearance . light))
  (setq ns-use-proxy-icon  nil)
  (setq frame-title-format nil)
  (global-set-key (kbd "<escape>") 'keyboard-escape-quit)
  (setq initial-scratch-message nil)
  (defun display-startup-echo-area-message ()
    (message ""))
  (defalias 'yes-or-no-p 'y-or-n-p)
  (set-charset-priority 'unicode)
  (setq locale-coding-system 'utf-8
        coding-system-for-read 'utf-8
        coding-system-for-write 'utf-8)
  (set-terminal-coding-system 'utf-8)
  (set-keyboard-coding-system 'utf-8)
  (set-selection-coding-system 'utf-8)
  (prefer-coding-system 'utf-8)
  (setq default-process-coding-system '(utf-8-unix . utf-8-unix))
  (setq-default indent-tabs-mode nil)
  (setq-default tab-width 4)
  (set-face-attribute 'default nil
                      :font "JetBrainsMono Nerd Font"
                      :height 120)
  (defun amraleth/enable-line-numbers ()
    "enable relative line numbers"
    (interactive)
    (display-line-numbers-mode)
    (setq display-line-numbers 'relative))
  (add-hook 'prog-mode-hook #'amraleth/enable-line-numbers)
  (setq-default fill-column 80)
  (set-face-attribute 'fill-column-indicator nil
                      :foreground "#717C7C"
                      :background "transparent")
  (global-display-fill-column-indicator-mode 1)
  :config
  (setq backup-directory-alist `(("." . "~/.saves")))
  )

;; evil keybindings
(setq evil-want-keybinding nil)
(use-package evil
  :demand
  :config
  (evil-mode 1))

;; theming
(use-package doom-themes
  :demand
  :config
  (load-theme 'doom-challenger-deep t))

;; keybindings
(use-package which-key
  :demand
  :init
  (setq which-key-idle-delay 0.5)
  :config
  (which-key-mode))

;; buffer formatting
(defun amraleth/format-buffer ()
  "formats entire buffer"
  (interactive)
  (save-excursion
    (indent-region (point-min) (point-max))
    (when (boundp 'indent-tabs-mode)
      (unless indent-tabs-mode
        (untabify (point-min) (point-max))))
    (delete-trailing-whitespace)))

;; running shell commands
(defun amraleth/run-command-output-buffer (command)
  "run command and output to new buffer"
  (interactive "sRun command: ")
  (let ((buffer (generate-new-buffer (format "*Output: %s*" command))))
    (shell-command command buffer)
    (display-buffer buffer)))

;; dired
(defun amraleth/open-dired-current-dir ()
  "open dired in the current directory"
  (interactive)
  (let ((dir (if (buffer-file-name)
                 (file-name-directory (buffer-file-name))
               default-directory)))
    (dired dir)))

;; buffer killing
(defun amraleth/kill-buffer-and-window ()
  "kills current buffer with window"
  (interactive)
  (kill-this-buffer)
  (delete-window))

;; actual keybindings
(use-package general
  :demand
  :config
  (general-evil-setup)

  (general-create-definer leader-keys
    :states '(normal insert visual emacs)
    :keymaps 'override
    :prefix "SPC"
    :global-prefix "C-SPC")
  (leader-keys
    "x" '(execute-extended-command :wk "execute command")
    "e" '(eval-region :wk "eval region")
    "u" '(amraleth/run-command-output-buffer :wk "run shell command")
    "c" '(compile :wk "compile") 
    "r" '(recompile :wk "recompile")
    "TAB" '(amraleth/open-dired-current-dir :wk "open dired")

    "f" '(:ignore t :wk "file")
    "f i" '((lambda () (interactive) (find-file user-init-file)) :wk "open config")
    "f f" '(find-file :wk "find file")
    "f b" '(amraleth/format-buffer :wk "format buffer")

    "b" '(:ignore t :wk "buffer")
    "b n" '(next-buffer :wk "next buffer")
    "b p" '(previous-buffer :wk "previous buffer")

    "w" '(:ignore t :wk "window")
    "w w" '(other-window :wk "next window")
    "w c" '(amraleth/kill-buffer-and-window :wk "kill windows")
    )
  )

;; fuzzy finding
(use-package ivy
  :config
  (ivy-mode))

;; magit
(use-package magit
  :general
  (leader-keys
    "g" '(:ignore t :wk "git")
    "g s" '(magit-status :which-key "status")
    "g l" '(magit-log :wk "log"))
  (general-nmap
    "<escape>" #'transient-quit-one))

(use-package evil-collection
  :after evil
  :demand
  :config
  (evil-collection-init))

(use-package diff-hl
  :hook
  (after-init . global-diff-hl-mode)
  :config
  (with-eval-after-load 'magit
    (add-hook 'magit-pre-refresh-hook  #'diff-hl-magit-pre-refresh)
    (add-hook 'magit-post-refresh-hook #'diff-hl-magit-post-refresh)))

;; terminal
(use-package vterm-toggle
  :general
  (leader-keys
    "." '(vterm-toggle :wk "terminal")))

;; library loading
(use-package exec-path-from-shell
  :init
  (exec-path-from-shell-initialize))

;; treesitter
(use-package treesit-auto
  :custom
  (treesit-auto-install 'prompt)
  :config
  (treesit-auto-add-to-auto-mode-alist 'all)
  (global-treesit-auto-mode))

;; searching
(use-package rg
  :general
  (leader-keys
    "s" '(rg-menu :wk "search")))

;; lsp
(use-package lsp-mode
  :commands lsp
  :hook ((c-mode . lsp)
         (c++-mode . lsp))
  :init
  (setq lsp-prefer-flymake nil)
  (setq lspenable-on-type-formatting nil)
  (setq lsp-enable-on-type-formatting nil)
  )

(use-package lsp-ui
  :after lsp-mode
  :config
  (setq lsp-ui-doc-enable t)
  (setq lsp-ui-doc-show-with-mouse nil)
  :commands lsp-ui-mode)

(use-package lsp-ivy
  :after lsp-ode
  :commands lsp-ivy-workspace-symbol)

;; company
(use-package company
  :hook (after-init . global-company-mode)
  :config
  (setq company-minimum-prefix-length 1)
  (setq company-idle-delay 0.1))

;; snippet engine
(use-package yasnippet
  :hook (prog-mode . yas-minor-mode)
  :config
  (yas-reload-all))

(defun amraleth/yasnip-completion ()
  "run yasnippet expansion, or fallback to company completion"
  (interactive)
  (if (yas-expand)
      t
    (call-interactively 'company-complete-common)))
;;(global-set-key (kbd "TAB") 'amraleth/yasnip-completion)

;; java lsp
;;(use-package lsp-java
;;  :ensure t
;;  :after lsp
;;  :config
;;  (add-hook 'java-mode-hook #'lsp)
;;  (setq lsp-java-format-settings-url
;;        "https://raw.githubusercontent.com/google/styleguide/gh-pages/eclipse-java-google-style.xml")
;;  (setq lsp-java-format-settings-profile "GoogleStyle"))


;; nixd lsp
(use-package nix-mode
  :mode "\\.nix\\'"
  :hook (nix-mode . lsp))
(with-eval-after-load 'lsp-mode
  (setq
   lsp-nix-nixd-server-path "nixd"
   lsp-nix-nixd-formatting-command [ "nixpkgs-fmt "]
   lsp-nix-nixd-flake-auto-eval-inputs t
   lsp-nix-nixd-nixpkgs-expr
   "import <nixpkgs> {}"))

(leader-keys
  "l" '(:ignore t :wk "lsp")
  "l r" '(lsp-rename :wk "rename symbol")
  "l f" '(lsp-format-buffer :wk "format")
  "l d" '(lsp-find-definition :wk "go to definition")
  "l R" '(lsp-find-references :wk "find references")
  "l h" '(lsp-ui-doc-toggle :wk "hover")
  "l e" '(lambda ()
           (interactive)
           (lsp)
           (lsp-ui-mode 1)
           :wk "enable lsp")
  "l D" '(lambda ()
           (interactive)
           (lsp-shutdown-workspace)
           (lsp-ui-mode 0)
           :wk "disable lsp")
  "l x" '(lsp-treemacs-errors-list :wk "list errors")
  )

;; indentation and tweaks
(electric-indent-mode 1)
;;(global-set-key (kbd "RET") 'newline-and-indent)
(electric-layout-mode 1)
(electric-pair-mode 1)
(add-hook 'prog-mode-hook #'electric-pair-mode)
