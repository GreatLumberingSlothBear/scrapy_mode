;;; scrapy_mode.el --- Minor mode for the scrapy python library

;; Author: Huntington Bagby <huntingtonb@proton.me>
;; Version: 1.0

;;; Commentary

;; Provides utility functions for interfacing with the scrapy library using keybindings instead of typing out shell commands to make scrapy workflow more efficient.


;; Custom variables for user environment
(defgroup scrapy nil "Group to customize scrapy-mode")

;; TODO: make custom paths use a file picker instead of string
(defcustom pyvenv-path ""
  "Path to the python virtual environment scrapy is installed in. Leave blank if using a version of scrapy that is installed globally."
  :type '(string)
  :group 'scrapy)

(defcustom spider-output-path ""
  "Path to an output file to dump data from spider crawls."
  :type '(string)
  :group 'scrapy)

(defcustom new-spider-module-path ""
  "Path where newly generated spiders created with genspider will go."
  :type '(string)
  :group 'scrapy)

(defvar pyvenv-activate-cmd
  (if (string= "" pyvenv-path)
      ""
    (format ". %s/bin/activate && " pyvenv-path))
  "Command prepended to scrapy commands to activate venv if scrapy is installed in a virtual environment")

;; Function definitions for package
(defun get-spider-name ()
  "Function for test to get spider name, greps it out of the file, will need more robust method eventually."
  (string-trim-right
   (shell-command-to-string
    (format "grep -Po '(?<=name = \")([^\"]+)' %s" buffer-file-name))))

(defun scrapy-crawl-spider ()
  "Crawl the scrapy spider in the current buffer and display the output in a new buffer."
  (interactive)
  (shell-command
   (format "%sscrapy crawl %s -O output.jl" pyvenv-activate-cmd (get-spider-name)))
  (find-file spider-output-path))

(defun scrapy-run-spider ()
  "Run the current spider in the buffer outside of a scrapy project and display the output in a new buffer."
  (interactive)
  (shell-command
   (format "%sscrapy runspider %s -O output.jl" pyvenv-activate-cmd buffer-file-name))
  (find-file spider-output-path))

(defun scrapy-shell-url-at-point ()
  "Open a scrapy shell using the url at point"
  (interactive)
  (let ((url-at-point (thing-at-point-url-at-point)))
    (if (stringp url-at-point)
	(progn
	  (message "Scrapy shell: %s" url-at-point)
	  (shell "Scrapy shell")
	  (insert (format "%sscrapy shell %s\n" pyvenv-activate-cmd url-at-point))
	  (comint-send-input))
      (message "No URL found at point!"))))

(defun scrapy-view-url-at-point ()
  "View the url at point in the browser as downloaded by scrapy"
  (interactive)
  (let ((url-at-point (thing-at-point-url-at-point)))
    (if (stringp url-at-point)
	(shell-command
	 (format "%sscrapy view %s" pyvenv-activate-cmd url-at-point))
      (message "No URL found at point!"))))

(defun list-templates ()
  "List all available templates in the project"
  (cdr (split-string (shell-command-to-string (format "%sscrapy genspider --list" pyvenv-activate-cmd))
		     "\n"
		     t
		     "\s+")))

;; TODO completing read templates and open file from newspider_module in settings
(defun scrapy-genspider (name)
  "Runs the scrapy genspider command with selected template to create a new spider and opens the new spider in a new buffer"
  (interactive "sEnter spider name: ")
  (let ((template (completing-read "Choose a template: " (list-templates))))
    (shell-command
     (format "%sscrapy genspider -t %s %s google.com" pyvenv-activate-cmd template name))
    (find-file (concat new-spider-module-path name ".py"))))

(defun list-spiders ()
  "Returns a list of spider names for the project"
  (split-string
   (shell-command-to-string (format "%sscrapy list" pyvenv-activate-cmd))
   "\n"
   t
   "\s+"))

(defun scrapy-edit-spider (spider)
  "Edit a spider from the list of all spiders in the current project"
  (interactive (list (completing-read "Choose a spider: " (list-spiders))))
  (async-shell-command (format "%sscrapy edit %s" pyvenv-activate-cmd spider)))

(defun scrapy-list ()
  "List all spiders in the scrapy project"
  (interactive)
  (shell-command (format "%sscrapy list" pyvenv-activate-cmd)))

(defun scrapy-start-project (name)
  "Start a new scrapy project"
  (interactive "sName of new project: ")
  (let ((project-dir (read-directory-name "New project directory: ")))
    (shell-command (format "%sscrapy startproject %s %s" pyvenv-activate-cmd name project-dir))
    (message "Created new project %s at %s" name project-dir)))

(define-minor-mode scrapy-local-mode
  "A minor mode for the python scrapy library"
  :lighter " scrapy"
  :keymap (let ((map (make-sparse-keymap)))
	    (define-key map (kbd "C-c . c") 'scrapy-crawl-spider)
	    (define-key map (kbd "C-c . s") 'scrapy-shell-url-at-point)
	    (define-key map (kbd "C-c . g") 'scrapy-genspider)
	    (define-key map (kbd "C-c . v") 'scrapy-view-url-at-point)
	    (define-key map (kbd "C-c . e") 'scrapy-edit-spider)
	    (define-key map (kbd "C-c . l") 'scrapy-list)
	    (define-key map (kbd "C-c . r") 'scrapy-run-spider)
	    (define-key map (kbd "C-c . p") 'scrapy-start-project)
	    map))

(define-globalized-minor-mode scrapy-mode scrapy-local-mode
  (lambda () (scrapy-local-mode 1))
  :predicate '(python-mode))
