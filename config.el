;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Jeyadev Asokan"
      user-mail-address "jeyadev_asokan@gmail.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
;; (setq doom-font (font-spec :family "monospace" :size 12 :weight 'semi-light)
;;       doom-variable-pitch-font (font-spec :family "sans" :size 13))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-one)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

(setq org-log-done 'time)
(setq org-log-done 'note)
(setq org-agenda-include-diary t)
(setq org-agenda-files (directory-files-recursively "~/org/" "\\.org$"))
(setq org-hide-emphasis-markers t)

(require 'org-agenda)
(setq org-agenda-custom-commands
 '(("w" "Work calendar and todo"
    ((agenda "")
     (tags-todo "work")))
   ("h" "Personal calendar and todo"
    ((agenda "")
     (tags-todo "personal")))
   )
 )

(setq org-roam-directory "~/org/roam/")

(use-package! org-journal
  :defer
  :init
  ;; org journal
  (setq org-journal-dir "~/org/journal/")
  (setq org-journal-file-type 'daily)
  (setq org-journal-file-format "%Y%m%d.org")
  (setq org-journal-date-format "%A, %B %d %Y")
  :config
  (setq org-journal-carryover-items "")
  )
(defun org-journal-file-header-func (time)
  "Custom function to create journal header."
  (concat
    (pcase org-journal-file-type
      (`daily "#+TITLE: Daily Journal\n#+STARTUP: showeverything\n#+#+FILETAGS: :personal:")
      (`weekly "#+TITLE: Weekly Journal\n#+STARTUP: folded")
      (`monthly "#+TITLE: Monthly Journal\n#+STARTUP: folded")
      (`yearly "#+TITLE: Yearly Journal\n#+STARTUP: folded"))))

(setq org-journal-file-header 'org-journal-file-header-func)


(require 'org-journal)
;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.
;;
(add-hook 'vterm-mode-hook
          (lambda ()
            (setq buffer-face-mode-face '(:family "MesloLGS NF"))
                 (buffer-face-mode t)))

(add-hook 'python-mode-hook
  (lambda ()
     (setq flycheck-python-pylint-executable "/Users/jd/.pyenv/shims/pylint")
     (setq flycheck-pylintrc (substitute-in-file-name "$HOME/.pylintrc"))))

(defun org-summary-todo (n-done n-not-done)
  "Switch entry to DONE when all subentries are done, to TODO otherwise."
  (let (org-log-done org-log-states)   ; turn off logging
    (org-todo (if (= n-not-done 0) "DONE" "TODO"))))

(add-hook 'org-after-todo-statistics-hook 'org-summary-todo)

(use-package org-bullets
  :config
  (add-hook 'org-mode-hook (lambda () (org-bullets-mode 1))))

(use-package company-org-roam
  :ensure t
  ;; You may want to pin in case the version from stable.melpa.org is not working
  ; :pin melpa
  :config
  (push 'company-org-roam company-backends))

(require 'workgroups2)
(workgroups-mode 1)

(use-package ledger-mode
    :mode ("\\.dat\\'"
           "\\.ledger\\'")
    :custom (ledger-clear-whole-transactions t))

(use-package flycheck-ledger :after ledger-mode)
(setq ledger-reconcile-default-commodity "₹")
