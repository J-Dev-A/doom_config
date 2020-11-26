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

(setq org-todo-keywords
  '((sequence "TODO(t)"
      "MAYBE(m)"
      "IN-PROGRESS(i)"
      "WAITING(w)"
      "DELEGATED(p)"
      "|"
      "DONE(d)"
      "DEFERRED(q)"
      "DECLINED(x)"
      "CANCELLED(c)")))

  (setq org-todo-keyword-faces
    '(
      ("TODO" :background "red1" :foreground "black" :weight bold :box (:line-width 2 :style released-button))
      ("IN-PROGRESS" :background "orange" :foreground "black" :weight bold :box (:line-width 2 :style released-button))
      ("WAITING" :background "yellow" :foreground "black" :weight bold :box (:line-width 2 :style released-button))
      ("DEFERRED" :background "gold" :foreground "black" :weight bold :box (:line-width 2 :style released-button))
      ("DELEGATED" :background "gold" :foreground "black" :weight bold :box (:line-width 2 :style released-button))
      ("MAYBE" :background "gray" :foreground "black" :weight bold :box (:line-width 2 :style released-button))
      ("DONE" :background "forest green" :weight bold :box (:line-width 2 :style released-button))
      ("DECLINED" :background "black" :foreground "red" :weight bold :box (:line-width 2 :style released-button))
      ("CANCELLED" :background "lime green" :foreground "black" :weight bold :box (:line-width 2 :style released-button))))

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
      (`daily "#+TITLE: Daily Journal\n#+STARTUP: showeverything\n#+#+FILETAGS: :personal:\n")
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

(setq org-roam-capture-templates
      '(("d" "default" plain
         (function org-roam-capture--get-point)
         "%?"
         :file-name "%<%Y%m%d%H%M%S>-${slug}"
         :head "#+TITLE: ${title}\n#+CREATED: %U\n#+LAST_MODIFIED: %U\n\n"
         :unnarrowed t)
        ))

  ;;--------------------------
  ;; Handling file properties for ‘CREATED’ & ‘LAST_MODIFIED’
  ;;--------------------------

  (defun zp/org-find-time-file-property (property &optional anywhere)
    "Return the position of the time file PROPERTY if it exists.
When ANYWHERE is non-nil, search beyond the preamble."
    (save-excursion
      (goto-char (point-min))
      (let ((first-heading
             (save-excursion
               (re-search-forward org-outline-regexp-bol nil t))))
        (when (re-search-forward (format "^#\\+%s:" property)
                                 (if anywhere nil first-heading)
                                 t)
          (point)))))

  (defun zp/org-has-time-file-property-p (property &optional anywhere)
    "Return the position of time file PROPERTY if it is defined.
As a special case, return -1 if the time file PROPERTY exists but
is not defined."
    (when-let ((pos (zp/org-find-time-file-property property anywhere)))
      (save-excursion
        (goto-char pos)
        (if (and (looking-at-p " ")
                 (progn (forward-char)
                        (org-at-timestamp-p 'lax)))
            pos
          -1))))

  (defun zp/org-set-time-file-property (property &optional anywhere pos)
    "Set the time file PROPERTY in the preamble.
When ANYWHERE is non-nil, search beyond the preamble.
If the position of the file PROPERTY has already been computed,
it can be passed in POS."
    (when-let ((pos (or pos
                        (zp/org-find-time-file-property property))))
      (save-excursion
        (goto-char pos)
        (if (looking-at-p " ")
            (forward-char)
          (insert " "))
        (delete-region (point) (line-end-position))
        (let* ((now (format-time-string "[%Y-%m-%d %a %H:%M]")))
          (insert now)))))

  (defun zp/org-set-last-modified ()
    "Update the LAST_MODIFIED file property in the preamble."
    (when (derived-mode-p 'org-mode)
      (zp/org-set-time-file-property "LAST_MODIFIED")))

(add-hook 'before-save-hook #'zp/org-set-last-modified)

(require 'workgroups2)
(workgroups-mode 1)

(use-package ledger-mode
    :mode ("\\.dat\\'"
           "\\.ledger\\'")
    :custom (ledger-clear-whole-transactions t))

(use-package flycheck-ledger :after ledger-mode)
(setq ledger-reconcile-default-commodity "₹")
