(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   (quote
    ("bb08c73af94ee74453c90422485b29e5643b73b05e8de029a6909af6a3fb3f58" default)))
 '(package-selected-packages
   (quote
    (use-package smartparens smart-mode-line rtags powerline org-plus-contrib org-bullets nlinum multiple-cursors miniedit magit lua-mode langtool intero helm-projectile helm-descbinds guide-key flycheck-irony expand-region dired+ dash-functional company-quickhelp company-irony-c-headers company-irony company-ghc company-c-headers company-auctex color-theme-sanityinc-tomorrow cmake-ide auto-compile ace-window))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;; Load the rest of the packages
(package-initialize nil)
(setq package-enable-at-startup nil)
(org-babel-load-file "~/.emacs.d/Settings.org")
