((nil . ((tab-width . 4)
         (indent-tabs-mode . nil) ; no tabs
         (eval . (progn

                   (setq my/c-make-ide-project "<pwd>") ;; should include '/' at the end of the path
                   (setq my/c-make-ide-build-folder "build")
                   (setq my/c-make-ide-executable "a.out")
                   (setq my/c-make-ide-test "./test-project.sh")

                   ;; pretty important for cmake-ide, otherwise we have long loading times
                   (setq cmake-ide-build-dir (concat my/c-make-ide-project my/c-make-ide-build-folder))
                   
                   ;; launch .h files in C++ mode
                   (add-to-list 'auto-mode-alist '("\\.h\\'" . c++-mode))
                   ;; gdb debug
                   (require 'gdb-mi)
                   (add-to-list 'gud-gdb-history (concat "gdb -i=mi " my/c-make-ide-project my/c-make-ide-build-folder "/" my/c-make-ide-executable))
                   
                   (require 'projectile)
                   (puthash (projectile-project-root)
                            (concat "make -C " my/c-make-ide-build-folder)
                            projectile-compilation-cmd-map)
                   (puthash (projectile-project-root)
                            (concat my/c-make-ide-build-folder "/" my/c-make-ide-executable)
                            projectile-run-cmd-map)
                   (puthash (projectile-project-root)
                            my/c-make-ide-test
                            projectile-test-cmd-map)
                   ))
         ))
 
 (c++-mode . ((c-file-style . "linux")
              (c-basic-offset . 4)
              (tab-width . 4)
              (indent-tabs-mode . nil))))
