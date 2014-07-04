;;; package --- Summary
;;; Commentary:
;;; Evil init.el.  I tried as I could!

;;; Code:

;;;;;;;;;;;;;;;;;;;;;;
; Package management ;
;;;;;;;;;;;;;;;;;;;;;;

;;; this loads the package manager
(require 'package)

;;; here there's a variable named package-archives,
;;; and we are adding the MELPA repository to it
(add-to-list 'package-archives
             '("melpa" . "http://melpa.milkbox.net/packages/") t)


;;; loads packages and activates them
(package-initialize)

;;; initialize el-get
(add-to-list 'load-path "~/.emacs.d/el-get/el-get")

(unless (require 'el-get nil 'noerror)
  (with-current-buffer
      (url-retrieve-synchronously
       "https://raw.github.com/dimitri/el-get/master/el-get-install.el")
    (goto-char (point-max))
    (eval-print-last-sexp)))

;; Local recipies
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; (setq                                                                       ;;
;;  el-get-sources                                                             ;;
;;  '((:name buffer-move	; have to add your own keys                    ;;
;;         :after (lambda ()                                                   ;;
;;             (global-set-key (kbd "<C-S-up>") 'buf-move-up)                  ;;
;;             (global-set-key (kbd "<C-S-down>") 'buf-move-down)              ;;
;;             (global-set-key (kbd "<C-S-left>") 'buf-move-left)              ;;
;;             (global-set-key (kbd "<C-S-right>") 'buf-move-right)))          ;;
;;                                                                             ;;
;;    (:name smex	; a better (ido like) M-x                              ;;
;;         :after (lambda ()                                                   ;;
;;             (setq smex-save-file "~/.emacs.d/.smex-items")                  ;;
;;             (global-set-key (kbd "M-x") 'smex)                              ;;
;;             (global-set-key (kbd "M-X") 'smex-major-mode-commands)))        ;;
;;                                                                             ;;
;;    (:name magit	; git meet emacs, and a binding                        ;;
;;         :after (lambda ()                                                   ;;
;;             (global-set-key (kbd "C-x C-z") 'magit-status)))                ;;
;;                                                                             ;;
;;    (:name goto-last-change	; move pointer back to last change             ;;
;;         :after (lambda ()                                                   ;;
;;             ;; when using AZERTY keyboard, consider C-x C-_                 ;;
;;             (global-set-key (kbd "C-x C-/") 'goto-last-change)))))          ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;; Packages
(setq
 my:el-get-packages
 '(
   el-get
   ; Editing
   evil
   column-marker
   autopair
   ; navigation
   ace-jump-mode
   projectile
   ; Language
   jedi))

; Sync those packages
(el-get 'sync my:el-get-packages)

;;;;;;;;;;;;;;;;;;
; Basic settings ;
;;;;;;;;;;;;;;;;;;

;;; enable vim mode T_T
(require 'evil)
(evil-mode t)

;;; load custom themes
(add-to-list 'custom-theme-load-path "~/.emacs.d/themes")
(set-cursor-color "#0a9dff")
(provide 'init-themes)
(load-theme 'badwolf t)

;;; Set default font for all windows
(set-frame-font "PragmataPro 14" t t)

;;; Editing settings

(setq-default indent-tabs-mode nil) ;;; Soft tabs
(scroll-bar-mode -1)  ;;; Disable scrollbar
(menu-bar-mode -1)    ;;; Disable menu
(tool-bar-mode -1)    ;;; Disable toolbar

;;;;;;;;;;
; Keymap ;
;;;;;;;;;;

;(global-set-key (kbd "ss") 'split-window-below)
;(global-set-key (kbd "vv") 'split-window-right)

;;;;;;;;;;;;;;;;;;
; Initialization ;
;;;;;;;;;;;;;;;;;;

; Save buffers on exit
(require 'desktop)
  (desktop-save-mode 1)
  (defun my-desktop-save ()
    (interactive)
    ;; Don't call desktop-save-in-desktop-dir, as it prints a message.
    (if (eq (desktop-owner) (emacs-pid))
        (desktop-save desktop-dirname)))
  (add-hook 'auto-save-hook 'my-desktop-save)

; Interactive mode
(require 'ido)
(ido-mode t)

;;;;;;;;;;;;;;;;;;;;
; Modules settings ;
;;;;;;;;;;;;;;;;;;;;

;;; Easy motion
(define-key evil-normal-state-map (kbd "SPC") 'ace-jump-mode)

;;; Highlit column
(add-hook 'foo-mode-hook (lambda ()
 (interactive) (column-marker-1 80)))

;;; Switch windows
(global-set-key (kbd "C-x o") 'switch-window)

;;; Languages
(require 'python)
(add-hook 'python-mode-hook 'jedi:setup)
(setq jedi:complete-on-dot t)
(add-hook 'after-init-hook #'global-flycheck-mode)

;;; Project navigation
(projectile-global-mode)

;;; Completion
(autopair-global-mode) ;; to enable in all buffers

(global-linum-mode t)

(provide 'init)

;;; init.el ends here
