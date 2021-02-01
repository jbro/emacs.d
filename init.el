;;
(setq inhibit-splash-screen t)
(setq inhibit-startup-message t)

;; Remove menu bar
(menu-bar-mode -1)
(setq tty-menu-open-use-tmm t)

;; Save custom- to separate file
(setq custom-file "~/.emacs.d/custom.el")
(load-file custom-file)

;; MELPA repo
(package-initialize)
(require 'package)
(add-to-list 'package-archives
    '("melpa" . "https://melpa.org/packages/") t)

;; Install use-package automatically
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

;; Gruvbox theme
(use-package gruvbox-theme
  :ensure t
  :config
  (load-theme 'gruvbox t)
)

;; Evil mode
(use-package evil
  :ensure t
  :defer .1 ;; don't block emacs when starting, load evil immediately after startup
  :custom
  (evil-search-module 'evil-search)
  :config
  (evil-mode t)
)

;; Show trailing whitespaces on lines
(use-package whitespace
  :custom
  (whitespace-style '(face trailing spaces space-mark empty))
  :config
  (set-face-foreground 'whitespace-space (face-background 'default)) ;hide space marks
  (set-face-attribute 'whitespace-trailing nil
		      :background (face-background 'default)
		      :weight 'bold)
  :init
  (global-whitespace-mode 't))

;;
(show-paren-mode 't)

;;
(global-display-line-numbers-mode)
(setq display-line-numbers-type 'relative)

;; Gramma checker
(use-package langtool
  :ensure t
  :custom
  (langtool-language-tool-jar "~/local/languagetool/LanguageTool-5.2/languagetool-commandline.jar")
  (langtool-http-server-host "localhost"
   langtool-http-server-port 8082)
  (langtool-default-language "en-GB"))

;; Spell checking
(use-package flyspell
  :custom
  (ispell-program-name "aspell")
  (ispell-dictionary "british")
  (ispell-list-command "--list")
  :config
  (add-hook 'org-mode-hook 'flyspell-mode)
  (add-hook 'emacs-lisp-mode-hook 'flyspell-prog-mode))

;; Change language both for flyspell and LanguageTool
(defun spell-set-language (flyspell languagetool)
  (interactive
   (letrec ((languages '((us . ("american" "en-US"))
			 (uk . ("british" "en-UK"))
			 (dk . ("danish" "da-DK"))))
	    (defaultlang 'uk)
	    (selection (intern (completing-read "Choose language: " languages))))
     (alist-get selection languages (alist-get defaultlang languages))))
  (ispell-change-dictionary flyspell)
  (setq langtool-default-language languagetool)
  (message "aspell: %s\nLanguageTool: %s" flyspell languagetool))

;; TODO
;; folding (evilmode?)
;; mail
;; org work flows
;; ical export of agendas?
;; html export of agendas
