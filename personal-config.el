;; Theme is preloded
(prelude-require-packages '(multiple-cursors
                            fill-column-indicator
                            smartscan
                            restclient
                            restclient-helm
                            helm-projectile
                            persp-projectile
                            helm-gtags
                            ggtags
                            osx-clipboard
                            ))
;; Projectile
(require 'helm-projectile)
(helm-projectile-on)
(setq projectile-enable-caching nil)
(setq projectile-completion-system 'helm)
(setq projectile-indexing-method 'alien)
(global-set-key (kbd "M-p") 'projectile-find-file)

;;persp-projectile
(require 'persp-projectile)
(persp-mode)

;; Mac OS X specific
(setq mac-command-modifier 'meta)
(setq mac-option-modifier 'super)
(setq ns-function-modifier 'hyper)

;; No tool-bar, scroll-bar, menu-bar
(tool-bar-mode 0)
(menu-bar-mode 0)
(scroll-bar-mode 0)

;; Font size
(set-frame-font "Menlo-14")

;; Exiting
(global-unset-key (kbd "C-x C-c"))
(global-set-key (kbd "C-x C-c r q") 'save-buffers-kill-terminal)

;; Killing
(global-set-key (kbd "C-w") 'backward-kill-word)
(global-set-key (kbd "C-x C-k") 'kill-region)
(global-set-key (kbd "C-c C-k") 'kill-region)

;; goto-line remap
(global-set-key [remap goto-line] 'goto-line-with-feedback)
(defun goto-line-with-feedback ()
  "Show line numbers temporarily, while prompting for the line number input"
  (interactive)
  (unwind-protect
      (progn
        (linum-mode 1)
        (forward-line
         (- (read-number "Goto line: ") (1+ (count-lines 1 (point))))))
    (linum-mode -1)))

;; multiple cursor
(global-set-key (kbd "C->") 'mc/mark-next-like-this)
(global-set-key (kbd "C-<") 'mc/mark-previous-like-this)
(global-set-key (kbd "C-c >") 'mc/mark-all-words-like-this)

;; Paragraph navigation
(global-set-key (kbd "C-M-[") 'backward-paragraph)
(global-set-key (kbd "C-M-]") 'forward-paragraph)

(global-set-key (kbd "M-[") 'backward-sexp)
(global-set-key (kbd "M-]") 'forward-sexp)

;; Guru mode strict
(setq guru-warn-only 1)

;; Aspell settings
(setq ispell-program-name "/usr/local/bin/aspell")
(setq ispell-dictionary "british")

;; Uses pbpaste and pbcopy in terminals
;; Must install osx-clipboard first
(osx-clipboard-mode +1)

;; fill-column-indicator configuration
(setq fci-rule-width 1)
(setq-default fill-column 80)
(define-globalized-minor-mode global-fci-mode
  fci-mode (lambda ()
             (when (not (memq major-mode
                              (list 'web-mode))) ;; workaround for bug of fci and web-mode
               (fci-mode 1))))
(global-fci-mode 1)

;; Whitespace configuration
(setq whitespace-style '(face trailing tabs))
(global-set-key (kbd "C-x d") 'whitespace-cleanup)

;; Javascript configuration
(setq js-indent-level 2)
(setq js2-basic-offset 2)
(setq js2-include-node-externs t)
(setq js2-highlight-level 2)
(setq js2-mode-show-parse-errors nil)
(setq js2-mode-show-strict-warnings nil)

;; join line
(global-set-key (kbd "M-j")
                (lambda ()
                  (interactive)
                  (join-line -1)))

;; M-o is now bound to ace-window, yay!
(define-key prelude-mode-map (kbd "M-o") nil)
(global-set-key (kbd "M-o") 'ace-window)

(global-set-key (kbd "C-x o") 'other-window)

;; smartparens default
(define-key smartparens-mode-map (kbd "C-<right>") 'sp-forward-slurp-sexp)
(define-key smartparens-mode-map (kbd "C-<left>") 'sp-forward-barf-sexp)
(define-key smartparens-mode-map (kbd "C-M-<left>") 'sp-backward-slurp-sexp)
(define-key smartparens-mode-map (kbd "C-M-<right>") 'sp-backward-barf-sexp)

;; create a scratch
(global-set-key (kbd "C-c c s") 'crux-create-scratch-buffer)

;; smartscan
(smartscan-mode 1)

;; I don't like these
(global-unset-key (kbd "C-o"))

;; restclient-mode
(add-to-list 'auto-mode-alist '("\\.restclient\\'" . restclient-mode))

;; mocha config
(eval-after-load 'js2-mode
  '(define-key js2-mode-map (kbd "C-x C-.") 'mocha-test-at-point))

;; makes ggtags polite
(setq ggtags-enable-navigation-keys nil)

;; http://emacs.stackexchange.com/a/21207
(defun my/use-eslint-from-node-modules ()
  (let* ((root (locate-dominating-file
                (or (buffer-file-name) default-directory)
                "node_modules"))
         (eslint (and root
                      (expand-file-name "node_modules/eslint/bin/eslint.js"
                                        root))))
    (when (and eslint (file-executable-p eslint))
      (setq-local flycheck-javascript-eslint-executable eslint))))

(add-hook 'flycheck-mode-hook #'my/use-eslint-from-node-modules)
